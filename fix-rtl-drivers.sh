#!/bin/bash
# Fix RTL-SDR driver conflicts

set -e

if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

echo "🔧 Fixing RTL-SDR Driver Conflicts"
echo "===================================="
echo ""

echo "1️⃣  Checking for loaded DVB-T drivers..."
if lsmod | grep -qE "dvb_usb_rtl28xxu|rtl2832|rtl2830"; then
    echo "⚠️  Found conflicting drivers. Unloading..."
    modprobe -r dvb_usb_rtl28xxu 2>/dev/null || true
    modprobe -r rtl2832 2>/dev/null || true
    modprobe -r rtl2830 2>/dev/null || true
    echo "✅ Drivers unloaded"
else
    echo "✅ No conflicting drivers loaded"
fi
echo ""

echo "2️⃣  Ensuring blacklist is in place..."
mkdir -p /etc/modprobe.d
cat > /etc/modprobe.d/blacklist-rtl.conf <<EOF
blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
EOF
echo "✅ Blacklist updated"
echo ""

echo "3️⃣  Checking USB device..."
if lsusb | grep -qi "rtl\|2832"; then
    echo "✅ RTL-SDR device found in USB"
    lsusb | grep -i "rtl\|2832"
else
    echo "⚠️  RTL-SDR device not found in lsusb"
fi
echo ""

echo "4️⃣  Testing RTL-SDR..."
echo "Running rtl_test (may show errors but should find device)..."
timeout 5 rtl_test -t 2>&1 | head -5 || true
echo ""

echo "✅ Driver fix complete!"
echo ""
echo "If you still see errors, try:"
echo "1. Unplug and replug the RTL-SDR dongle"
echo "2. Reboot: sudo reboot"
echo "3. Check dmesg: dmesg | tail -20"
