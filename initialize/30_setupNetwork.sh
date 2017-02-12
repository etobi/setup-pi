#!/usr/bin/env bash
# setup network interfaces

read -p "IP? " ipadress
read -p "Gateway/DNS? " gateway

sudo bash -c "echo '

# interface eth0
# static ip_address=`echo $ipadress`
# static routers=`echo $gateway`
# static domain_name_servers=`echo $gateway`
' >> /etc/dhcpcd.conf"

sudo bash -c "etckeeper commit 'configure network'"
