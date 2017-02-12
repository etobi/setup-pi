#!/usr/bin/env bash
# configure hostname

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
if (test ! "$hostname" = ""); then
	NEW_HOSTNAME="$hostname"
else
	read -p "new hostname: " NEW_HOSTNAME
	if (test "$NEW_HOSTNAME" = ""); then
		NEW_HOSTNAME=$CURRENT_HOSTNAME
	fi
fi

echo new hostname: $NEW_HOSTNAME

if (test ! "$NEW_HOSTNAME" = ""); then
	sudo bash -c "echo $NEW_HOSTNAME > /etc/hostname"
	sudo bash -c "sed -i 's/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME.etobi.de $NEW_HOSTNAME/g' /etc/hosts"
	sudo bash -c "hostname $NEW_HOSTNAME"
	sudo bash -c "hostname $NEW_HOSTNAME.etobi.de"
fi
