BeforeAll {

    # /PsBambooHr
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsBambooHr/PsBambooHr/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

    # /PsBambooHr/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # Get-BambooHrEmployee.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsBambooHr/PsBambooHr/Public/Get-BambooHrEmployee.ps1
    $Path = Join-Path $PublicPath $sut

    . (Join-Path $PublicPath $sut)

}

Describe "Get-BambooHrEmployee" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-BambooHrEmployee'
        } 

        $Parameters = @(
            @{
                ParameterName = 'ApiKey'
                Type = [string]
                ParameterSets = @(
                    @{ParameterSetName='AllEmployees';Mandatory=$true}
                    @{ParameterSetName='ById';Mandatory=$true}
                    @{ParameterSetName='LastChanged';Mandatory=$true}
                )
            }
            @{
                ParameterName = 'Subdomain'
                Type = [string]
                ParameterSets = @(
                    @{ParameterSetName='AllEmployees';Mandatory=$true}
                    @{ParameterSetName='ById';Mandatory=$true}
                    @{ParameterSetName='LastChanged';Mandatory=$true}
                )
            }
            @{
                ParameterName = 'Id'
                Type = [string]
                ValidatePattern = '\d'
                ParameterSets = @(
                    @{ParameterSetName='ById';Mandatory=$true}
                )
            }
            @{
                ParameterName = 'LastChanged'
                Type = [datetime]
                ParameterSets = @(
                    @{ParameterSetName='LastChanged';Mandatory=$true}
                )
            }
            @{
                ParameterName = 'AllowNull'
                Type = [switch]
                ParameterSets = @(
                    @{ParameterSetName='LastChanged';Mandatory=$false}
                )
            }
            @{
                ParameterName = 'Fields'
                Type = [string[]]
                ParameterSets = @()
            }
        ) | ForEach-Object {

            $Parameter = $_

            It "<ParameterName> is a <Type>" -TestCases $Parameter {
                param ($ParameterName, $Type)
                $Command | Should -HaveParameter $ParameterName -Type $Type
            }

            if ( $null -ne $_.ValidatePattern ) {
                it '<ParameterName> has a ValidatePattern of ''<ValidatePattern>''' -TestCases $_ {
                    param ($ParameterName,$ValidatePattern)
                    $Attribute = $Command.Parameters[$ParameterName].Attributes | Where-Object { $_.TypeId -eq [System.Management.Automation.ValidatePatternAttribute] }
                    $Attribute.RegexPattern | Should -Be $ValidatePattern
                }    
            }

            $_.ParameterSets | ForEach-Object {

                $Case = @{
                    ParameterName = $Parameter.ParameterName
                }
                $Case += $_

                It "<ParameterName> is $( $_.Mandatory ? 'a mandatory': 'an optional') member of <ParameterSetName>" -TestCases $Case {
                    param ($ParameterName,$ParameterSetName,$Mandatory)
                    $Command.Parameters[$ParameterName].ParameterSets[$ParameterSetName].IsMandatory -eq $Mandatory
                }
    
            }
    
        }

    } # /parameter validation

    Context "when ApiKey and Subdomain parameters are supplied" {

        BeforeAll {
            # arrange
            $ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
            $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
            $Subdomain = 'subdomain'
        }

        BeforeEach {
            # arrange
            Mock Invoke-WebRequest {
                $Fixture = 'Get-Report.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

            # act
            Get-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain
        }
    
        It "uses the correct Uri" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/reports/custom?format=json"
            }
        }

        It "uses the correct Method" {    
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
        }
    
        It "uses the correct Accept" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Headers.Accept -eq 'application/json' }
        }

        It "uses the correct Credential" {
            # arrange
            $BasicCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password

            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $Credential.UserName -eq $BasicCredential.UserName -and
                ($Credential.Password | ConvertFrom-SecureString -AsPlainText) -eq ($BasicCredential.Password | ConvertFrom-SecureString -AsPlainText) -and
                $UseBasicParsing -eq $true
            }
        }

        It "uses the correct Body" {

            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $Actual = $Body | ConvertFrom-Json
                $Actual.fields -eq $null
            }

        }

        Context "when the Fields parameter is supplied" {

            BeforeEach {
                # arrange
                $Fields = 'firstName','lastName'

                Mock Invoke-WebRequest {
                    $Fixture = 'Get-Report.Response.json'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
    
                    $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                    $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                    $Response
                }
    
                # act
                Get-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain -Fields $Fields
            }

            It "uses the correct Body" {

                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    $Actual = $Body | ConvertFrom-Json
    
                    $Delta = Compare-Object -ReferenceObject $Fields -DifferenceObject $Actual.fields
                    Write-Debug "Differences: $( $Delta.SideIndicator.Count )"
    
                    $Delta.SideIndicator.Count -eq 0
                }
    
            }
    
        }

        Context "when the Id parameter is supplied" {

            BeforeEach {
                # arrange
                $Id = 1

                Mock Invoke-WebRequest {
                    $Fixture = 'Get-Employee.Response.json'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
    
                    $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                    $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                    $Response
                }
        
                # act
                Get-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain -Id $Id
            }
    
            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$Id/" }
            }
    
            It "uses the correct Method" {    
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Get' }
            }
        
            It "uses the correct Accept" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Headers.Accept -eq 'application/json' }
            }

            Context "when the Fields parameter is supplied" {

                BeforeEach {
                    # arrange
                    $Fields = 'lastName','firstName'

                    # act
                    Get-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain -Id $Id -Fields $Fields
                }
        
                It "uses the correct Uri" {
                    # assert
                    Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                        $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$Id/?fields=@( $Fields -join ',')"
                    }
                }
    
            } # /context Fields

        } # /context Id
    
        Context "when the LastChanged parameter is supplied" {

            BeforeEach {
                # arrange
                $LastChanged = '10/30/2020 12:00:00'

                Mock Invoke-WebRequest {
                    $Fixture = 'Get-Report.Response.json'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
    
                    $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                    $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                    $Response
                }

                # act
                Get-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain -LastChanged $LastChanged
            }
            
            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/reports/custom?format=json" }
            }

            It "uses the correct Method" {    
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            }

            It "uses the correct Body" {

                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    $Actual = $Body | ConvertFrom-Json
                    $Actual.filters.lastChanged.value -eq ([datetime]$LastChanged).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
                }

            }

            Context "when the AllowNull parameter is supplied" {

                BeforeEach {
                    # act
                    Get-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain -LastChanged $LastChanged -AllowNull
                }
    
                It "uses the correct Body" {

                    Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                        $Actual = $Body | ConvertFrom-Json
                        $Actual.filters.lastChanged.includeNul -eq 'yes'
                    }
    
                }
    
            } # /context AllowNull

        } # /context LastChanged

    }

} # /Describe