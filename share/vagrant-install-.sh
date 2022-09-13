#!/bin/sh
source /vagrant/MyVars.sh

#crontab weer leeg maken
sudo echo "" >> crontab_new
sudo crontab crontab_new
rm crontab_new

source /etc/os-release
case "$ID_LIKE" in
    "rhel centos fedora")
    sudo yum update -y
    ;;
      
    "suse opensuse")
    sudo zypper refresh
    sydo zypper update -y
    ;;
    
    *)
    echo "OS Niet gedefineerd"
    exit 1
    ;;
esac
#Eventueel te wijzigen configuratie opties
case $HOSTNAME in
  "NAME")
    case "$ID_LIKE" in
      "rhel centos fedora") #Rocky linux installatie commando's

      ;;
      "suse opensuse") #OpenSuse installatie commando's
      ;;
      *)
        echo "OS Niet gedefineerd"
      exit 1
      ;;
    esac
  *)
  ;;
esac

#firewall poorten open
#sudo firewall-cmd --permanent --zone=public --add-port=XXXXX/tcp
#sudo systemctl reload firewalld

