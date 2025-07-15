@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Récupère la lettre de la clé USB (où ce script est lancé)
set usbdrive=%~d0

:: Demande le nom de la personne
set /p username=Nom de la personne (ex: Mme Dupont) :

:: Crée le dossier principal
set "basedir=%~dp0DUMP\%username%"
if not exist "%basedir%" mkdir "%basedir%"

:: Lance le script PowerShell en lui passant le nom de la personne et le dossier cible
powershell.exe -ExecutionPolicy Bypass -File "%~dp0recup.ps1" "%username%" "%basedir%"

pause
