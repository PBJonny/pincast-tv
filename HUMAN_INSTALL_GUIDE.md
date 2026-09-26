# Pinball Buddies Pincast TV: Human Installation Guide

> **100% Native TV App** — Built specifically for TV hardware with Kotlin, Jetpack Compose for TV, and Room SQLite offline caching. Zero clunky web browsers.

---

## 📺 Method 1: Sideloading via the "Downloader" App (No Computer Needed! 📱)

This is the standard, easiest way to install native apps onto an Amazon Fire TV Stick or Android TV without touching a computer or terminal.

### What you need:
- Your Amazon Fire TV Stick or Android TV box plugged into your TV.
- Your Fire TV remote.
- Your smartphone (to pair your venue).

---

### Step 1: Install the Free "Downloader" App on your Fire TV
1. Turn on your Fire TV Stick.
2. From the Home screen, scroll to **Find** (magnifying glass) or press the Alexa voice button on your remote.
3. Search for: **Downloader**.
4. Select the orange **Downloader** app (by AFTVnews) and click **Get / Download** (it is 100% free).

---

### Step 2: Enable "Install Unknown Apps" for Downloader
Amazon Fire OS requires you to grant Downloader permission to install apps:

1. On your Fire TV, go to **Settings (⚙️)** > **My Fire TV**.
2. Select **Developer Options**.
   - *(Note: If Developer Options is hidden on your Fire TV, go to **Settings > My Fire TV > About**, highlight your device name, and click the center remote button **7 times** until it says "You are now a developer").*
3. Select **Install unknown apps**.
4. Find **Downloader** in the list and switch it to **ON**.

---

### Step 3: Download & Install the Native Pincast TV App
1. Open the **Downloader** app on your Fire TV.
2. Click into the URL text box.
3. Enter the direct download URL for the release APK:
   ```
   https://github.com/PBJonny/pincast-tv/releases/latest/download/pinball-buddies-pincast-tv.apk
   ```
   *(Or simply type the short link on your remote: **`pinballbuddies.com/tv`**)*
4. Click **Go**. Downloader will fetch the APK package.
5. When the download finishes, a prompt will appear on your TV: click **INSTALL**.
6. Once installed, click **OPEN**!

---

### Step 4: Link Your TV with Your Smartphone (1-Tap Pairing)
1. **Pinball Buddies Pincast TV** will launch natively on your screen in full 1080p/4K resolution.
2. You will see a 6-digit **Pairing Code** and a large **QR Code**.
3. Open your smartphone camera or the Pinball Buddies app.
4. Navigate to your **Venue Dashboard > Displays > Pair New Display** (or scan the QR code).
5. Enter the 6-digit code.
6. Tap **Approve Display**!
7. **Your TV will instantly activate the live leaderboard carousel!** 🚀

---

## 💻 Method 2: Automated 1-Click Wi-Fi Installer (From Mac, Windows, or Linux)

If your computer is on the same Wi-Fi network as your Fire TV Stick, you can install the APK in 15 seconds without typing URLs on your TV remote:

### 1. Enable ADB Debugging on Fire TV:
- Go to **Settings > My Fire TV > Developer Options > ADB Debugging > ON**.
- Note your device's IP address (**Settings > My Fire TV > About > Network**).

### 2. Run the Installer:
From the unzipped release folder on your computer:

```bash
# On Mac or Linux:
./scripts/setup-firestick.sh 192.168.1.150

# On Windows:
.\scripts\setup-firestick.bat 192.168.1.150
```

The script automatically:
- Connects to your Fire TV over Wi-Fi.
- Installs the native APK (`pinball-buddies-pincast-tv.apk`).
- Configures 24/7 arcade kiosk power settings (disables sleep timer and screensavers).
- Launches the native app on your TV screen!

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

### Why native instead of a web browser?
TV browsers (like Silk or smart TV web browsers) suffer from high memory consumption, address bar popups, lack of D-pad remote focus, and frequent crashes. Our native Kotlin + Jetpack Compose app runs at 60fps with Room SQLite local database persistence—if your venue's Wi-Fi drops, your screens keep running flawlessly!

### Does this prevent screen sleep during arcade hours?
Yes! Our native app includes active wake-lock management and burn-in micro-pixel drift (±2dp drift every 120s) to protect arcade OLEDs and CRT monitors.
