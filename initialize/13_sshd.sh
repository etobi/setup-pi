#!/usr/bin/env bash
# configure sshd

sudo bash -c "echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config"
sudo bash -c "echo '#PasswordAuthentication no' >> /etc/ssh/sshd_config"
