BeforeAll {

    # /PsBambooHr
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsBambooHr/PsBambooHr/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

    # /PsBambooHr/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # New-BambooHrEmployeeTableRow.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)

}

Describe "New-BambooHrEmployeeTableRow" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'New-BambooHrEmployeeTableRow'
        } 

        $Parameters = @(
            @{ParameterName='ApiKey';Type=[string]; Mandatory=$true}
            @{ParameterName='Subdomain';Type=[string]; Mandatory=$true}
            @{ParameterName='EmployeeId';Type=[int]; Mandatory=$true}
            @{ParameterName='TableName';Type=[string]; Mandatory=$true}
            @{ParameterName='Data';Type=[pscustomobject]; Mandatory=$true}
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
            $Authentication = @{
                ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'    
                Subdomain = 'subdomain'
            }

            $Splat = @{
                EmployeeId = 1
                TableName = 'jobInfo'
                Data = [pscustomobject]@{
                    date = "2010-06-01"
                    location = "New York Office"
                    divison = "Sprockets"
                    department = "Research and Development"
                    jobTitle = "Machinist"
                    reportsTo = "John Smith"
                }    
            }

        }

        Context "Request" {

            BeforeAll {

                # arrange
                Mock Invoke-WebRequest {
                    $Fixture = 'New-EmployeeTableData.jobInfo.Response.json'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
    
                    $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                    $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                    $Response
                }

            }

            BeforeEach {
                # act
                New-BambooHrEmployeeTableRow @Authentication @Splat
            }
    
            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    $Uri -eq "https://api.bamboohr.com/api/gateway.php/$( $Authentication.Subdomain )/v1/employees/$( $Splat.EmployeeId )/tables/$( $Splat.TableName )"
                }
            }
    
            It "uses the correct Method" {    
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            }

            It "uses the correct ContentType" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { $ContentType -eq 'application/json' }
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

            It "uses the correct Body" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    $Expected = [pscustomobject]$Splat.Data

                    $Actual = $Body | ConvertFrom-Json
                    Write-Debug $Actual
    
                    $Delta = Compare-Object -ReferenceObject @($Expected.PsObject.Properties | select name,value) -DifferenceObject @($Actual.PsObject.Properties | select name,value)
                    Write-Debug "Differences: $( $Delta.SideIndicator.Count )"
    
                    $Delta.SideIndicator.Count -eq 0
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
                New-BambooHrEmployeeTableRow @Authentication @Splat

                # assert
                Assert-MockCalled Write-Warning -ParameterFilter { 
                    $Message -eq $WarningMessage
                }

            }

        }

    } # /Context

} # /Describe