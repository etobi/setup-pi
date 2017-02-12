#!/usr/bin/env bash
# setup ssmtp

sudo apt-get -y install ssmtp
sudo bash -c 'echo "
root=mail_pi@etobi.de
hostname=etobi.de
AuthUser=xxxxxx
AuthPass=XXXXXX
FromLineOverride=YES
mailhub=wolke.etobi.de:587
UseSTARTTLS=YES
" > /etc/ssmtp/ssmtp.conf'

sudo vi /etc/ssmtp/ssmtp.conf

sudo bash -c "etckeeper commit 'configure ssmtp'"
