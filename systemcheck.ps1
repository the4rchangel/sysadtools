Write-Host "-----------------------"
Write-Host "CHECKING SERVICES" -ForegroundColor Yellow
Write-Host "-----------------------"
$serviceName = '*Webroot*'

If (Get-Service -displayName $serviceName -ErrorAction SilentlyContinue) {

    If ((Get-Service -displayName $serviceName).Status -eq 'Running') {

        Write-Host "$serviceName is running..." -ForegroundColor Green

    } Else {

        Write-Host "$serviceName found, but it is not running." -ForegroundColor Red

    }

} Else {

    Write-Host "$serviceName not found" -ForegroundColor Red

}
$serviceName2 = '*Carbonite*'

If (Get-Service -displayName $serviceName2 -ErrorAction SilentlyContinue) {

    If ((Get-Service -displayName $serviceName2).Status -eq 'Running') {

        Write-Host "$serviceName2 is running..." -ForegroundColor Green

    } Else {

        Write-Host "$serviceName2 found, but it is not running." -ForegroundColor Red

    }

} Else {

    Write-Host "$serviceName2 not found" -ForegroundColor Red

}
Write-Host "-----------------------"
Write-Host "ARE ANY OF THESE DIRECTORIES LARGE?" -ForegroundColor Yellow
Write-Host "-----------------------"
$colItems = Get-ChildItem $env:USERPROFILE | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
foreach ($i in $colItems)
{
    $subFolderItems = Get-ChildItem $i.FullName -recurse -force -erroraction 'silentlycontinue'| Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
    $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
}
Set-Itemproperty -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'AUOptions' -value '4'
Set-Itemproperty -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'AutoInstallMinorUpdates' -value '1'
Set-Itemproperty -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate' -value '0'
Set-Itemproperty -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoRebootWithLoggedOnUsers' -value '1'
#Removed line below opting to set the keys above in the script instead of running a registry file. 
#reg import .\AutoWinUpdate.reg
Write-Host "-----------------------"
Write-Host "AUTOMATIC WINDOWS UPDATES HARD CODED" -ForegroundColor Yellow
Write-Host "-----------------------"
Write-Host "CHECKING FOR SAVED PASSWORDS IN CHROME..." -ForegroundColor Yellow
Write-Host "-----------------------"
$FileExists = Test-Path "$env:userprofile\AppData\Local\Google\Chrome\User Data\Default\Login Data" -PathType Leaf
If ($FileExists -eq $True) {Write-Host "***There ARE passwords saved in Google Chrome" -ForegroundColor Red}
Else {Write-Host "***There ARE NOT passwords saved in Google Chrome" -ForegroundColor Green}
Write-Host "-----------------------"
Write-Host "CHECKING FOR SAVED PASSWORDS IN FIREFOX..." -ForegroundColor Yellow
Write-Host "-----------------------"
$FIREPASS= dir -recurse "$env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles" | sls -pattern "logins.json" | select -unique path
if ($FIREPASS -ne $null)
{
    Write-Host "***There ARE passwords stored in Firefox." -ForegroundColor Red
}
else
{
    Write-Host "***There ARE NOT passwords stored in Firefox." -ForegroundColor Green
}
Write-Host "-----------------------"
Write-Host "CHECKING FOR LASTPASS CHROME EXTENSION..." -ForegroundColor Yellow
Write-Host "-----------------------"
$EXT = dir -recurse "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Extensions" | sls -pattern "LastPass_Color.png" | select -unique path
if ($EXT -ne $null)
{
    Write-Host "***The LastPass Google Chrome Extension IS installed." -ForegroundColor Green
}
else
{
    Write-Host "***The LastPass Google Chrome Extension IS NOT installed." -ForegroundColor Red
}
Write-Host "-----------------------"
Write-Host "ENFORCING 10M SCREEN LOCKOUT..." -ForegroundColor Yellow
Write-Host "-----------------------"
Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\7516b95f-f776-4464-8c53-06167f40cc99\8EC4B3A5-6868-48c2-BE75-4F3044BE88A7' -Name 'Attributes' -value '2'
powercfg -change -monitor-timeout-ac 10
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 1
powercfg /SETACTIVE SCHEME_CURRENT
Write-Host "-----------------------"
Write-Host "ENABLING WINDOWS FIREWALL ON ALL PROFILES..." -ForegroundColor Yellow
Write-Host "-----------------------"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Write-Host "-----------------------"
Write-Host "DISABLING USB STORAGE ACCESS..." -ForegroundColor Yellow
New-Item -Path HKLM:\Software\Policies\Microsoft\Windows\RemovableStorageDevices -Name Deny_All –Force
Set-Itemproperty -path 'HKLM:\Software\Policies\Microsoft\Windows\RemovableStorageDevices' -Name 'Deny_All' -value '1'
Write-Host "-----------------------"
Write-Host "-----------------------"
Write-Host "SCRIPT HAS COMPLETED SUCCESSFULLY" -ForegroundColor Yellow
Write-Host "-----------------------"
Write-Host "-----------------------"