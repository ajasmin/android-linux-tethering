# Android <-> Linux Tethering Script for Rooted Phones
# This script tethers the internet from the phone to your PC

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
$ADB ppp "shell:pppd nodetach noauth noipdefault /dev/tty" nodetach noauth noipdefault notty 10.0.0.1:10.0.0.2

echo "Waiting for the interface to come up..."
until ifconfig | grep -q 10.0.0.1; do sleep 1; done

echo "Configuring route..."
route add default gw 10.0.0.2

echo "Using Gooogle public DNS"
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

echo "Should be connected now. Pining www.example.com"
ping -c2 www.example.com

