#!/usr/bin/env bash
# config.txt

sudo bash -c 'echo "# dtparam=i2c_arm=on" >> /boot/config.txt '
sudo bash -c 'echo "# dtparam=spi=on" >> /boot/config.txt '
sudo bash -c 'echo "# dtoverlay=w1-gpio,gpiopin=4,pullup=on" >> /boot/config.txt '
sudo bash -c 'echo "# dtoverlay=w1-gpio" >> /boot/config '
sudo bash -c 'echo "# dtparam=audio=on" >> /boot/config.txt '
sudo bash -c 'echo "# disable_camera_led=1" >> /boot/config.txt '
