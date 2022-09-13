#!/bin/sh
source /vagrant/MyVars.sh
master_ip=$salt

#crontab weer leeg maken
sudo echo "" >> crontab_new
sudo crontab crontab_new
rm crontab_new

#init heeft al keer gedraaid niet 2de x starten
sudo [ -e /etc/salt/minion.d/local.conf ] && exit 0

source /etc/os-release
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
#sommige distributies starten salt direct na installatie!
#sudo systemctl restart salt-minion

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
        sudo yum install -y python3-pygit2
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

    sudo cp /vagrant/root/.bash_history /root/.bash_history

    #voorlopig multi environments config mee werken
    sudo cp /vagrant/etc/salt/master.d/multi.conf /etc/salt/master.d/multi.conf
    sudo systemctl stop salt-master.service
    sudo systemctl start salt-master.service
  
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

