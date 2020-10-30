<#
.SYNOPSIS
Update a BambooHR employee by its BambooHR-assigned, unique identifier.

.DESCRIPTION
Update an employee, based on employee id. If employee is currently on a pay schedule syncing with Trax Payroll, or being added to one, the API user will need to update the employee with all of the following required fields for the update to be successful (listed by API field name): employeeNumber, firstName, lastName, dateOfBirth, ssn, gender, maritalStatus, hireDate, address1, city, state, country, employmentHistoryStatus, exempt, payType, payRate, payPer, location, department, and division.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER id
The employee's unique identifier (assigned by BambooHR). The employee ID of zero (0) is the employee ID associated with the API key.

.PARAMETER address1
The employee's first address line.

.PARAMETER address2
The employee's second address line.

.PARAMETER bestEmail
The employee's work email if set, otherwise their home email.

.PARAMETER bonusAmount
The amount of the most recent bonus.

.PARAMETER bonusComment
Comment about the most recent bonus.

.PARAMETER bonusDate
The date of the last bonus.

.PARAMETER bonusReason
The reason for the most recent bonus.

.PARAMETER city
The employee's city.

.PARAMETER commissionAmount
The amount of the most recent commission.

.PARAMETER commissionComment
Comment about the most recent commission.

.PARAMETER commissionDate
The date of the last commission.

.PARAMETER country
The employee's country.

.PARAMETER dateOfBirth
The date the employee was born.

.PARAMETER department
The employee's CURRENT department.

.PARAMETER division
The employee's CURRENT division.

.PARAMETER eeo
The employee's EEO job category. These are defined by the U.S. Equal Employment Opportunity Commission.

.PARAMETER employeeNumber
Employee number (assigned by your company).

.PARAMETER ethnicity
The employee's ethnicity.

.PARAMETER exempt
The FLSA Overtime Status (Exempt or Non-exempt).

.PARAMETER firstName
The employee's first name.

.PARAMETER gender
The employee's gender (Male or Female).

.PARAMETER hireDate
The date the employee was hired.

.PARAMETER originalHireDate
The date the employee was originally hired. Available starting with version 1.1.

.PARAMETER homeEmail
The employee's home email address.

.PARAMETER homePhone
The employee's home phone number.

.PARAMETER jobTitle
The CURRENT value of the employee's job title, updating this field will create a new row in position history.

.PARAMETER lastName
The employee's last name.

.PARAMETER location
The employee's CURRENT location.

.PARAMETER maritalStatus
The employee's marital status (Single, Married, or Domestic Partnership).

.PARAMETER middleName
The employee's middle name.

.PARAMETER mobilePhone
The employee's mobile phone number.

.PARAMETER nationalId
The employee's National ID number

.PARAMETER nationality
The employee's nationality

.PARAMETER nin
The employee's NIN number

.PARAMETER payChangeReason
The reason for the employee's last pay rate change.

.PARAMETER payGroup
The custom pay group that the employee belongs to.

.PARAMETER payGroupId
The ID value corresponding to the pay group that an employee belongs to.

.PARAMETER payRate
The employee's CURRENT pay rate (e.g., $8.25).

.PARAMETER payRateEffectiveDate
The day the most recent change was made.

.PARAMETER payType
The employee's CURRENT pay type. ie: "hourly","salary","commission","exception hourly","monthly","weekly","piece rate","contract","daily","pro rata".

.PARAMETER payPer
The employee's CURRENT pay per. ie: "Hour", "Day", "Week", "Month", "Quarter", "Year".

.PARAMETER paidPer
The employee's CURRENT pay per. ie: "Hour", "Day", "Week", "Month", "Quarter", "Year".

.PARAMETER paySchedule
The employee's CURRENT pay schedule.

.PARAMETER payScheduleId
The ID value corresponding to the pay schedule that an employee belongs to.

.PARAMETER payFrequency
The employee's CURRENT pay frequency. ie: "Weekly", "Every other week", "Twice a month", "Monthly", "Quarterly", "Twice a year", or "Yearly"

.PARAMETER includeInPayroll
Should employee be included in payroll (Yes or No)

.PARAMETER timeTrackingEnabled
Should time tracking be enabled for the employee (Yes or No)

.PARAMETER preferredName
The employee's preferred name.

.PARAMETER ssn
The employee's Social Security number.

.PARAMETER sin
The employee's Canadian Social Insurance Number.

.PARAMETER standardHoursPerWeek
The number of hours the employee works in a standard week.

.PARAMETER state
The employee's state/province.

.PARAMETER status
The employee's employee status (Active or Inactive).

.PARAMETER workEmail
The employee's work email address.

.PARAMETER workPhone
The employee's work phone number, without extension.

.PARAMETER workPhonePlusExtension
The employee's work phone and extension. Read only

.PARAMETER workPhoneExtension
The employee's work phone extension (if any).

.PARAMETER zipcode
The employee's ZIP code.

.LINK
https://documentation.bamboohr.com/reference#update-employee

#>

function Set-BambooHrEmployee {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [int]$id,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$address1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$address2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$bestEmail,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$bonusAmount,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$bonusComment,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$bonusDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$bonusReason,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$city,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$commissionAmount,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$commissionComment,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$commissionDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$country,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$dateOfBirth,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$department,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$division,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$eeo,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$employeeNumber,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ethnicity,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Exempt','Non-exempt')]
        [string]$exempt,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$firstName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Male','Female')]
        [string]$gender,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$hireDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$originalHireDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$homeEmail,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$homePhone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$jobTitle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$lastName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$location,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$maritalStatus,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$middleName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$mobilePhone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$nationalId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$nationality,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$nin,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$payChangeReason,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$payGroup,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$payGroupId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$payRate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$payRateEffectiveDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$payType,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$payPer,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$paidPer,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$paySchedule,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$payScheduleId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$payFrequency,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$includeInPayroll,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$timeTrackingEnabled,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$preferredName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ssn,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$sin,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$standardHoursPerWeek,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$state,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Active','Inactive')]
        [string]$status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$workEmail,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$workPhone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$workPhonePlusExtension,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$zipcode
    )
    
    begin {
        # headers
        $Headers = @{ Accept = 'application/json' }

        # credentials
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }
    
    process {
        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$id"
        Write-Debug "Uri: $Uri"

        # make a copy of Dictionary
        $Body = @{} + $PSBoundParameters

        # remove the information
        $Body.Remove('ApiKey')
        $Body.Remove('Subdomain')
        $Body.Remove('id')

        Write-Debug ($Body | ConvertTo-Json)
 
        try
        {
            $Response = Invoke-WebRequest -Uri $Uri -Method Post -Body ($Body | ConvertTo-Json) -Headers $Headers -ContentType "application/json" -Credential $Credentials -UseBasicParsing
        }
        catch
        {
            Write-Error -Message $_.Exception.Message
        }
    }
    
    end {}
}