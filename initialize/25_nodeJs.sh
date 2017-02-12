#!/usr/bin/env bash
# install nodejs 6.x

NODEVERSION=`wget --no-verbose http://nodejs.org/dist/index.tab -O - | grep "^v6." | head -1 | awk '{print $1}'`
cd /tmpf
wget http://nodejs.org/dist/latest-v6.x/node-${NODEVERSION}-linux-armv6l.tar.gz
tar -xvf node-*.tar.gz
cd node-*/
sudo cp -R * /usr/local/
cd