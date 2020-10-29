<#
.SYNOPSIS
Get a BambooHR employee by its BambooHR-assigned, unique identifier.

.DESCRIPTION
Get employee data by specifying a set of fields. This is suitable for getting basic employee information, including current values for fields that are part of a historical table, like job title, or compensation information. See the fields endpoint for a list of possible fields.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER Id
The employee's unique identifier (assigned by Bamboo HR). The employee ID of zero (0) is the employee ID associated with the API key.

.LINK
Get-BambooHrField

.LINK
https://documentation.bamboohr.com/reference#get-employee

.LINK
https://documentation.bamboohr.com/reference#get-employees-directory-1
#>
function Get-BambooHrEmployee {

    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName='ForDirectory', Mandatory)]
        [Parameter(ParameterSetName='ById',Mandatory)]
        [string]$ApiKey,

        [Parameter(ParameterSetName='ForDirectory', Mandatory)]
        [Parameter(ParameterSetName='ById',Mandatory)]
        [string]$Subdomain,

        [Parameter(ParameterSetName='ById',Mandatory)]
        [ValidatePattern('\d')] # numbers only
        [string]$Id,

        [Parameter(ParameterSetName='ById')]
        [string[]]$Fields=@('firstName','lastName')
    )
    
    begin {
        # headers
        $Headers = @{
            Accept = 'application/json'
        }

        # uri
        if ( $Id -ne '' ) # strings are empty not null in PS
        {
            $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$Id/?fields=$( $Fields -join ',' )"
        }
        else
        {
            $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/directory"
        }
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