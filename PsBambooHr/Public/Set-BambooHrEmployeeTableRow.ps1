<#
.SYNOPSIS
Updates the row for the specified table.

.DESCRIPTION
Updates the data for a given employee, table, and row combination.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr.

.PARAMETER EmployeeId
The employee's unique identifier.

.PARAMETER TableName
The name of the table.

.PARAMETER RowId
The row's unique identifier.

.PARAMETER Data
A [pscustomobject] represenation of the row's data.

.EXAMPLE
[pscustomobject]@{
    Field0 = 1
    Field1 = 'abc'
} | Set-BambooHrEmployeeTableRow -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -EmployeeId 1 -TableName 'MyTable' -RowId 1000

.LINK
https://documentation.bamboohr.com/reference/update-employee-table-row-1
#>

function Set-BambooHrEmployeeTableRow 
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [int]$EmployeeId,

        [Parameter(Mandatory)]
        [string]$TableName,

        [Parameter(Mandatory)]
        [int]$RowId,

        [Parameter(Mandatory,ValueFromPipeline)]
        [pscustomobject]$Data
    )
    
    begin {
        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$EmployeeId/tables/$TableName/$RowId"
        Write-Debug "Uri: $Uri"

        # credentials
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }
    
    process {

        try {

            $Data.Remove('employeeId') # supplying the employeeId will cause the POST to fail
            $Data.Remove('id') # supplying the row id will cause the POST to fail

            $Body = $Data | ConvertTo-Json

            if ( $PSCmdlet.ShouldProcess("POST /employees/$EmployeeId/tables/$TableName/$RowId",'Invoke-WebRequest') )
            {
                Invoke-WebRequest -Uri $Uri -Method Post -Body $Body -ContentType 'application/json' -Credential $Credentials -UseBasicParsing -Verbose:$false | Out-Null
            }
        }
        # catch [Microsoft.PowerShell.Commands.HttpResponseException] {
        #     if ( $_.Exception.Response.StatusCode -eq 'NotFound' ) 
        #     {
        #         $Message = "Table '$TableName' was not found for Employee #$EmployeeId"
        #         Microsoft.PowerShell.Utility\Write-Warning $Message
        #     }
        #     else
        #     {
        #         Write-Error -Message $_.Exception.Message
        #     }
        # }
        catch {
            Write-Error -Message $_.Exception.Message
        }
    }
    
    end {}
}