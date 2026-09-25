# Pinball Buddies Pincast TV: Multi-Platform Architecture & Native Adaptation Playbook

> **Core Philosophy**: Zero web browsers. The web browser is fragile on TV hardware—it suffers from memory leaks, address bar intrusions, cursor emulation quirks, and lacks offline SQLite persistence.
> This guide outlines how **the native application code we made for Firestick** runs across TV hardware, and how we adapt native code for all platforms.

---

## Platform Matrix & Native Capabilities

| Platform | Native Runtime | Distribution Binary | Offline Cache | Remote Navigation |
|---|---|---|---|---|
| **Amazon Fire TV Stick** | Android (Fire OS 7/8) | `pinball-buddies-pincast-tv.apk` | ✅ Room SQLite | ✅ Native D-Pad Focus |
| **Google TV / Android TV** | Android TV (API 26+) | `pinball-buddies-pincast-tv.apk` | ✅ Room SQLite | ✅ Native D-Pad Focus |
| **Apple TV 4K / HD** | tvOS 17+ (SwiftUI) | `PinballBuddiesTV.ipa` / TestFlight | ✅ Swift Cache | ✅ Siri Remote Focus Engine |
| **Raspberry Pi 4 / 5** | Android TV / Compose Linux | `pinball-buddies-pincast-tv.apk` | ✅ Room SQLite | ✅ USB / Bluetooth Remote |
| **Windows Mini-PC / NUC** | WSA / Compose Desktop | Native APK / `.exe` | ✅ SQLite DB | ✅ Keyboard / Remote |
| **Linux Mini-PC** | Waydroid / Compose Desktop | Native APK / `.AppImage` | ✅ SQLite DB | ✅ Keyboard / Remote |

---

## 1. Amazon Fire TV Stick (Fire OS 7 & 8)

The native app in this package (`pinball-buddies-pincast-tv.apk`) is built with Kotlin and Jetpack Compose for TV.

### Key Capabilities on Fire TV:
- **Direct Sideload via Downloader App**: Takes 60 seconds with no computer required.
- **Automated ADB Sideload**: `./scripts/setup-firestick.sh <FIRE_TV_IP>`.
- **Offline Room Database**: Stores display snapshots locally in SQLite so screens keep running even if the venue's internet drops.
- **Arcade Burn-In Protection**: Subtle micro-pixel drift (±2dp drift every 120s) prevents image retention on arcade OLEDs and CRT monitors.
- **Physical Remote Integration**: D-Pad Left/Right cycles machines; Back button opens Operator PIN pad.

---

## 2. Google TV & Android TV Devices

Because Fire OS is an Android fork, **the exact same native APK (`pinball-buddies-pincast-tv.apk`) runs natively on all Google TV and Android TV devices without changing a single line of code!**

### Supported Hardware:
- **Chromecast with Google TV** (HD and 4K)
- **Sony Bravia TVs** (Google TV / Android TV)
- **Nvidia Shield TV & Shield TV Pro**
- **TCL, Hisense, Philips, Sharp, and Xiaomi Android TVs**
- **Walmart Onn. 4K Google TV Streaming Box** ($20)

### Installation:
Install via ADB or using the **Downloader** app from the Google Play Store on the TV.

---

## 3. Apple TV (tvOS)

For venues using Apple TV 4K or Apple TV HD hardware, we created a **100% native SwiftUI tvOS application** located in the repository at `ios/App/AppTV/` (`PinballBuddiesTV`).

### Architecture Parity with Fire TV:
- Real-time Firestore snapshot listeners.
- Local snapshot caching with automatic offline recovery.
- Native Apple TV Siri Remote focus engine.
- Shared 6-digit pairing handshake and QR code scanner.

### Deployment:
- **Public Beta (TestFlight)**: [https://testflight.apple.com/join/Z2tSzfsx](https://testflight.apple.com/join/Z2tSzfsx)
- **tvOS App Store**: "Pinball Buddies TV" (Standalone commercial app).

---

## 4. Raspberry Pi 4 & 5 (Dedicated Arcade Kiosk Hardware)

Many operators mount a Raspberry Pi inside the backbox or behind an arcade monitor. There are two primary native paths:

### Method A: LineageOS Android TV for Raspberry Pi (Turnkey)
1. Flash **LineageOS 21 (Android TV 14)** for Raspberry Pi 4 / 5 (maintained by KonstaKANG).
2. Boot the Pi into Android TV with full HDMI GPU hardware acceleration.
3. Install our native `pinball-buddies-pincast-tv.apk` via USB drive or ADB.
4. The app runs with full native Room SQLite caching, remote control support, and 60fps animations.

### Method B: Compose Multiplatform (Desktop Linux ARM64)
Because our Fire TV app is written in **Jetpack Compose**, the UI views (`TVCarouselScreen`, `TVPairingScreen`, `TVBrandMark`) can be compiled directly for Desktop Linux using JetBrains Compose Multiplatform!
- Compiles into a standalone Linux binary (`.AppImage` / `.deb`).
- Uses native embedded SQLite.
- Eliminates any Android runtime overhead.

---

## 5. Windows & Linux Mini-PCs (Intel NUC, PC Sticks)

For venues using small media PCs:

### Method A: Native Android Subsystem (WSA / Waydroid)
- **Windows 11**: Using Windows Subsystem for Android (WSA), simply double-click `pinball-buddies-pincast-tv.apk` to install and run in fullscreen landscape.
- **Linux (Ubuntu/Debian)**: Run `waydroid app install pinball-buddies-pincast-tv.apk` and launch `waydroid app launch com.pinballbuddies.app.tv`.

### Method B: Compose Multiplatform Desktop Executable
- Compiles the Compose TV UI into a native Windows `.exe` / `.msi` using Kotlin JVM.
- Runs without any emulator or subsystem.

---

## 6. What About Smart TVs (Samsung Tizen & LG webOS)?

Samsung (Tizen) and LG (webOS) use proprietary operating systems that do not run native Android APKs.

### Why Digital Signage Operators Do NOT Use Smart TV Browsers:
Smart TV built-in web browsers have strict RAM limits (often crashing after 20–30 minutes), lack D-pad remote control focus, display intrusive address bars, and cannot store persistent local SQLite databases.

### The Professional Signage Standard:
Instead of dealing with buggy Smart TV browsers, commercial arcade operators plug a **$25 Amazon Fire TV Stick or Onn. Google TV box** into the HDMI port of the Samsung or LG TV.
- Bypasses the slow TV operating system completely.
- Runs our 60fps native application with Room SQLite caching.
- Gives you a responsive physical remote control.
- Keeps screens alive 24/7 without sleep.
