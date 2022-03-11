#
# Module manifest for module 'PsBambooHr'
#
# Generated by: Craig Buchanan
#
# Generated on: 9/23/2020
#

@{

# Script module or binary module file associated with this manifest.
RootModule = './PsBambooHr.psm1'

# Version number of this module.
ModuleVersion = '0.6.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'e46e5477-42b8-4a17-82f7-4d5ff0face03'

# Author of this module
Author = 'Craig Buchanan'

# Company or vendor of this module
CompanyName = 'Cogniza, Inc.'

# Copyright statement for this module
Copyright = '(c) Cogniza. All rights reserved.'

# Description of the functionality provided by this module
Description = 'PowerShell module that wraps the BambooHR API.'

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Get-BambooHrEmployee','New-BambooHrEmployee','Set-BambooHrEmployee'
    'Get-BambooHrEmployeeFile','New-BambooHrEmployeeFile','Remove-BambooHrEmployeeFile','Set-BambooHrEmployeeFile'
    'New-BambooHrEmployeeFileCategory',
    'Get-BambooHrEmployeeTableRow','New-BambooHrEmployeeTableRow','Set-BambooHrEmployeeTableRow'
    'Get-BambooHrField'
    'Get-BambooHrList'
    'Get-BambooHrTable'
    'Get-BambooHrUser'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('bamboohr','bamboo','hr','powershell')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/craibuc/PsBambooHr/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/craibuc/PsBambooHr'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = 'alpha'

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

