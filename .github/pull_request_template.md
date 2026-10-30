## Summary

<!-- Briefly describe what this pull request changes and why. -->

## Type of Change

- [ ] **Installer / Kiosk Script Improvement** (`scripts/*.sh` or `scripts/*.bat`)
- [ ] **Hardware / Multi-Platform Documentation** (`HUMAN_INSTALL_GUIDE.md`, `MULTI_PLATFORM_GUIDE.md`, `README.md`)
- [ ] **Automation Playbook Update** (`AI_AGENT_INSTALL_GUIDE.md`)
- [ ] **Security / Community Standard Update** (`SECURITY.md`, `CONTRIBUTING.md`, `.github/`)

## Hardware & Environment Tested On

<!-- List any TV devices or host OS environments you verified this change on. -->
- **Host OS**: (e.g., macOS 15, Windows 11, Ubuntu 24.04, N/A for docs)
- **Target TV / Device**: (e.g., Fire TV Stick 4K Max, Chromecast with Google TV, Onn. 4K, N/A)

## Verification Checklist

- [ ] `shellcheck scripts/*.sh` passes with zero warnings
- [ ] `jq empty manifest.json` passes
- [ ] Line endings match `.gitattributes` (`LF` for `.sh`/`.md`/`.json`/`.yml`, `CRLF` for `.bat`)
- [ ] APK SHA-256 checksum & signing certificate verification (`d7da0d56...`) remain intact
- [ ] No hardcoded IP addresses, credentials, or tokens introduced
