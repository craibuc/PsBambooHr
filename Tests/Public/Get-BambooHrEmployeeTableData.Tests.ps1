BeforeAll {

    # /PsBambooHr
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsBambooHr/PsBambooHr/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

    # /PsBambooHr/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # Get-BambooHrEmployeeTableData.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)

}

Describe "Get-BambooHrEmployeeTableData" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-BambooHrEmployeeTableData'
        } 

        $Parameters = @(
            @{ParameterName='ApiKey';Type=[string]; Mandatory=$true}
            @{ParameterName='Subdomain';Type=[string]; Mandatory=$true}
            @{ParameterName='EmployeeId';Type=[int]; Mandatory=$true}
            @{ParameterName='TableName';Type=[string]; Mandatory=$true}
        )

        Context "Type" {
            It '<ParameterName> mandatory is a <Type>' -TestCases $Parameters {
                param($ParameterName, $Type)
                $Command | Should -HaveParameter $ParameterName -Type $Type
            }    
        }

        Context "Mandatory" {
            it '<ParameterName> mandatory is <Mandatory>' -TestCases $Parameters {
                param($ParameterName, $Type, $Mandatory)
              
                if ($Mandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
                else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
            }    
        }

    } # /Context

    Context "Default parameters" {

        BeforeAll {
            # arrange
            $Authentication =@{
                ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
                Subdomain = 'subdomain'
            }

            $Splat = @{
                EmployeeId = 1
                TableName = 'employmentStatus'    
            }

        }

        Context "Request" {

            BeforeAll {

                # arrange
                Mock Invoke-WebRequest {
                    $Fixture = 'Get-EmployeeTable.employmentStatus.Response.json'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
    
                    $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                    $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                    $Response
                }

            }

            BeforeEach {
                # act
                Get-BambooHrEmployeeTableData @Authentication @Splat
            }
    
            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$( $Splat.EmployeeId )/tables/$( $Splat.TableName )"
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
                $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
                $BasicCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Authentication.ApiKey, $Password

                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    $Credential.UserName -eq $BasicCredential.UserName -and
                    ($Credential.Password | ConvertFrom-SecureString -AsPlainText) -eq ($BasicCredential.Password | ConvertFrom-SecureString -AsPlainText) -and
                    $UseBasicParsing -eq $true
                }
            }

        } # /Context

        Context "TableName 404 (Not Found)" {

            It "writes a warning" {

                # arrange
                $Splat.TableName = 'DummyTable'
                $WarningMessage = "Table '$( $Splat.TableName )' was not found for Employee #$( $Splat.EmployeeId )"

                Mock Invoke-WebRequest {
                    $Response = New-Object System.Net.Http.HttpResponseMessage 404
                    $Phrase = 'Response status code does not indicate success: 404 (Not Found).'
                    Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
                }

                Mock Write-Warning {
                    $Message = $WarningMessage
                }

                # act
                Get-BambooHrEmployeeTableData @Authentication @Splat

                # assert
                Assert-MockCalled Write-Warning -ParameterFilter { 
                    $Message -eq $WarningMessage
                }

            }

        }

    } # /Context

} # /Describe