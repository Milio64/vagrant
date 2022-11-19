#!/bin/sh

echo config salt master met single states en pillars

[ -e /etc/salt/master.d/multi.conf ] && rm /etc/salt/master.d/multi.conf
cp /vagrant/etc/salt/master.d/single.conf /etc/salt/master.d/single.conf


systemctl stop salt-master.service
systemctl start salt-master.service
