#!/usr/bin/env bash
# finish raspi-config

sed '/disable_raspi_config_at_boot()/,/^$/!d' /usr/bin/raspi-config | sed -e '1i ASK_TO_REBOOT=0;' -e '$a disable_raspi_config_at_boot' | sudo bash
