#!/bin/sh

#if exist then exit because Virtual machine is setup alread, no installation steps
sudo [ -f vagrantsetup$projectname.started ] && exit 0
sudo [ -f vagrantsetup$projectname.done ] && exit 0
echo "vagrantsetup-$projectname done"  /root/vagrantsetup-$projectname.started

#variable init
#source commando doesn work on Debian, this does
. /etc/os-release
projectname=$1
domain=.localdomain


case "$ID" in
    "rocky")
      sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
      if [[ $HOSTNAME == puppet$domain ]] ;
        then
          #puppet-agent wordt automatisch mee geinstalleerd met puppet server.
          sudo yum -y install puppetserver

        else
          sudo yum -y install puppet-agent
      fi
      sudo yum update -y
    ;;
    "opensuse-leap")
      sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
      if [[ $HOSTNAME == puppet$domain ]] ;
        then
          #puppet-agent wordt automatisch mee geinstalleerd met puppet server.
          sudo zypper install -y install puppetserver
        else
          #tested this combi doesnt work
          #zou geinstalleerd moeten zijn in: /opt/puppetlabs/puppet/bin
          ####################################################################
          ####################################################################
          sudo zypper install -y puppet-agent
      fi
      sudo zypper refresh
      sudo zypper update -y
    ;;
    "debian")
      ####################################################################
      ####################################################################
      wget https://apt.puppet.com/puppet7-release-focal.deb
      sudo dpkg -i puppet7-release-focal.deb
      sudo apt-get update

      if [[ $HOSTNAME == puppet$domain ]] ;
        then
          #puppet-agent wordt automatisch mee geinstalleerd met puppet server.
          apt-get install -y puppetserver
        else
          sudo apt-get install -y puppet-agent
      fi
    ;;   
    *)
    echo "OS Niet gedefineerd"
    exit 1
    ;;
esac

#start configuratie from agents
export PATH=/opt/puppetlabs/bin:$PATH
puppet config set server puppet.localdomain --section main

#puppet config commands that valid for all OS versions
if [[ $HOSTNAME == puppet$domain ]] ;
  then
      #set firewall settings if needed
      sudo firewall-cmd --permanent --zone=public --add-port=8140/tcp
      sudo systemctl reload firewalld

      sudo systemctl start puppetserver
      sudo systemctl enable puppetserver

      ###############################################
      #sudo puppetserver ca sign --certname [naam]
      ###############################################
      #is auto sign configured? by default? how to check?
      
    done
fi

#first time, generate ssl cert for puppet agent
puppet ssl bootstrap

#https://www.tutorialspoint.com/puppet/puppet_ssl_sign_certificate_setup.htm

puppet agent -t

###############################################
#second time to accept signed cert
#puppet ssl bootstrap
###############################################


if [ -f /root/vagrantsetup-$projectname.started ] ;
  then
    echo "vagrantsetup-$projectname done"  /root/vagrantsetup-$projectname.done
    rm /root/vagrantsetup-$projectname.started
fi

