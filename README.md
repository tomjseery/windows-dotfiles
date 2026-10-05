# windows-dotfiles

Idempotent setup script for customizing a Windows 10 desktop.

Run `setup.ps1` and it applies each module below. Every step checks the
current state first, so it is safe to re-run.

## Modules

| Module | What it does |
| --- | --- |
| Taskbar | Installs [ExplorerPatcher](https://github.com/valinet/ExplorerPatcher) and centers the taskbar. |
| Transparency | Installs [TranslucentTB](https://github.com/TranslucentTB/TranslucentTB) and applies [`config/TranslucentTB.cfg`](config/TranslucentTB.cfg) (fluent accent, clear look). |

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

Explorer is restarted at the end, so the taskbar will flash once.

## Customizing

Edit `config/TranslucentTB.cfg` to change the look (accent, color, opacity,
dynamic modes), then re-run the script.

## License

MIT
