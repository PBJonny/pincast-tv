#!/usr/bin/env bash
# ==============================================================================
# Pinball Buddies Pincast TV — Automated Fire Stick & Android TV Installer
# ==============================================================================
# Installs the commercial Pinball Buddies Pincast TV kiosk app (Flutter + Dart)
# directly onto Amazon Fire TV Sticks, Google TVs, and Android TVs via ADB.
#
# Before installing, the script verifies:
#   1. The APK SHA-256 matches the value published in manifest.json.
#   2. (If `apksigner` is available) the APK is signed by the official
#      Pinball Buddies release certificate.
#
# Usage:
#   ./setup-firestick.sh [DEVICE_IP[:PORT]]
#
# Examples:
#   ./setup-firestick.sh 192.168.1.150
#   ./setup-firestick.sh 192.168.1.150:5555
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
APK_PATH="$PACKAGE_DIR/pinball-buddies-pincast-tv.apk"
MANIFEST_PATH="$PACKAGE_DIR/manifest.json"
PACKAGE_NAME="com.pinballbuddies.venuedisplay"
ACTIVITY_NAME=".MainActivity"
# SHA-256 of the official Pinball Buddies release signing certificate.
EXPECTED_CERT_SHA256="d7da0d5619c8969bc7ae92e9044e3b8a045fde44ac93e47cc81ce06d7515d79f"
AUTH_TIMEOUT_SECONDS=60

die() {
  echo "[-] ERROR: $*" >&2
  exit 1
}

echo "=========================================================="
echo "  Pinball Buddies Pincast TV — Native TV Setup            "
echo "=========================================================="

# 1. Verify APK exists
[ -f "$APK_PATH" ] || die "pinball-buddies-pincast-tv.apk not found at: $APK_PATH"

# 2. Verify APK integrity against manifest.json
if [ -f "$MANIFEST_PATH" ]; then
  EXPECTED_SHA256="$(sed -n 's/.*"apkSha256"[[:space:]]*:[[:space:]]*"\([0-9a-fA-F]\{64\}\)".*/\1/p' "$MANIFEST_PATH" | head -n 1)"
  if command -v sha256sum >/dev/null 2>&1; then
    ACTUAL_SHA256="$(sha256sum "$APK_PATH" | awk '{print $1}')"
  elif command -v shasum >/dev/null 2>&1; then
    ACTUAL_SHA256="$(shasum -a 256 "$APK_PATH" | awk '{print $1}')"
  else
    ACTUAL_SHA256=""
    echo "[!] WARNING: No sha256sum/shasum found; skipping checksum verification."
  fi

  if [ -n "$ACTUAL_SHA256" ]; then
    [ -n "$EXPECTED_SHA256" ] || die "manifest.json does not contain a valid apkSha256 value."
    if [ "$(echo "$ACTUAL_SHA256" | tr '[:upper:]' '[:lower:]')" != "$(echo "$EXPECTED_SHA256" | tr '[:upper:]' '[:lower:]')" ]; then
      die "APK checksum mismatch! Expected $EXPECTED_SHA256 but got $ACTUAL_SHA256. Re-download the release from the official GitHub repository."
    fi
    echo "[+] APK checksum verified ($ACTUAL_SHA256)."
  fi
else
  echo "[!] WARNING: manifest.json not found; skipping checksum verification."
fi

# 3. Optional: verify the signing certificate
if command -v apksigner >/dev/null 2>&1; then
  if apksigner verify --print-certs "$APK_PATH" 2>/dev/null | grep -qi "SHA-256 digest: $EXPECTED_CERT_SHA256"; then
    echo "[+] APK signature verified (official Pinball Buddies certificate)."
  else
    die "APK is not signed with the official Pinball Buddies certificate. Do not install it."
  fi
fi

# 4. Check for adb
if ! command -v adb >/dev/null 2>&1; then
  echo "[-] 'adb' command not found."
  echo "    Please install Android Platform Tools:"
  echo "      macOS:  brew install android-platform-tools"
  echo "      Ubuntu: sudo apt-get install -y adb"
  echo "      Fedora: sudo dnf install -y android-tools"
  exit 1
fi

# 5. Determine Device IP
DEVICE_IP="${1:-}"
if [ -z "$DEVICE_IP" ]; then
  echo "[?] Enter the Fire TV Stick / Android TV IP address:"
  echo "    (Find this on Fire TV: Settings -> My Fire TV -> About -> Network)"
  read -r -p "    Device IP: " DEVICE_IP
