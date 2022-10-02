#!/bin/sh

#if exist then exit because Virtual machine is setup alread, no installation steps
sudo [ -f vagrantsetup$projectname.done ] && exit 0

#variable init
[ -f /vagrant/MyVars.sh ] && . /vagrant/MyVars.sh
. /etc/os-release

case "$ID" in
    "rocky")
      sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
      if [[ $HOSTNAME == puppet ]] ;
        then
          sudo yum -y install puppetserver
          #sudo yum install puppet-agent
        else
          sudo yum -y install puppet-agent
      fi
      sudo yum update -y
    ;;
    "opensuse-leap")
      sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
      if [[ $HOSTNAME == puppet ]] ;
        then
          sudo zypper install -y install puppetserver
          #sudo zypper install puppet-agent
        else
          #tested deze combinatie werkt niet
          #zou geinstalleerd moeten zijn in: /opt/puppetlabs/puppet/bin
          ####################################################################
          ####################################################################
          sudo zypper install -y puppet-agent
      fi
      sudo zypper refresh
      sudo zypper update -y
    ;;
    "debian")
      #not yet tested
      ####################################################################
      ####################################################################
      wget https://apt.puppet.com/puppet7-release-focal.deb
      sudo dpkg -i puppet7-release-focal.deb
      if [[ $HOSTNAME == puppet ]] ;
        then
          apt-get install -y puppetserver
          #sudo apt-get install puppet-agent
        else
          sudo apt-get install -y puppet-agent
      fi
      sudo apt-get update
    ;;   
    *)
    echo "OS Niet gedefineerd"
    exit 1
    ;;
esac

#start configuratie from agents
export PATH=/opt/puppetlabs/bin:$PATH
puppet config set server $puppet --section main

if [[ $HOSTNAME == puppet ]] ;
  then
    for (( x=0; x<$vm_number; x++))
    do
      sudo systemctl start puppetserver
      sudo systemctl enable puppetserver

      sudo puppetserver ca sign --certname ${vm_name[$x]}
    done
  else
    #first time, generate ssl cert for puppet agent
    puppet ssl bootstrap
fi

#second time to accept signed cert
#puppet ssl bootstrap

#set firewall settings if needed
#sudo firewall-cmd --permanent --zone=public --add-port=XXXXX/tcp
#sudo systemctl reload firewalld

echo "Init done" > vagrantsetup$projectname.done

