#!/bin/sh

#if exist then exit because Virtual machine is started before, no installation steps
sudo [ -f /root/.bash_history ] && exit 0

#crontab weer leeg maken
sudo echo "" >> crontab_new
sudo crontab crontab_new
rm crontab_new

#source commando werkt niet op Debian, dit wel
[ -f /vagrant/MyVars.sh ] && . /vagrant/MyVars.sh
. /etc/os-release

#Start initial installation steps
#set history back for saved $project dir, easy recap commands
sudo [ ! -f /root/.bash_history ] cp /vagrant/root/.bash_history /root/.bash_history

case "$ID" in
    "rocky")
      sudo yum update -y
    ;;
    "opensuse-leap")
      sudo zypper refresh
      sudo zypper update -y
    ;;
    "debian")
      sudo apt-get update -y
    ;;   
    *)
    echo "OS Niet gedefineerd"
    exit 1
    ;;
esac

#set firewall settings if needed
#sudo firewall-cmd --permanent --zone=public --add-port=XXXXX/tcp
#sudo systemctl reload firewalld

