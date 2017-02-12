#!/usr/bin/env bash
# install watchdog

sudo bash -c 'echo "dtparam=watchdog=on" >> /boot/config.txt'
sudo apt-get -y install watchdog
sudo modprobe bcm2835_wdt
sudo bash -c 'echo "
bcm2835_wdt
" >> /etc/modules'
sudo bash -c 'echo "
max-load-1 = 24
min-memory = 1
watchdog-device = /dev/watchdog
watchdog-timeout = 15
" >> /etc/watchdog.conf'
sudo bash -c 'echo "
[Install]
WantedBy=multi-user.target
" >> /lib/systemd/system/watchdog.service'
sudo systemctl enable watchdog
sudo systemctl start watchdog
sudo bash -c "etckeeper commit 'configure watchdog'"
