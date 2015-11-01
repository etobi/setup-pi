#!/bin/bash

echo update apt
sudo apt-get update

echo install some packages
sudo apt-get -y install usbmount default-jre-headless

echo Remove unneeded packages
sudo apt-get -y remove --purge xserver-common gnome-icon-theme gnome-themes-standard
sudo apt-get -y remove --purge x11-*
sudo apt-get -y remove --purge desktop-base desktop-file-utils hicolor-icon-theme raspberrypi-artwork omxplayer
sudo apt-get -y remove --purge wolfram-engine supercollider penguinspuzzle minecraft-pi libreoffice
sudo apt-get -y autoremove

echo apt-get upgrade
sudo apt-get -y upgrade

echo rpi-update
sudo rpi-update

echo enable tmp ram disk
sudo bash -c 'echo -e "\n\n# mount /tmp ram disk\nRAMTMP=yes" >> /etc/default/tmpfs'

echo disable swap
sudo chmod -x /etc/init.d/dphys-swapfile
sudo swapoff -a
sudo rm /var/swap

echo set vim as default editor
sudo update-alternatives --set editor /usr/bin/vim.tiny

echo disable camera led
sudo bash -c 'echo "disable_camera_led=1" >> /boot/config.txt '

echo expand file system
sudo /usr/bin/raspi-config --expand-rootfs

echo change password of user 'pi'
passwd pi

echo configure locale
sudo bash -c 'sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen'
sudo bash -c 'sed -i -e "s/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/" /etc/locale.gen'
sudo bash -c 'echo "LANG=\"de_DE.UTF-8\"" > /etc/default/locale'
sudo bash -c 'dpkg-reconfigure --frontend=noninteractive locales'
sudo bash -c 'update-locale LANG=de_DE.UTF-8'

echo configure timezone
sudo bash -c 'echo "Europe/Berlin" > /etc/timezone'
sudo bash -c 'dpkg-reconfigure -f noninteractive tzdata'

echo configure hostname
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
read -p "new hostname: " NEW_HOSTNAME
sudo bash -c 'echo $NEW_HOSTNAME > /etc/hostname'
sudo bash -c 'sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts'

echo setup ssh keys
mkdir ~pi/.ssh
wget http://etobi.de/publickey.txt -O - > ~pi/.ssh/authorized_keys

cat /dev/zero | ssh-keygen -q -N ""
sudo bash -c 'cat /dev/zero | ssh-keygen -q -N ""'

echo setup git author
git config --global user.email mail@etobi.de
git config --global user.name "Tobias Liebig"
sudo bash -c 'git config --global user.email mail@etobi.de'
sudo bash -c 'git config --global user.name "Tobias Liebig"'

echo setup etckeeper
sudo apt-get -y install etckeeper
sudo bash -c 'cd /etc && etckeeper init'
sudo bash -c 'git remote add origin ssh://git@git.etobi.de:2222/etc/`echo $NEW_HOSTNAME`.git'

# TODO setup network

# TODO configure sSMTP

# TODO nagios plugins
# sudo apt-get install nagios-plugins
# nagios user anlegen und authorized keys hinterlegen

# TODO configuration
# config für mon-pi/icinga
# ping
# http
# ssh
# disk (/)
# cpu temp (cat /sys/class/thermal/thermal_zone0/temp)
# procs
# mem
# load

# TODO install watchdog
# http://raspberrypi.link-tech.de/doku.php?id=watchdog

# TODO install rpi monitor
# http://rpi-experiences.blogspot.fr/p/rpi-monitor.html

echo finish raspi-config
sed '/disable_raspi_config_at_boot()/,/^$/!d' /usr/bin/raspi-config | sed -e '1i ASK_TO_REBOOT=0;' -e '$a disable_raspi_config_at_boot' | sudo bash

echo cleanup pi home
rm -fr Desktop Documents Downloads Music Pictures Public python_games Templates Videos

echo reboot
sudo reboot
