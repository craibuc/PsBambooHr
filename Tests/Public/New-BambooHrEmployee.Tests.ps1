# /PsBambooHr
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsBambooHr/PsBambooHr/Public
$PublicPath = Join-Path $ProjectDirectory "/PsBambooHr/Public/"

# /PsBambooHr/Tests/Fixtures/
$FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# New-BambooHrEmployee.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsBambooHr/PsBambooHr/Public/New-BambooHrEmployee.ps1
. (Join-Path $PublicPath $sut)

Describe "New-BambooHrEmployee" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'New-BambooHrEmployee'
        }
    
        $Parameters = @(
            @{Name='ApiKey';Type='string';Mandatory=$true}
            @{Name='Subdomain';Type='string';Mandatory=$true}

            @{Name='address1';Type='string';Mandatory=$false}
            @{Name='address2';Type='string';Mandatory=$false}
            @{Name='bestEmail';Type='string';Mandatory=$false}
            @{Name='bonusAmount';Type='decimal';Mandatory=$false}
            @{Name='bonusComment';Type='string';Mandatory=$false}
            @{Name='bonusDate';Type='datetime';Mandatory=$false}
            @{Name='bonusReason';Type='string';Mandatory=$false}
            @{Name='city';Type='string';Mandatory=$false}
            @{Name='commissionAmount';Type='decimal';Mandatory=$false}
            @{Name='commissionComment';Type='string';Mandatory=$false}
            @{Name='commissionDate';Type='datetime';Mandatory=$false}
            @{Name='country';Type='string';Mandatory=$false}
            @{Name='dateOfBirth';Type='datetime';Mandatory=$false}
            @{Name='department';Type='string';Mandatory=$false}
            @{Name='division';Type='string';Mandatory=$false}
            @{Name='eeo';Type='string';Mandatory=$false}
            @{Name='employeeNumber';Type='string';Mandatory=$false}
            @{Name='ethnicity';Type='string';Mandatory=$false}
            @{Name='exempt';Type='string';Mandatory=$false}
            @{Name='firstName';Type='string';Mandatory=$false}
            @{Name='gender';Type='string';Mandatory=$false}
            @{Name='hireDate';Type='datetime';Mandatory=$false}
            @{Name='originalHireDate';Type='datetime';Mandatory=$false}
            @{Name='homeEmail';Type='string';Mandatory=$false}
            @{Name='homePhone';Type='string';Mandatory=$false}
            @{Name='jobTitle';Type='string';Mandatory=$false}
            @{Name='lastName';Type='string';Mandatory=$false}
            @{Name='location';Type='string';Mandatory=$false}
            @{Name='maritalStatus';Type='string';Mandatory=$false}
            @{Name='middleName';Type='string';Mandatory=$false}
            @{Name='mobilePhone';Type='string';Mandatory=$false}
            @{Name='nationalId';Type='string';Mandatory=$false}
            @{Name='nationality';Type='string';Mandatory=$false}
            @{Name='nin';Type='string';Mandatory=$false}
            @{Name='payChangeReason';Type='string';Mandatory=$false}
            @{Name='payGroup';Type='string';Mandatory=$false}
            @{Name='payGroupId';Type='int';Mandatory=$false}
            @{Name='payRate';Type='decimal';Mandatory=$false}
            @{Name='payRateEffectiveDate';Type='datetime';Mandatory=$false}
            @{Name='payType';Type='string';Mandatory=$false}
            @{Name='payPer';Type='string';Mandatory=$false}
            @{Name='paidPer';Type='string';Mandatory=$false}
            @{Name='paySchedule';Type='string';Mandatory=$false}
            @{Name='payScheduleId';Type='int';Mandatory=$false}
            @{Name='payFrequency';Type='string';Mandatory=$false}
            @{Name='includeInPayroll';Type='bool';Mandatory=$false}
            @{Name='timeTrackingEnabled';Type='boolean';Mandatory=$false}
            @{Name='preferredName';Type='string';Mandatory=$false}
            @{Name='ssn';Type='string';Mandatory=$false}
            @{Name='sin';Type='string';Mandatory=$false}
            @{Name='standardHoursPerWeek';Type='int';Mandatory=$false}
            @{Name='state';Type='string';Mandatory=$false}
            @{Name='status';Type='string';Mandatory=$false}
            @{Name='workEmail';Type='string';Mandatory=$false}
            @{Name='workPhone';Type='string';Mandatory=$false}
            @{Name='workPhonePlusExtension';Type='string';Mandatory=$false}
            @{Name='zipcode';Type='string';Mandatory=$false}
        )

        Context "Type" {
            it '<Name> is a <Type>' -TestCases $Parameters {
                param($Name, $Type, $Mandatory)
              
                $Command | Should -HaveParameter $Name -Type $type
            }    
        }

        Context "Mandatory" {
            it '<Name> mandatory is <Mandatory>' -TestCases $Parameters {
                param($Name, $Type, $Mandatory)
              
                if ($Mandatory) { $Command | Should -HaveParameter $Name -Mandatory }
                else { $Command | Should -HaveParameter $Name -Not -Mandatory }
            }    
        }
    
    }

    Context "Request" {

        BeforeEach {
            # arrange
            $ApiKey = '2134d8d5-d1b4-4a1d-89ac-f44a96514bb5'
            $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force

            $Subdomain = 'subdomain'
            
            $Employee = @{
                address1 = 'address1'
                address2 = 'address2'
                bestEmail = 'first.last@domain.tld'
                bonusAmount = 100.00
                bonusComment = 'lorem ipsum'
                bonusDate = '10/31/2020'
                bonusReason = 'lorem ipsum'
                city = 'city'
                commissionAmount = 100.00
                commissionComment = 'lorem ipsum'
                commissionDate = '10/31/2020'
                country = 'US'
                dateOfBirth = '10/31/2020'
                department = 'department'
                division = 'division'
                eeo = 'eeo'
                employeeNumber = 'employeeNumber'
                ethnicity = 'ethnicity'
                exempt = 'Exempt'
                firstName = 'firstName'
                gender = 'male'
                hireDate = '10/31/2020'
                originalHireDate = '10/31/2020'
                homeEmail = 'first.last@domain.tld'
                homePhone = '2223334444'
                jobTitle = 'jobTitle'
                lastName = 'lastName'
                location = 'location'
                maritalStatus = 'maritalStatus'
                middleName = 'middleName'
                mobilePhone = '2223334444'
                nationalId = 'nationalId'
                nationality = 'nationality'
                nin = 'nin'
                payChangeReason = 'lorem ipsum'
                payGroup = 'payGroup'
                payGroupId = 1
                payRate = 100.00
                payRateEffectiveDate = '10/31/2020'
                payType = 'payType'
                payPer = 'payPer'
                paidPer = 'paidPer'
                paySchedule = 'paySchedule'
                payScheduleId = 1
                payFrequency = 'payFrequency'
                includeInPayroll = $true
                timeTrackingEnabled = $true
                preferredName = 'preferredName'
                ssn = '222334444'
                sin = 'sin'
                standardHoursPerWeek = 40
                state = 'state'
                status = 'Active'
                workEmail = 'first.last@domain.tld'
                workPhone = '2223334444'
                workPhonePlusExtension = '1234'
                zipcode = '12345'
            }

            Mock Invoke-WebRequest {
                $Fixture = 'Add-Employee.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

            # act
            New-BambooHrEmployee -ApiKey $ApiKey -Subdomain $Subdomain @Employee
        }

        It "uses the correct Uri" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/" }
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
            $BasicCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password

            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $Credential.UserName -eq $BasicCredential.UserName -and
                ($Credential.Password | ConvertFrom-SecureString -AsPlainText) -eq ($BasicCredential.Password | ConvertFrom-SecureString -AsPlainText) -and
                $UseBasicParsing -eq $true
            }
        }

        It "creates the correct Body" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $Expected = [pscustomobject]$Employee

                $Actual = $Body | ConvertFrom-Json
                Write-Debug $Actual

                $Delta = Compare-Object -ReferenceObject @($Expected.PsObject.Properties | select name,value) -DifferenceObject @($Actual.PsObject.Properties | select name,value)
                Write-Debug "Differences: $( $Delta.SideIndicator.Count )"

                $Delta.SideIndicator.Count -eq 0
            }
        }

    }

}