<#
.SYNOPSIS
Gets the list of BambooHR users.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER Id
The employee record's primary key.

.PARAMETER FileId
The file record's primary key.

.EXAMPLE
PS> Remove-BambooHrEmployeeFile -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -Id 1 -FileId 100

.LINK
https://documentation.bamboohr.com/reference#delete-employee-file-1

#>
function Remove-BambooHrEmployeeFile
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [ValidatePattern('\d')] # numbers only
        [string]$Id,

        [Parameter(Mandatory)]
        [ValidatePattern('\d')] # numbers only
        [string]$FileId
    )

    begin {
        # headers
        $Headers = @{
            Accept = 'application/json'
        }

        # credentials
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password

        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$Id/files/$FileId"
    }

    process {

        try
        {
            if ( $PSCmdlet.ShouldProcess("EmployeeId: $Id; FileId: $FileId",'Delete') ) 
            {
                $Response = Invoke-WebRequest -Uri $Uri -Method Delete -Headers $Headers -ContentType "application/json" -Credential $Credentials -UseBasicParsing
            }
        }
        catch
        {
            Write-Error -Message $_.Exception.Message
        }

    }

    end {}

}