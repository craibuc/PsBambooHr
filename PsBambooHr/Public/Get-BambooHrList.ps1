<#
.SYNOPSIS
This endpoint will return details for all list fields.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The value 'mycompany' in this URI: https://mycompany.bamboohr.com.

.EXAMPLE
PS> Get-BambooHrList

{
  "fieldId": 17,
  "alias": "department",
  "manageable": "yes",
  "multiple": "no",
  "name": "Department",
  "options": [
    {
      "id": 1,
      "archived": "no",
      "createdDate": "2016-12-08T17:41:56+00:00",
      "archivedDate": null,
      "name": "ABC"
    },
    {
      "id": 2,
      "archived": "no",
      "createdDate": "2016-12-08T17:41:56+00:00",
      "archivedDate": null,
      "name": "DEF"
    },
    {
      "id": 18465,
      "archived": "yes",
      "createdDate": "2016-12-08T17:41:56+00:00",
      "archivedDate": "2016-12-31T17:41:56+00:00",
      "name": "GHI"
    }
  ]
}

.LINK
https://documentation.bamboohr.com/reference#metadata-get-a-list-of-tabular-fields-1

#>
function Get-BambooHrList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain
    )
    
    begin {
        # headers
        $Headers = @{ Accept = 'application/json' }

        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/meta/lists"
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