#!/usr/bin/env bash
# setup etckeeper

sudo apt-get -y install etckeeper
sudo bash -c 'cd /etc && etckeeper init'
sudo bash -c 'cd /etc && git remote add origin ssh://git@git.etobi.de:2222/etcs/`hostname`_etc.git'
sudo bash -c "echo '0 1 * * * root cd /etc && git push --set-upstream origin master > /dev/null 2>&1' > /etc/cron.d/etckeeper_push"
sudo bash -c "echo 'PUSH_REMOTE=\"origin\"' >> /etc/etckeeper/etckeeper.conf"
