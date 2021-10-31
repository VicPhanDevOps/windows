# activate Windows in PowerShell

# you can run this script with: .\ActivateWindows.ps1 -computerName < computer name > -licenseKey < license key >

[CmdletBinding()]
param 
(
    [string] [Parameter(Mandatory = $False)] $computerName = "", 
    [string] [Parameter(Mandatory = $False)] $licenseKey = ""
)

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
        
        Write-Host "Sorry but this script only works on Windows." -ForegroundColor Red

        Write-Host "Finished checking operating system at" (Get-Date).DateTime
        Write-Host ""
        break
    }
}

function GetComputerName([string]$computerName)
{
    if (($computerName -eq $Null) -or ($computerName -eq ""))
    {
        $computerName = Read-Host -Prompt "Please type the computer name and press `"Enter`" key (Example: Dev-PC) or press `"Ctrl`" and `"C`" keys to use the computer name from the environment"
        
        Write-Host ""
        return $computerName
    }
    else 
    {
        $computerName = Get-Content $env:Computername
        return $computerName
    }
}

function GetLicenseKey([string]$licenseKey)
{
    if (($licenseKey -eq $Null) -or ($licenseKey -eq ""))
    {
        $licenseKey = Read-Host -Prompt "Please type the Windows license key (Example: aaaaa-bbbbb-ccccc-ddddd-eeeee) and press `"Enter`" key"

        Write-Host ""
        return $licenseKey
    }
    else
    {
        return $licenseKey
    }
}

function CheckParameters([string]$computerName, [string]$licenseKey)
{
    Write-Host "Started checking parameters at" (Get-Date).DateTime
    $valid = $True

    Write-Host "Parameters:"
    Write-Host "-------------------------------------"
    Write-Host ("computerName: {0}" -F $computerName)
    Write-Host ("licenseKey  : {0}" -F $licenseKey)
    Write-Host "-------------------------------------"

    if (($computerName -eq $Null) -or ($computerName -eq ""))
    {
        Write-Host "computerName is not set." -ForegroundColor Red
        $valid = $False
    }

    if (($licenseKey -eq $Null) -or ($licenseKey -eq ""))
    {
        Write-Host "licenseKey is not set." -ForegroundColor Red
        $valid = $False
    }

    if ($valid -eq $True)
    {
        Write-Host "All parameter checks passed." -ForegroundColor Red
    }
    else 
    {
        Write-Host "One or more parameter checks are incorrect." -ForegroundColor Red
        
        break
    }

    Write-Host "Finished checking parameters at" (Get-Date).DateTime
    Write-Host ""
}

function ActivateWindows([string]$computerName, [string]$licenseKey)
{
    Write-Host "`nActivate Windows in PowerShell`n"
    CheckOsForWindows

    $computerName = GetComputerName $computerName
    $licenseKey = GetLicenseKey $licenseKey
    CheckParameters $computerName $licenseKey

    try
    {
        $startDateTime = (Get-Date)
        Write-Host "Started activating Windows at: " $startDateTime
        
        $service = Get-WmiObject -query "select * from SoftwareLicensingService" -Computername $computerName

        $service.InstallProductKey($licenseKey)
        $service.RefreshLicenseStatus()

        Write-Host ("Windows has been activated on {0} with license key: {1}" -F $computerName, $licenseKey) -ForegroundColor Green

        $finishedDateTime = (Get-Date)
        Write-Host "Finished activating Windows at: " $finishedDateTime
        
        $duration = New-TimeSpan $startDateTime $finishedDateTime
        
        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)
    }
    catch
    {
        Write-Host ("Windows failed to activate on {0} with license key: {1}" -F $computerName, $licenseKey) -ForegroundColor Red

        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
    }
}

ActivateWindows $computerName $licenseKey
