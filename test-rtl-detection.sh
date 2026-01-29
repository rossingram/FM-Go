#!/bin/bash
# Test RTL-SDR detection from service user context

echo "🔍 Testing RTL-SDR Detection"
echo "============================"
echo ""

echo "1️⃣  Testing as current user ($(whoami)):"
rtl_test -t 2>&1 | head -10
echo ""

echo "2️⃣  Testing as service user (fmgo):"
sudo -u fmgo rtl_test -t 2>&1 | head -10 || echo "Failed to run as fmgo user"
echo ""

echo "3️⃣  Checking USB device:"
lsusb | grep -i "rtl\|2832\|2830" || echo "No RTL-SDR found in lsusb"
echo ""

echo "4️⃣  Checking for driver conflicts:"
if lsmod | grep -qE "dvb_usb_rtl28xxu|rtl2832|rtl2830"; then
    echo "⚠️  Conflicting drivers loaded:"
    lsmod | grep -E "dvb_usb_rtl28xxu|rtl2832|rtl2830"
else
    echo "✅ No conflicting drivers"
fi
echo ""

echo "5️⃣  Testing Python detection:"
sudo -u fmgo /opt/fm-go/venv/bin/python3 << 'EOF'
import subprocess
try:
    result = subprocess.run(['rtl_test', '-t'], capture_output=True, timeout=5)
    output = result.stdout.decode('utf-8', errors='replace') + result.stderr.decode('utf-8', errors='replace')
    if 'Found' in output and 'device' in output.lower():
        print("✅ Python detection: RTL-SDR FOUND")
        print("Output snippet:", output[:200])
    else:
        print("❌ Python detection: RTL-SDR NOT FOUND")
        print("Output:", output[:500])
except Exception as e:
    print(f"❌ Python detection error: {e}")
EOF
