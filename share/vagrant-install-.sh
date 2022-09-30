#!/bin/sh

#if exist then exit because Virtual machine is started before, no installation steps
sudo [ -f /root/vagrant-secondfase.started ] && exit 0
echo "Init done" > /root/vagrant-secondfase.started

#variable init
#source commando doesn work on Debian, this does
[ -f /vagrant/MyVars.sh ] && . /vagrant/MyVars.sh
. /etc/os-release


#crontab weer leeg maken
sudo echo "" >> crontab_new
sudo crontab crontab_new
rm crontab_new

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

echo "Init done" > /root/vagrant-secondfase.done
