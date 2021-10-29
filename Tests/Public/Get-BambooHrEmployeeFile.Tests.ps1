BeforeAll {

    # /PsBambooHr
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsBambooHr/PsBambooHr/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

    # /PsBambooHr/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # Get-BambooHrEmployeeFfile.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsBambooHr/PsBambooHr/Public/Get-BambooHrEmployeeFfile.ps1
    $Path = Join-Path $PublicPath $sut

    . (Join-Path $PublicPath $sut)

}

Describe "Get-BambooHrEmployeeFfile" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-BambooHrEmployee'
        } 

        $Parameters = @(
            @{
                ParameterName = 'ApiKey'
                Type = [string]
            }
            @{
                ParameterName = 'Subdomain'
                Type = [string]
            }
            @{
                ParameterName = 'Id'
                Type = [string]
                ValidatePattern = '\d'
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
    
        }

    }

    Context 'Usage' {

        BeforeAll {
            # arrange
            $ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
            $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force

            $Subdomain = 'subdomain'

            $Id = 1

            Mock Invoke-WebRequest {
                $Fixture = 'Get-EmployeeFile.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            Get-BambooHrEmployeeFile -ApiKey $ApiKey -Subdomain $Subdomain -Id $Id
        }
        Context 'Request' {

            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    # Write-Debug "Uri: $Uri"
                    $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$Id/files/view/"
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

        }
    }

}