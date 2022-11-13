#!/bin/sh

#if exist then exit because Virtual machine is started before, no installation steps
sudo [ -f /root/vagrantsetup2.done ] && exit 0
sudo [ -f /root/vagrantsetup2.started ] && exit 0
echo "vagrantsetup2, started" >> /root/vagrantsetup2.started

#variable init
#source commando doesn work on Debian, this does
. /etc/os-release
projectname=$1
domain=$2

#crontab weer leeg maken
crontab -r

#register VM's in hosts file
[ -f /vagrant/hosts ] && sudo cat /vagrant/hosts >> /etc/hosts

#set hostname and domain name (otherwise somtimes system uses domain prefix from DHCP scope)
hostnamectl set-hostname $HOSTNAME$domain

#set "complete profile" for "root"
cp -R -u /vagrant/root/. /root/
##############################################################################################
####### toevoegingen aan profile die onder git control staan lukken niet op deze manier.  ####
####### installatie commando's opnemen hieronder in dit script.                           #### 
##############################################################################################

##############################################################################################
#message by login on VM about update procedure #Add to so i do not overwrite $bestand OS specific settings!!
bestand=/root/.bashrc
echo "if [ -f /vagrant/message.log ] ;"      >> $bestand
echo "  then"                                >> $bestand
echo "    cat /vagrant/message.log"          >> $bestand
echo "fi"                                    >> $bestand

#Start vagrantsetup-project.sh if available
if [ -f /vagrant/vagrantsetup-$projectname.sh ] ;
  then
    sudo echo "/vagrant/vagrantsetup-$projectname started" >> /root/vagrantsetup-$projectname.started
    sudo echo "/vagrant/vagrantsetup-$projectname started" >> /root/setup.log

    echo "vagrantsetup2, done" >> /root/vagrantsetup2.done
    rm /root/vagrantsetup2.started

    sudo /vagrant/vagrantsetup-$projectname.sh $projectname $domain
    exit 0
fi
    
#if vagrantsetup project is not available, update system and finish 
case "$ID" in
    "rocky")
      sudo yum update -y
    ;;
    "opensuse-leap")
      sudo zypper refresh
      sudo zypper update -y
      zypper ps | grep 'The following running processes use deleted files:'
      if [[ $? == 0 ]]; then reboot; fi #string found REBOOT NEEDED!
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

echo "vagrantsetup2, done" > /root/vagrantsetup2.done
rm /root/vagrantsetup2.started
