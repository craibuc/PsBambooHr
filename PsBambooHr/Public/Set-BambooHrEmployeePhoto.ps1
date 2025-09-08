<#
.SYNOPSIS
Set the photo for a BambooHR employee.

.DESCRIPTION
Set the photo for a BambooHR employee.

.PARAMETER ApiKey
The API key for the BambooHR account.

,PARAMETER Subdomain
The subdomain for the BambooHR account.

.PARAMETER EmployeeId
The ID of the employee to set the photo for.

.PARAMETER Path
The path to the photo file to upload. Supported formats are .gif, .jpg, .jpeg, and .png.

.EXAMPLE
Set-BambooHrEmployeePhoto -ApiKey 'your_api_key' -Subdomain 'your_subdomain' -EmployeeId 123 -Path '/path/to/photo.jpg'
Sets the photo for the employee with ID 123 using the specified photo file.

.URL
https://documentation.bamboohr.com/reference/upload-employee-photo
#>

function Set-BambooHrEmployeePhoto {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [int]$EmployeeId,

        [Parameter()]
        [string]$Path
    )
    
    begin {
        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }
    
    process {
        
        if ( (Test-Path -Path $Path) -eq $false )
        {
            throw [System.IO.FileNotFoundException]::new("File not found",$Path)
        }

        $Item = Get-Item -Path $Path

        if ( $Item.Extension -notin '.gif','.jpg','.jpeg','.png' )
        {
            throw [System.IO.FileFormatException]::new(("{0} is not a supported file format." -f $Item.Extension), $Path)
        }

        $Form = @{
            file = $Item
            fileName = $Item.Name
        }

        $Uri = "https://$Subdomain.bamboohr.com/api/v1/employees/$EmployeeId/photo"
        Write-Debug "Uri: $Uri"
      
        if ( $PSCmdlet.ShouldProcess($Item.Name, 'Set-BambooHrEmployeePhoto') )
        {
            $Response = Invoke-WebRequest -Uri $Uri -Method Post -Form $Form -Headers @{"Accept" = "application/json"} -Credential $Credentials #-UseBasicParsing
            $Response
        }

    }
    
    end {}
}
