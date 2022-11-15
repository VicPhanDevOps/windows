# create local admin on Windows

# you can run this script with: .\CreateLocalAdminOnWindows.ps1 -localAdmin < new admin > -password < new password > -description < admin description >

[CmdletBinding()]
param(
    [string]       [Parameter(Mandatory = $False)] $localAdmin  = "", # you can set the local admin here
    [securestring] [Parameter(Mandatory = $False)] $password    = $Null, # you can set the password here
    [string]       [Parameter(Mandatory = $False)] $description = "" # you can set the description here
)

function CheckOsForWindows()
{
    Write-Host "Stared checking operating system at" (Get-Date).DateTime
    $hostOs = [System.Environment]::OSVersion.Platform

    if ($hostOs -eq "Win32NT")
    {
        Write-Host "Operating System: " (Get-CimInstance -ClassName Win32_OperatingSystem).Caption -ForegroundColor Green

        Write-Host "Finished checking operating system at" (Get-Date).DateTime
        Write-Host ""
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

function GetLocalAdmin([string]$localAdmin)
{
    if (($localAdmin -eq $Null) -or ($localAdmin -eq ""))
    {
        $localAdmin = Read-Host -Prompt "Please the admin name and press `"Enter`" key (Example: 'Foo.Bar')"

        Write-Host ""
        return $localAdmin
    }
    else
    {
        return $localAdmin
    }
}

function GetPassword([securestring]$password)
{
    if (($password -eq $Null) -or ($password -eq ""))
    {
        $password = Read-Host -Prompt "Please type the password and press `"Enter`" key (Example: 'Password1234')" -AsSecureString

        Write-Host ""
        return $password
    }
    else
    {
        return $password
    }
}

function GetDescription()
{
    if (($description -eq $Null) -or ($description -eq ""))
    {
        $description = Read-Host -Prompt "Please type the description and press `"Enter`" key (Example: 'Local Admin')"

        Write-Host ""
        return $description
    }
    else
    {
        return $description
    }
}

function CheckParameters([string]$localAdmin, [securestring]$password, [string]$description)
{
    Write-Host "Started checking parameters at" (Get-Date).DateTime
    $valid = $True

    Write-Host "Parameters:"
    Write-Host "-----------------------------------"
    Write-Host ("localAdmin : {0}" -F $localAdmin)
    Write-Host ("password   : {0}" -F "***")
    Write-Host ("description: {0}" -F $description)
    Write-Host "-----------------------------------"

    if (($localAdmin -eq $Null) -or ($localAdmin -eq ""))
    {
        Write-Host "localAdmin is not set." -ForegroundColor Red
        $valid = $False
    }

    if (($password -eq $Null) -or ($password -eq ""))
    {
        Write-Host "password is not set." -ForegroundColor Red
        $valid = $False
    }

    if (($description -eq $Null) -or ($description -eq ""))
    {
        Write-Host "description is not set." -ForegroundColor Red
        $valid = $False
    }

    if ($valid -eq $True)
    {
        Write-Host "All parameters checks passed." -ForegroundColor -Green

        Write-Host "Finished checking parameters at" (Get-Date).DateTime
        Write-Host ""
    }
    else 
    {
        Write-Host "One or more parameters are incorrect." -ForegroundColor Red

        Write-Host "Finished checking parameters at" (Get-Date).DateTime
        Write-Host ""

        break
    }
}

function CreateLocalAdmin([string]$localAdmin, [securestring]$password, [string]$description)
{
    Write-Host "`nCreate local admin on Windows.`n"
    CheckOsForWindows

    $localAdmin  = GetLocalAdmin $localAdmin
    $password    = GetPassword $password
    $description = GetDescription $description
    CheckParameters $localAdmin $password $description

    try
    {
        $startDateTime = (Get-Date)
        Write-Host "Started creating local admin at: " $startDateTime

        New-LocalUser "$localAdmin" -Password $password -FullName "$localAdmin" -Description "$description"

        Add-LocalGroupMember -Group "Administrators" -Member "$localAdmin"
        Set-LocalUser -Name "$localAdmin" -PasswordNeverExpires 1

        Write-Host ("Successfully created local admin {0}." -F $localAdmin) -ForegroundColor Green

        $finishedDateTime = (Get-Date)
        Write-Host "Finished creating local admin at: " $finishedDateTime

        $duration = New-TimeSpan $startDateTime $finishedDateTime

        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)

        Write-Host ""

        Write-Host "The users on this computer are: "
        Get-LocalUser
    }
    catch
    {
        Write-Host ("Faild to create local admin {0}." -F $localAdmin) -ForegroundColor Red

        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red

        Write-Host "The users on this computer are:"
        Get-LocalUser
    }
}

CreateLocalAdmin $localAdmin $password $description