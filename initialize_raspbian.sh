#!/bin/bash

echo 
echo ==================================================================
echo "configure locale (en_US.UTF-8, de_DE.UTF-8)"
read -p "[ENTER]"

sudo bash -c 'sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen'
sudo bash -c 'sed -i -e "s/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/" /etc/locale.gen'
sudo bash -c 'echo "LANG=\"de_DE.UTF-8\"" > /etc/default/locale'
sudo bash -c 'dpkg-reconfigure --frontend=noninteractive locales'
sudo bash -c 'update-locale LANG=de_DE.UTF-8'

echo

BLOCKS=`df | grep "/dev/root" | awk '{print $2}'`
if (test "$BLOCKS" -lt 3800000); then

	echo ==================================================================
	echo 
	df -h | grep "/dev/root"

	echo
	read -n 1 -p "Expand file system? [Y/n] " YESNO
	echo

	if (test "$YESNO" = "" -o "$YESNO" = "y"  -o "$YESNO" = "Y"); then
		sudo /usr/bin/raspi-config --expand-rootfs
		echo ==================================================================
		echo reboot
		read -p "[ENTER]"
		sudo reboot
		exit
	fi
fi

echo 
echo ==================================================================
echo configure timezone
read -p "[ENTER]"

sudo bash -c 'echo "Europe/Berlin" > /etc/timezone'
sudo bash -c 'dpkg-reconfigure -f noninteractive tzdata'

echo 
echo ==================================================================
echo configure hostname
read -p "[ENTER]"

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
read -p "new hostname: " NEW_HOSTNAME
if (test ! "$NEW_HOSTNAME" = ""); then
	sudo bash -c "echo $NEW_HOSTNAME > /etc/hostname"
	sudo bash -c "sed -i 's/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g' /etc/hosts"
else
	NEW_HOSTNAME=$CURRENT_HOSTNAME
fi

echo 
echo ==================================================================
echo change password of user 'pi'
read -p "[ENTER]"

passwd

echo 
echo ==================================================================
echo enable tmp ram disk
read -p "[ENTER]"

# sudo bash -c 'echo -e "\n\n# mount /tmp ram disk\nRAMTMP=yes" >> /etc/default/tmpfs'
sudo bash -c 'echo -e "\ntmpfs /tmp tmpfs nodev,nosuid,relatime,size=100M 0 0\n" >> /etc/fstab'

echo 
echo ==================================================================
echo disable swap
read -p "[ENTER]"

sudo chmod -x /etc/init.d/dphys-swapfile
sudo swapoff -a
sudo rm /var/swap

echo 
echo ==================================================================
echo set vim as default editor
read -p "[ENTER]"

sudo update-alternatives --set editor /usr/bin/vim.tiny

echo 
echo ==================================================================
echo disable camera led
read -p "[ENTER]"

sudo bash -c 'echo "disable_camera_led=1" >> /boot/config.txt '

echo 
echo ==================================================================
echo setup ssh keys
read -p "[ENTER]"

mkdir ~pi/.ssh
wget http://etobi.de/publickey.txt -O - > ~pi/.ssh/authorized_keys

bash -c 'ssh-keygen -q -N ""'
sudo bash -c 'ssh-keygen -q -N ""'

echo 
echo ==================================================================
echo setup git author
read -p "[ENTER]"

git config --global push.default simple
git config --global user.email mail@etobi.de
git config --global user.name "Tobias Liebig"
sudo bash -c 'git config --global user.email mail@etobi.de'
sudo bash -c 'git config --global user.name "Tobias Liebig"'
sudo bash -c 'git config --global push.default simple'

echo 
echo ==================================================================
echo update apt
read -p "[ENTER]"

sudo apt-get update

echo 
echo ==================================================================
echo setup etckeeper
read -p "[ENTER]"

sudo apt-get -y install etckeeper
sudo bash -c 'cd /etc && etckeeper init'
sudo bash -c 'cd /etc && git remote add origin ssh://git@git.etobi.de:2222/etcs/`echo $NEW_HOSTNAME`_etc.git'
sudo bash -c "echo '0 1 * * * root cd /etc && git push --set-upstream origin master > /dev/null 2>&1' > /etc/cron.d/etckeeper_push"

