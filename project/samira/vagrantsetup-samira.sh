#!/bin/sh
#if exist then exit because Virtual machine is started before, no installation steps
sudo [ -f /root/vagrantsetup-$1.done ] && exit 0

#variable inlezen
#source commando doesn work on Debian, this does
[ -f /vagrant/MyVars.sh ] && . /vagrant/MyVars.sh
[ -f /root/secret.sh ] && . /root/secret.sh
. /etc/os-release

echo Start initial installation steps
case "$ID_LIKE" in
    "rhel centos fedora")
      installtool=yum
      package=httpd
    ;;
      
    "suse opensuse")
      installtool=zypper
      package=apache2
      sudo $installtool refresh
    ;;
  
    *)
    echo "OS Niet gedefineerd"
    exit 1
    ;;
esac

sudo $installtool update -y
sudo $installtool install -y $package
echo start and enable $package
sudo systemctl enable $package && sudo systemctl start $package

echo firewall op VM aanpassen zodat verbinding op http en https poorten gemaakt mogen worden.
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload 
echo na reload van de firewall zijn de poorten pas te zien in running config

#firewall-cmd --list-all-zones
#testen van firewall poorten indien nodig
#ss -tulp | grep LIST

#kopieren van je HTTP voorbeeld file naar de VM webserver
#Nu pas kopieren want dan bestaat directory en defaut rechten zijn geregeld...
sudo echo 'cp -r /vagrant/var/www/html/index.html /var/www/html/index.html' > /root/copy-html.sh
sudo chmod 744 /var/www/html/index.html /root/copy-html.sh

sudo echo 'vagrantsetup-$1.done' > /root/vagrantsetup-$1.done ]
sudo [ -f /root/vagrantsetup-$1.done ] && rm -f /root/vagrantsetup-$1.started
