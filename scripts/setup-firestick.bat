@echo off
rem ==============================================================================
rem Pinball Buddies Pincast TV — Automated Fire Stick Kiosk Installer (Windows)
rem ==============================================================================
rem Before installing, verifies the APK SHA-256 hash matches manifest.json.
rem ==============================================================================

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PACKAGE_DIR=%SCRIPT_DIR%.."
set "APK_PATH=%PACKAGE_DIR%\pinball-buddies-pincast-tv.apk"
set "MANIFEST_PATH=%PACKAGE_DIR%\manifest.json"
set "PACKAGE_NAME=com.pinballbuddies.venuedisplay"
set "ACTIVITY_NAME=.MainActivity"

echo ==========================================================
echo   Pinball Buddies Pincast TV — Commercial Kiosk Setup
echo ==========================================================

if not exist "%APK_PATH%" (
    echo [-] ERROR: pinball-buddies-pincast-tv.apk not found at:
    echo     %APK_PATH%
    pause
    exit /b 1
)

rem 1. Verify APK SHA-256 against manifest.json using PowerShell
if exist "%MANIFEST_PATH%" (
    echo [*] Verifying APK SHA-256 checksum...
    powershell -NoProfile -Command "$expected = (Get-Content -Raw '%MANIFEST_PATH%' | ConvertFrom-Json).apkSha256.ToLower(); $actual = (Get-FileHash -Algorithm SHA256 '%APK_PATH%').Hash.ToLower(); if ($expected -ne $actual) { Write-Host '[-] ERROR: APK checksum mismatch! Expected' $expected 'but got' $actual -ForegroundColor Red; exit 1 } else { Write-Host '[+] APK checksum verified (' $actual ').' }"
    if !errorlevel! neq 0 (
        echo [-] Checksum verification failed. Do not install this APK.
        pause
        exit /b 1
    )
)

where adb >nul 2>nul
if %errorlevel% neq 0 (
    echo [-] 'adb' command not found.
    echo     Please download Android SDK Platform-Tools for Windows and add it to your PATH:
    echo     https://developer.android.com/tools/releases/platform-tools
    pause
    exit /b 1
)

set "DEVICE_IP=%~1"
if "%DEVICE_IP%"=="" (
    echo [?] Enter the Fire TV Stick IP address:
    echo     (Find this on Fire TV: Settings -^> My Fire TV -^> About -^> Network)
    set /p "DEVICE_IP=    Device IP: "
)

if "%DEVICE_IP%"=="" (
    echo [-] ERROR: Device IP cannot be empty.
    pause
    exit /b 1
)

echo %DEVICE_IP% | findstr ":" >nul
if %errorlevel% equ 0 (
    set "DEVICE_TARGET=%DEVICE_IP%"
) else (
    set "DEVICE_TARGET=%DEVICE_IP%:5555"
)

echo.
echo [*] Connecting to %DEVICE_TARGET%...
adb connect "%DEVICE_TARGET%"
powershell -NoProfile -Command "$out = adb devices | Select-String -SimpleMatch '%DEVICE_TARGET%'; if (-not $out -or $out -match '\soffline$') { exit 1 } else { exit 0 }"
if !errorlevel! neq 0 (
    echo [*] Resetting local ADB server and retrying connection to %DEVICE_TARGET%...
    adb kill-server >nul 2>nul
    adb start-server >nul 2>nul
    adb connect "%DEVICE_TARGET%"
)

echo [*] Checking device authorization...
echo     If prompted on your TV screen, select 'Always allow from this computer' -^> OK.
powershell -NoProfile -Command "for ($i=0; $i -lt 60; $i++) { $out = adb devices | Select-String -SimpleMatch '%DEVICE_TARGET%'; if ($out -match '\sdevice$') { exit 0 }; Start-Sleep -Seconds 1 }; exit 1"
if !errorlevel! neq 0 (
    echo [-] Device did not authorize or connect within 60 seconds.
    echo     Ensure ADB Debugging is ON and accept the prompt on your TV screen.
    pause
    exit /b 1
)

echo [+] Connected and authorized!

echo [*] Installing Pinball Buddies Pincast TV APK...
adb -s "%DEVICE_TARGET%" uninstall com.pinballbuddies.app >nul 2>nul
adb -s "%DEVICE_TARGET%" uninstall com.pinballbuddies.app.tv >nul 2>nul
adb -s "%DEVICE_TARGET%" install -r -d -g "%APK_PATH%"
if %errorlevel% neq 0 (
    echo [-] Installation failed.
    pause
    exit /b 1
)

echo [+] Installation successful!

echo [*] Applying 24/7 kiosk power and Fire OS auto-boot settings...
adb -s "%DEVICE_TARGET%" shell appops set "%PACKAGE_NAME%" SYSTEM_ALERT_WINDOW allow
adb -s "%DEVICE_TARGET%" shell pm grant "%PACKAGE_NAME%" android.permission.WAKE_LOCK >nul 2>nul
adb -s "%DEVICE_TARGET%" shell dumpsys deviceidle whitelist +"%PACKAGE_NAME%" >nul 2>nul
adb -s "%DEVICE_TARGET%" shell settings put system screen_off_timeout 2147483647
adb -s "%DEVICE_TARGET%" shell settings put global stay_on_while_plugged_in 7
adb -s "%DEVICE_TARGET%" shell settings put secure sleep_timeout 0
adb -s "%DEVICE_TARGET%" shell input keyevent KEYCODE_WAKEUP

echo [*] Launching Pinball Buddies Pincast TV...
adb -s "%DEVICE_TARGET%" shell am start -n "%PACKAGE_NAME%/%ACTIVITY_NAME%"

adb disconnect "%DEVICE_TARGET%" >nul 2>nul

echo.
echo ==========================================================
echo   [✓] Pinball Buddies Pincast TV is now running!
echo ==========================================================
echo   1. Check your TV screen for the pairing code or QR code.
echo   2. Pair the display in the Pinball Buddies mobile app.
echo ==========================================================
echo   SECURITY REMINDER: Turn ADB Debugging back OFF on the TV
echo   (Settings -^> My Fire TV -^> Developer Options -^> ADB Debugging -^> OFF)
echo ==========================================================
pause
