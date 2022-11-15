# create remote mailbox in Exchange

# you can run this script with: .\CreateRemoteMailboxInExchange.ps1 -email < email > -password < password > -firstName < first name > -lastName < last name >

[CmdletBinding()]
param(
      [string]       [Parameter(Mandatory = $False)] $email = ""
    , [securestring] [Parameter(Mandatory = $False)] $password = $Null
    , [string]       [Parameter(Mandatory = $False)] $firstName = ""
    , [string]       [Parameter(Mandatory = $False)] $lastName = ""
)

function CheckOsForWindows()
{
    Write-Host "Started checking operating system at" (Get-Date).DateTime
    $hostOs = [System.Environment]::OSVersion.Platform

    if ($hostOs -eq "Win32NT")
    {
        Write-Host "Operating System:" (Get-CimInstance -ClassName Win32_OperatingSystem).Caption -ForegroundColor Green

        Write-Host "Finished checking parameters at" (Get-Date).DateTime
        write-Host ""
    }
    else 
    {
        Write-Host "Operating System:" $hostOs
        
        Write-Host "Sorry but this script only works on Windows." -ForegroundColor Red

        Write-Host "Finished checking operating system at" (Get-Date).DateTime
        Write-Host ""
        break
    }
}
function GetEmail([string]$email)
{
    if (($email -eq $Null) -or ($email -eq ""))
    {
        $email = Read-Host -Prompt "Please type the new email you wish to create and press `"Enter`" key (Example: dev@vicphan.dev)"

        return $email
    }
    else
    {
        return $email
    }
}

function GetPassword([securestring]$password)
{
    if (($password -eq $Null) -or ($password -eq ""))
    {
        $password = Read-Host -Prompt "Please type the password for the new email account and press `"Enter`" (Example: Password123)" -AsSecureString

        return $password
    }
    else
    {
        return $password
    }
}

function GettFirstName([string]$firstName)
{
    if (($firstName -eq $Null) -or ($firstName -eq ""))
    {
        $firstName = Read-Host -Prompt "Please type the first name for the new account and press `"Enter`" key (Example: Software)"

        return $firstName
    }
    else 
    {
        return $firstName
    }
}

function GetLastName([string]$lastName)
{
    if (($lastName -eq $Null) -or ($lastName -eq ""))
    {
        $lastName = Read-Host -Prompt "Please type the last name for the new account and press `"Enter`" key (Example: Developer)"

        return $lastName
    }
    else
    {
        return $lastName
    }
}

function CheckParameters([string]      $email, 
                         [securestring]$password, 
                         [string]      $firstName, 
                         [string]      $lastName)
{
    Write-Host "Started checking parameters at" (Get-Date).DateTime
    $valid = $True

    Write-Host "Parameters:"
    Write-Host "-------------------------------"
    Write-Host ("email    : {0}" -F $email)
    Write-Host ("password : {0}" -F "***")
    Write-Host ("firstName: {0}" -F $firstName)
    Write-Host ("lastName : {0}" -F $lastName)
    Write-Host "-------------------------------"

    if (($email -eq $Null) -or ($email -eq ""))
    {
        Write-Host "email is not set." -ForegroundColor Red
        $valid = $False
    }

    if (($password -eq $Null) -or ($password -eq ""))
    {
        Write-Host "password is not set." -ForegroundColor Red
        $valid = $False
    }

    if (($firstName -eq $Null) -or ($firstName -eq ""))
    {
        Write-Host "firstName is not set." -ForegroundColor Red
        $valid = $False
    }

    if (($lastName -eq $Null) -or ($lastName -eq ""))
    {
        Write-Host "lastName is not set." -ForegroundColor Red
        $valid = $False
    }

    if ($valid -eq $True)
    {
        Write-Host "All parameter checks passed." -ForegroundColor Green
    }
    else
    {
        Write-Host "One or more parameter checks incorrect, exiting script." -ForegroundColor Red

        exit -1
    }

    Write-Host "Finished checking parameters at" (Get-Date).DateTime
}

function NewRemoteMailboxInExchange([string]      $email, 
                                    [securestring]$password, 
                                    [string]      $firstName, 
                                    [string]      $lastName)
{
    Write-Host "`nCreate remote mailbox in Exchange.`n"
    CheckOsForWindows

    $email = GetEmail $email
    $password = GetPassword $password
    $firstName = GettFirstName $firstName
    $lastName = GetLastName $lastName
    CheckParameters $email $password $firstName $lastName

    try 
    {
        $startDateTime = (Get-Date)
        Write-Host "Started creating remote mailbox at" $startDateTime

        New-Mailbox -UserPrincipalName $email  -Name $firstName$lastName -OrganizationalUnit Users -Password $password -FirstName $firstName -LastName $lastName -DisplayName "$firstName $lastName" -ResetPasswordOnNextLogon $false

        Write-Host ("Successfully created new mailbox: {0}" -F $email) -ForegroundColor Green

        $finishedDateTime = (Get-Date)
        Write-Host "Finished creating remote mailbox at" (Get-Date)
        $duration = New-TimeSpan $startDateTime $finishedDateTime

        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)
    }
    catch 
    {
        Write-Host ("Failed to create new mailbox: {0}" -F $email) -ForegroundColor Red

        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
    }
}

NewRemoteMailboxInExchange $email $password $firstName $lastName