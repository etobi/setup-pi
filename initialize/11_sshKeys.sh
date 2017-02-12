#!/usr/bin/env bash
# setup ssh keys

mkdir ~pi/.ssh
wget http://etobi.de/publickey.txt -O - > ~pi/.ssh/authorized_keys

bash -c 'ssh-keygen -q -N ""'
sudo bash -c 'ssh-keygen -q -N ""'
