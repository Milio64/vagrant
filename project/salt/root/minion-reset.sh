#!/bin/sh

master_ip=192.168.178.25

sudo echo "master: $master_ip" > /etc/salt/minion.d/local.conf
sudo echo "id: $HOSTNAME" >> /etc/salt/minion.d/local.conf

sudo systemctl stop salt-minion && sudo systemctl start salt-minion
