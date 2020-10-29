# /PsBambooHr
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsBambooHr/PsBambooHr/Public
$PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

# /PsBambooHr/Tests/Fixtures/
$FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-BambooHrTable.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsBambooHr/PsBambooHr/Public/Get-BambooHrTable.ps1
$Path = Join-Path $PublicPath $sut
Write-Debug "Path: $Path"

. (Join-Path $PublicPath $sut)

Describe "Get-BambooHrTable" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-BambooHrTable'
        } 

        $Parameters = @(
            @{ParameterName='ApiKey';Type=[string]; Mandatory=$true}
            @{ParameterName='Subdomain';Type=[string]; Mandatory=$true}
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

    Context "Usage" {

        BeforeAll {
            # arrange
            $ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
            $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force

            $Subdomain = 'subdomain'

            Mock Invoke-WebRequest {
                $Fixture = 'Get-TabularFields.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            Get-BambooHrTable -ApiKey $ApiKey -Subdomain $Subdomain
        }

        Context "Request" {

            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    # Write-Debug "Uri: $Uri"
                    $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/meta/tables" 
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

        } # /Context

    } # /Context

} # /Describe