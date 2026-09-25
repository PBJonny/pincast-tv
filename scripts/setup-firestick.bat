@echo off
rem ==============================================================================
rem Pinball Buddies Pincast TV — Automated Fire Stick & Android TV Installer (Windows)
rem ==============================================================================

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PACKAGE_DIR=%SCRIPT_DIR%.."
set "APK_PATH=%PACKAGE_DIR%\pinball-buddies-pincast-tv.apk"
set "PACKAGE_NAME=com.pinballbuddies.app.tv"
set "ACTIVITY_NAME=.MainActivity"

echo ==========================================================
echo   Pinball Buddies Pincast TV — Native TV Setup (Windows)
echo ==========================================================

if not exist "%APK_PATH%" (
    echo [-] ERROR: pinball-buddies-pincast-tv.apk not found at:
    echo     %APK_PATH%
    pause
    exit /b 1
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
    echo [?] Enter the Fire TV Stick / Android TV IP address:
    echo     (Find this on Fire TV: Settings -^> My Fire TV -^> About -^> Network)
    set /p "DEVICE_IP=    Device IP: "
)

if "%DEVICE_IP%"=="" (
    echo [-] ERROR: Device IP cannot be empty.
    pause
    exit /b 1
)

set "DEVICE_TARGET=%DEVICE_IP%:5555"

echo.
echo [*] Connecting to %DEVICE_TARGET%...
adb connect %DEVICE_TARGET%

echo [*] Installing Pinball Buddies Pincast TV APK...
adb -s %DEVICE_TARGET% install -r -g "%APK_PATH%"
if %errorlevel% neq 0 (
    echo [-] Installation failed. Check device screen for authorization prompt.
    pause
    exit /b 1
)

echo [+] Installation successful!

echo [*] Applying 24/7 kiosk power settings...
adb -s %DEVICE_TARGET% shell settings put system screen_off_timeout 2147483647
adb -s %DEVICE_TARGET% shell settings put global stay_on_while_plugged_in 3
adb -s %DEVICE_TARGET% shell settings put secure sleep_timeout 0
adb -s %DEVICE_TARGET% shell input keyevent KEYCODE_WAKEUP

echo [*] Launching Pinball Buddies Pincast TV...
adb -s %DEVICE_TARGET% shell am start -n %PACKAGE_NAME%/%ACTIVITY_NAME%

echo.
echo ==========================================================
echo   [✓] Pinball Buddies Pincast TV is now running!
echo ==========================================================
echo   1. Check your TV screen for the 6-digit code or QR code.
echo   2. Pair the display in the Pinball Buddies mobile app.
echo ==========================================================
pause
