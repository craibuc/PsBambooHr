BeforeAll {

    # /PsBambooHr
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsBambooHr/PsBambooHr/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

    # /PsBambooHr/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # Set-BambooHrEmployeeFile.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)

}

Describe "Set-BambooHrEmployeeFile" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Set-BambooHrEmployeeFile'
        } 

        $Parameters = @(
            @{ParameterName='ApiKey';Type=[string]; Mandatory=$true}
            @{ParameterName='Subdomain';Type=[string]; Mandatory=$true}
            @{ParameterName='EmployeeId';Type=[int]; Mandatory=$true}
            @{ParameterName='FileId';Type=[int]; Mandatory=$true}
            @{ParameterName='FileName';Type=[string]; Mandatory=$false}
            @{ParameterName='CategoryId';Type=[int]; Mandatory=$false}
            @{ParameterName='Share';Type=[bool]; Mandatory=$false}
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
            $Authentication = @{
                ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
                Subdomain = 'subdomain'    
            }

            $Splat = @{
                EmployeeId = 1
                FileId = 100
                FileName = 'Lorem.txt'
                CategoryId = 22
                Share = $false  
            }

            Mock Invoke-WebRequest {
                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $null -Force
                $Response
            }

        }

        BeforeEach {
            # act
            Set-BambooHrEmployeeFile @Authentication @Splat
        }

        Context "Request" {

            It "uses the correct Uri" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    $Uri -eq "https://api.bamboohr.com/api/gateway.php/$( $Authentication.Subdomain )/v1/employees/$( $Splat.EmployeeId )/files/$( $Splat.FileId )"
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
                $BasicCredential = [pscredential]::new($Authentication.ApiKey, ('Password' | ConvertTo-SecureString -AsPlainText -Force) )

                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                    $UseBasicParsing -eq $true -and
                    $Credential.UserName -eq $BasicCredential.UserName -and
                    ($Credential.Password | ConvertFrom-SecureString -AsPlainText) -eq ($BasicCredential.Password | ConvertFrom-SecureString -AsPlainText)
                }
            }

            It "uses the correct Form" {
                # assert
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Actual = $Body | ConvertFrom-Json

                    $Actual.name -eq $Splat.FileName -and
                    $Actual.categoryId -eq $Splat.CategoryId -and
                    $Actual.shareWithEmployee -eq ($Splat.Share ? 'yes' : 'no')
                }
            }

        } # /Context

    } # /Context

} # /Describe