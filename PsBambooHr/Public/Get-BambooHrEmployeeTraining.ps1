<#
.SYNOPSIS
Gets the files associated with an employee.

.PARAMETER Credential
THe API key and password represented as a PsCredential.

$Credential = [System.Management.Automation.PSCredential]::new($ApiKey, ( 'Password' | ConvertTo-SecureString -AsPlainText -Force))

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany".

.PARAMETER EmployeeId
The employee record's unique identifier.

.PARAMETER TrainingTypeId
The training type id is optional. Not supplying a training type id will return the collection of all training records for the employee.

.EXAMPLE
PS > Get-BambooHrEmployeeTraining -Credential $Credential -Subdomain 'companyDomain' -EmployeeId 40468

{
  "13": {
    "id": "13",
    "employeeId": "40468",
    "trainingTypeId": "4",
    "completed": "2015-11-20",
    "notes": null,
    "credits": null,
    "cost": null
  },
  "14": {
    "id": "14",
    "employeeId": "40468",
    "trainingTypeId": "4",
    "completed": "2015-05-21",
    "notes": null,
    "credits": null,
    "cost": null
  },
  "15": {
    "id": "15",
    "employeeId": "40468",
    "trainingTypeId": "4",
    "completed": "2016-07-01",
    "notes": "55",
    "credits": "55",
    "cost": "55.00 USD"
  }
}

.LINK 
https://documentation.bamboohr.com/reference/list-employee-trainings

#>
function Get-BambooHrEmployeeTraining
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscredential]$Credential,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [int]$EmployeeId,

        [Parameter()]
        [int]$TrainingTypeId
    )

    begin {
        # headers
        $Headers = @{ Accept = 'application/json' }
    }

    process {

        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/training/record/employee/$EmployeeId"

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