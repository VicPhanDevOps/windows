# get serial number on Windows

function CheckOsForWindows()
{
    Write-Host "`nChecking operating system..."

    $hostOs = [System.Environment]::OSVersion.Platform

    if ($hostOs -eq "Win32NT")
    {
        Write-Host "You are running this script on Windows." -ForegroundColor Green
    }
    else 
    {
        Write-Host "Your operating system is:" $hostOs
        
        Write-Host "Sorry but this script only works on Windows." -ForegroundColor Red

        Write-Host "Finished checking operating system.`n"
        break
    }
    Write-Host "Finished checking operating system.`n"
}

function GetSerialNumber()
{
    Write-Host "`nGet serial numbers on Windows.`n"
    CheckOsForWindows

    try 
    {
        $serialNumber = Get-CimInstance win32_bios | Format-List serialnumber
        Write-Host "The serial number of this computer is:" $serialNumber

        Write-Host "Successfully got serial number.`n" -ForegroundColor Green
    }
    catch
    {
        Write-Host "Failed to get serial number.`n"  -ForegroundColor Red
    }
}

GetSerialNumber