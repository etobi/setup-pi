#!/usr/bin/env bash
# configure timezone

sudo bash -c 'echo "Europe/Berlin" > /etc/timezone'
sudo bash -c 'dpkg-reconfigure -f noninteractive tzdata'
