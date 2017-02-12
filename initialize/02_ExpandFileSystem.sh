#!/usr/bin/env bash
# expand file system

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
		if (test "$YES" -eq 0); then read -p "[ENTER]"; fi
		sudo reboot
		exit
	fi
fi