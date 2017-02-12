#!/usr/bin/env bash

YES=0
help=0
hostname=""

while [[ "$#" > 0 ]]; do
	case $1 in
    -h|--host)
		hostname="$2"
		;;
    -y|--yes)
		YES=1
		;;
    help|--help)
		help=1
		;;
  esac;
  shift; 
done

if (test "$help" -eq 1); then
	echo "-h <name> | --host <name> : set hostname"
	echo "-y | --yes                : do not require enter/confirmation for each step"
	exit;
fi

for script in initialize/*.sh ; do
	echo
	echo ==================================================================
	echo == $script
	cat $script | head -4 | grep '^#[^!]' | sed 's/^# /== /'
	echo ==================================================================
	echo

	if (test "$YES" -eq 0); then
		read -n 1 -p "execute $script? [Y,n] " yesno;
		if (test "$yesno" == ""); then
			yesno=y
		fi
	else
		yesno=y
	fi

	if (test "$yesno" == "y"); then
		echo execute $script ...
		echo
		$script
		echo
		echo ... done.
	fi

	echo
done
