# windows-setup

Idempotent setup script for a centered, transparent taskbar on Windows 10.

It installs and configures:

- [ExplorerPatcher](https://github.com/valinet/ExplorerPatcher), with the
  taskbar alignment set to **Centered**.
- [TranslucentTB](https://github.com/TranslucentTB/TranslucentTB), using
  the config in [`config/TranslucentTB.cfg`](config/TranslucentTB.cfg)
  (fluent accent, clear look).

## Requirements

- Windows 10 (the `OldTaskbarAl` setting targets the Windows 10-style taskbar)
- [winget](https://learn.microsoft.com/windows/package-manager/winget/)
  (install "App Installer" from the Microsoft Store if `winget --version` fails)
- An elevated PowerShell prompt

## Usage

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\setup.ps1
```

Safe to re-run: each step checks the current state first. Explorer is
restarted at the end, so the taskbar will flash once.

## Customizing

Edit `config/TranslucentTB.cfg` to change the look (accent, color, opacity,
dynamic modes). Re-run the script to apply it.

## License

MIT
