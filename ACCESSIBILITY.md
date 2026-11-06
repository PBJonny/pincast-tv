# Accessibility Statement

**Pinball Buddies Pincast TV** (`com.pinballbuddies.venuedisplay`) is committed to making live pinball leaderboards, high score chases, tournament brackets, and venue announcements accessible and legible for players, spectators, and venue operators in real-world arcade and bar environments.

---

## Accessibility Features & Design Standards

### 1. 10-Foot Arcade & Low-Light Readability
- **High-Contrast Palette**: Designed specifically for dimly lit arcades, neon environments, and bright bar televisions using high-contrast foreground typography (`#FFFFFF` and `#E2E8F0`) against deep slate backgrounds.
- **Distance-Calibrated Typography**: Machine titles, Grand Champion callouts, player rankings, and scores are sized and weighted to be read clearly from **10 to 15 feet (3–4.5 meters)** away without visual crowding.
- **Clear Rank Differentiation**: Podium positions (`1st`, `2nd`, `3rd`) pair color coding with distinct numeric badges and crown iconography so rankings never rely on color perception alone.

### 2. Full Fire TV 5-Way D-Pad Remote Navigation
- **Zero Pointer / Mouse Requirement**: Every interactive operator control in the Flutter/Dart Kiosk application is 100% operable using the standard 5-way directional Fire TV remote:
  - **Back or Menu Button**: Opens the **Kiosk Configuration** screen from the live display.
  - **D-Pad Left / Right / Up / Down**: Navigates deterministically between the **Display Server URL** field, **Save & Launch**, and **Reset Default** with high-contrast white focus borders (`2.5px` `#FFFFFF`) on the active button.
  - **Select / Center**: Activates the focused button (**Save & Launch** or **Reset Default** to clear the current pairing session and return to the QR pairing screen).
- **Pairing Flexibility**: Initial venue pairing supports both scanning the on-screen QR code with a smartphone camera and manually entering the **8-character alphanumeric Display ID** in the Pinball Buddies iOS app, Android app, or Web app.

### 3. Photosensitivity & Motion Safety
- **No Strobe or Rapid Flashing**: Transitions between machine leaderboard slides, recent score feeds, and tournament brackets use smooth, hardware-accelerated crossfades and carousels. The application strictly avoids rapid flashing or high-frequency strobing effects.

### 4. Connection Resilience & Watchdog Recovery
- **Automatic Reconnection**: Temporary venue Wi-Fi drops are handled by a built-in 30-second health watchdog and exponential-backoff reconnection daemon (`5s -> 60s`), automatically restoring the live leaderboard display as soon as connectivity returns.

---

## Known Limitations

- **Ambient Display Audio**: Pincast TV is designed as a visual ambient signage display for noisy arcade venues and does not provide continuous spoken audio narration of cycling leaderboard scores, as TV speakers in arcades are typically muted. Players seeking full screen-reader support (VoiceOver on iOS or TalkBack on Android) can browse live venue leaderboards directly in the Pinball Buddies mobile app or web app at [pinballbuddies.com](https://pinballbuddies.com).

---

## Reporting Accessibility Barriers

If you encounter an accessibility barrier on Pincast TV or have suggestions for improving readability, contrast, or remote navigation in your venue:

- **Email**: **[support@pinballbuddies.com](mailto:support@pinballbuddies.com)**
- **GitHub Issues**: [Open an issue on GitHub](https://github.com/PBJonny/pincast-tv/issues/new/choose)

We review all accessibility feedback promptly and prioritize improvements in upcoming releases.
