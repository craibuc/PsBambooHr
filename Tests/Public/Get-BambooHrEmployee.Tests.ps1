BeforeAll {

    # /PsBambooHr
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsBambooHr/PsBambooHr/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

    # /PsBambooHr/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # Get-BambooHrEmployee.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)

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
                ParameterName = 'EmployeeId'
                Type = [System.Nullable[int]]
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
            $Authentication = @{
                ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
                Subdomain = 'subdomain'
            }
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
        }
    
        Context 'Basic' {

            BeforeEach {
                # act
                Get-BambooHrEmployee @Authentication
            }

            It "uses the correct Uri" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Uri -eq "https://api.bamboohr.com/api/gateway.php/$( $Authentication.Subdomain )/v1/reports/custom?format=json"
                }
            }
    
            It "uses the correct Method" {    
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            }
        
            It "uses the correct Accept" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { $Headers.Accept -eq 'application/json' }
            }
    
            It "uses the correct Credential" {
                # arrange
                $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
                $BasicCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Authentication.ApiKey, $Password
    
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Credential.UserName -eq $BasicCredential.UserName -and
                    ($Credential.Password | ConvertFrom-SecureString -AsPlainText) -eq ($BasicCredential.Password | ConvertFrom-SecureString -AsPlainText) -and
                    $UseBasicParsing -eq $true
                }
            }
    
            It "uses the correct Body" {
    
                Should -Invoke Invoke-WebRequest -ParameterFilter {
                    $Actual = $Body | ConvertFrom-Json
                    $Actual.fields.count -eq 0
                }
    
            }
    
        }

        Context "when the Fields parameter is supplied" {

            BeforeEach {
                # arrange
                $Fields = 'firstName','lastName'

                # act
                Get-BambooHrEmployee @Authentication -Fields $Fields
            }

            It "uses the correct Body" {

                Should -Invoke Invoke-WebRequest -ParameterFilter { 
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
                $EmployeeId = 1
        
                # act
                Get-BambooHrEmployee @Authentication -EmployeeId $EmployeeId
            }
    
            It "uses the correct Uri" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Uri -eq "https://api.bamboohr.com/api/gateway.php/$( $Authentication.Subdomain )/v1/employees/$EmployeeId/" 
                }
            }
    
            It "uses the correct Method" {    
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { $Method -eq 'Get' }
            }
        
            It "uses the correct Accept" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { $Headers.Accept -eq 'application/json' }
            }

            Context "when the Fields parameter is supplied" {

                BeforeEach {
                    # arrange
                    $Fields = 'lastName','firstName'

                    # act
                    Get-BambooHrEmployee @Authentication -EmployeeId $EmployeeId -Fields $Fields
                }
        
                It "uses the correct Uri" {
                    # assert
                    Should -Invoke Invoke-WebRequest -ParameterFilter { 
                        $EncodedFields = [System.Web.HttpUtility]::UrlEncode( $Fields -join ',' )
                        $Expected = "https://api.bamboohr.com/api/gateway.php/$( $Authentication.Subdomain )/v1/employees/$EmployeeId/?fields=$EncodedFields"
                        $Uri -eq $Expected
                    }
                }
    
            } # /context Fields

        } # /context Id
    
        Context "when the LastChanged parameter is supplied" {

            BeforeEach {
                # arrange
                $LastChanged = '10/30/2020 12:00:00'

                # act
                Get-BambooHrEmployee @Authentication -LastChanged $LastChanged
            }
            
            It "uses the correct Uri" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { $Uri -eq "https://api.bamboohr.com/api/gateway.php/$( $Authentication.Subdomain )/v1/reports/custom?format=json" }
            }

            It "uses the correct Method" {    
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            }

            It "uses the correct Body" {

                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Actual = $Body | ConvertFrom-Json
                    $Actual.filters.lastChanged.value -eq ([datetime]$LastChanged).ToUniversalTime()
                }

            }

            Context "when the AllowNull parameter is supplied" {

                BeforeEach {    
                    # act
                    Get-BambooHrEmployee @Authentication -LastChanged $LastChanged -AllowNull
                }
    
                It "uses the correct Body" {
    
                    Should -Invoke Invoke-WebRequest -ParameterFilter { 
                        $Actual = $Body | ConvertFrom-Json
                        $Actual.filters.lastChanged.includeNull -eq 'yes'
                    }
    
                }
    
            } # /context AllowNull

        } # /context LastChanged

    }

} # /Describe