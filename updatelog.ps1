# This script pulls all Windows Update logs with the string "failed" and outputs them to the desktop in a file called error.log

Get-WindowsUpdateLog
cat ~\Desktop\WindowsUpdate.log | Select-String failed >> ~\Desktop\error.log
