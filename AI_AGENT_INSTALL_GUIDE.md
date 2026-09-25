# AI Agent Installation Playbook: Pinball Buddies Pincast TV (Native)

> **Target Audience**: AI Agents (Claude Computer Use, Antigravity, OpenDevin, Cursor, AutoGPT, or local LLMs equipped with shell/ADB tools) deploying the native Pinball Buddies Pincast TV application.
> **Scope**: Pure native installation of `pinball-buddies-pincast-tv.apk` (`com.pinballbuddies.app.tv`) on Amazon Fire TV Sticks, Google TVs, Android TVs, and Android-based appliances. Zero web browsers.

---

## Agent System Prompt & Intent

You are deploying the native **Pinball Buddies Pincast TV** application on a venue's TV hardware.
Do not use or suggest web browsers. Install the signed production APK directly.

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

Verify the native APK exists:
```bash
ls -lh pinball-buddies-pincast-tv.apk
```

---

## Step 2: Establish ADB Connection

Set target IP:
```bash
export DEVICE_TARGET="<FIRE_TV_IP>:5555"
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

## Step 3: Install Native TV APK

Execute package installation:
```bash
adb -s "$DEVICE_TARGET" install -r -g pinball-buddies-pincast-tv.apk
```

**Flags**:
- `-r`: Replaces existing package while preserving Room SQLite local cache and credentials.
- `-g`: Automatically grants all runtime permissions.

### Verification:
```bash
adb -s "$DEVICE_TARGET" shell pm list packages | grep "com.pinballbuddies.app.tv"
```
**Expected**: `package:com.pinballbuddies.app.tv`

---

## Step 4: Configure 24/7 Arcade Kiosk Power

Prevent Fire OS / Android TV from sleeping during arcade hours:
```bash
# 1. Permanent screen timeout
adb -s "$DEVICE_TARGET" shell settings put system screen_off_timeout 2147483647

# 2. Stay awake on AC power
adb -s "$DEVICE_TARGET" shell settings put global stay_on_while_plugged_in 3

# 3. Disable ambient screensaver sleep
adb -s "$DEVICE_TARGET" shell settings put secure sleep_timeout 0

# 4. Wake display immediately
adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_WAKEUP
```

---

## Step 5: Launch Native Activity & Verify Process

Launch the TV activity:
```bash
adb -s "$DEVICE_TARGET" shell am start -n com.pinballbuddies.app.tv/.MainActivity
```

Verify process is running:
```bash
adb -s "$DEVICE_TARGET" shell pidof com.pinballbuddies.app.tv
```
*(Must return a numeric PID)*.

---

## Step 6: Pairing & Operator Reporting

When the app boots on a fresh device, it generates a 6-digit pairing code and QR code.

Report to user:
> *"Pinball Buddies Pincast TV is now running natively on your TV! You will see a 6-digit code on screen. Open your Pinball Buddies phone app, go to your Venue Dashboard > Displays > 'Pair Display', and enter the code to link your arcade leaderboards."*

### Optional Automated Screen Verification:
```bash
adb -s "$DEVICE_TARGET" exec-out screencap -p > /tmp/pincast_screen_check.png
```

---

## Remote Diagnostics & Control Matrix

- D-Pad Center: `adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_DPAD_CENTER`
- D-Pad Left: `adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_DPAD_LEFT`
- D-Pad Right: `adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_DPAD_RIGHT`
- Back Button (Opens Operator PIN Pad): `adb -s "$DEVICE_TARGET" shell input keyevent KEYCODE_BACK`
- Force Restart:
  ```bash
  adb -s "$DEVICE_TARGET" shell am force-stop com.pinballbuddies.app.tv
  adb -s "$DEVICE_TARGET" shell am start -n com.pinballbuddies.app.tv/.MainActivity
  ```
