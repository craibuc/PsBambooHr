<#
.SYNOPSIS
Get a BambooHR employee by its BambooHR-assigned, unique identifier.

.DESCRIPTION
Get employee data by specifying a set of fields. This is suitable for getting basic employee information, including current values for fields that are part of a historical table, like job title, or compensation information. See the fields endpoint for a list of possible fields.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER EmployeeId
The employee's unique identifier (assigned by Bamboo HR). The employee ID of zero (0) is the employee ID associated with the API key.

.PARAMETER LastChanged
Include only those employee records that have changed after this date/time.

.PARAMETER AllowNull
Include only those employee records that have a null last-changed date (legacy).

.PARAMETER Fields
Array of field names to be retrieved.

.EXAMPLE
PS > Get-BambooHrEmployee -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain'

Return all employee Ids.

.EXAMPLE
PS > Get-BambooHrEmployee -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain'  -Field 'firstName','lastName'

Return all employee Ids, including first and last names.

.EXAMPLE
PS > Get-BambooHrEmployee -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -EmployeeId 1 -Field 'firstName','lastName'

Return id, first, and last names for employee #1.

.EXAMPLE
PS > Get-BambooHrEmployee -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -LastChanged '10/01/2021' -Field 'firstName','lastName'

Return id, first, and last names for all employee records that have changed since 01-OCT-2021.

.LINK
https://documentation.bamboohr.com/reference#get-employee

.LINK
https://documentation.bamboohr.com/reference#get-employees-directory-1
#>
function Get-BambooHrEmployee {

    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName='AllEmployees', Mandatory)]
        [Parameter(ParameterSetName='ById',Mandatory)]
        [Parameter(ParameterSetName='LastChanged',Mandatory)]
        [string]$ApiKey,

        [Parameter(ParameterSetName='AllEmployees', Mandatory)]
        [Parameter(ParameterSetName='ById',Mandatory)]
        [Parameter(ParameterSetName='LastChanged',Mandatory)]
        [string]$Subdomain,

        [Parameter(ParameterSetName='ById',Mandatory)]
        [System.Nullable[int]]$EmployeeId,

        [Parameter(ParameterSetName='LastChanged',Mandatory)]
        [datetime]$LastChanged,

        [Parameter(ParameterSetName='LastChanged')]
        [switch]$AllowNull,

        [string[]]$Fields
    )
    
    begin {
        # headers
        $Headers = @{
            Accept = 'application/json'
        }

        # credentials
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }
    
    process {

        Write-Debug "EmployeeId: $EmployeeId"
        Write-Debug "LastChanged: $LastChanged"
        Write-Debug "AllowNull: $AllowNull"
        Write-Debug "Fields: $Fields"

        try {

            # specified employee
            if ( $EmployeeId -ne $null ) # strings are empty not null in PS
            {
                if ($Fields)
                {
                    $EncodedFields = [System.Web.HttpUtility]::UrlEncode( $Fields -join ',' )
                    $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$EmployeeId/?fields=$EncodedFields"
                }
                else 
                {
                    $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$EmployeeId/"
                }
                Write-Debug "Uri: $Uri"

                $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers -Credential $Credentials -UseBasicParsing
                $Response.Content | ConvertFrom-Json
            }
            # all employees
            else 
            {
                $Body = @{
                    fields = $fields ? $Fields : @()
                    filters=@{}
                }

                if ($LastChanged)
                {
                    $Body.filters += @{ 
                        lastChanged = @{ value=$LastChanged.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
                    }

                    if ($AllowNull)
                    {
                        $Body.filters.lastChanged += @{ includeNull='yes' }
                    }
                }
                
                Write-Debug ($Body | ConvertTo-Json )

                $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/reports/custom?format=json"
                Write-Debug "Uri: $Uri"

                $Response = Invoke-WebRequest -Uri $Uri -Method Post -Headers $Headers  -Body ( $Body | ConvertTo-Json ) -ContentType 'application/json' -Credential $Credentials -UseBasicParsing
                ($Response.Content | ConvertFrom-Json).employees
            }

        }
        catch {
            Write-Error -Message $_.Exception.Message
        }

    }
    
    end {}

}