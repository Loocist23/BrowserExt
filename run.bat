@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Récupère la lettre de la clé USB (où ce script est lancé)
set usbdrive=%~d0

:: Lance le script PowerShell (le nom sera demandé directement dans le script)
powershell.exe -ExecutionPolicy Bypass -File "%~dp0recup.ps1"

pause
