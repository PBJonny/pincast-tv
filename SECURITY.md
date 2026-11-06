# Security Policy

## Supported Versions

Only the latest release of **Pinball Buddies Pincast TV** (`pinball-buddies-pincast-tv.apk`, `com.pinballbuddies.venuedisplay`) published on the `main` branch and GitHub Releases receives security updates.

| Version | Supported |
| :--- | :--- |
| `1.0.x` (Latest) | :white_check_mark: |
| `< 1.0.0` | :x: |

---

## Verifying APK Authenticity & Integrity

Before sideloading `pinball-buddies-pincast-tv.apk` onto any venue hardware, always verify both the **SHA-256 file checksum** and the **APK signing certificate** (performed automatically by `scripts/setup-firestick.sh` and `scripts/setup-firestick.bat`).

### 1. SHA-256 Checksum
Compare the file hash against `apkSha256` in [`manifest.json`](./manifest.json):
```bash
# macOS / Linux
shasum -a 256 pinball-buddies-pincast-tv.apk

# Windows PowerShell
Get-FileHash -Algorithm SHA256 .\pinball-buddies-pincast-tv.apk
```

### 2. Official Signing Certificate Fingerprint
All official Pinball Buddies Pincast TV APKs are signed with APK Signature Scheme v2 using the Pinball Buddies release key:
- **Subject DN**: `CN=Pinball Buddies, OU=Mobile, O=Pinball Buddies, L=San Francisco, ST=California, C=US`
- **Certificate SHA-256 Digest**:
  ```text
  d7da0d5619c8969bc7ae92e9044e3b8a045fde44ac93e47cc81ce06d7515d79f
  ```
Verify manually using Android SDK `apksigner`:
```bash
apksigner verify --print-certs pinball-buddies-pincast-tv.apk
```

---

## Venue Hardware Hardening Best Practices

1. **Disable ADB After Installation**: Once `setup-firestick.sh` / `setup-firestick.bat` completes, turn **ADB Debugging OFF** on the Fire TV (`Settings > My Fire TV > Developer Options > ADB Debugging > OFF`). Leaving network ADB (`:5555`) enabled on shared arcade Wi-Fi allows anyone on the same LAN to connect to the TV.
2. **Use Isolated / IoT VLANs**: Connect arcade display hardware to an isolated LAN/VLAN rather than an open public guest network.

---

## Reporting a Vulnerability

Please **do not** open public GitHub issues for security vulnerabilities.

You can report a vulnerability privately using either of the following channels:
1. **GitHub Private Vulnerability Reporting**: [Submit a private security advisory](https://github.com/PBJonny/pincast-tv/security/advisories/new) directly on GitHub.
2. **Email**: Send reports directly to **[support@pinballbuddies.com](mailto:support@pinballbuddies.com)** with:
   - A description of the issue and affected component (installer scripts, APK, or pairing handshake).
   - Steps to reproduce or proof-of-concept details.

We acknowledge security reports within **48 hours** and aim to ship validated fixes within **7 days**.
