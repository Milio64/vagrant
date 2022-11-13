#!/bin/sh
#if exist then exit because Virtual machine is started before, no installation steps
sudo [ -f /root/vagrantsetup-$1.done ] && exit 0

#variable init
master_ip=$salt

#source commando doesn work on Debian, this does
[ -f /vagrant/MyVars.sh ] && . /vagrant/MyVars.sh
. /etc/os-release

#Start initial installation steps
case "$ID_LIKE" in
    "rhel centos fedora")
    sudo rpm --import https://repo.saltproject.io/py3/redhat/8/x86_64/latest/SALTSTACK-GPG-KEY.pub
    sudo curl -fsSL https://repo.saltproject.io/py3/redhat/8/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt.repo
    sudo yum clean expire-cache
    sudo yum update -y
    sudo yum install -y salt-minion
    ;;
      
    "suse opensuse")
    sudo zypper refresh
    sydo zypper update -y
    sudo zypper install -y salt-minion
    ;;
    
    *)
    echo "OS Niet gedefineerd"
    exit 1
    ;;
esac

sudo echo "master: $master_ip" > /etc/salt/minion.d/local.conf
sudo echo "id: $HOSTNAME" >> /etc/salt/minion.d/local.conf

sudo systemctl enable salt-minion && sudo systemctl start salt-minion
#sommige distributies starten salt direct na installatie! dus voor zekerheid:
sudo systemctl restart salt-minion

#https://docs.saltproject.io/en/latest/ref/configuration/index.html
#Eventueel te wijzigen configuratie opties
case $HOSTNAME in
  "salt")
    case "$ID" in
      "rocky") #Rocky linux installatie commando's
        sudo yum install -y salt-master
        sudo yum install -y salt-ssh
        sudo yum install -y salt-syndic
        sudo yum install -y salt-cloud
        sudo yum install -y salt-api
        
        #voor ondersteuning van GIT moet onderstaande 3 packages geinstalleerd worden
        sudo dnf install -y epel-release
        #pygit heeft de voorkeur
        sudo yum install -y python3-pygit2 git
        #GitPython is bekend met memory leaks bij langdurige gebruik! if needed check check check! for test installed!
        sudo yum install -y python3-GitPython 
        sudo yum install -y python3-dulwich
      ;;
      "opensuse-leap") #OpenSuse installatie commando's
        sudo zypper install -y salt-master
        sudo zypper install -y salt-ssh
        sudo zypper install -y salt-syndic
        sudo zypper install -y salt-cloud
        sudo zypper install -y salt-api
      ;;
      "debian")

      ;;      *)
        #echo "OS Niet gedefineerd"
        #exit 1
      ;;
    esac
  
    #firewall open op de master only
    sudo firewall-cmd --permanent --zone=public --add-port=4505-4506/tcp
    sudo systemctl reload firewalld

    sudo systemctl enable salt-master && sudo systemctl start salt-master
    #sudo systemctl enable salt-syndic && sudo systemctl start salt-syndic
    sudo systemctl enable salt-api && sudo systemctl start salt-api

    #voorlopig multi environments config mee werken
    #sudo cp /vagrant/etc/salt/master.d/multi.conf /etc/salt/master.d/multi.conf
    #sudo systemctl restart salt-master.service
  
    #hier nog GIT installatie in en meteen clone van repo zodat alles meteen werkt

    #salt-key's auto accepteren loop zodat de boel gaat werken
    while true
    do
      [ -e /etc/salt/pki/master/minions_pre/* ] && sudo salt-key -A -y
    done

  ;;
  *)
    #Salt minion moet herstarten ivm wijziging in config voor die beschikbaar is
    for (( i=1; i<=10; i++))
    do
     sleep 1m && sudo systemctl restart salt-minion
    done
  ;;
esac

echo "vagrantsetup-$1, done" > /root/vagrantsetup-$1.done
rm /root/vagrantsetup-$1.started
