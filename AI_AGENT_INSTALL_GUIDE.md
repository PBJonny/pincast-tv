# Automated CLI Installation Playbook: Pinball Buddies Pincast TV (Flutter/Dart Kiosk)

> **Target Audience**: Automated deployment tools, CLI operators, and shell/ADB runners deploying the commercial Pinball Buddies Pincast TV Flutter/Dart kiosk application.
> **Scope**: Automated installation of `pinball-buddies-pincast-tv.apk` (`com.pinballbuddies.venuedisplay`) on Amazon Fire TV Stick hardware.

---

## Deployment Intent

Deploy the commercial **Pinball Buddies Pincast TV** Flutter/Dart Kiosk application (`com.pinballbuddies.venuedisplay`) onto the venue's Fire TV Stick.
Do not use consumer web browsers. Install the signed production APK directly.

Follow this deterministic state machine:

```
[INIT] ──> [DISCOVER_IP] ──> [ADB_CONNECT] ──> [CHECK_AUTH] ──> [INSTALL_APK]
                                                     │
                                             (If Unauthorized)
                                                     ▼
                                            [PROMPT_USER_REMOTE]
                                                     │
                                                     ▼
[CONFIGURE_KIOSK] <── [VERIFY_INSTALL] <────────────┘
        │
        ▼
   [LAUNCH_APP] ──> [VERIFY_PID] ──> [REPORT_TO_USER]
```

---

## Step 1: Pre-flight Verification

Verify `adb` is present on the host:
```bash
which adb
```
If missing:
- macOS: `brew install android-platform-tools`
- Debian/Ubuntu: `sudo apt-get install -y adb`
- Windows: Ensure Android SDK `platform-tools` is in `%PATH%`.

Verify the APK exists and matches the SHA-256 checksum in `manifest.json`:
```bash
ls -lh pinball-buddies-pincast-tv.apk
shasum -a 256 pinball-buddies-pincast-tv.apk
```

---

## Step 2: Establish ADB Connection

Set target IP:
```bash
export DEVICE_TARGET="<FIRE_TV_IP>:5555"
adb connect "$DEVICE_TARGET"
```

If `adb connect` reports `No route to host` due to a stale host ADB daemon socket, restart the local ADB server and reconnect:
```bash
adb kill-server && adb start-server
adb connect "$DEVICE_TARGET"
```

### Response Evaluation Matrix:
| Output Pattern | State | Required Action |
|---|---|---|
| `connected to <IP>:5555` | Connected | Proceed to Step 3 |
| `already connected to <IP>:5555` | Connected | Proceed to Step 3 |
| `device unauthorized` | Blocked | Prompt user to accept RSA key dialog on TV remote, sleep 10s |
| `Connection refused` | Network/ADB Off | Prompt user to verify IP & ensure ADB Debugging is ON |

---

## Step 3: Install Pincast TV Kiosk APK

Execute package installation:
```bash
adb -s "$DEVICE_TARGET" install -r -d -g pinball-buddies-pincast-tv.apk
```

**Flags**:
- `-r`: Replaces existing package while preserving Keystore-backed configuration and credentials.
- `-d`: Allows version code downgrade if reinstalling.
- `-g`: Grants all declared runtime permissions automatically.

### Verification:
```bash
adb -s "$DEVICE_TARGET" shell pm list packages | grep "com.pinballbuddies.venuedisplay"
```
**Expected**: `package:com.pinballbuddies.venuedisplay`

---

## Step 4: Configure 24/7 Arcade Kiosk Power & Auto-Boot

Prevent Fire OS from sleeping during arcade hours and grant power-on auto-boot overlay permissions:
```bash
# 1. Grant SYSTEM_ALERT_WINDOW overlay so BootReceiver auto-launches on Fire OS boot
adb -s "$DEVICE_TARGET" shell appops set com.pinballbuddies.venuedisplay SYSTEM_ALERT_WINDOW allow

# 2. Grant WAKE_LOCK and exempt from Doze battery optimization
adb -s "$DEVICE_TARGET" shell pm grant com.pinballbuddies.venuedisplay android.permission.WAKE_LOCK
adb -s "$DEVICE_TARGET" shell dumpsys deviceidle whitelist +com.pinballbuddies.venuedisplay

# 3. Permanent screen timeout
adb -s "$DEVICE_TARGET" shell settings put system screen_off_timeout 2147483647

# 4. Stay awake on AC/USB power
adb -s "$DEVICE_TARGET" shell settings put global stay_on_while_plugged_in 7

# 5. Disable ambient screensaver sleep
adb -s "$DEVICE_TARGET" shell settings put secure sleep_timeout 0

# 6. Wake display immediately
adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_WAKEUP
```

---

## Step 5: Launch Kiosk Activity & Verify Process

Launch the TV activity:
```bash
adb -s "$DEVICE_TARGET" shell am start -n com.pinballbuddies.venuedisplay/.MainActivity
```

Verify process is running:
```bash
adb -s "$DEVICE_TARGET" shell pidof com.pinballbuddies.venuedisplay
```
*(Must return a numeric PID)*.

> ⚠️ **Notice (Cold Boot Behavior)**: If testing cold-boot behavior or executing `adb reboot`, allow **45 to 60 seconds** after power-on. Fire OS takes ~30s to boot and connect to Wi-Fi before broadcasting `BOOT_COMPLETED` to launch the application. Do not mark the test as failed during this initialization window.

---

## Step 6: Pairing & Operator Reporting

When the app boots on a fresh device, it loads `https://pinballbuddies.com/display` and displays a QR code and 8-character Display ID.

Disconnect the ADB session and report to user:
```bash
adb disconnect "$DEVICE_TARGET"
```
> *"Pinball Buddies Pincast TV is now running on your TV! You will see the Connect Display QR code and Display ID on screen. Scan the QR code with your phone camera (or enter the 8-character Display ID in the Pinball Buddies app) to link your venue or private arcade. For security, remember to turn ADB Debugging OFF in Fire TV Developer Options once paired."*

### Optional Automated Screen Verification:
```bash
adb -s "$DEVICE_TARGET" exec-out screencap -p > /tmp/pincast_screen_check.png
```

---

## Remote Diagnostics & Control Matrix

- **Back / Menu Button** (Opens Kiosk Configuration):
  ```bash
  adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_BACK
  ```
- **Reset Default Session** (From Kiosk Configuration — moves focus to Reset Default and activates it):
  ```bash
  adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_DPAD_RIGHT
  adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_DPAD_CENTER
  ```
- **Force Restart**:
  ```bash
  adb -s "$DEVICE_TARGET" shell am force-stop com.pinballbuddies.venuedisplay
  adb -s "$DEVICE_TARGET" shell am start -n com.pinballbuddies.venuedisplay/.MainActivity
  ```
