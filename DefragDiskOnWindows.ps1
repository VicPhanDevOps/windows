# defrag disk on Windows

function CheckOsForWindows()
{
    Write-Host "`nStarted checking operating system at" (Get-Date).DateTime
    $hostOS = [System.Environment]::OSVersion.Platform

    if ($hostOS -eq "Win32NT")
    {
        Write-Host "Operating System: " (Get-CimInstance -ClassName Win32_OperatingSystem).Caption -ForegroundColor Green

        Write-Host "Finished checking operating system at" (Get-Date).DateTime
        Write-Host ""
    }
    else 
    {
        Write-Host "Operating System:" $hostOS
        
        Write-Host "Sorry but this script only works on Windows." -ForegroundColor Red

        Write-Host "Finished checking operating system at" (Get-Date).DateTime
        Write-Host ""
        break
    }
}

function DefragDisk()
{
    Write-Host "`nDefrag disk on Windows`n"
    CheckOsForWindows

    try
    {
        $startDateTime = (Get-Date)
        Write-Host "Started defragging disk at" $startDateTime

        defrag c: /u

        Write-Host "`nSuccessfully defragged disk.`n" -ForegroundColor Green
        $finishedDateTime = (Get-Date)
        Write-Host "Finished defragging disk at" $finishedDateTime
        $duration = New-TimeSpan $startDateTime $finishedDateTime

        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)
    }
    catch
    {
        Write-Host "`nFailed to defrag disk.`n" -ForegroundColor Red
        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
    }
}

DefragDisk
