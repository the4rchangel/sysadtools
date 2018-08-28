
function Show-Menu
{
     param (
           [string]$Title = 'Exchange Services Easy Menu'
     )
     cls
     Write-Host "================ $Title ================"
     Write-Host "============================================================="
     Write-Host "= 1: DISABLE all Exchange services on startup.              ="
     Write-Host "= 2: ENABLE all Exchange services on startup. (Automatic)   ="
     Write-Host "= 3: STOP all Exchange services.                            ="
     Write-Host "= 4: START all Exchange services.                           ="
     Write-Host "= Q: Quit                                                   ="
     Write-Host "============================================================="
}
do
{
     Show-Menu
     $input = Read-Host "Pick your poison"
     switch ($input)
     {
             '1' {
                cls
                Get-Service -DisplayName "Microsoft Exchange*" | select -property name,starttype | Set-Service -StartupType Disabled
           } '2' {
                cls
                Get-Service -DisplayName "Microsoft Exchange*" | select -property name,starttype | Set-Service -StartupType Automatic
                Get-Service -DisplayName "Microsoft Exchange Server Extension for Windows Server Backup" | select -property name,starttype | Set-Service -StartupType Manual
           } '3' {
                cls
                Get-service -displayname "Microsoft Exchange*" | stop-service -force
           } '4' {
                cls
                Get-service -displayname "Microsoft Exchange*" | start-service
                Get-service -displayname "Microsoft Exchange Server Extension for Windows Server Backup" | stop-service -force
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')
