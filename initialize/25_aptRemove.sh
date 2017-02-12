#!/usr/bin/env bash
# (test "$YES" -eq 0); then read -p "[ENTER]"; fi

sudo apt-get -y remove --purge xserver-common gnome-icon-theme gnome-themes-standard desktop-base desktop-file-utils hicolor-icon-theme raspberrypi-artwork omxplayer wolfram-engine supercollider penguinspuzzle minecraft-pi sonic-pi libreoffice* pi-greeter
sudo apt-get clean
sudo apt-get -y autoremove
