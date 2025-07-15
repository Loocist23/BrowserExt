param(
    [string]$username,
    [string]$basedir
)

# Changer l'encodage de la console pour afficher les accents correctement
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Créer le fichier log
$logFile = Join-Path $basedir "log.txt"

function Log {
    param ([string]$msg)
    Write-Output $msg
    $msg | Out-File $logFile -Append -Encoding utf8
}

Log "Début de la récupération des données pour $username`n"

# Liste des navigateurs Chromium-like
$chromiumBrowsers = @(
    @{ Name = "Chrome"; Path = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks" },
    @{ Name = "Edge"; Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Bookmarks" },
    @{ Name = "Brave"; Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Bookmarks" },
    @{ Name = "Vivaldi"; Path = "$env:LOCALAPPDATA\Vivaldi\User Data\Default\Bookmarks" },
    @{ Name = "Yandex"; Path = "$env:LOCALAPPDATA\Yandex\YandexBrowser\User Data\Default\Bookmarks" },
    @{ Name = "Opera"; Path = "$env:APPDATA\Opera Software\Opera Stable\Bookmarks" },
    @{ Name = "Opera GX"; Path = "$env:APPDATA\Opera Software\Opera GX Stable\Bookmarks" }
)

foreach ($browser in $chromiumBrowsers) {
    $name = $browser.Name
    $bookmarkPath = $browser.Path
    $dest = Join-Path $basedir $name

    if (Test-Path $bookmarkPath) {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Copy-Item $bookmarkPath -Destination $dest -Force
        Log "Favoris $name copiés avec succès."
    }
    else {
        Log "Favoris $name non trouvés."
    }
}

# Firefox
$firefoxProfiles = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory
$foundFirefox = $false
foreach ($ffProfile in $firefoxProfiles) {
    $places = Join-Path $ffProfile.FullName "places.sqlite"
    if (Test-Path $places) {
        $firefoxDest = Join-Path $basedir "Firefox\$($ffProfile.Name)"
        New-Item -ItemType Directory -Path $firefoxDest -Force | Out-Null
        Copy-Item $places -Destination $firefoxDest -Force
        Log "Favoris Firefox ($($ffProfile.Name)) copiés avec succès."
        $foundFirefox = $true
    }
}
if (-not $foundFirefox) {
    Log "Aucun profil Firefox trouvé ou favoris non détectés."
}

Log "`nRécupération terminée."
Log "Merci d’exporter manuellement les mots de passe depuis chaque navigateur installé."
Log "   Ouvrez la page des mots de passe, cliquez sur les trois points ⋮, puis 'Exporter'."

# Ouvrir les pages de gestion des mots de passe
Log "`nOuverture des pages d'export de mots de passe :"

$browserPages = @(
    @{ Name = "Chrome"; Exec = "chrome"; Url = "chrome://password-manager/passwords" },
    @{ Name = "Edge"; Exec = "msedge"; Url = "edge://wallet/passwords" },
    @{ Name = "Brave"; Exec = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"; Url = "brave://password-manager/settings" },
    @{ Name = "Vivaldi"; Exec = "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"; Url = "vivaldi:password-manager/passwords" },
    @{ Name = "Yandex"; Exec = "$env:LOCALAPPDATA\Yandex\YandexBrowser\Application\browser.exe"; Url = "browser://personal/passwords" },
    @{ Name = "Opera"; Exec = "$env:LOCALAPPDATA\Programs\Opera\opera.exe"; Url = "opera://password-manager/passwords" },
    @{ Name = "Opera GX"; Exec = "$env:LOCALAPPDATA\Programs\Opera GX\opera.exe"; Url = "opera://password-manager/passwords" },
    @{ Name = "Firefox"; Exec = "firefox"; Url = "about:logins" }
)

$wShell = New-Object -ComObject WScript.Shell

foreach ($browser in $browserPages) {
    try {
        $exec = $browser.Exec

        # Vérifie si c’est un chemin ou une commande simple
        $isPath = $exec -like "*\*"  # contient un backslash = chemin
        $canRun = $isPath -and (Test-Path $exec)

        if ($canRun -or -not $isPath) {
            # Lance le navigateur
            Start-Process $exec
            Start-Sleep -Seconds 1.5
            $wShell.AppActivate($browser.Name) | Out-Null
            $wShell.SendKeys($browser.Url)
            Start-Sleep -Milliseconds 300
            $wShell.SendKeys("{ENTER}")
            Log "Page d'export des mots de passe ouverte pour $($browser.Name)."
        } else {
            Log "$($browser.Name) non installé ou exécutable introuvable."
        }
    }
    catch {
        Log "$($browser.Name) n'a pas pu être lancé."
    }
}

Log "Les pages ont été ouvertes."

Write-Host "`n[ATTENTION] Appuyez sur une touche quand vous avez terminé l'export des mots de passe (.csv)..."