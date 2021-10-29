<#
.SYNOPSIS
Transmits a file to BambooHr and associates with an employee and file category.

.PARAMETER ApiKey
The API key.

.PARAMETER Subdomain
The subdomain used to access bamboohr. If you access bamboohr at https://mycompany.bamboohr.com, then the companyDomain is "mycompany"

.PARAMETER EmployeeId
The employee's unique identifier (assigned by Bamboo HR). The employee ID of zero (0) is the employee ID associated with the API key.

.PARAMETER Path
The path to the file to be transmitted.

.PARAMETER CategoryId
The category (i.e. the folder) that will contain the file.

.PARAMETER Share
Share the document with the employee.

.EXAMPLE
PS> New-BambooHrEmployeeFile -ApiKey '3ee9c09c-c4be-4e0b-9b08-d7df909ae001' -Subdomain 'companyDomain' -Id 1 -Path '~/Desktop/My File.pdf' -CategoryId 28 -Share

Transmits ~/Desktop/My File.pdf to BambooHR, associating it with the empployee with Id 1, placing it in the Uncategoried [28] folder, and sharing it with the employee.
#>
function New-BambooHrEmployeeFile
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Subdomain,

        [Parameter(Mandatory)]
        [int]$EmployeeId,

        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [int]$CategoryId,

        [Parameter()]
        [bool]$Share
    )

    begin {
        $Headers = @{
            Accept = 'application/json'
        }

        $Password = ConvertTo-SecureString 'Password' -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApiKey, $Password
    }

    process {

        if ( (Test-Path -Path $Path) -eq $false )
        {
            throw [System.IO.FileNotFoundException]::new("File not found",$Path)
        }

        # $boundary = [System.Guid]::NewGuid().ToString();
        # $LF = "`r`n";

        #
        # process file
        #

        # $Item = Get-Item -Path $Path

        # $fileBytes = [System.IO.File]::ReadAllBytes($Path);
        # $fileEnc = [System.Text.Encoding]::GetEncoding('UTF-8').GetString($fileBytes);

        # $fileTemplate =
        # "--$boundary
        # Content-Disposition: form-data; name=`"`"; filename=`"{0}`"
        # Content-Type: application/octet-stream
        
        # {1}" -f $Item.Name, $fileEnc
        
        # $bodyLines = ( 
        #     "--$boundary",
        #     "Content-Disposition: form-data; name=`"file`"; filename=`"$Item.Name`"",
        #     "Content-Type: application/octet-stream$LF",
        #     $fileEnc,
        #     "--$boundary--$LF" 
        # ) -join $LF

        #
        # other attributes
        #
        
        # $template = 
        # "--$boundary
        # Content-Disposition: form-data; name=`"{0}`"

        # {1}"

                # Invoke-RestMethod -Uri $Uri -Method Post -ContentType "multipart/form-data; boundary=`"$boundary`"" -Body $bodyLines

        $Item = Get-Item -Path $Path

        $Form = @{
            file = $Item
            fileName = $Item.Name
            category = $CategoryId.ToString()
            share = $Share ? 'yes' : 'no'
        }
    
        $Uri = "https://api.bamboohr.com/api/gateway.php/$Subdomain/v1/employees/$EmployeeId/files"
        Write-Debug "Uri: $Uri"
        
        # $FileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new('form-data')
        # $FileHeader.Name = $FieldName
        # $FileHeader.FileName = Split-Path -Leaf $Path
        # $FileHeader.Size = $Item.Length

        # $ResolvedPath = Resolve-Path $Path

        # $FileStream = [System.IO.FileStream]::new($ResolvedPath, [System.IO.FileMode]::Open)
        # $FileContent = [System.Net.Http.StreamContent]::new($FileStream)

        # $FileContent.Headers.ContentDisposition = $FileHeader
        # $FileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('application/octet-stream')
        
        # $MultipartContent = [System.Net.Http.MultipartFormDataContent]::new()
        # $MultipartContent.Add($FileContent)
        
        # $MultipartContent.Add($CategoryId, 'category')

        try
        {
            if ( $PSCmdlet.ShouldProcess($Item.Name, 'Send') )
            {
                # $Response = Invoke-WebRequest -Proxy 'http://localhost:8080' -Uri $Uri -Method Post -Form $Form -Headers $Headers -Credential $Credentials -UseBasicParsing
                $Response = Invoke-WebRequest -Uri $Uri -Method Post -Form $Form -Headers $Headers -Credential $Credentials -UseBasicParsing
                $Response
            }
        }
        catch
        {
            Write-Error -Message $_.Exception.Message
        }

    }

    end {}
}