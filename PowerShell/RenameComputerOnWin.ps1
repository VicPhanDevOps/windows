# rename computer on Windows 

# haven't tested this script yet
# run this script as admin: Start-Process PowerShell -Verb RunAs
# you can run this script with: .\RenameComputerOnWin.ps1 -newName '< new computer name >'

[CmdletBinding()]
param(
    [string] [Parameter(Mandatory = $False)] $newName = ""
)

function CheckOsForWin()
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
        throw "Sorry but this script only works on Windows."     }
}

function GetNewName([string]$newName)
{
    if (($newName -eq $Null) -or ($newName -eq ""))
    {
        $newName = Read-Host -Prompt "Please type the new name of the computer and press the `"Enter`" key (Example: DEV-PC)"

        Write-Host ""
        return $newName
    }
    else 
    {
        return $newName
    }
}

function CheckParameters([string]$newName)
{
    Write-Host "Started checking parameter(s) at" (Get-Date).DateTime
    $valid = $True

    Write-Host "Parameter(s):"
    Write-Host "---------------------------"
    Write-Host ("newName: {0}" -F $newName)
    Write-Host "---------------------------"

    if (($newName -eq $Null) -or ($newName -eq ""))
    {
        Write-Host "newName is not set." -ForegroundColor Red
        $valid = $False
    }

    if ($valid -eq $True)
    {
        Write-Host "All parameter check(s) passed." -ForegroundColor Green

        Write-Host "Finished checking parameter(s) at" (Get-Date).DateTime
        Write-Host ""
    }
    else 
    {
        throw "One or more parameter checks are incorrect." 
    }
}

function RenameComputer([string]$newName)
{
    Write-Host "`nRename computer on Windows.`n"
    CheckOsForWin

    $newName = GetNewName $newName
    CheckParameters $newName

    try 
    {
        $startDateTime = (Get-Date)
        Write-Host "Started renaming computer at" $startDateTime.DateTime

        Rename-Computer -NewName "$newName" -DomainCredential Domain01\Admin01 -Restart

        $hostName = $Env:COMPUTERNAME
        Write-Host "The computer name is:" $hostName

        Write-Host ("Successfully renamed computer to {0}." -F $newName) -ForegroundColor Green

        $finishedDateTime = (Get-Date)
        Write-Host "Finished renaming computer at" $finishedDateTime.DateTime

        $duration = New-TimeSpan $startDateTime $finishedDateTime
        
        Write-Host ("Total execution time: {0} hours {0} minutes {1} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)

        Write-Host ""
    }
    catch
    {
        Write-Host ("Failed to rename the computer to {0}." -F $newName) -ForegroundColor Red
        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
        Write-Host ""
    }
}

RenameComputer $newName
