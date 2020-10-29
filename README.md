# PsBambooHr
PowerShell module that wraps the BambooHR API.

## Installation

- Copy the archive to local computer
- Expand archive
- Move the `PsBambooHr` folder to `~/Documents/PowerShell/Modules`
- Run `Unblock-File` on the module

## Usage

```powershell
# import the module into the session's scope
Import-Module PsBambooHr
```

### Get-BambooHrEmployee

```powershell
# gets a list of all active employees

Get-BambooHrField -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany'

id  firstName lastName
--  --------- -------
111 First     Last
112 Jane      Doe
113 John      Doe
```

```powershell
# get employee #111

Get-BambooHrField -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany' -Id 111

id  firstName lastName
--  --------- -------
111 First     Last
```

```powershell
# get employee #111, specifying the desired fields

Get-BambooHrField -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany' -Id 111 -Fields firstName,lastName,gender 

id  firstName lastName gender
--  --------- -------  ------
111 First     Last     Male
```

### Set-BambooHrEmployee

```powershell
# sets the `gender` property to 'Male' for employee #112

@{
  id = 112
  gender = 'Male'
} | Set-BambooHrEmployee  -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany'
```

```powershell
# makes employees #112 and #113 inactive

@{
  id = 112
  status = $false
},
@{
  id = 113
  status = $false
} | Set-BambooHrEmployee  -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany'
```

### New-BambooHrEmployee

```powershell
# creates a new employee

@{
  firstName = 'Fred'
  lastName = 'Flintstone'
  gender = 'Male'
  employeeNumber = 'FF123456'
} | Set-BambooHrEmployee  -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany'
```

### Get-BambooHrField

```powershell
# get a list of fields

Get-BambooHrField -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany'

    id name                             type             alias
    -- ----                             ----              -----
  4175 Accrual Level Start Date         date
     8 Address Line 1                   text              address1
     9 Address Line 2                   text              address2
  4304 Benefit Groups                   benefit_group     
  1502 Benefit History                  benefit_history   
     6 Birth Date                       date              dateOfBirth
    10 City                             text              city
...
```
```powershell
# get a list of fields with an alias, then sort by the alias

Get-BambooHrField -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany' | Where-Object { $null -ne $_.alias } | Sort-Object -Property alias | Select-Object -ExpandedProperty alias

acaStatus
address1
address2
city
country
dateOfBirth
department
division
eeo
employeeNumber
employeeStatusDate
employmentHistoryStatus
employmentHistoryStatus
employmentStatus
ethnicity
exempt
facebook
...
```

```powershell
# get a detailed list of fields

Get-BambooHrField -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany' -Detailed

fieldId    : 16
manageable : yes
multiple   : no
name       : Employment Status
options    : {@{id=18358; archived=no; createdDate=9/24/2020 5:24:20 PM; archivedDate=; name=Contractor}, ...}
alias      : employmentHistoryStatus

fieldId    : 17
manageable : yes
multiple   : no
name       : Job Title
options    : {}
alias      : jobTitle

fieldId    : 18
manageable : yes
multiple   : no
name       : Location
options    : {}
alias      : location

...
```
> NOTE: `id` corresponds with `fieldId`.

### Get-BambooHrTable

```powershell
# get the list of tabular fields

Get-BambooHrTable -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany'

alias               fields
-----               ------
jobInfo             {@{id=4047; name=Job Information: Date; alias=date; type=date}, @{id=18; name=Location; alias=location; type=list}, @{id=4; name=Department; alias=department; type=list}, @{id=1355; name=Division; alias=division; type=list}…}
employmentStatus    {@{id=1936; name=Employment Status: Date; alias=date; type=date}, @{id=16; name=Employment Status; alias=employmentStatus; type=list}, @{id=4046; name=Employment status comments; alias=comment; type=textarea}, @{id=4314; name=Termin…
...
```

### Get-BambooHrUser

```powershell
# get the list of users

Get-BambooHrUser -ApiKey 'xxxxxxxxxx' -Subdomain 'mycompany'

1234
----
@{id=1234; employeeId=111; firstName=First; lastName=Last; email=first.last@mycompany.tld; status=enabled; lastLogin=10/29/2020 12:00:00 AM}
```
