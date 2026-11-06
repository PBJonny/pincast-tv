# Pinball Buddies Pincast TV: Installation & Setup Guide

> **Commercial Flutter & Dart Kiosk App (`com.pinballbuddies.venuedisplay`)** — Built specifically for commercial arcade TV displays with Flutter, Dart, hardware wake locks, a native watchdog crash-recovery daemon, Fire OS power-on auto-boot (`BootReceiver`), and Android Keystore secure storage.
> **Automated Setup**: Installs the signed production APK, grants Fire OS power-on auto-boot overlay permissions, applies 24/7 arcade kiosk sleep prevention, and auto-launches the display over your local Wi-Fi network in seconds.

---

## 💻 Automated 1-Click Wi-Fi Setup (Mac, Windows, or Linux)

This is the standard installation method for all venues. Running the installer script over Wi-Fi automatically:
1. Installs the signed production Flutter/Dart Kiosk APK (`pinball-buddies-pincast-tv.apk`).
2. Grants Fire OS auto-boot overlay permission (`SYSTEM_ALERT_WINDOW`) and configures 24/7 arcade kiosk power settings (disables sleep timers, stays awake on AC power, exempts from Doze battery optimization, and turns off screensavers).
3. Launches the Pincast TV display directly on your TV screen in 1080p/4K landscape.

---

### What you need:
- Your Amazon Fire TV Stick plugged into your TV.
- Your computer (Mac, Windows, or Linux) connected to the same Wi-Fi network as your TV.
- Your smartphone (iOS, Android, or Web) to pair your venue.

---

### Step 1: Enable ADB Debugging on Fire TV (Takes 15 seconds)
1. On your Fire TV, go to **Settings (⚙️)** > **My Fire TV**.
2. Select **Developer Options**.
   - *(Note: If Developer Options is hidden on your Fire TV, go to **Settings > My Fire TV > About**, highlight your device name, and click the center remote button **7 times** until it says "You are now a developer").*
3. Set **ADB Debugging** to **ON**.

---

### Step 2: Note Your Fire TV's IP Address
1. Go to **Settings** > **My Fire TV** > **About** > **Network**.
2. Note the **IP Address** shown on the right (e.g. `192.168.1.150`).

---

### Step 3: Download & Run the 1-Click Installer
Open your terminal (or Command Prompt), download the release package, and run the installer with your Fire TV's IP address:

```bash
# On macOS or Linux:
curl -L -o pincast.zip https://github.com/PBJonny/pincast-tv/releases/latest/download/pinball-buddies-pincast-v1.0.0.zip
unzip pincast.zip
cd pincast
./scripts/setup-firestick.sh 192.168.1.150
```

```powershell
# On Windows (Command Prompt / PowerShell):
curl.exe -L -o pincast.zip https://github.com/PBJonny/pincast-tv/releases/latest/download/pinball-buddies-pincast-v1.0.0.zip
tar -xf pincast.zip
cd pincast
.\scripts\setup-firestick.bat 192.168.1.150
```
*(Tip: If you omit the IP address, the script will prompt you to enter it).*

---

### Step 4: Authorize on Your TV Screen
1. Look at your TV screen. You will see a prompt: **"Allow USB/ADB debugging?"**
2. Check the box **"Always allow from this computer"** and select **OK**.
3. The script will finish in seconds:
   - `[+] Connected to device successfully.`
   - `[*] Installing Pinball Buddies Pincast TV (Flutter/Dart Kiosk)...`
   - `[*] Applying 24/7 arcade kiosk power & Fire OS auto-boot settings...`
   - `[✓] Pinball Buddies Pincast TV is now running!`

---

### Step 5: Link Your TV with Your Smartphone (1-Tap Pairing)
1. **Pinball Buddies Pincast TV** will launch on your screen in full 1080p/4K resolution showing the **Connect Display** screen.
2. You will see an 8-character **Display ID** and a large **QR Code**.
3. Scan the QR code with your smartphone camera, or open the **Pinball Buddies** app (iOS, Android, or Web) and enter the 8-character Display ID.
4. Select your **Venue** (or Private Arcade) and screen name (e.g. `Main Display`), then tap **Approve & Connect TV** / **Link Display**!
5. **Your TV will instantly activate the live leaderboard carousel!** 🚀
6. 🔒 **Security Best Practice**: Once setup is complete, turn **ADB Debugging OFF** on your Fire TV (**Settings > My Fire TV > Developer Options > ADB Debugging > OFF**) so other devices on the venue Wi-Fi cannot connect to the TV over ADB.

