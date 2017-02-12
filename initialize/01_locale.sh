#!/usr/bin/env bash
# configure locale (en_US.UTF-8, de_DE.UTF-8)

sudo bash -c 'sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen'
sudo bash -c 'sed -i -e "s/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/" /etc/locale.gen'
sudo bash -c 'echo "LANG=\"de_DE.UTF-8\"" > /etc/default/locale'
sudo bash -c 'dpkg-reconfigure --frontend=noninteractive locales'
sudo bash -c 'update-locale LANG=de_DE.UTF-8'
