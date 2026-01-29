# FM-Go 🎧

A plug-and-play Raspberry Pi FM radio receiver that turns a Pi into a headless, always-on network radio, accessible through a simple web interface.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Quick Start

### One-Command Installation

```bash
curl -sSL https://raw.githubusercontent.com/rossingram/FM-Go/main/install.sh | sudo bash
```

### Manual Installation

```bash
git clone https://github.com/rossingram/FM-Go.git
cd FM-Go
sudo ./install.sh
```

## Features

- 🎧 One-command installation
- 📻 Automatic RTL-SDR hardware detection
- 🌐 Simple web interface accessible from any device on your LAN
- 🔄 Always-on operation with systemd
- 📡 FM broadcast radio reception
- 💾 Station presets management

## Requirements

- Raspberry Pi (3B+, 4, or 5)
- RTL-SDR dongle
- Network connection (Ethernet or Wi-Fi)
- microSD card

## Architecture

- **Backend**: Python service using RTL-SDR for FM demodulation
- **Streaming**: HTTP audio stream (MP3)
- **Frontend**: Lightweight HTML/CSS/JS web interface
- **Service**: systemd-managed for auto-start on boot

## Web Interface

Access the web interface at `http://<pi-ip>:8080` after installation.

Features:
- Play/Pause controls
- Volume control
- Station frequency tuning
- Preset management
- System status display

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup and contribution guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.
