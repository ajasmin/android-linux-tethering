# Android <-> Linux Tethering Script with Slirp

# This script tether the internet from the phone to your PC using Slirp

# Path to ADB
export ADB=/opt/android-sdk-linux_x86/platform-tools/adb

if [ $USER != "root" ]; then
	echo "Please run this script as root"
	exit
fi

echo "Connecting to the phone via slirp..."
$ADB ppp "shell:HOME=/data/local /data/local/slirp ppp mtu 1500" nodetach noauth noipdefault notty 10.0.2.15:10.64.64.64

echo "Waiting for the interface to come up..."
until ifconfig | grep -q 10.0.2.15; do sleep 1; done

echo "Configuring route..."
route add default gw 10.64.64.64

echo "Using Gooogle public DNS"
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

echo "Should be connected now."

