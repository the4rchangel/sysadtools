@echo off
set /p drive=Enter Drive Letter:

xcopy /s %UserProfile% %drive%:\