#!/bin/sh

echo config salt master met multiple states en pillars

[ -e /etc/salt/master.d/single.conf ] && rm /etc/salt/master.d/single.conf
cp /vagrant/etc/salt/master.d/multi.conf /etc/salt/master.d/multi.conf

systemctl stop salt-master.service
systemctl start salt-master.service


