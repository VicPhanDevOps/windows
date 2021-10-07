# obtain IP address automatically on Windows

# you can run this script with: ObtainIpAutomaticallyOnWindows.ps1 -ipType < IPv4 or IPv6 > 

[CmdletBinding()]
param(
    [string] [Parameter(Mandatory = $False)] $ipType = ""
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


function GetIpType([string]$ipType)
{
    if (($ipType -eq $Null) -or ($ipType -eq ""))
    {
        $iPType = Read-Host -Prompt "Please type which IP type you like to use and press `"Enter`" key (IPv4 or IPv6)?"

        return $ipType
    }
    else 
    {
        return $ipType
    }
}

function CheckParameters([string]$ipType)
{
    Write-Host "Started checking parameters at" (Get-Date).DateTime
    $valid = $True

    Write-Host "Parameters:"
    Write-Host "-------------------------"
    Write-Host ("ipType: {0}" -F $ipType)
    Write-Host "-------------------------"

    if (($ipType -eq $Null) -or ($ipType -eq ""))
    {
        Write-Host "ipType is not set." -ForegroundColor Red
        $valid = $False
    }

    if ($valid -eq $True)
    {
        Write-Host "All parameter checks passed." -ForegroundColor Green
    }
    else
    {
        Write-Host "One or more parameters are incorrect, exiting script." -ForegroundColor Red

        exit -1
    }

    Write-Host "Finished checking parameters at" (Get-Date).DateTime
}

function ObtainIpAutomatically([string]$ipType)
{
    Write-Host "`nObtain IP address automatically on Windows.`n"
    CheckOsForWindows

    $ipType = GetIpType $ipType
    CheckParameters $ipType

    try 
    {
        $startDateTime = (Get-Date)
        Write-Host "Started optaining IP address automatically at" $startDateTime

        $adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
        $interface = $adapter | Get-NetIPInterface -AddressFamily $ipType
        
        # obtain IP address
        if ($interface.Dhcp -eq "Disabled") 
        {
            # Remove existing gateway
            if (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) 
            {
                $interface | Remove-NetRoute -Confirm:$false
            }
            # Enable DHCP
            $interface | Set-NetIPInterface -DHCP Enabled
            
            # Configure the DNS Servers automatically
            $interface | Set-DnsClientServerAddress -ResetServerAddresses

            Write-Host "Successfully obtained IP address automatically." -ForegroundColor Green
        }

        $finishedDateTime = (Get-Date)
        
        Write-Host "Finished obtaining IP address automatically at" $finishedDateTime

        $duration = New-TimeSpan $startDateTime $finishedDateTime

        Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)
    }
    catch 
    {
        Write-Host "Failed to obtain IP address automatically" -ForegroundColor Red

        Write-Host $_ -ForegroundColor Red
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
    }
}

ObtainIpAutomatically $ipType
