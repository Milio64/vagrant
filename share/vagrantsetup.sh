#!/bin/sh
#Init not second time.
sudo [ -f /root/vagrant-firsttime.done ] && exit 0

#register my ssh key to login as root.
sudo [ ! -d /root/.ssh ] && sudo mkdir /root/.ssh
sudo [ ! -f /root/.ssh/authorized_keys ] && sudo cp /vagrant/root/.ssh/authorized_keys /root/.ssh

#set root password that i know.
sudo sed -i '/root/c\root:$6$PjVXvGHBfjAom0fs$01tRho2BPeCF4J4AJUwqrUYf93ofyijdkDvuO2Mkd.7TWjwd0fTKXE8xZCm3McLoiYtjuOlzZbxM6BWDbEkdN0:19230::::::' /etc/shadow

#set timezone
timedatectl set-timezone Europe/Amsterdam

source /etc/os-release
#Keep this so empty as posible!
#if system boot vagrant init will wait before start next VM
case "$ID" in
    "opensuse-leap")
      sudo zypper refresh
      sudo zypper install -y cron vi vim
      sudo systemctl start cron && systemctl enable cron
    ;;
    "rocky")
      sleep 30
      #sleep a little else crontab is not available
    ;;
    "debian")
      #not yet fully tested
    ;;
    *)
    ;;
esac  

#shedule the installation from the project tools
sudo echo "*/2 * * * * /bin/sh /vagrant/vagrant-install-$1.sh >> /root/setup.log" >> /root/setup.log
sudo crontab /root/setup.log

#zorgen dat init niet nog een keer draait
echo "Init done" > /root/vagrant-firsttime.done



