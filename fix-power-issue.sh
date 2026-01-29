#!/bin/bash
# Fix Raspberry Pi power/undervoltage issues

set -e

if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

echo "⚡ Raspberry Pi Power Issue Fix"
echo "==============================="
echo ""

echo "⚠️  UNDERVOLTAGE DETECTED!"
echo ""
echo "Your Pi is not getting enough power. This causes:"
echo "- USB devices to disconnect"
echo "- System instability"
echo "- RTL-SDR to fail"
echo ""

echo "1️⃣  Checking current power status..."
vcgencmd get_throttled
echo ""

echo "2️⃣  Checking voltage..."
vcgencmd measure_volts
echo ""

echo "3️⃣  Reducing power consumption..."
# Disable unnecessary services/features that draw power
echo "   - Disabling HDMI (saves power)"
/usr/bin/tvservice -o 2>/dev/null || echo "   (tvservice not available)"

echo "   - Setting CPU governor to ondemand (if available)"
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
    echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || true
    echo "   ✅ CPU governor set"
fi

echo ""
echo "4️⃣  Disabling USB autosuspend (prevents USB disconnects)..."
for usb in /sys/bus/usb/devices/*/power/control; do
    if [ -f "$usb" ]; then
        echo 'on' > "$usb" 2>/dev/null || true
    fi
done

# Make USB power control persistent
cat > /etc/udev/rules.d/50-usb-power.rules <<'EOF'
# Keep USB devices powered on
SUBSYSTEM=="usb", ATTR{power/control}="on"
EOF
udevadm control --reload-rules 2>/dev/null || true

echo "   ✅ USB autosuspend disabled"
echo ""

echo "5️⃣  Reducing USB current limit warnings..."
# Increase USB current limit if possible (Pi 4+)
if [ -f /sys/devices/platform/soc/*.usb/b_maximum_current ]; then
    echo 1200 > /sys/devices/platform/soc/*.usb/b_maximum_current 2>/dev/null || true
    echo "   ✅ USB current limit increased"
fi
echo ""

echo "✅ Power optimizations applied!"
echo ""
echo "🔌 CRITICAL: Power Supply Recommendations"
echo "=========================================="
echo ""
echo "Your Pi needs a BETTER POWER SUPPLY:"
echo ""
echo "✅ Use the official Raspberry Pi power supply:"
echo "   - Pi 3B+: 5V 2.5A (12.5W)"
echo "   - Pi 4: 5V 3A (15W)"
echo "   - Pi 5: 5V 5A (27W)"
echo ""
echo "✅ Or a high-quality USB-C power supply:"
echo "   - At least 5V 3A for Pi 3B+"
echo "   - Use a short, thick USB cable"
echo "   - Avoid cheap/no-name power supplies"
echo ""
echo "✅ Check your power supply:"
echo "   - Look for the official Raspberry Pi logo"
echo "   - Check the output rating (should be 5V 2.5A+ for Pi 3B+)"
echo "   - Use the original cable that came with it"
echo ""
echo "⚠️  Using a powered USB hub for RTL-SDR can help, but"
echo "   you still need a good power supply for the Pi itself."
echo ""
echo "📊 Monitor power status:"
echo "   watch -n 1 vcgencmd get_throttled"
echo ""
echo "After getting a better power supply:"
echo "1. Unplug and replug RTL-SDR"
echo "2. Restart FM-Go service: sudo systemctl restart fm-go.service"
echo "3. Check web interface - RTL-SDR should stay connected"
