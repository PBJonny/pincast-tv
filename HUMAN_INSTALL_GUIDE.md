# Pinball Buddies Pincast TV: Installation & Setup Guide

> **100% Native TV App** — Built specifically for TV hardware with Kotlin, Jetpack Compose for TV, and Room SQLite offline caching. Zero clunky web browsers.
> **Automated Setup**: Installs the native APK, applies 24/7 arcade kiosk sleep prevention, and auto-launches the display over your local Wi-Fi network in seconds.

---

## 💻 Automated 1-Click Wi-Fi Setup (Mac, Windows, or Linux)

This is the standard installation method for all venues. Running the installer script over Wi-Fi automatically:
1. Installs the signed production APK (`pinball-buddies-pincast-tv.apk`).
2. Configures 24/7 arcade kiosk power settings (disables sleep timers, stays awake on AC power, and turns off screensavers).
3. Launches the native app directly on your TV screen in 1080p/4K landscape.

---

### What you need:
- Your Amazon Fire TV Stick, Google TV, or Android TV plugged into your TV.
- Your computer (Mac, Windows, or Linux) connected to the same Wi-Fi network as your TV.
- Your smartphone (to pair your venue).

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

### Step 3: Run the 1-Click Installer
From the unzipped release folder on your computer, open your terminal (or Command Prompt) and run:

```bash
# On macOS or Linux:
./scripts/setup-firestick.sh 192.168.1.150

# On Windows:
.\scripts\setup-firestick.bat 192.168.1.150
```
*(Tip: If you omit the IP address, the script will simply prompt you to type it in).*

---

### Step 4: Authorize on Your TV Screen
1. Look at your TV screen. You will see a prompt: **"Allow USB/ADB debugging?"**
2. Check the box **"Always allow from this computer"** and select **OK**.
3. The script will finish in seconds:
   - `[+] Connected to device successfully.`
   - `[+] Installing native Pinball Buddies Pincast TV app...`
   - `[+] Applying 24/7 arcade kiosk power settings...`
   - `[+] Launching Pinball Buddies Pincast TV!`

---

### Step 5: Link Your TV with Your Smartphone (1-Tap Pairing)
1. **Pinball Buddies Pincast TV** will launch natively on your screen in full 1080p/4K resolution.
2. You will see a 6-digit **Pairing Code** and a large **QR Code**.
3. Open your smartphone camera or the Pinball Buddies app.
4. Navigate to your **Venue Dashboard > Displays > Pair New Display** (or scan the QR code).
5. Enter the 6-digit code.
6. Tap **Approve Display**!
7. **Your TV will instantly activate the live leaderboard carousel!** 🚀

---

## ⚡ Power-On & Cold Boot Behavior: The Startup Delay Timer

> **Don't touch the remote—it's not broken!** 🛑
> When you power on your TV or turn on your arcade's master power strip in the morning, your Fire TV Stick / Android TV performs a cold boot.

### Why is there a 30 to 60 second delay before the app launches?
1. **Fire OS System Boot (~25–35s)**: Fire TV OS has to boot its operating system and start core system services. During this time, you may see the Amazon boot logo followed briefly by the standard Fire TV home screen.
2. **Wi-Fi Network Association (~10–15s)**: The Fire Stick takes several seconds to find your venue's Wi-Fi router, negotiate WPA security, and acquire a local IP address.
3. **Intentional Startup Delay Timer**: The auto-start sequence has an intentional delay timer before launching **Pinball Buddies Pincast TV**. This delay prevents black screens, ensures HDMI CEC video sync is ready, and guarantees the network socket is active before the leaderboard carousel begins fetching scores.
4. **Hands-Off Fullscreen Launch**: Once the startup timer finishes, the Pincast app will take over the screen automatically in full 60fps landscape without anyone having to touch the Fire TV remote!

💡 **Staff Opening Procedure**: Instruct your opening staff to simply switch on the TV power strip and walk away. Remind them **not** to press buttons on the remote—the display will initialize automatically within 45–60 seconds.

---

## 🎮 Native TV Remote Navigation

Unlike web browsers that require awkward mouse pointers, Pinball Buddies Pincast TV is 100% remote-control native:

- **D-Pad Left / Right**: Manually cycle between machines and leaderboard slides.
- **D-Pad Center (Select)**: Pause / resume automatic carousel rotation.
- **Back Button**: Opens the Operator Management PIN Pad (default PIN: `1234` or custom PIN set in venue dashboard). From the operator menu, you can toggle playlists, force reload snapshots, or re-pair the display.

---

## 🛠️ Frequently Asked Questions (FAQ)

### Why do I see the Fire TV home screen for 30–60 seconds after powering on?
That is 100% normal cold-boot behavior. Fire OS needs time to boot and connect to Wi-Fi. An intentional startup delay timer waits for the network and HDMI handshake to stabilize before automatically launching Pinball Buddies Pincast. It is not frozen or broken—just give it a minute!

### Why automated script setup instead of a TV web browser?
TV browsers (like Silk or smart TV web browsers) suffer from high memory consumption, address bar popups, lack of D-pad remote focus, and frequent crashes. Our automated installer puts a 100% native Kotlin + Jetpack Compose app directly on the hardware with 24/7 sleep prevention and Room SQLite local database persistence—if your venue's Wi-Fi drops, your screens keep running flawlessly!

### Does this prevent screen sleep during arcade hours?
Yes! The installer configures permanent screen timeout (`screen_off_timeout 2147483647`), keeps the device awake on AC power (`stay_on_while_plugged_in 3`), disables screensavers, and the native app itself enforces active wake-lock management and burn-in micro-pixel drift (±2dp drift every 120s) to protect arcade OLEDs and CRT monitors.
