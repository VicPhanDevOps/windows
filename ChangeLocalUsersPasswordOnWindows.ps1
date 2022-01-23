# change local user's password on Windows

# run this script with: .\ChangeLocalUsersPasswordOnWindows.ps1 -localUser < local user > -newPassword < new password >

[CmdletBinding()]
param (
      [string]       [Parameter(Mandatory = $False)] $localUser = "" # you can set the local user here
    , [securestring] [Parameter(Mandatory = $False)] $newPassword = $Null # you can set the new password here
)

function GetLocalUser([string]$localUser)
{
    if (($localUser -eq $Null) -or ($localUser -eq ""))
    {
        $localUser = Read-Host -Prompt "Please type the local user you would like to change the password for and press `"Enter`" key (Example: LocalUser)"

        Write-Host ""
        return $localUser
    }
    else
    {
        return $localUser
    }
}

function GetNewPassword([securestring]$newPassword)
{
    if (($newPassword -eq $Null) -or ($newPassword -eq ""))
    {
        $newPassword = Read-Host -Prompt "Please type the new password for the local user and press `"Enter`" key (Example: Password123)" -AsSecureString

        Write-Host ""
        return $newPassword
    }
    else
    {
        return $newPassword
    }
}

function CheckOsForWindows()
{
    Write-Host "Started checking operating system at" (Get-Date).DateTime
    $hostOs = [System.Environment]::OSVersion.Platform

    if ($hostOs -eq "Win32NT")
    {
        Write-Host "Operating System:" (Get-CimInstance -ClassName Win32_OperatingSystem).Caption -ForegroundColor Green

        Write-Host "Finished checking operating system at" (Get-Date).DateTime
        Write-Host ""
    }
    else 
    {
        Write-Host "Operating System:" $hostOs
        
        Write-Host "Sorry but this script only runs on Windows." -ForegroundColor Red

        Write-Host "Finished checking operating system at" (Get-Date).DateTime
        Write-Host ""

        break
    }
}

function CheckParameters([string]$localUser, [securestring]$newPassword)
{
    Write-Host "Started checking parameters at" (Get-Date).DateTime
    $valid = $True

    Write-Host "Parameters:"
    Write-Host "--------------------------------"
    Write-Host ("localUser  : {0}" -F $localUser)
    Write-Host ("newPassword: {0}" -F "***")
    Write-Host "--------------------------------"

    if (($localUser -eq $Null) -or ($localUser -eq ""))
    {
        Write-Host "localUser is not set." -ForegroundColor Red
        $valid = $False
    }

    if (($newPassword -eq $Null) -or ($newPassword -eq ""))
    {
        Write-Host "newPassword is not set." -ForegroundColor Red
        $valid = $False
    }

    if ($valid -eq $True)
    {
        Write-Host "All parameter checks passsed." -ForegroundColor Green
    }
    else 
    {
        Write-Host "One or more parameters are incorrect." -ForegroundColor Red
        break
    }

    Write-Host "Finished checking parameteres at" (Get-Date).DateTime
    Write-Host ""
}

function ChangeLocalUsersPassword([string]$localUser, [securestring]$newPassword) 
{
    Write-Host "`nChange local user's password on Windows.`n"
    CheckOsForWindows

    Write-Host "The local users on this computer are:"
    Get-LocalUser

    $localUser = GetLocalUser $localUser
    $newPassword = GetNewPassword $newPassword
    CheckParameters $localUser $newPassword

    try
    {
        $startDateTime = (Get-Date)
        Write-Host "Started changing local user's password at: " $startDateTime

        Set-LocalUser -Name $localUser -Password (ConvertTo-SecureString -AsPlainText $newPassword -Force)

        Write-Host ("Successfully changed the password for {0}." -F $localUser) -ForegroundColor Green

        $finishedDateTime = (Get-Date)
        Write-Host "Finished changing local user's password at: " $finishedDateTime

        $duration = New-TimeSpan $startDateTime $finishedDateTime
        
        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)

        Write-Host ""
    }
    catch
    {
        Write-Host ("Failed to change the password for {0}." -F $localUser) -ForegroundColor Red

        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
        Write-Host ""
    }
}

ChangeLocalUsersPassword $localUser $newPassword
