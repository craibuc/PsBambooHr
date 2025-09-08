<#
.SYNOPSIS
Get a list of training categories. The owner of the API key used must have access to training settings.

.PARAMETER Credential
THe API key and password represented as a PsCredential.

$Credential = [System.Management.Automation.PSCredential]::new($ApiKey, ( 'Password' | ConvertTo-SecureString -AsPlainText -Force))

.PARAMETER Subdomain
The value 'mycompany' in this URI: https://mycompany.bamboohr.com.

.EXAMPLE
PS> Get-BambooHrTrainingCategory -Credential $Credential -Subdomain 'companyDomain'

{
    {
        "id": "18001",
        "name": "First Aid Trainings"
    },
    {
        "id": "18002",
        "name": "Management Training"
    }
}

.LINK
https://documentation.bamboohr.com/reference/list-training-categories

#>
function Get-BambooHrTrainingCategory {
  
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
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/training/category"
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