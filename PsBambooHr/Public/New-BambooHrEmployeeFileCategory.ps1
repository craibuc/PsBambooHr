<#
.SYNOPSIS
Add an employee file category.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER Name
An array of categories to add.

.EXAMPLE
PS> New-BambooHrEmployeeFileCategory -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -Name 'Category I','Category II'

.LINK
https://documentation.bamboohr.com/reference#add-employee-file-category-1

#>
function New-BambooHrEmployeeFileCategory
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [string[]]$Name
    )

    begin {
        # headers
        $Headers = @{ Accept = 'application/json' }

        # uri
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/files/categories"
        Write-Debug "Uri: $Uri"

        # credentials
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }

    process {

        try {
            $Response = Invoke-WebRequest -Uri $Uri -Method Post -Body ($Name | ConvertTo-Json) -Headers $Headers -Credential $Credentials -UseBasicParsing
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