#!/usr/bin/env bash
# disable swap

sudo chmod -x /etc/init.d/dphys-swapfile
sudo swapoff -a
sudo rm /var/swap
