# defrag disk on Windows

function CheckOsForWin()
{
    Write-Host "Started checking operating system at" (Get-Date).DateTime
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
        throw "Sorry but this script only works on Windows." 
    }
}

function DefragDisk()
{
    Write-Host "`nDefrag disk on Windows`n"
    CheckOsForWin

    try
    {
        $startDateTime = (Get-Date)
        Write-Host "Started defragging disk at" $startDateTime.DateTime.DateTime

        $disk = Get-PhysicalDisk

        if ($disk.MediaType -eq "HDD")
        {
            defrag c: /u
            Write-Host "Successfully defragged disk." -ForegroundColor Green
        } 
        else 
        {
            Write-Host "SSD drives don't need defragging." -ForegroundColor Red
        }
        
        $finishedDateTime = (Get-Date)
        Write-Host "Finished defragging disk at" $finishedDateTime.DateTime.DateTime
        
        $duration = New-TimeSpan $startDateTime $finishedDateTime

        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)

        Write-Host ""
    }
    catch
    {
        Write-Host "Failed to defrag disk." -ForegroundColor Red
        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
        Write-Host ""
    }
}

DefragDisk
