# Windows maintenance 

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

function CheckDisk()
{
    Write-Host "Started checking disk at" (Get-Date).DateTime

    Write-Output y | chkdsk /f/r c:

    Write-Host "Finished checking disk at" (Get-Date).DateTime
    Write-Host ""
}

function SystemsFileCheck()
{
    Write-Host "Started systems file check at" (Get-Date).DateTime

    SFC /scannow

    Write-Host "Finished systems file check at" (Get-Date).DateTime
    Write-Host ""
}

function ScanWindowsImage()
{
    Write-Host "Started scanning Windows image at" (Get-Date).DateTime

    Dism /Online /Cleanup-Image /ScanHealth

    Write-Host "Finished scanning Windows image at" (Get-Date).DateTime
    Write-Host ""
}

function DefragDisk()
{
    Write-Host "Started defragging disk at" (Get-Date).DateTime

    defrag c: /u

    Write-Host "Finished defragging disk at" (Get-Date).DateTime
    Write-Host ""
}

function WindowsMaintenance()
{
    Write-Host "`nWindows maintenance.`nYou need to elevate permissions before running this script: Start-Process Powershell -Verb runAs`n"

    CheckOsForWindows

    try 
    {
        $startDateTime = (Get-Date)
        Write-Host "Started Windows maintenance at:" $startDateTime

        CheckDisk
        SystemsFileCheck
        ScanWindowsImage

        $disk = Get-PhysicalDisk

        if ($disk.MediaType -eq "HDD")
        {
            DefragDisk
        }

        Write-Host "Successfully performed maintenance on Windows." -ForegroundColor Green
    }
    catch
    {
        Write-Host "Failed to perform maintenance on Windows." -ForegroundColor Red
        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
        Write-Host ""
    }
    finally
    {
        $finishedDateTime = (Get-Date)
        Write-Host "Finished Windows maintenance at:" $finishedDateTime
        
        $duration = New-TimeSpan $startDateTime $finishedDateTime
        
        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)

        Write-Host ""

        Read-Host -Prompt "Please save your documents and close applications.`nPress any key to restart your computer"
        
        Restart-Computer
    }
}

WindowsMaintenance