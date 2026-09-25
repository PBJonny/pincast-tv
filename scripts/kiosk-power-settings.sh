#!/usr/bin/env bash
# ==============================================================================
# Pinball Buddies Pincast — 24/7 Arcade Power & Sleep Tuner (ADB)
# ==============================================================================
# Disables screen sleep, disables screensavers, and keeps displays awake 24/7
# across Amazon Fire TV Sticks, Google TVs, and Android TVs.
#
# Usage:
#   ./kiosk-power-settings.sh [TARGET_DEVICE_IP_OPTIONAL]
# ==============================================================================

set -euo pipefail

TARGET="${1:-}"
ADB_CMD="adb"

if [ -n "$TARGET" ]; then
  if [[ "$TARGET" != *":"* ]]; then
    TARGET="$TARGET:5555"
  fi
  ADB_CMD="adb -s $TARGET"
fi

echo "[*] Applying 24/7 Arcade Kiosk power settings..."

# 1. Set display timeout to maximum (~24 days)
$ADB_CMD shell settings put system screen_off_timeout 2147483647
echo "[+] Screen off timeout set to permanent (2147483647 ms)"

# 2. Stay awake while connected to AC/USB power
$ADB_CMD shell settings put global stay_on_while_plugged_in 3
echo "[+] Stay awake while on AC power enabled"

# 3. Disable Fire OS ambient screensaver sleep timeout
$ADB_CMD shell settings put secure sleep_timeout 0
echo "[+] Ambient sleep timeout disabled"

# 4. Wake up device display right now
$ADB_CMD shell input keyevent KEYCODE_WAKEUP
echo "[+] Display awake signal dispatched"

echo "[✓] Power optimization complete!"
