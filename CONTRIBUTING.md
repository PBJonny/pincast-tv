# Contributing to Pinball Buddies Pincast TV

Thank you for helping improve **Pinball Buddies Pincast TV** (`com.pinballbuddies.venuedisplay`)! Whether you are an arcade venue operator setting up a display, a tournament director reporting a display quirk, or a developer improving our automated ADB setup scripts, your contributions are welcome.

By participating in this project, you agree to abide by our [Code of Conduct](./CODE_OF_CONDUCT.md).

---

## Ways to Contribute

### 1. Reporting Bugs & Installation Issues
If you encounter an issue installing or running `pinball-buddies-pincast-tv.apk`, please [open a Bug Report](https://github.com/PBJonny/pincast-tv/issues/new?template=bug_report.yml) and include:
- **Fire TV Model**: (e.g., Amazon Fire TV Stick 4K Max, Fire TV Stick 4K, Fire TV Stick HD).
- **Host Computer OS**: (e.g., macOS 15, Windows 11, Ubuntu 24.04) if using the 1-Click Wi-Fi installer.
- **Terminal / ADB Output**: Any output from `./scripts/setup-firestick.sh` or `.\scripts\setup-firestick.bat`.

### 2. Suggesting Features
Have an idea for a new arcade display slide, kiosk power setting, or tournament view? Open a [Feature Request](https://github.com/PBJonny/pincast-tv/issues/new?template=feature_request.yml).

### 3. Security Vulnerabilities
Please **do not** report security vulnerabilities in public GitHub issues. Follow our [Security Policy](./SECURITY.md) to report issues privately via [GitHub Private Vulnerability Reporting](https://github.com/PBJonny/pincast-tv/security/advisories/new) or by emailing [support@pinballbuddies.com](mailto:support@pinballbuddies.com).

---

## Submitting Pull Requests

We welcome pull requests that improve our installer scripts (`scripts/`) and setup guides.

### Technical & Security Requirements

1. **Line Endings (`.gitattributes`)**:
   - Shell scripts (`*.sh`), Markdown (`*.md`), JSON (`*.json`), and YAML (`*.yml`) **must** use Unix `LF` line endings.
   - Windows Batch scripts (`*.bat`) **must** use `CRLF` line endings.
2. **Shell Script Quality**:
   - All bash scripts in `scripts/` must pass `shellcheck` with zero warnings:
     ```bash
     shellcheck scripts/*.sh
     ```
   - Never hardcode venue IPs, Wi-Fi credentials, or tokens. Validate all user-supplied arguments (such as `<FIRE_TV_IP>`) before invoking `adb`.
3. **APK Integrity & Signature Verification**:
   - Installer scripts must preserve the SHA-256 checksum check against `manifest.json` (`apkSha256`) and the official APK signing certificate verification (`d7da0d5619c8969bc7ae92e9044e3b8a045fde44ac93e47cc81ce06d7515d79f`).
   - Do not modify or replace `pinball-buddies-pincast-tv.apk` in pull requests; official APK builds are signed and published exclusively by the Pinball Buddies release pipeline.
4. **Manifest Validation**:
   - Ensure `manifest.json` remains valid JSON:
     ```bash
     jq empty manifest.json
     ```

### Pull Request Workflow
1. Fork the repository and create a descriptive branch from `main` (e.g., `fix/adb-port-validation` or `docs/firestick-setup`).
2. Run local verification (`shellcheck scripts/*.sh` and `jq empty manifest.json`).
3. Open a Pull Request and complete all sections of the [Pull Request Template](./.github/pull_request_template.md).

---

## Questions or Support?

Reach out anytime at **[support@pinballbuddies.com](mailto:support@pinballbuddies.com)** or visit **[pinballbuddies.com](https://pinballbuddies.com)**.
