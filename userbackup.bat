@echo off
# Backs up user profile to a flash drive.
echo This script will backup the user's Chrome settings and User Profile
echo -------------------------------------------------------------------
set /p drive=Enter USB Drive Letter:
:: Backs up the Google Chrome Settings
xcopy /s C:\Users\%USERNAME%\AppData\Local\Google %drive%:\
:: Backs up the User Profile
xcopy /s %UserProfile% %drive%:\
