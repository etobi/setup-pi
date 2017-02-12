#!/usr/bin/env bash
# enable tmp ram disk

sudo bash -c 'echo -e "\ntmpfs /tmp tmpfs nodev,nosuid,relatime,size=100M 0 0\n" >> /etc/fstab'
