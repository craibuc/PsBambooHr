<#
.SYNOPSIS
Get a list of training types. The owner of the API key used must have access to training settings.

.PARAMETER Credential
THe API key and password represented as a PsCredential.

$Credential = [System.Management.Automation.PSCredential]::new($ApiKey, ( 'Password' | ConvertTo-SecureString -AsPlainText -Force))

.PARAMETER Subdomain
The value 'mycompany' in this URI: https://mycompany.bamboohr.com.

.EXAMPLE
PS> Get-BambooHrTrainingType -Credential $Credential -Subdomain 'companyDomain'

{
  {
    "id": "1",
    "name": "Emergency Preparedness",
    "renewable": false,
    "frequency": 0,
    "dueFromHireDate": [],
    "required": false,
    "category": [],
    "linkUrl": "https://example.com/",
    "description": null,
    "allowEmployeesToMarkComplete": true
  },
  {
    "id": "2",
    "name": "CPR Certification",
    "renewable": true,
    "frequency": "12",
    "dueFromHireDate": {
      "unit": "day",
      "amount": "1"
    },
    "required": true,
    "category": {
      "id": "18001",
      "name": "First Aid Trainings"
    },
    "linkUrl": null,
    "description": "Very important.",
    "allowEmployeesToMarkComplete": false
  }
}

.LINK
https://documentation.bamboohr.com/reference/list-training-types

#>
function Get-BambooHrTrainingType {
  
    [CmdletBinding()]
    param (
      [Parameter(Mandatory)]
      [pscredential]$Credential,

        [Parameter(Mandatory)]
        [string]$Subdomain
    )
    
    begin {
        # headers
        $Headers = @{ Accept = 'application/json' }

        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/training/type"
    }
    
    process {

        try {
            $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers -Credential $Credential -UseBasicParsing
            $Response.Content | ConvertFrom-Json | ForEach-Object { $_.PSObject.Properties.Value }
        }
        catch {
            Write-Error -Message $_.Exception.Message
        }

    }
    
    end {}

}