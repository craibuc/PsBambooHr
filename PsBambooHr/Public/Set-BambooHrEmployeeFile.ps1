<#
.SYNOPSIS
Modified a file that has been sent to BambooHr.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER EmployeeId
The employee's unique identifier (assigned by Bamboo HR). The employee ID of zero (0) is the employee ID associated with the API key.

.PARAMETER FileId
The file's unique identifier.

.PARAMETER FileName
The file's new name.

.PARAMETER CategoryId
The new category (i.e. the folder) that will contain the file.

.PARAMETER Share
Share the document with the employee.

.EXAMPLE
PS> Set-BambooHrEmployeeFile -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -Id 1 -FileId 100 -FileName 'New Name.pdf' -CategoryId 22 -Share $false

Changes the file name and category of the file; prevents the file from being shared with the employee.

.LINK
https://documentation.bamboohr.com/reference#update-employee-file-1
#>
function Set-BambooHrEmployeeFile
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

        [Parameter()]
        [string]$FileName,

        [Parameter()]
        [int]$CategoryId,

        [Parameter()]
        [bool]$Share
    )

    begin {

        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password

        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$EmployeeId/files/$FileId"
    }

    process {

        $Body = @{
            shareWithEmployee = $Share ? 'yes' : 'no'
        }

        if ( ![string]::IsNullOrEmpty($fileName) ) { $Body['name']=$fileName }
        if ( $categoryId -ne 0 ) { $Body['categoryId']=$categoryId }

        Write-Debug ($Body | ConvertTo-Json)

        try
        {
            Invoke-WebRequest -Uri $Uri -Method Post -Body ($Body | ConvertTo-Json) -ContentType 'application/json' -Credential $Credentials -UseBasicParsing | Out-Null
        }
        catch
        {
            Write-Error -Message $_.Exception.Message
        }

    }

    end {}
}