#!/usr/bin/env bash
# install rpi monitor

sudo apt-get -y install librrds-perl libhttp-daemon-perl libjson-perl libipc-sharelite-perl libhttp-date-perl libhttp-message-perl liblwp-mediatypes-perl librrd4 libencode-locale-perl libhtml-parser-perl liburi-perl libdbi1 libhtml-tagset-perl libfile-which-perl
wget https://github.com/XavierBerger/RPi-Monitor-deb/blob/master/packages/rpimonitor_2.10-1_all.deb?raw=true -O rpimonitor.deb
sudo dpkg -i rpimonitor.deb
sudo apt-get update
sudo /usr/share/rpimonitor/scripts/updatePackagesStatus.pl