echo 
echo ==================================================================
echo install jre
read -p "[ENTER]"

sudo apt-get -y install default-jre-headless

echo 
echo ==================================================================
echo install usbmount
read -p "[ENTER]"

sudo apt-get -y install usbmount

echo 
echo ==================================================================
echo install screen
read -p "[ENTER]"

sudo apt-get -y install screen

echo 
echo ==================================================================
echo install nodejs 6.x
read -p "[ENTER]"

NODEVERSION=`wget --no-verbose http://nodejs.org/dist/index.tab -O - | grep "^v6." | head -1 | awk '{print $1}'`
cd /tmpf
wget http://nodejs.org/dist/latest-v6.x/node-${NODEVERSION}-linux-armv6l.tar.gz
tar -xvf node-*.tar.gz 
cd node-*/
sudo cp -R * /usr/local/
cd

echo 	
echo ==================================================================
echo Remove unneeded packages
read -p "[ENTER]"

sudo apt-get -y remove --purge xserver-common gnome-icon-theme gnome-themes-standard x11-common x11-utils x11-xkb-utils x11-xserver-utils desktop-base desktop-file-utils hicolor-icon-theme raspberrypi-artwork omxplayer wolfram-engine supercollider penguinspuzzle minecraft-pi libreoffice
sudo apt-get -y autoremove

echo 
echo ==================================================================
echo apt-get upgrade
read -p "[ENTER]"

sudo apt-get -y upgrade

echo 
echo ==================================================================
echo rpi-update
read -p "[ENTER]"

sudo rpi-update

echo 
echo ==================================================================
echo setup network interfaces
read -p "[ENTER]"

# 
# sudo bash -c "echo '
# 
# #iface eth0 inet static
# #  address 192.168.50.222
# #  netmask 255.255.255.0
# #  gateway 192.168.50.1
# ' >> /etc/network/interfaces"
# sudo vi /etc/network/interfaces
# sudo bash -c "etckeeper commit 'configure network'"
# 

sudo bash -c "echo '

# interface eth0
# static ip_address=192.168.50.85
# static routers=192.168.50.1
# static domain_name_servers=192.168.50.1
' >> /etc/dhcpcd.conf"
sudo vi /etc/dhcpcd.conf
sudo bash -c "etckeeper commit 'configure network'"


echo 
echo ==================================================================
echo setup ssmtp
read -p "[ENTER]"

sudo apt-get -y install ssmtp
sudo bash -c 'echo "
root=mail_root-pi@etobi.de
hostname=etobi.de
AuthUser=xxxxxx
AuthPass=XXXXXX
FromLineOverride=YES
mailhub=wolke.etobi.de:587
UseSTARTTLS=YES
" > /etc/ssmtp/ssmtp.conf'
sudo vi /etc/ssmtp/ssmtp.conf
sudo bash -c "etckeeper commit 'configure ssmtp'"

echo 
echo ==================================================================
echo setup nagios
read -p "[ENTER]"

sudo apt-get -y install nagios-plugins
echo "
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjtS/PeZaW/4/zIERUvA2UpfeH7g5EiY+dv+3+20LL8askHNcK3YYO9MxsOEhH/rHSGp7Iv6ukaCrOqZxq6co+28/kijoj+M+y6zYFaekitgEr8wH+xN/FuZJPfPauZWD/ixvyOjJq/366+FF6WsQMqxu+0HxS76rsQ5Ed2PQP0Q2mpxm7wC2fsFPlfIck0dn3faRCyh7VdMCVMy0vtcu+dK0SbIDjWV3w9Wwk7jyNe5SPg5dGB4fiyb7Ax2N6Hlyj9QsOn6rqBNkDPud5gZ/Q2SLHK0a5yYkJWurrj+mEyWL+dkGu4yO3vcaNBEwQXXo4FbfKLtH+WP6cmr9rH3df nagios@mon-pi
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8mxQZFs1MfSE0RMs66lp13D9QUZdlnOszM3QBM5hYYkJNJ3NEHIZr2JwOaExKH3dysZy/WyKw7ypZ9nUDB8BrxNPA/o4/KWxUc7myEdQacYP3xdMFStOwDRi8fBV2V5xwCxij6ahhkCMgcT+9S31GXIust5rXg31+Sk7QJs7FI+fg9xt5xi5He2Z9DoVdHNPWh7nZLOJU4Y1UPOU+d/TA4jYofqQRRSRZdPZwJgPQsz98CPUu5NA6KDd4nPjj58v4XEkRgoyrfSuhL/m8mvjyM3AHb+B5J4RX9TA884X1+bx+kQiYBs8dYWvQSwS7gMRKfa00hLXrvPHUdCpcE+/H pi@mon-pi
" >> ~/.ssh/authorized_keys

