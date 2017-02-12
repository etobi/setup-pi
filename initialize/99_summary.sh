#!/usr/bin/env bash

echo done
echo
echo etckeeper remote git url:
sudo cat /etc/.git/config | grep "url ="

echo
echo root ssh public key:
sudo cat ~root/.ssh/id_rsa.pub
