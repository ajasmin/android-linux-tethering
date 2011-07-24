# Linux <-> Android Reverse Tethering Script
# This script tether the internet from your PC *to* the phone

# Path to ADB
export ADB=/opt/android-sdk-linux_x86/platform-tools/adb

if [ $USER != "root" ]; then
	echo "Please run this script as root"
	exit
fi

echo "Enabling NAT on `hostname`..."
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -F
iptables -t nat -A POSTROUTING -j MASQUERADE

echo "Connecting to the phone via 'adb ppp'..."
$ADB ppp "shell:pppd nodetach noauth noipdefault defaultroute /dev/tty" nodetach noauth noipdefault notty 10.0.0.1:10.0.0.2

echo "Done."

