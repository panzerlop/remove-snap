#!/bin/bash

echo "Copy the following commands once complete and past them in your Terminal one by one to install Firefox .deb"
echo " "
echo "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6DCF7707EBC211F"
echo " "
echo "sudo apt-add-repository "deb http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu jammy main"
echo " "
echo "sudo apt update"
echo " "
echo "sudo apt install firefox"
echo " "

echo "Removing snap..."

# Stop the daemon
sudo systemctl stop snapd && sudo systemctl disable snapd

# Uninstall
sudo apt purge -y snapd

# Tidy up dirs
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap

# Stop it from being reinstalled by 'mistake' when installing other packages
cat << EOF > no-snap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

sudo mv no-snap.pref /etc/apt/preferences.d/
sudo chown root:root /etc/apt/preferences.d/no-snap.pref

# done
echo "Snap removed"

pkill -f firefox
