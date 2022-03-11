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