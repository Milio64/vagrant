#!/bin/sh
source /vagrant/MyVars.sh

#crontab weer leeg maken
sudo echo "" >> crontab_new
sudo crontab crontab_new
rm crontab_new

#if exist then exit because Virtual machine is started before, no installation steps
sudo [ -f /root/.bash_history ] && exit 0

#Start initial installation steps
#set history back for saved $project dir, easy recap commands
cp /vagrant/root/.bash_history /root/.bash_history

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

#set firewall settings if needed
#sudo firewall-cmd --permanent --zone=public --add-port=XXXXX/tcp
#sudo systemctl reload firewalld

