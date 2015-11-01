#!/bin/bash

################################################################

do_check() {
	type dd >/dev/null 2>&1 || { echo >&2 "I require dd but it's not installed.  Aborting."; exit 1; }
	type wget >/dev/null 2>&1 || { echo >&2 "I require wget but it's not installed.  Aborting."; exit 1; }
	type pv >/dev/null 2>&1 || { echo >&2 "I require pv but it's not installed.  Aborting."; exit 1; }
	type jar >/dev/null 2>&1 || { echo >&2 "I require jar but it's not installed.  Aborting."; exit 1; }
	type diskutil >/dev/null 2>&1 || { echo >&2 "I require diskutil but it's not installed.  Aborting."; exit 1; }
	
	if (test ! -d "./tmp"); then
		mkdir ./tmp
	fi
}

################################################################

do_download_image() {
	read -n 1 -p "Download latest raspbian? [Y/n] " YESNO
	echo
	if (test "$YESNO" = "" -o "$YESNO" = "y"  -o "$YESNO" = "Y"); then
		rm -f tmp/raspbian.zip
		wget http://downloads.raspberrypi.org/raspbian_latest -O tmp/raspbian.zip
		cd tmp
		echo unzipping...
		jar xvf raspbian.zip
		cd ..
	else
		if (test ! -f tmp/raspbian.zip); then
			echo "tmp/raspbian.zip does not exist";
			exit 1;
		fi
	fi

	SOURCE=`ls -t1 tmp/*.img | head -1`
	echo "Image found: $SOURCE"

	if (test "$SOURCE" = "" -o ! -f "./$SOURCE"); then
		echo No image found.
		exit 1;
	fi

	ls -lh $SOURCE
}

################################################################

do_choose_target() {
	read -p "Insert empty SD-Card and press enter [ENTER] "

	diskutil list

	echo 
	echo 
	echo 

	TARGET=`diskutil list | grep FAT_32 | awk 'NF{print $NF; exit}' | sed 's/s1//' | sed 's/s2//'`
	TARGET=/dev/$TARGET
	read -p "Enter SD-Card device path: [$TARGET] " INPUT
	echo 

	if (test ! "$INPUT" = ""); then
		TARGET=$INPUT
	fi
	
	if (test "$TARGET" = "/dev/"); then
		echo Unknown device.
		exit 1
	fi
	
	RAWTARGET=`echo $TARGET | sed 's/disk/rdisk/'`
	
	if (test ! -b "$RAWTARGET"); then
		echo Invalid device.
		exit 1
	fi
	
}

################################################################

do_dump() {
	echo "source:"
	ls -lh $SOURCE

	echo "target: $TARGET   $RAWTARGET"
	echo
	read -p "Ready? [ENTER]"
	diskutil unmountDisk $TARGET
	
	echo "dd..."
	sudo bash -c "pv -tpreb $SOURCE | dd bs=1m of=$RAWTARGET"
	
	diskutil eject $SOURCE
}


################################################################

do_check

echo 
echo 
echo 

do_download_image

echo 
echo 
echo 

do_choose_target

echo 
echo 
echo 

do_dump

echo 
echo 
echo 
echo "done."

################################################################