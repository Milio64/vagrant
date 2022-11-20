ll
cd /
ll
cd vagrant
ll
sh vagrantsetup2.sh 
cd /root/
ll
rm vagrantsetup2.started 
sh /vagrantsetup2.sh 
sh ../vagrantsetup2.sh 
sh /vagrant/vagrantsetup2.sh 
ll
cd /vagrant
ll
 vagrant halt
cd /vagrant
ll
ls
shutdown -H
ping 192.168.178.26
cd /vagrant
ll
sh vagrantsetup-samira.sh 
systemctl restart httpd
systemctl status httpd
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --reload 
#na reload zijn poorten pas te zien in running config
firewall-cmd --list-all-zone
exit
