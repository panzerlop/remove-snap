#!/bin/bash

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

pkill -f firefox

sudo add-apt-repository ppa:alexlarsson/flatpak

sudo apt update
      
sudo apt install flatpak -y

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.mozilla.firefox

# done
echo " "
echo " "
echo " Snap removed"
echo " "
echo " & "
echo " "
echo " Firefox Flatpak installed "
echo " "
echo " To run Firefox from Terminal type the following:"
echo " "
echo " flatpak run org.mozilla.firefox "
echo " "
echo " Restart session if firefox doesn't appear in Applications menu "
echo " "
