# import PSWindowsUpdate module on Windows 

function CheckOsForWindows()
{
    Write-Host "Started checking operating system" (Get-Date).DateTime
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

        Write-Host "Finished checking operating system."
        Write-Host ""
        break
    }
}

function ImportPSWindowsUpdateModule()
{
    Write-Host "`nImport PSWindowsUpdate module on Windows.`n"
    CheckOsForWindows

    try 
    {
        $startDateTime = (Get-Date)
        Write-Host "Started importing PSWindowsUpdate module at" $startDateTime.DateTime

        Import-Module PSWindowsUpdate

        $finishedDateTime = (Get-Date)
        Write-Host "Finished importing PSWindowsUpdate module at" $finishedDateTime.DateTime
        $duration = New-TimeSpan $startDateTime $finishedDateTime

        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)
    }
    catch 
    {
        Write-Host "Failed to import PSWindowsUpdate module." -ForegroundColor Red

        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
    }
}

ImportPSWindowsUpdateModule
