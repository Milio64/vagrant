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

#register VM in hosts file
for (( x=0; x<$vm_number; x++))
do
  echo ${vm_ipnr[$x]}   ${vm_name[$x]}.localdomain  >> /etc/hosts
done

#Start initial installation steps
#set history back for saved $project dir, easy recap commands
sudo [ ! -f /root/.bash_history ] && [ -f /vagrant/root/.bash_history-$projectname ] && cp /vagrant/root/.bash_history-$projectname /root/.bash_history

#Eventueel te wijzigen configuratie opties
case $HOSTNAME in
  "jenkins")
    case "$ID" in
      "rocky") #Rocky linux installatie commando's
        #wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz
        #tar xvf openjdk-17_linux-x64_bin.tar.gz
        #sudo mv jdk-17 /opt/
        #echo "export \$JAVA_HOME=/opt/jdk-17" >> /etc/profile.d/jdk.sh
        #echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile.d/jdk.sh
        #source /etc/profile.d/jdk.sh
        
        #install Jenkins
        #https://www.jenkins.io/doc/pipeline/tour/getting-started/
        #https://pkg.jenkins.io/redhat-stable/
        sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
        
        sudo yum install -y fontconfig java-17-openjdk jenkins
        #yum install jenkins
        
        sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
        sudo systemctl reload firewalld
        
        
        sudo systemctl enable jenkins.service
        sudo systemctl start jenkins.service
        sudo echo "start browser naar http://${vm_ipnr[0]}:8080"  >> /vagrant/message.log
        
      ;;
      "opensuse-leap") #OpenSuse installatie commando's
      ;;
      "debian")
      ;;
      *)
        echo "OS Niet gedefineerd"
        exit 1
      ;;
    esac
esac

echo "Init done" > /root/vagrant-secondfase.done
