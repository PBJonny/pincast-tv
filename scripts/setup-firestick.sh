#!/usr/bin/env bash
# ==============================================================================
# Pinball Buddies Pincast TV — Automated Fire Stick & Android TV Installer
# ==============================================================================
# Installs the native Pinball Buddies Pincast TV app (Kotlin + Jetpack Compose)
# directly onto Amazon Fire TV Sticks, Google TVs, and Android TVs via ADB.
#
# Usage:
#   ./setup-firestick.sh [DEVICE_IP]
#
# Examples:
#   ./setup-firestick.sh 192.168.1.150
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
APK_PATH="$PACKAGE_DIR/pinball-buddies-pincast-tv.apk"
PACKAGE_NAME="com.pinballbuddies.app.tv"
ACTIVITY_NAME=".MainActivity"

echo "=========================================================="
echo "  Pinball Buddies Pincast TV — Native TV Setup            "
echo "=========================================================="

# 1. Verify APK exists
if [ ! -f "$APK_PATH" ]; then
  echo "[-] ERROR: pinball-buddies-pincast-tv.apk not found at:"
  echo "    $APK_PATH"
  exit 1
fi

# 2. Check for adb
if ! command -v adb >/dev/null 2>&1; then
  echo "[-] 'adb' command not found."
  echo "    Please install Android Platform Tools:"
  echo "      macOS:  brew install android-platform-tools"
  echo "      Ubuntu: sudo apt-get install -y adb"
  echo "      Fedora: sudo dnf install -y android-tools"
  exit 1
fi

# 3. Determine Device IP
DEVICE_IP="${1:-}"
if [ -z "$DEVICE_IP" ]; then
  echo "[?] Enter the Fire TV Stick / Android TV IP address:"
  echo "    (Find this on Fire TV: Settings -> My Fire TV -> About -> Network)"
  read -r -p "    Device IP: " DEVICE_IP
fi

if [ -z "$DEVICE_IP" ]; then
  echo "[-] ERROR: Device IP cannot be empty."
  exit 1
fi

DEVICE_TARGET="$DEVICE_IP:5555"

echo ""
echo "[*] Connecting to $DEVICE_TARGET..."
adb connect "$DEVICE_TARGET"

CONNECT_CHECK=$(adb devices | grep "$DEVICE_TARGET" || true)
if [ -z "$CONNECT_CHECK" ]; then
  echo "[-] Failed to connect to $DEVICE_TARGET."
  echo "    Ensure Fire TV has ADB enabled:"
  echo "    Settings -> My Fire TV -> Developer Options -> ADB Debugging -> ON"
  exit 1
fi

if echo "$CONNECT_CHECK" | grep -q "unauthorized"; then
  echo "[!] ACTION REQUIRED ON TV:"
  echo "    Look at your TV screen and select 'Always allow from this computer' -> OK."
  echo "    Waiting 10 seconds for authorization..."
  sleep 10
fi

echo "[+] Connected to device successfully."

# 4. Install / Update the Native TV APK
echo "[*] Installing native Pinball Buddies Pincast TV app..."
adb -s "$DEVICE_TARGET" install -r -g "$APK_PATH"
echo "[+] Installation successful!"

# 5. Configure 24/7 Arcade Kiosk Power & Sleep Prevention
echo "[*] Applying 24/7 arcade kiosk power settings..."
adb -s "$DEVICE_TARGET" shell settings put system screen_off_timeout 2147483647 || true
adb -s "$DEVICE_TARGET" shell settings put global stay_on_while_plugged_in 3 || true
adb -s "$DEVICE_TARGET" shell settings put secure sleep_timeout 0 || true
adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_WAKEUP || true

# 6. Launch the Native App
echo "[*] Launching Pinball Buddies Pincast TV..."
adb -s "$DEVICE_TARGET" shell am start -n "$PACKAGE_NAME/$ACTIVITY_NAME"

echo ""
echo "=========================================================="
echo "  [✓] Pinball Buddies Pincast TV is now running!         "
echo "=========================================================="
echo "  1. Look at your TV: A 6-digit code & QR code are shown. "
echo "  2. Open the Pinball Buddies app on your phone, go to   "
echo "     your Venue -> Displays -> 'Pair Display', and enter  "
echo "     the code or scan the QR code.                        "
echo "  3. The display will immediately load your live arcade   "
echo "     leaderboard carousel with full offline SQLite cache! "
echo "=========================================================="
