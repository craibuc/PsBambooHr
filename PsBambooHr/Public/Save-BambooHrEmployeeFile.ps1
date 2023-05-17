<#
.SYNOPSIS
Gets the files associated with an employee.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany".

.PARAMETER EmployeeId
The employee record's unique identifier.

.PARAMETER FileId
The file's unique identifier.

.PARAMETER OutFile
Specifies the output file for which this cmdlet saves the response body. Enter a path and filename. 

.EXAMPLE
PS > Save-BambooHrEmployeeFile -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -EmployeeId 1 -FileId 1 -OutFile /Path/To/File

.LINK 
https://documentation.bamboohr.com/reference/get-employee-file-1

#>
function Save-BambooHrEmployeeFile
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [int]$EmployeeId,

        [Parameter(Mandatory)]
        [int]$FileId,

        [Parameter(Mandatory)]
        [string]$OutFile
    )

    begin {
        # headers
        $Headers = @{ Accept = 'application/json' }

        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$EmployeeId/files/$FileId"
        Write-Debug "Uri: $Uri"

        # credentials
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }

    process {

        try {
            Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers -Credential $Credentials -UseBasicParsing -OutFile $OutFile
        }
        catch {
            Write-Error -Message $_.Exception.Message
        }

    }

    end {}

}