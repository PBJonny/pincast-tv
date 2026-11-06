# Pinball Buddies Pincast TV — Commercial Arcade Signage Kiosk

> Commercial Flutter & Dart Kiosk Application (`com.pinballbuddies.venuedisplay`) with hardware wake locks, native watchdog crash recovery, Fire OS power-on auto-boot, and Android Keystore secure storage.
> Turn any Amazon Fire TV Stick, Google TV, or Android TV device into a 24/7 unattended arcade leaderboard display.

![Pincast Ambient Arcade Display Banner](./tv_banner.png)

---

## Why the Dedicated Flutter/Dart Kiosk App?

Consumer TV web browsers (like Silk or Smart TV browsers) suffer from intrusive address bars, sleep timeouts, no power-on auto-launch, and unrecovered connection drops.

**Pinball Buddies Pincast TV** (`com.pinballbuddies.venuedisplay`) is built with **Flutter & Dart** as a commercial unattended signage kiosk that renders the full Pinball Buddies web display experience (`https://pinballbuddies.com/display`):
- ⚡ **Full Web Display Parity**: Renders multi-machine leaderboards, single-machine spotlights, multi-zone screen layouts, active score chases, tournament brackets, and live high-score alert celebrations.
- 🔄 **Native Watchdog & Auto-Recovery Daemon**: Built-in 30-second health watchdog and exponential-backoff reconnect daemon (`5s -> 60s`) automatically recover the screen after venue Wi-Fi blips.
- 🚀 **Fire OS Power-On Auto-Boot**: Native `BootReceiver` + `SYSTEM_ALERT_WINDOW` overlay permission automatically launches the display when the arcade master power strip is switched on.
- 🛡️ **24/7 Sleep Prevention**: Enforces hardware `WakelockPlus`, Android `FLAG_KEEP_SCREEN_ON`, Doze battery exemption, and permanent display timeout.
- 📱 **Instant QR Code Handshake**: Launches directly into the **Connect Display** QR code screen—scan with your phone to link to any public venue or private arcade!

---

## Hardware Compatibility

| Platform | Support Level | Implementation |
|---|---|---|
| **Amazon Fire TV Stick** | **Tier 1 (Native App)** | Sideload `pinball-buddies-pincast-tv.apk` (Fire OS 7/8) |
| **Google TV & Android TV** | **Tier 1 (Native App)** | Sideload `pinball-buddies-pincast-tv.apk` (Chromecast, Sony, Shield) |
| **Apple TV (tvOS)** | **Tier 1 (Native App)** | Native SwiftUI tvOS app (`PinballBuddiesTV`) on TestFlight & App Store |
| **Raspberry Pi 4 / 5** | **Tier 1 (Native TV)** | Android TV / LineageOS 21 (KonstaKANG) with native APK |
| **Windows / Linux Mini-PCs** | **Tier 1 (Native)** | Android Subsystem (WSA / Waydroid) or Compose Desktop |

---

## Quick Start for Humans (1-Click Automated Wi-Fi Installer)

*Installs the APK over your local Wi-Fi, configures 24/7 arcade kiosk sleep prevention, and auto-launches the display:*

1. On your Fire TV, enable ADB: **Settings > My Fire TV > Developer Options > ADB Debugging > ON**.
2. Note your Fire TV's IP address: **Settings > My Fire TV > About > Network** (e.g. `192.168.1.150`).
3. Run the installer from your computer:
   ```bash
   # macOS / Linux
   ./scripts/setup-firestick.sh 192.168.1.150

   # Windows
   .\scripts\setup-firestick.bat 192.168.1.150
   ```
4. Look at your TV, select **"Always allow from this computer" > OK**, and scan the on-screen QR code from your phone to link your venue!
👉 *Read the full step-by-step walkthrough in **[`HUMAN_INSTALL_GUIDE.md`](./HUMAN_INSTALL_GUIDE.md)**.*

---

## ⚡ Power-On & Boot Behavior (Startup Delay Explained)

> **Important Note for Staff & Operators**:
> When you power on your TV or turn on your arcade master power strip in the morning, Fire OS performs a cold boot and connects to the venue Wi-Fi network.
>
> ⏳ **There is an intentional 30–60 second startup delay timer** before the app launches.
> **The display is not frozen or broken!** 
> This delay guarantees that the Wi-Fi connection and HDMI display handshake are fully established before the app begins streaming live leaderboard scores.
> 
> 👉 **Do not press buttons on the remote.** Pinball Buddies Pincast will take over the display automatically!

---

## Expanding Past Fire Stick: Other Platforms

Wondering how our native code runs on Google TV, Apple TV, Raspberry Pi, or mini-PCs?
👉 Read our comprehensive architectural guide: **[`MULTI_PLATFORM_GUIDE.md`](./MULTI_PLATFORM_GUIDE.md)**.

- **Google TV & Android TV**: Uses the exact same `pinball-buddies-pincast-tv.apk`!
- **Apple TV (tvOS)**: Native SwiftUI tvOS app (`PinballBuddiesTV`) available via TestFlight & the App Store.
- **Raspberry Pi 4 / 5**: Run LineageOS Android TV to run our native APK with full GPU acceleration.
- **Smart TVs (Samsung / LG)**: Plug a \$25 Fire Stick or Onn. Google TV into HDMI to bypass slow TV OS software.

---

## For AI Agents

Are you having an autonomous AI agent (Claude, Antigravity, OpenDevin, Cursor, or local LLMs) set up your display?
👉 Refer to **[`AI_AGENT_INSTALL_GUIDE.md`](./AI_AGENT_INSTALL_GUIDE.md)** for deterministic ADB commands, process validation, and error-handling matrices.

---

## Included Files in this Package

```
pincast/
├── pinball-buddies-pincast-tv.apk  # Signed production release APK (Fire OS & Android TV)
├── tv_banner.png                  # 1080p display banner artwork
├── README.md                      # Overview and quick-start guide
├── HUMAN_INSTALL_GUIDE.md         # Step-by-step human guide (1-Click Wi-Fi setup)
├── AI_AGENT_INSTALL_GUIDE.md      # Deterministic playbook for AI agents
├── MULTI_PLATFORM_GUIDE.md        # Native multi-platform adaptation playbook
├── SECURITY.md                    # APK signature verification & security disclosure policy
├── CONTRIBUTING.md                # Guidelines for reporting issues, hardware tests & PRs
├── CODE_OF_CONDUCT.md             # Contributor Covenant community standards
├── ACCESSIBILITY.md               # 10-foot arcade readability, D-Pad & motion safety statement
├── manifest.json                  # Release metadata & SHA-256 integrity hash
└── scripts/
    ├── setup-firestick.sh         # macOS/Linux automated native APK installer (with SHA-256 check)
    ├── setup-firestick.bat        # Windows automated native APK installer (with SHA-256 check)
    └── kiosk-power-settings.sh    # 24/7 ADB display sleep and power tuner
```

---

## Community, Standards & Support

- **Website**: [https://pinballbuddies.com](https://pinballbuddies.com)
- **Support**: [support@pinballbuddies.com](mailto:support@pinballbuddies.com)
- **Contributing**: [`CONTRIBUTING.md`](./CONTRIBUTING.md)
- **Code of Conduct**: [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md)
- **Security Policy**: [`SECURITY.md`](./SECURITY.md)
- **Accessibility Statement**: [`ACCESSIBILITY.md`](./ACCESSIBILITY.md)
- **License**: [`MIT License`](./LICENSE)
