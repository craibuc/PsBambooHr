<#
.SYNOPSIS
This endpoint can help with discovery of fields that are available in an account.

.DESCRIPTION
This endpoint will return details for all list fields. Lists that can be edited will have the "manageable" attribute set to yes. Lists with the "multiple" attribute set to yes are fields that can have multiple values. Options with the "archived" attribute set to yes should not appear as current options, but are included so that historical data can reference the value.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER Detailed
When set, the endpoint will return details for all list fields. 

.EXAMPLE
Get-BambooHrField -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain'

.EXAMPLE
Get-BambooHrField -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -Detailed

.LINK
https://documentation.bamboohr.com/reference#metadata-get-a-list-of-fields

.LINK
https://documentation.bamboohr.com/reference#metadata-get-details-for-list-fields-1
#>
function Get-BambooHrField {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter()]
        [switch]$Detailed
    )
    
    begin {
        # headers
        $Headers = @{ Accept = 'application/json' }

        # uri
        $uri = $Detailed ? "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/meta/lists/" : "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/meta/fields/"
        Write-Debug "Uri: $Uri"

        # credentials
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }
    
    process {

        try {
            $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers -Credential $Credentials -UseBasicParsing
            # switch ($Response.StatusCode) {
            #     condition {  }
            #     Default {}
            # }
            # if ($Response -ne 201) {}
            $Response.Content | ConvertFrom-Json
        }
        catch {
            Write-Error -Message $_.Exception.Message
        }

    }
    
    end {}

}