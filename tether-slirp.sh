# Android <-> Linux Tethering Script with Slirp

# This script tether the internet from the phone to your PC using Slirp

# See http://ajasmin.wordpress.com/2011/07/24/android-usb-tethering-with-a-linux-pc/

# Path to ADB
export ADB=/opt/android-sdk-linux_x86/platform-tools/adb

if [ $USER != "root" ]; then
	echo "Please run this script as root"
	exit
fi

echo "Connecting to the phone via slirp..."
$ADB ppp "shell:HOME=/data/local /data/local/slirp ppp mtu 1500" nodetach noauth noipdefault defaultroute usepeerdns notty 10.0.2.15:10.64.64.64

echo "Done."

