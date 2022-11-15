# create standard user on Windows

# you can run this script with: .\CreateStandardUserOnWindows.ps1 -standardUser < standard user > -password < password > -description < description >

[CmdletBinding()]
param(
  [string]       [Parameter(Mandatory = $False)] $standardUser = "", # you can set the username here 
  [securestring] [Parameter(Mandatory = $False)] $password     = $Null, # you can set the password here 
  [string]       [Parameter(Mandatory = $False)] $description  = "" # you can 
)

function CheckOsForWindows()
{
  Write-Host "Started checking operation system at" (Get-Date).DateTime
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
    Write-Host "Sorry but this script only works in Windows." -ForegroundColor Red

    Write-Host "Finished checking operating system at" (Get-Date).DateTime
    Write-Host ""

    break
  }
}

function GetStandardUser([string]$standardUser)
{
  if (($standardUser -eq $Null) -or ($standardUser -eq ""))
    {
      $standardUser = Read-Host -Prompt "Please type the standard user name and press `"Enter`" key (Example: Standard.User)"

      Write-Host ""
      return $standardUser
    }
    else 
    {
      return $standardUser
    }
}

function GetPassword([securestring]$password)
{
  if (($password -eq $Null) -or ($password -eq ""))
  {
    $password = Read-Host -Prompt "Please type the password and press `"Enter`" key (Example: Password1234)" -AsSecureString

    Write-Host ""
    return $password
  }
  else 
  {
    return $password
  }
}

function GetDescription([string]$description)
{
  if (($description -eq $Null) -or ($description -eq ""))
  {
    $description = Read-Host -Prompt "Please type the description and press `"Enter`" key (Example: Standard User)"

    Write-Host ""
    return $description
  }
  else
  {
    return $description
  }
}

function CheckParameters([string]      $standardUser, 
                         [securestring]$password, 
                         [string]      $description)
{
  Write-Host "Started checking parameters at" (Get-Date).DateTime
  $valid = $True

  Write-Host "Parameters:"
  Write-Host "-------------------------------------"
  Write-Host ("standardUser: {0}" -F $standardUser)
  Write-Host ("password    : {0}" -F "***")
  Write-Host ("description : {0}" -F $description)
  Write-Host "-------------------------------------"

  if (($standardUser -eq $Null) -or ($standardUser -eq ""))
  {
    Write-Host "standardUser is not set." -ForegroundColor Red
    $valid = $False
  }

  if (($password -eq $Null) -or ($password -eq ""))
  {
    Write-Host "password is not set." -ForegroundColor Red
    $valid = $False
  }

  if (($description -eq $Null) -or ($description -eq ""))
  {
    Write-Host "description is not set." -ForegroundColor Red
    $valid = $False
  }

  if ($valid -eq $True)
  {
    Write-Host "All parameter checks passed.`n"  -ForegroundColor Green

    Write-Host "Finished checking parameters at" (Get-Date).DateTime
    Write-Host ""
  }
  else 
  {
    Write-Host "One or more parameters are incorrect." -ForegroundColor Red

    Write-Host "Finished checking parameters at" (Get-Date).DateTime
    Write-Host ""

    break
  }
}

function CreateStandardUser([string]$standardUser, [securestring]$password, [string]$description)
{
  Write-Host "`nCreate standard user on Windows.`n"
  CheckOsForWindows

  $standardUser = GetStandardUser $standardUser
  $password     = GetPassword $password
  $description  = GetDescription $description
  CheckParameters $standardUser $password $description

  try 
  {
    $startDateTime = (Get-Date)
    Write-Host "Started creating standard user at" $startDateTime

    New-LocalUser $standardUser -Password $sassword -FullName $standardUser -Description $description

    Set-LocalUser -Name $standardUser -PasswordNeverExpires 1
    
    Write-Host ("Successfully created standard user: {0}" -F $standardUser) -ForegroundColor Green

    Write-Host "The users on the this computer are:"
    Get-LocalUser

    $finishedDateTime = (Get-Date)
    Write-Host "Finished creating standard user at" $finishedDateTime
    
    $duration = New-TimeSpan $startDateTime $finishedDateTime

    Write-Host ("Total execution time: {0} hours {1} minutes {2} seconds" -F $duration.Hours, $duration.Minutes, $duration.Seconds)

    Write-Host ""
  }
  catch 
  {
    Write-Host ("Failed to create standard user {0}." -F $standardUser) -ForegroundColor Red

    Write-Host $_ -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    Write-Host ""
  }
}

CreateStandardUser $standardUser $password $description