---

## ⚡ Power-On & Cold Boot Behavior: The Startup Delay Timer

> **Don't touch the remote—it's not broken!** 🛑
> When you power on your TV or turn on your arcade's master power strip in the morning, your Fire TV Stick performs a cold boot.

### Why is there a 30 to 60 second delay before the app launches?
1. **Fire OS System Boot (~25–35s)**: Fire TV OS boots its operating system and starts core system services. During this time, you may see the Amazon boot logo followed briefly by the standard Fire TV home screen.
2. **Wi-Fi Network Association (~10–15s)**: The Fire Stick takes several seconds to associate with your venue's Wi-Fi router, negotiate WPA security, and acquire a local IP address.
3. **Intentional Startup Delay Timer**: The auto-start sequence has an intentional delay timer before launching **Pinball Buddies Pincast TV**. This delay prevents black screens, ensures HDMI video sync is ready, and guarantees the network socket is active before the leaderboard carousel begins fetching scores.
4. **Hands-Off Fullscreen Launch**: Once the startup timer finishes, the Pincast app takes over the screen automatically in fullscreen landscape without anyone having to touch the Fire TV remote!

💡 **Staff Opening Procedure**: Instruct your opening staff to simply switch on the TV power strip and walk away. Remind them **not** to press buttons on the remote—the display will initialize automatically within 45–60 seconds.

---

## 🎮 TV Remote & Kiosk Configuration Controls

Pinball Buddies Pincast TV runs unattended in immersive fullscreen landscape mode, with built-in operator controls:

- **Back or Menu Button on Remote (or 2.5s Long-Press)**: Opens the **Kiosk Configuration** screen where operators can inspect or customize the Display Server / Pairing URL.
- **Save & Launch**: Saves the configured URL and relaunches the display.
- **Reset Default (Back → Right → Select)**: Clears the cached venue pairing session (`display_auth`), resets the URL to `https://pinballbuddies.com/display`, and returns the TV directly to the **Connect Display** QR pairing screen so it can be linked to a different venue or screen layout.
- **Venue Dashboard Remote Control**: From your phone or computer (**Venue Dashboard > Displays**), you can change multi-zone screen layouts, switch active playlists, spotlight individual machines or tournaments, and remotely manage all screens in real time.

---

## 🛠️ Frequently Asked Questions (FAQ)

### Why do I see the Fire TV home screen for 30–60 seconds after powering on?
That is 100% normal cold-boot behavior. Fire OS needs time to boot and connect to Wi-Fi before broadcasting `BOOT_COMPLETED` to launch Pinball Buddies Pincast TV. It is not frozen or broken—just give it a minute!

### Why use the Flutter/Dart Commercial Kiosk app instead of a standard TV web browser?
Standard TV browsers (like Amazon Silk) suffer from memory leaks, address bar popups, sleep timeouts, and no auto-start on power-on. Our commercial Flutter/Dart kiosk app (`com.pinballbuddies.venuedisplay`) locks the display in immersive fullscreen landscape, enforces hardware and window wake locks (`WakelockPlus` + `FLAG_KEEP_SCREEN_ON`), auto-boots on power-on via `BootReceiver` + `SYSTEM_ALERT_WINDOW`, and runs a native 30-second watchdog daemon with exponential-backoff auto-recovery if venue Wi-Fi ever drops!

### Does this prevent screen sleep during arcade hours?
Yes! The installer configures permanent screen timeout (`screen_off_timeout 2147483647`), keeps the device awake on power (`stay_on_while_plugged_in 7`), exempts the app from Doze battery optimization, disables screensavers, and the Flutter app itself enforces active hardware and window wake locks 24/7.
