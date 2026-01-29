#!/bin/bash
# Troubleshoot RTL-SDR detection issues

set -e

echo "🔍 RTL-SDR Troubleshooting"
echo "=========================="
echo ""

echo "1️⃣  Checking USB devices..."
lsusb | grep -i "rtl\|dvb\|2832\|2830" || echo "No RTL-SDR devices found in lsusb"
echo ""

echo "2️⃣  Testing rtl_test command..."
if command -v rtl_test >/dev/null 2>&1; then
    echo "Running rtl_test (this may take a few seconds)..."
    timeout 3 rtl_test -t 2>&1 || timeout 3 sudo rtl_test -t 2>&1 || echo "rtl_test failed"
else
    echo "❌ rtl_test command not found"
fi
echo ""

echo "3️⃣  Checking for DVB-T driver conflicts..."
if lsmod | grep -q "dvb_usb_rtl28xxu\|rtl2832\|rtl2830"; then
    echo "⚠️  DVB-T drivers are loaded! These need to be blacklisted."
    lsmod | grep -E "dvb_usb_rtl28xxu|rtl2832|rtl2830"
else
    echo "✅ No conflicting DVB-T drivers loaded"
fi
echo ""

echo "4️⃣  Checking blacklist configuration..."
if [ -f /etc/modprobe.d/blacklist-rtl.conf ]; then
    echo "✅ Blacklist file exists:"
    cat /etc/modprobe.d/blacklist-rtl.conf
else
    echo "⚠️  Blacklist file not found"
fi
echo ""

echo "5️⃣  Checking udev rules..."
if [ -d /etc/udev/rules.d ]; then
    echo "Looking for RTL-SDR udev rules..."
    grep -r "rtl" /etc/udev/rules.d/ 2>/dev/null || echo "No RTL-SDR udev rules found"
else
    echo "udev rules directory not found"
fi
echo ""

echo "6️⃣  Checking USB permissions..."
echo "Current user: $(whoami)"
echo "Groups: $(groups)"
if groups | grep -q "plugdev\|dialout"; then
    echo "✅ User is in plugdev or dialout group"
else
    echo "⚠️  User may need to be added to plugdev group"
fi
echo ""

echo "7️⃣  Testing with sudo..."
echo "Running sudo rtl_test -t..."
sudo timeout 3 rtl_test -t 2>&1 | head -10 || echo "sudo rtl_test also failed"
echo ""

echo "8️⃣  Checking dmesg for USB errors..."
dmesg | tail -20 | grep -i "usb\|rtl\|dvb" || echo "No recent USB/RTL messages in dmesg"
echo ""

echo "✅ Troubleshooting complete!"
echo ""
echo "Common fixes:"
echo "1. If DVB-T drivers are loaded: sudo modprobe -r dvb_usb_rtl28xxu rtl2832 rtl2830"
echo "2. If rtl_test works with sudo: Check permissions or run service as root"
echo "3. If device not in lsusb: Check USB cable/port, try different port"
echo "4. Reboot after blacklisting drivers: sudo reboot"
