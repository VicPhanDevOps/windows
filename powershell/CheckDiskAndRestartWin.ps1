# check disk and restart Windows

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
        throw "Sorry but this script only runs on Windows." 
    }
}

function CheckDiskAndRestartWindows()
{
    Write-Host "`nCheck disk and restart on Windows.`n"
    CheckOsForWin

    try
    {
        $startDateTime = (Get-Date)
        
        Write-Host "Started checking disk and restarting Windows at: " $startDateTime.DateTime.DateTime

        Write-Output y | chkdsk /f/r c:
        Write-Host "Please save your documents and close applications."
        Pause
        Write-Host "Successfully checked disk and restarted Windows." -ForegroundColor Green

        $finishedDateTime = (Get-Date)
        
        Write-Host "Finished checking disk and restarting Windows at: " $finishedDateTime.DateTime.DateTime

        $duration = New-TimeSpan $startDateTime $finishedDateTime
        
        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)

        Write-Host ""

        Write-Host "Please save your documents and close your applications."
        Pause
        Restart-Computer
    }
    catch
    {
        Write-Host "Failed to check disk and restart Windows." -ForegroundColor Red
        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
        Write-Host ""
    }
}

CheckDiskAndRestartWindows
