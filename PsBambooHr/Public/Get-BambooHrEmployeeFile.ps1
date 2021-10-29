<#
.SYNOPSIS
Gets the files associated with an employee.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany".

.PARAMETER EmployeeId
The employee record's unique identifier.

.EXAMPLE
PS > Get-BambooHrEmployeeFile -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -EmployeeId 1

{
    "employee": {
        "id": 1
    },
    "categories": [
        {
            "id": 1,
            "name": "New Hire Docs",
            "canRenameCategory": "yes",
            "canDeleteCategory": "yes",
            "canUploadFiles": "yes",
            "displayIfEmpty": "yes",
            "files": [
                {
                    "id": 1234,
                    "name": "Employee handbook",
                    "originalFileName": "employee_handbook.doc",
                    "size": 23552,
                    "dateCreated": "2011-06-28 16:50:52",
                    "createdBy": "John Doe",
                    "shareWithEmployee": "yes",
                    "canRenameFile": "yes",
                    "canDeleteFile": "yes",
                    "canChangeShareWithEmployeeFieldValue": "yes"
                }
            ]
        },
        {
            "id": 112,
            "name": "Training Docs"
        }
    ]
}

.LINK 
https://documentation.bamboohr.com/reference#employee-files-1

#>
function Get-BambooHrEmployeeFile
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [int]$EmployeeId
    )

    begin {
        # headers
        $Headers = @{ Accept = 'application/json' }

        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$EmployeeId/files/view/"
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