# Powershell-Skript um das aktuelle Release zu installieren
# Es können dem Powershell-Skript verschiedene Parameter mitgegeben werden

# Variablen


# Start des Powershell-Skripts

function init {

    $global:release = "4_5_9"
    $global:releaseDate = "18.05.23"
    $global:drive = "C:"
    $global:target = "C:\P@PPS"
    $global:source = "\\DEAR-AP-PPS04\PAPPS_Produktiv"
    $global:frontend = "\\DEAR-AP-PPS04\PAPPS_Produktiv\Frontend_74"
    $global:environment = "\\DEAR-AP-PPS04\PAPPS_Produktiv\Umgebung_74"
    $global:dummy_file = "papps_$release.txt"

    $hasError = $false
    return $hasError
}

function clearFolderAfterUpdate {
    if (!(Test-Path "C:\TEMP\rel_$releaseDate.txt")) {
        if (Test-Path "C:\P@PPS") { Remove-Item -Path "C:\P@PPS" -Recurse -Force }
        if (Test-Path "C:\P@PPS_62") { Remove-Item -Path "C:\P@PPS_62" -Recurse -Force }
        if (Test-Path "C:\P@PPS_74") { Remove-Item -Path "C:\P@PPS_74" -Recurse -Force }
        Set-Content -Path "C:\TEMP\rel_$releaseDate.txt" -Value "Diese Datei NICHT löschen!"
    }
}
function currentRelease {
    if (Test-Path $target\$dummy_file) {
        return $true
    }
}


function createPAPPSFolder {
    New-Item -ItemType Directory -Path $target
}
function installPAPPS {


    $WINDIR = $env:WINDIR
    
    xcopy "$frontend\." "$target\." /D /E /F /R /Y
    xcopy "$environment\Runtime\." "$target\." /D /E /F /R /Y
    xcopy "$environment\Konfig\sql.ini" "$target\." /D /E /F /R /Y
    xcopy "$environment\Konfig\kb-mobile.ini" "$target\." /D /E /F /R /Y
    xcopy "$environment\Konfig\papps.ini" "$target\." /D /E /F /R /Y
    xcopy "$environment\Konfig\papps_fonts.reg" "$target\." /D /E /F /R /Y
    
    if (-not (Test-Path "$WINDIR\esalib.ini")) {
        Copy-Item "$frontend\esalib.ini" "$WINDIR\esalib.ini" -Force
    }
    if (-not (Test-Path "$WINDIR\Fonts\code_128.ttf")) {
        Copy-Item "$frontend\code_128.ttf" "$WINDIR\Fonts\code_128.ttf" -Force
    }
    if (-not (Test-Path "$WINDIR\Fonts\3of9.ttf")) {
        Copy-Item "$frontend\3of9.ttf" "$WINDIR\Fonts\3of9.ttf" -Force
    }
    if (-not (Test-Path "$WINDIR\Fonts\CV30_1.ttf")) {
        Copy-Item "$frontend\CV30_1.ttf" "$WINDIR\Fonts\CV30_1.ttf" -Force
    }
    if (-not (Test-Path "$WINDIR\Fonts\CV30_2.ttf")) {
        Copy-Item "$frontend\CV30_2.ttf" "$WINDIR\Fonts\CV30_2.ttf" -Force
    }
    if (-not (Test-Path "$WINDIR\Fonts\CV30_3.ttf")) {
        Copy-Item "$frontend\CV30_3.ttf" "$WINDIR\Fonts\CV30_3.ttf" -Force
    }
    
    if (Test-Path "${drive}:\app\ora219\network\ADMIN") {
        Copy-Item "$environment\Konfig\tnsnames.ora" "${drive}:\app\ora219\network\ADMIN\." -Force
    }
    if (Test-Path "${drive}:\app\ora219\network\ADMIN") {
        Copy-Item "$environment\Konfig\sqlnet.ora" "${drive}:\app\ora219\network\ADMIN\." -Force
    }

}

Write-Host "Überprüfe P@PPS-Ordner.."

$hasError = init

if ($hasError -eq $false) {
    # Prüfen ob 
    clearFolderAfterUpdate
    # Prüfen ob das aktuelle $release bereits installiert wurde
    if(currentRelease -eq $true) {
        # Aktuelles Release wurde bereits einmal installiert
        installPAPPS
    }
    else {
        # Aktuelles Release wurde nicht installiert
        createPAPPSFolder
        installPAPPS
    }
}


exit


# Funktion CHECK_PARAM
# In dieser Funktion werden die übergebenen Parameterwerte geprüft 
function checkParam([string]$param1, [string]$param2) {
    
    pause
}

