<#
.SYNOPSIS
Retuns the rows and columns for the specified table.

.DESCRIPTION
Returns a data structure representing all the table rows for a given employee and table combination. The result is not sorted in any particular order.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER EmployeeId
The employee's unique identifier (assigned by Bamboo HR). The employee ID of zero (0) is the employee ID associated with the API key.

.PARAMETER TableName
The name of the table.

.EXAMPLE
Get-BambooHrEmployeeTableRow -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -EmployeeId 1 -TableName 'MyTable'

.LINK
https://documentation.bamboohr.com/reference#get-employee-table-row-1
#>
function Get-BambooHrEmployeeTableRow {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [int]$EmployeeId,

        [Parameter(Mandatory)]
        [string]$TableName
    )
    
    begin {
        # headers
        $Headers = @{
            Accept = 'application/json'
        }

        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$EmployeeId/tables/$TableName"
        Write-Debug "Uri: $Uri"

        # credentials
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }
    
    process {

        Write-Verbose $TableName

        try {
            $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers -Credential $Credentials -UseBasicParsing -Verbose:$false
            $Response.Content | ConvertFrom-Json
        }

        catch [Microsoft.PowerShell.Commands.HttpResponseException] {
            if ( $_.Exception.Response.StatusCode -eq 'NotFound' ) 
            {
                $Message = "Table '$TableName' was not found for Employee #$EmployeeId"
                Microsoft.PowerShell.Utility\Write-Warning $Message
            }
            else
            {
                Write-Error -Message $_.Exception.Message
            }
        }
        catch {
            Write-Error -Message $_.Exception.Message
        }
    }
    
    end {}
}