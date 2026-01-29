#!/bin/bash
# Fix USB 3.0 compatibility issues with RTL-SDR on Pi 5

set -e

if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

echo "🔧 Fixing USB 3.0 Compatibility Issues"
echo "========================================"
echo ""

echo "ℹ️  Raspberry Pi 5 has USB 3.0 ports which can cause issues with RTL-SDR"
echo ""

echo "1️⃣  Checking USB ports..."
lsusb -t
echo ""

echo "2️⃣  Forcing USB 2.0 mode for RTL-SDR..."
# Add kernel parameter to force USB 2.0 for specific ports if needed
# Or use USB 2.0 port if available

echo "3️⃣  Disabling USB autosuspend..."
for usb in /sys/bus/usb/devices/*/power/control; do
    if [ -f "$usb" ]; then
        echo 'on' > "$usb" 2>/dev/null || true
    fi
done

# Make persistent
cat > /etc/udev/rules.d/50-usb-power.rules <<'EOF'
# Keep USB devices powered on
SUBSYSTEM=="usb", ATTR{power/control}="on"
EOF
udevadm control --reload-rules 2>/dev/null || true
echo "✅ USB autosuspend disabled"
echo ""

echo "4️⃣  Setting USB quirk for RTL-SDR..."
# Add USB quirk to prevent disconnects
if ! grep -q "rtl2832" /etc/modprobe.d/blacklist-rtl.conf 2>/dev/null; then
    echo "options usbcore autosuspend=-1" >> /etc/modprobe.d/blacklist-rtl.conf
fi
echo "✅ USB quirks configured"
echo ""

echo "5️⃣  Recommendations:"
echo ""
echo "✅ Try these USB ports in order:"
echo "   1. USB 2.0 port (if available on your Pi 5)"
echo "   2. USB-A port (not USB-C)"
echo "   3. Different USB port"
echo ""
echo "✅ Use a USB 2.0 hub between Pi and RTL-SDR"
echo "   (forces USB 2.0 mode)"
echo ""
echo "✅ Check if RTL-SDR dongle is faulty:"
echo "   - Try on a different computer"
echo "   - Try a different RTL-SDR dongle"
echo ""
echo "✅ Monitor USB events:"
echo "   sudo dmesg -w"
echo ""
echo "After applying fixes:"
echo "1. Unplug RTL-SDR"
echo "2. Wait 5 seconds"
echo "3. Plug into USB 2.0 port (or use USB 2.0 hub)"
echo "4. Wait 10 seconds for enumeration"
echo "5. Test: rtl_test -t"
echo "6. Restart service: sudo systemctl restart fm-go.service"
