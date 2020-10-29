# /PsBambooHr
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsBambooHr/PsBambooHr/Public
$PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

# /PsBambooHr/Tests/Fixtures/
$FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-BambooHrEmployee.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsBambooHr/PsBambooHr/Public/Get-BambooHrEmployee.ps1
$Path = Join-Path $PublicPath $sut
Write-Debug "Path: $Path"

. (Join-Path $PublicPath $sut)

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
                    @{ParameterSetName='ForDirectory';Mandatory=$true}
                    @{ParameterSetName='ById';Mandatory=$true}
                )
            }
            @{
                ParameterName = 'Subdomain'
                Type = [string]
                ParameterSets = @(
                    @{ParameterSetName='ForDirectory';Mandatory=$true}
                    @{ParameterSetName='ById';Mandatory=$true}
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
                ParameterName = 'Fields'
                Type = [string[]]
                ParameterSets = @(
                    @{ParameterSetName='ById';Mandatory=$false}
                )
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

    Context "ParameterSet 'None'" {

        BeforeAll {
            # arrange
            $ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
            $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force

            $Subdomain = 'subdomain'

            Mock Invoke-WebRequest {
                $Fixture = 'Get-EmployeeDirectory.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            Get-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain
        }
    
        Context "Request" {

            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    # Write-Debug "Uri: $Uri"
                    $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/directory" 
                }
            }
    
            It "uses the correct Method" {    
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Get' }
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
    
        } # /Context Request

    }

    Context "ParameterSet 'ById'" {

        BeforeAll {
            # arrange
            $ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
            $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force

            $Subdomain = 'subdomain'
            $Id = '123'

            Mock Invoke-WebRequest {
                $Fixture = 'Get-Employee.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            Get-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain -Id $Id
        }
    
        Context "Request" {

            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$Id/?fields=firstName,lastName" }
            }
    
            It "uses the correct Method" {    
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Get' }
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
    
        } # /Context Request

    }  # /Context ById

} # /Describe