# FM-Go Project Structure

## Directory Layout

```
FM-Go/
├── backend/
│   └── fm_receiver.py      # Main Python service (FM demodulation + HTTP API)
├── frontend/
│   └── index.html          # Single-page web interface
├── install.sh              # One-command installer script
├── requirements.txt        # Python dependencies
├── README.md              # Project documentation
├── LICENSE                # MIT License
├── CONTRIBUTING.md        # Contribution guidelines
└── .gitignore            # Git ignore rules
```

## Installation Flow

1. **install.sh** runs on Raspberry Pi
   - Detects hardware
   - Installs system dependencies (rtl-sdr, sox, ffmpeg)
   - Creates service user
   - Sets up Python virtual environment
   - Copies files to `/opt/fm-go`
   - Creates systemd service
   - Enables auto-start

2. **Backend Service** (`fm_receiver.py`)
   - Detects RTL-SDR hardware
   - Manages FM demodulation pipeline (rtl_fm → sox → ffmpeg)
   - Provides REST API for web interface
   - Serves audio stream via HTTP
   - Manages configuration and presets

3. **Web Interface** (`index.html`)
   - Single-page application
   - Player controls
   - Preset management
   - Status display
   - Mobile-friendly design

## Key Components

### Backend (`backend/fm_receiver.py`)

- **Hardware Detection**: `detect_rtl_sdr()` - Checks for RTL-SDR availability
- **Streaming**: `start_streaming()` - Starts FM demodulation pipeline
- **API Endpoints**:
  - `/api/status` - System status
  - `/api/config` - Configuration management
  - `/api/presets` - Preset CRUD operations
  - `/api/tune` - Frequency tuning
  - `/api/play` / `/api/stop` - Playback control
  - `/api/stream` - Audio stream (MP3)

### Frontend (`frontend/index.html`)

- **Player Section**: Frequency display, play/pause, volume, tuning
- **Presets Section**: Add/edit/delete station presets
- **Status Section**: RTL-SDR detection, stream status, CPU temperature

### Installer (`install.sh`)

- System dependency installation
- Service user creation
- File deployment
- Systemd service setup
- Hardware detection check

## Configuration Files

- `/opt/fm-go/config/config.json` - Main configuration
- `/opt/fm-go/config/presets.json` - Station presets

## Service Management

- **Service Name**: `fm-go.service`
- **User**: `fmgo` (system user)
- **Installation**: `/opt/fm-go`
- **Port**: 8080 (configurable)

## Audio Pipeline

```
RTL-SDR → rtl_fm (FM demod) → sox (format conversion) → ffmpeg (MP3 encoding) → HTTP stream
```

## Technology Stack

- **Backend**: Python 3, Flask
- **FM Demodulation**: rtl_fm (from rtl-sdr package)
- **Audio Processing**: sox, ffmpeg
- **Frontend**: Vanilla HTML/CSS/JavaScript
- **Service Management**: systemd
