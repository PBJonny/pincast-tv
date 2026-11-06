#!/usr/bin/env bash
# ==============================================================================
# Pinball Buddies Pincast — 24/7 Arcade Power & Sleep Tuner (ADB)
# ==============================================================================
# Disables screen sleep, disables screensavers, and keeps displays awake 24/7
# on Amazon Fire TV Stick kiosk displays.
#
# Usage:
#   ./kiosk-power-settings.sh [TARGET_DEVICE_IP[:PORT]]
#   (omit the target to use the only USB/ADB device currently connected)
# ==============================================================================

set -euo pipefail

TARGET="${1:-}"
ADB_CMD=(adb)

if [ -n "$TARGET" ]; then
  if [[ ! "$TARGET" =~ ^[A-Za-z0-9.-]+(:[0-9]{1,5})?$ ]]; then
    echo "[-] ERROR: '$TARGET' is not a valid IP address or hostname." >&2
    exit 1
  fi
  if [[ "$TARGET" != *":"* ]]; then
    TARGET="$TARGET:5555"
  fi
  ADB_CMD=(adb -s "$TARGET")
fi

echo "[*] Applying 24/7 Arcade Kiosk power & Fire OS auto-boot settings..."

PACKAGE_NAME="com.pinballbuddies.venuedisplay"

# 1. Grant SYSTEM_ALERT_WINDOW overlay permission for Fire OS power-on BootReceiver auto-launch
"${ADB_CMD[@]}" shell appops set "$PACKAGE_NAME" SYSTEM_ALERT_WINDOW allow 2>/dev/null || true
echo "[+] Granted SYSTEM_ALERT_WINDOW overlay permission for power-on auto-boot"

# 2. Grant WAKE_LOCK and exempt from Doze battery optimization
"${ADB_CMD[@]}" shell pm grant "$PACKAGE_NAME" android.permission.WAKE_LOCK 2>/dev/null || true
"${ADB_CMD[@]}" shell dumpsys deviceidle whitelist +"$PACKAGE_NAME" 2>/dev/null || true
echo "[+] Granted WAKE_LOCK and Doze battery optimization exemption"

# 3. Set display timeout to maximum (~24 days)
"${ADB_CMD[@]}" shell settings put system screen_off_timeout 2147483647
echo "[+] Screen off timeout set to permanent (2147483647 ms)"

# 4. Stay awake while connected to AC/USB power
"${ADB_CMD[@]}" shell settings put global stay_on_while_plugged_in 7
echo "[+] Stay awake while on AC/USB power enabled"

# 5. Disable Fire OS ambient screensaver sleep timeout
"${ADB_CMD[@]}" shell settings put secure sleep_timeout 0
echo "[+] Ambient sleep timeout disabled"

# 6. Wake up device display right now
"${ADB_CMD[@]}" shell input keyevent KEYCODE_WAKEUP
echo "[+] Display awake signal dispatched"

echo "[✓] Power optimization complete!"
