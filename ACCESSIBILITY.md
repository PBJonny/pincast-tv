# Accessibility Statement

**Pinball Buddies Pincast TV** is committed to making live pinball leaderboards, high score chases, and venue announcements accessible and legible for players, spectators, and venue operators in real-world arcade and bar environments.

---

## Accessibility Features & Design Standards

### 1. 10-Foot Arcade & Low-Light Readability
- **High-Contrast Palette**: Designed specifically for dimly lit arcades, neon environments, and bright bar televisions using high-contrast foreground typography (`#FFFFFF` and `#E2E8F0`) against deep slate backgrounds.
- **Distance-Calibrated Typography**: Machine titles, Grand Champion callouts, player rankings, and scores are sized and weighted to be read clearly from **10 to 15 feet (3–4.5 meters)** away without visual crowding.
- **Clear Rank Differentiation**: Podium positions (`1st`, `2nd`, `3rd`) pair color coding with distinct numeric badges and iconography so rankings never rely on color perception alone.

### 2. Full 5-Way D-Pad Remote Control Navigation
- **Zero Pointer / Mouse Requirement**: Every interactive screen in the native TV app is 100% operable using a standard 5-way directional TV remote (Amazon Fire TV Remote, Google TV Remote, Android TV D-Pad, or Apple TV Siri Remote):
  - **D-Pad Left / Right**: Manually cycle backward or forward through machine leaderboard slides.
  - **D-Pad Center / Select**: Pause or resume automatic slide rotation so players can inspect scores at their own pace.
  - **Back / Return**: Open the 6-digit Operator PIN management modal with clear high-visibility focus rings on every keypad button.
- **Pairing Flexibility**: Initial venue pairing supports both scanning an on-screen QR code with a phone camera and manually entering an **8-character alphanumeric pairing code** at `pinballbuddies.com/venues` or in the mobile app.

### 3. Photosensitivity & Motion Safety
- **No Strobe or Rapid Flashing**: Transitions between machine slides use smooth, hardware-accelerated 60fps crossfades and horizontal carousels. The application strictly avoids rapid flashing or high-frequency strobing effects.
- **Non-Disorienting Burn-In Protection**: Arcade CRT, OLED, and commercial LCD protection uses an imperceptible micro-pixel drift (`±2dp` every 120 seconds) that prevents static image retention without causing motion sickness or visual distraction.

### 4. Offline Continuity
- **Room SQLite Local Persistence**: Temporary venue Wi-Fi drops do not trigger jarring flashing error banners or blank screens; the display continues cycling cached leaderboards seamlessly until connectivity is restored.

---

## Supported Environments

- **Amazon Fire OS 7 & 8** (Fire TV Stick Lite, HD, 4K, 4K Max, Fire TV Cube, and Fire TV Edition Smart TVs)
- **Google TV & Android TV 8.0+** (Chromecast with Google TV, Walmart Onn., Sony Bravia, TCL, Hisense, Nvidia Shield)
- **Apple tvOS** (`PinballBuddiesTV` native SwiftUI application)

---

## Known Limitations

- **Ambient Display Audio**: Pincast TV is designed primarily as a visual ambient signage display for noisy arcade venues and does not currently provide continuous spoken audio narration of cycling leaderboard scores, as TV speakers in arcades are typically muted. Players seeking full screen-reader support (VoiceOver on iOS or TalkBack on Android) can browse live venue leaderboards directly in the Pinball Buddies mobile app or web app at [pinballbuddies.com](https://pinballbuddies.com).

---

## Reporting Accessibility Barriers

If you encounter an accessibility barrier on Pincast TV or have suggestions for improving readability, contrast, or remote navigation in your venue:

- **Email**: **[support@pinballbuddies.com](mailto:support@pinballbuddies.com)**
- **GitHub Issues**: [Open an issue on GitHub](https://github.com/PBJonny/pincast-tv/issues/new/choose)

We review all accessibility feedback promptly and prioritize improvements in upcoming releases.
