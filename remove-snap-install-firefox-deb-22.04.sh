#!/bin/bash -e

# Syntax Derived from script Copyright (C) 2019 madaidan under GPL
# Snap disable owed to https://github.com/BryanDollery
# 2022 script panzerlop under GPLv3

set -eu -o pipefail # fail on error and report it, debug all lines


script_checks() {

 sudo apt-get update
 
echo ""
    if [[ "$(id -u)" -ne 0 ]]; then
      echo "This script needs to be run as root (sudo)."
      exit 1
    fi
}


disable_snap() {


  read -r -p "Disable and remove Snap? (y/n) " disable_snap
	  if [ "${disable_snap}" = "y" ]; then

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

    
  fi
}

install_flatpak() {

  read -r -p "InstallFlatpak backend and add flathub? (y/n) " install_flatpak
	  if [ "${install_flatpak}" = "y" ]; then

sudo add-apt-repository ppa:alexlarsson/flatpak

sudo apt update
      
sudo apt install flatpak -y

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  fi
}

install_firefox() {

  read -r -p "InstallFlatpak backend and add flathub? (y/n) " install_firefox
	  if [ "${install_firefox}" = "y" ]; then
	  
flatpak install flathub org.mozilla.firefox

echo " To run Firefox from Terminal type the following: "
echo " "
echo " flatpak run org.mozilla.firefox "
echo " "
echo " Restart session if Firefox doesn't appear in Applications menu "
echo " "

  fi
}

ending() {
  ## Reboot
  echo ""
   echo " https://github.com/panzerlop/"
   echo ""
   echo "Hope this helped"
   echo "Maybe come improve it?"
    echo ""
       echo ""
  read -r -p "Reboot to apply all the changes? (y/n) " reboot
  if [ "${reboot}" = "y" ]; then
    reboot
    
  fi
}

echo ""
echo "22.04 Jelly Jammyfish easy Post-Install guided customisation script"
echo ""
cat << "EOF"
               .-.
         .-'``(|||)
      ,`\ \    `-`.
     /   \ '``-.   `
   .-.  ,       `___:
  (:::) :        ___
   `-`  `       ,   :
     \   / ,..-`   ,
      `./ /    .-.`
         `-..-(   ) 
               `-`
EOF

echo ""
echo ""
echo "By using this script you accept any break in system function/ damage / blabla is your own fault..."
echo "So if you also agree with that you may..."
echo ""
read -r -p "...start the script? (y/n) " start
if [ "${start}" = "n" ]; then

echo ""

  exit 1
elif ! [ "${start}" = "y" ]; then
  echo ""
  echo "You did not enter a correct character."
  echo ""
  echo "Be careful when reading through this script..."
  exit 1
fi

disable_snap
install_flatpak
install_firefox
ending 
