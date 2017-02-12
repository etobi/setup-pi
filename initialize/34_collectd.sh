#!/usr/bin/env bash
# install collectd


apt-get install libmosquitto-dev

wget https://storage.googleapis.com/collectd-tarballs/collectd-5.7.1.tar.bz2
tar xf collectd-*
cd collectd-*
sudo ./configure
sudo make all install

cp /opt/collectd/etc_/collectd.conf /etc/collectd/collectd.conf

ln -s /opt/collectd/sbin/collectd /usr/sbin/collectd
ln -s /opt/collectd/sbin/collectdmon /usr/sbin/collectdmon


sudo bash -c 'echo "
LoadPlugin uptime

#<Plugin exec>
#  Exec pi /usr/local/bin/collectd-temp.sh 10-000802ddf73b
#</Plugin>

LoadPlugin mqtt
<Plugin mqtt>
  <Publish igor>
    Host 192.168.50.88
#   Port 1883
#   User mqttuser
#   Password password
   ClientId "collectd-igor-pi"
#   QoS 0
#   Prefix collectd
#   Retain true
#   StoreRates false
  </Publish>
</Plugin>
" >> /etc/collectd/collectd.conf'

sudo service collectd start

sudo bash -c "etckeeper commit 'configure collectd'"
