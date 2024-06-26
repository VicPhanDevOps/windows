# delete local test user on Windows 

# run this script with: .\DeleteLocalTestUserOnWin.ps1 -testUser < test user >

[CmdletBinding()]
param(
    [string] [Parameter(Mandatory = $False)] $testUser = "" # you can set the test user here
)

function CheckOsForWin()
{
    Write-Host "Started checking operating system at" (Get-Date).DateTime
    $hostOs = [System.Environment]::OSVersion.Platform

    if ($hostOs -eq "Win32NT")
    {
        Write-Host "Operating System:" (Get-CimInstance -ClassName Win32_OperationSystem).Caption -ForegroundColor Green

        Write-Host "Finished checking operating system at" (Get-Date).DateTime
        Write-Host ""
    }
    else 
    {
        Write-Host "Operating System:" $hostOs
        throw "Sorry but this script only works in Windows." 
    }
}

function GetTestUser([string]$testUser)
{
    if (($testUser -eq $Null) -or ($testUser -eq ""))
    {
        $testUser = Read-Host -Prompt "Please input test username and press `"Enter`" key (Example: testuser)"

        Write-Host ""
        return $testUser
    }
    else 
    {
        return $testUser
    }
}

function CheckParameters([string]$testUser)
{
    Write-Host "Started checking parameter(s) at" (Get-Date).DateTime
    $valid = $True

    Write-Host "Parameter(s):"
    Write-Host "-----------------------------"
    Write-Host ("testUser: {0}" -F $testUser)
    Write-Host "-----------------------------"

    if (($testUser -eq $Null) -or ($testUser -eq ""))
    {
        Write-Host "testUser is not set." -ForegroundColor -Red
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
        throw "One or more parameters are incorrect." 
    }
}

function DeleteTestUser([string]$testUser)
{
    Write-Host "`nDelete local test user on Windows`n"
    CheckOsForWin

    $testUser = GetTestUser $testUser
    CheckParameters $testUser

    try
    {
        $startDateTime = (Get-Date)
        Write-Host "Started deleting local test user at" $startDateTime.DateTime

        Remove-LocalUser -Name "$testUser"

        Write-Host ("Successfuly deleted test user: {0}" -F $testUser) -ForegroundColor Green

        $finishedDateTime = (Get-Date)
        Write-Host "Finished deleting local user at" $finishedDateTime.DateTime

        $duration = New-TimeSpan $startDateTime $finishedDateTime

        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)

        Write-Host ""

        Write-Host "The users on this computer are:"
        Get-LocalUser
    }
    catch
    {
        Write-Host ("`nFailed to delete test user: {0} `n" -F $testUser) -ForegroundColor Red

        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
        
        Write-Host "The users on this computer are:"
        Get-LocalUser
    }
}

DeleteTestUser $testUser
