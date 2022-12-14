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

#register VM's in hosts file
for (( x=0; x<$vm_number; x++))
do
  echo ${vm_ipnr[$x]}   ${vm_name[$x]}.localdomain  >> /etc/hosts
done

#Start initial installation steps
#set history back for saved $project dir, easy recap commands
sudo [ ! -f /root/.bash_history ] && [ -f /vagrant/root/.bash_history-$projectname ] && cp /vagrant/root/.bash_history-$projectname /root/.bash_history

case "$ID" in
    "rocky")
      sudo yum update -y
      
      #https://www.linuxtechi.com/how-to-install-ansible-on-rocky-linux/
      sudo dnf install -y epel-release
      sudo dnf install -y ansible
      
      #git nodig voor ansible pull optie  
      sudo dnf install -y git
      #git config --global user.name "EmileSPX"
      #git config --global user.email "Emile@vanZeijl.net"

      #########################################################################################################
      #Ansible installatie veranderd als root user moet ansible beschikbaar zijn anders werkt deze opzet niet.
      #Daarom niet via PIP geinstalleerd
      #echo installeren als user!!!
      #if [ "$USER" == 'root' ]
      #  then 
      #    echo installeren als user!!!
      #    exit
      #fi
      #
      ##alternatives --config python
      ##https://www.linuxtechi.com/how-to-install-ansible-on-rocky-linux/
      #echo "#########################################################"
      #ech install PIP
      #echo "#########################################################"
      #sudo yum install -y python39-pip
      #
      ##install ansible via PIP in user enviorment
      #echo install PIP
      #pip3 install --upgrade pip
      #
      ##pip3 install setuptools-rust wheel
      ##directory nog toevoegen aan path, wat doen die tools?
      ##path: /home/emile/.local/bin
      #echo "#########################################################"
      #echo install Ansible
      #echo "#########################################################"
      #pip install --upgrade ansible
    ;;
    "opensuse-leap")
      sudo zypper refresh
      sudo zypper update -y
      sudo zypper install -y ansible ansible-doc
      #ansible-cmdb nakijken
      
      sudo zypper install -y git-core
    ;;
    "debian")
        sudo apt-get update
        sudo apt-get install ansible -y
        sudo apt-get install git -y
    ;;
    *)
      #echo "OS Niet gedefineerd"
      #exit 1
    ;;
esac

#I use Ansible pull so client keep thereself up-to-date
#start first ansible run, that also implements crontab entry 
sudo ansible-pull -U https://github.com/Milio64/setup.git

#########################################################################################################
#firewall poorten open
#########################################################################################################
#sudo firewall-cmd --permanent --zone=public --add-port=XXXXX/tcp
#sudo systemctl reload firewalld

echo "Init done" > /root/vagrant-secondfase.done
