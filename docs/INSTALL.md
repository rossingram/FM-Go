# FM-Go Installation

## One-command install

```bash
curl -sSL https://raw.githubusercontent.com/rossingram/FM-Go/main/install.sh | sudo bash
```

## Manual install (from repo)

```bash
git clone https://github.com/rossingram/FM-Go.git
cd FM-Go
sudo ./install.sh
```

## What the installer does

- Installs system packages: `rtl-sdr`, `sox`, `ffmpeg`, `python3`, etc.
- Blacklists DVB-T drivers that conflict with RTL-SDR
- Creates user `fmgo` and adds it to `plugdev` / `dialout`
- Adds udev rules for RTL-SDR
- Installs Python deps (Flask, flask-cors) in a venv under `/opt/fm-go`
- Copies backend and frontend to `/opt/fm-go`
- Creates and enables `fm-go.service` (systemd)

## After install

1. Plug in the RTL-SDR (after the service is running if you prefer).
2. Open the web UI: `http://<pi-ip>:8080`
3. Tap **Play** to start streaming.

## Updating

```bash
cd ~/FM-Go
git pull
sudo ./install.sh
```

The installer is idempotent; safe to run again.