fi

[ -n "$DEVICE_IP" ] || die "Device IP cannot be empty."

# Accept "host" or "host:port"; reject anything that is not a plain hostname/IP.
if [[ ! "$DEVICE_IP" =~ ^[A-Za-z0-9.-]+(:[0-9]{1,5})?$ ]]; then
  die "'$DEVICE_IP' is not a valid IP address or hostname."
fi

if [[ "$DEVICE_IP" == *:* ]]; then
  DEVICE_TARGET="$DEVICE_IP"
else
  DEVICE_TARGET="$DEVICE_IP:5555"
fi

device_state() {
  adb devices | awk -v t="$DEVICE_TARGET" '$1 == t {print $2}'
}

echo ""
echo "[*] Connecting to $DEVICE_TARGET..."
adb connect "$DEVICE_TARGET" || true

STATE="$(device_state)"
if [ -z "$STATE" ] || [ "$STATE" = "offline" ]; then
  echo "[*] Resetting local ADB server and retrying connection to $DEVICE_TARGET..."
  adb kill-server >/dev/null 2>&1 || true
  adb start-server >/dev/null 2>&1 || true
  adb connect "$DEVICE_TARGET" || true
  STATE="$(device_state)"
fi

[ -n "$STATE" ] || die "Failed to connect to $DEVICE_TARGET. Ensure ADB Debugging is ON (Settings -> My Fire TV -> Developer Options) and that this computer is on the same network."

if [ "$STATE" = "unauthorized" ]; then
  echo "[!] ACTION REQUIRED ON TV:"
  echo "    Select 'Always allow from this computer' -> OK on the TV screen."
  echo "    Waiting up to ${AUTH_TIMEOUT_SECONDS}s for authorization..."
  for _ in $(seq 1 "$AUTH_TIMEOUT_SECONDS"); do
    sleep 1
    STATE="$(device_state)"
    [ "$STATE" = "device" ] && break
  done
fi

[ "$STATE" = "device" ] || die "Device did not authorize this computer (state: ${STATE:-disconnected}). Re-run the script and accept the prompt on the TV."

echo "[+] Connected to device successfully."

# 6. Install / Update the Pincast TV Kiosk APK
echo "[*] Installing Pinball Buddies Pincast TV (Flutter/Dart Kiosk)..."
adb -s "$DEVICE_TARGET" uninstall com.pinballbuddies.app >/dev/null 2>&1 || true
adb -s "$DEVICE_TARGET" uninstall com.pinballbuddies.app.tv >/dev/null 2>&1 || true
adb -s "$DEVICE_TARGET" install -r -d -g "$APK_PATH"
echo "[+] Installation successful!"

# 7. Configure 24/7 Arcade Kiosk Power, Overlay Auto-Boot & Sleep Prevention
echo "[*] Applying 24/7 arcade kiosk power & Fire OS auto-boot settings..."
"$SCRIPT_DIR/kiosk-power-settings.sh" "$DEVICE_TARGET" || echo "[!] Some power settings could not be applied (non-fatal)."

# 8. Launch the Kiosk App
echo "[*] Launching Pinball Buddies Pincast TV..."
adb -s "$DEVICE_TARGET" shell am start -n "$PACKAGE_NAME/$ACTIVITY_NAME"

# 9. Disconnect this computer from the device
adb disconnect "$DEVICE_TARGET" >/dev/null 2>&1 || true

echo ""
echo "=========================================================="
echo "  [✓] Pinball Buddies Pincast TV is now running!         "
echo "=========================================================="
echo "  1. Look at your TV: the Connect Display QR code and    "
echo "     Display ID are shown on screen.                     "
echo "  2. Scan the QR code with your phone camera (or open    "
echo "     the Pinball Buddies app) and select your Venue.     "
echo "  3. The display will immediately load your live arcade   "
echo "     leaderboard carousel in 24/7 kiosk mode!            "
echo "=========================================================="
echo ""
echo "  SECURITY: Turn ADB Debugging back OFF on the TV now:"
echo "  Settings -> My Fire TV -> Developer Options -> ADB Debugging -> OFF"
echo "  Leaving it on lets other devices on the venue network control the TV."
echo "=========================================================="