echo 
echo ==================================================================
echo install watchdog
read -p "[ENTER]"

sudo modprobe bcm2708_wdog
sudo bash -c 'echo "
bcm2708_wdog
" >> /etc/modules'
sudo apt-get -y install watchdog
sudo bash -c 'echo "
max-load-1 = 24
watchdog-device = /dev/watchdog
" >> /etc/watchdog.conf'
sudo /etc/init.d/watchdog restart
sudo bash -c "etckeeper commit 'configure watchdog'"

echo 
echo ==================================================================
echo install collectd
sudo apt-get -y install collectd
sudo mv /etc/collectd/collectd.conf /etc/collectd/collectd.conf.orig
sudo bash -c 'echo "
Hostname \"TODO-pi\"
FQDNLookup true
LoadPlugin syslog
<Plugin syslog>
  LogLevel info
</Plugin>
LoadPlugin cpu
LoadPlugin df
LoadPlugin disk
#LoadPlugin exec
LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin processes
LoadPlugin users
LoadPlugin uptime
#LoadPlugin write_graphite
#<Plugin exec>
#  Exec \"pi\" \"/usr/local/bin/collectd-temp.sh\" \"10-000802ddf73b\"
#</Plugin>
#<Plugin write_graphite>
#  <Carbon>
#    Host \"192.168.50.65\"
#    Port \"2003\"
#    Prefix \"collectd/\"
#    StoreRates false
#    AlwaysAppendDS false
#    EscapeCharacter \"_\"
#  </Carbon>
#</Plugin>
Include \"/etc/collectd/filters.conf\"
Include \"/etc/collectd/thresholds.conf\"
" > /etc/collectd/collectd.conf'
sudo vi /etc/collectd/collectd.conf
sudo service collectd restart
sudo bash -c "etckeeper commit 'configure collectd'"

echo 
echo ==================================================================
echo install rpi monitor
read -p "[ENTER]"

sudo apt-get -y install librrds-perl libhttp-daemon-perl libjson-perl libipc-sharelite-perl libhttp-date-perl libhttp-message-perl liblwp-mediatypes-perl librrd4 libencode-locale-perl libhtml-parser-perl liburi-perl libdbi1 libhtml-tagset-perl libfile-which-perl
wget https://github.com/XavierBerger/RPi-Monitor-deb/blob/master/packages/rpimonitor_2.10-1_all.deb?raw=true -O rpimonitor.deb
sudo dpkg -i rpimonitor.deb
sudo apt-get update
sudo /usr/share/rpimonitor/scripts/updatePackagesStatus.pl

echo 
echo ==================================================================
echo finish raspi-config
read -p "[ENTER]"

sed '/disable_raspi_config_at_boot()/,/^$/!d' /usr/bin/raspi-config | sed -e '1i ASK_TO_REBOOT=0;' -e '$a disable_raspi_config_at_boot' | sudo bash

echo 
echo ==================================================================
echo cleanup pi home
read -p "[ENTER]"

cd ~
rm -fr Desktop Documents Downloads Music Pictures Public python_games Templates Videos

echo 
echo ==================================================================

echo 
echo done
echo
echo etckeeper remote git url:
sudo cat .git/config | grep "url ="

echo
echo root ssh public key:
sudo cat ~root/.ssh/id_rsa.pub

echo

echo ==================================================================
echo reboot?
read -p "[ENTER]"

sudo reboot