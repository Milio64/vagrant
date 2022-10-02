#!/bin/sh

#if exist then exit because Virtual machine is started before, no installation steps
sudo [ -f /root/vagrantsetup2.started ] && exit 0
echo "vagrantsetup2, started" > /root/vagrantsetup2.started

#variable init
#source commando doesn work on Debian, this does
[ -f /vagrant/MyVars.sh ] && . /vagrant/MyVars.sh
. /etc/os-release

#crontab weer leeg maken
sudo echo "" >> crontab_new
sudo crontab crontab_new
rm crontab_new

#register VM's in hosts file
for (( x=0; x<$vm_number; x++))
do
  echo ${vm_ipnr[$x]}   ${vm_name[$x]}.localdomain  >> /etc/hosts
done

#Start initial installation steps
#set history back for saved $project dir, easy recap commands
sudo [ -f /vagrant/root/.bash_history-$projectname ] && cp /vagrant/root/.bash_history-$projectname /root/.bash_history

#Start vagrantsetup project if available
if [ -f /vagrant/$projectname.sh ] ;
  then
    sudo echo "$projectname started" > /root/vagrantsetup$projectname.started
    sudo [ -f /vagrant/$projectname.sh ] && sudo /vagrant/$projectname.sh
  else
    #if vagrantsetup project is not available, update system and finish 
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
fi

echo "vagrantsetup2, done" > /root/vagrantsetup2.done
rm /root/vagrantsetup$projectname.started

if [ -f /root/vagrantsetup$projectname.started ] ;
  then
    echo "vagrantsetup$projectname done"  /root/vagrantsetup$projectname.done
    rm /root/vagrantsetup$projectname.started
fi

if [ -f /vagrant/message.log ] ;
  then
    wall -n /vagrant/message.log
    cat /vagrant/message.log >> /root/setup.log
    #rm /vagrant/message.log
fi