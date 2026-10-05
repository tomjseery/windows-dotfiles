#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Idempotent Windows 10 desktop customization: centered, transparent taskbar via
    ExplorerPatcher + TranslucentTB.

.DESCRIPTION
    Safe to re-run. Each step checks current state before changing anything.

.NOTES
    Run from an elevated PowerShell prompt:
        Set-ExecutionPolicy -Scope Process Bypass -Force
        .\setup.ps1
#>

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Install-WingetApp {
    param([string]$Id)
    $installed = winget list --id $Id -e --accept-source-agreements 2>$null | Select-String ([regex]::Escape($Id))
    if (-not $installed) {
        Write-Host "Installing $Id..." -ForegroundColor Cyan
        winget install --id $Id -e --silent --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "$Id already installed, skipping." -ForegroundColor DarkGray
    }
}

# --- 1. ExplorerPatcher: taskbar centering ---------------------------------
Install-WingetApp -Id "valinet.ExplorerPatcher"

New-Item -Path "HKCU:\Software\ExplorerPatcher" -Force | Out-Null
# OldTaskbarAl: 0 = at screen edge (Windows default), 1 = centered
Set-ItemProperty -Path "HKCU:\Software\ExplorerPatcher" -Name "OldTaskbarAl" -Value 1 -Type DWord
Write-Host "ExplorerPatcher: taskbar alignment set to Centered." -ForegroundColor Green

# --- 2. TranslucentTB: taskbar transparency ---------------------------------
$ttbPaths = @(
    "${env:ProgramFiles(x86)}\TranslucentTB\TranslucentTB.exe",
    "$env:LOCALAPPDATA\Programs\TranslucentTB\TranslucentTB.exe"
)
$ttbExisting = $ttbPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $ttbExisting) {
    Install-WingetApp -Id "CharlesMilette.TranslucentTB"
    $ttbExisting = $ttbPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
} else {
    Write-Host "TranslucentTB already installed, skipping." -ForegroundColor DarkGray
}

$ttbConfigDir = "$env:APPDATA\TranslucentTB"
New-Item -Path $ttbConfigDir -ItemType Directory -Force | Out-Null
Copy-Item -Path (Join-Path $scriptRoot "config\TranslucentTB.cfg") -Destination "$ttbConfigDir\config.cfg" -Force
Write-Host "TranslucentTB: config applied (accent=fluent, clear look)." -ForegroundColor Green

Get-Process TranslucentTB -ErrorAction SilentlyContinue | Stop-Process -Force
if ($ttbExisting) {
    Start-Process $ttbExisting
    Write-Host "TranslucentTB restarted to apply config." -ForegroundColor Green
}

# --- 3. Apply ---------------------------------------------------------------
Write-Host "Restarting Explorer to apply changes..." -ForegroundColor Cyan
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2

Write-Host "`nDone. Taskbar should be centered and transparent." -ForegroundColor Green
