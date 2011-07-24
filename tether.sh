# Android <-> Linux Tethering Script for Rooted Phones
# This script tethers the internet from the phone to your PC

# See http://ajasmin.wordpress.com/

# Requires a rooted phone with netfilter and pppd

# Path to ADB
export ADB=/opt/android-sdk-linux_x86/platform-tools/adb

if [ $USER != "root" ]; then
	echo "Please run this script as root"
	exit
fi

echo "Enabling NAT on the phone..."
$ADB shell "echo 1 > /proc/sys/net/ipv4/ip_forward"
$ADB shell "iptables -t nat -F"
$ADB shell "iptables -t nat -A POSTROUTING -j MASQUERADE"

echo "Connecting to the phone via 'adb ppp'..."
# This use Google Public DNS servers which should work most of the time
$ADB ppp "shell:pppd nodetach noauth noipdefault ms-dns 8.8.8.8 ms-dns 8.8.4.4 /dev/tty" nodetach noauth noipdefault defaultroute usepeerdns notty 10.0.0.1:10.0.0.2

echo "Done."
