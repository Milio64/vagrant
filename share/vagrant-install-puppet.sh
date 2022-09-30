#!/bin/sh

#if exist then exit because Virtual machine is started before, no installation steps
sudo [ -f /root/vagrant-secondfase.started ] && exit 0
echo "Init done" > /root/vagrant-secondfase.started

#variable init
#source commando doesn work on Debian, this does
[ -f /vagrant/MyVars.sh ] && . /vagrant/MyVars.sh
. /etc/os-release

#empty crontab, not start for second time
sudo echo "" >> crontab_new
sudo crontab crontab_new
rm crontab_new


#Start initial installation steps
#set history back for saved $project dir, easy recap commands
cp /vagrant/root/.bash_history /root/.bash_history



case "$ID" in
    "rocky")
      sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
      if [[ $HOSTNAME == puppet ]] ;
        then
          sudo yum -y install puppetserver
          sudo systemctl start puppetserver && sudo systemctl enable puppetserver
          #sudo yum install puppet-agent
        else
          sudo yum install puppet-agent
      fi
      sudo yum update -y
    ;;
    "opensuse-leap")
      sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
      if [[ $HOSTNAME == puppet ]] ;
        then
          sudo zypper install -y install puppetserver
          sudo systemctl start puppetserver && sudo systemctl enable puppetserver
          #sudo zypper install puppet-agent
        else
          sudo zypper install puppet-agent
      fi
      sudo zypper refresh
      sudo zypper update -y
    ;;
    "debian")
      #not yet tested
      wget https://apt.puppet.com/puppet7-release-focal.deb
      sudo dpkg -i puppet7-release-focal.deb
      if [[ $HOSTNAME == puppet ]] ;
        then
          apt-get install puppetserver
          sudo systemctl start puppetserver && sudo systemctl enable puppetserver
          #sudo apt-get install puppet-agent
        else
          sudo apt-get install puppet-agent
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

#register VM in hosts file
for (( x=0; x<$vm_number; x++))
do
  echo ${vm_ipnr[$x]}   ${vm_name[$x]} >> /etc/hosts
done

puppet ssl bootstrap

if [[ $HOSTNAME == puppet ]] ;
  then
    for (( x=0; x<$vm_number; x++))
    do
      sudo puppetserver ca sign --certname ${vm_name[$x]}
    done
fi

#second time to accept signed cert
#puppet ssl bootstrap


#set firewall settings if needed
#sudo firewall-cmd --permanent --zone=public --add-port=XXXXX/tcp
#sudo systemctl reload firewalld

echo "Init done" > /root/vagrant-secondfase.done

