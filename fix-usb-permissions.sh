#!/bin/bash
# Fix USB permissions for RTL-SDR

set -e

if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

SERVICE_USER="fmgo"

echo "🔧 Fixing USB Permissions for RTL-SDR"
echo "======================================="
echo ""

echo "1️⃣  Adding $SERVICE_USER to plugdev group..."
usermod -a -G plugdev "$SERVICE_USER" 2>/dev/null || echo "plugdev group may not exist"
echo "✅ Added to plugdev"

echo "2️⃣  Adding $SERVICE_USER to dialout group..."
usermod -a -G dialout "$SERVICE_USER" 2>/dev/null || echo "dialout group may not exist"
echo "✅ Added to dialout"

echo "3️⃣  Creating udev rules for RTL-SDR..."
cat > /etc/udev/rules.d/20-rtl-sdr.rules <<'EOF'
# RTL-SDR dongles
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", GROUP="plugdev", MODE="0666", SYMLINK+="rtl_sdr"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", GROUP="plugdev", MODE="0666", SYMLINK+="rtl_sdr"
EOF

echo "✅ Created udev rules"

echo "4️⃣  Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

echo "✅ Udev rules reloaded"

echo ""
echo "5️⃣  Testing detection as service user..."
if sudo -u "$SERVICE_USER" rtl_test -t 2>&1 | head -3 | grep -q "Found"; then
    echo "✅ Detection works as service user!"
else
    echo "⚠️  Detection still failing - may need to unplug/replug device or reboot"
fi

echo ""
echo "✅ Permission fix complete!"
echo ""
echo "Next steps:"
echo "1. Unplug and replug the RTL-SDR dongle"
echo "2. Restart the service: sudo systemctl restart fm-go.service"
echo "3. Or reboot: sudo reboot"
echo ""
echo "After restarting, check the web interface - RTL-SDR should be detected."
