
#install Java
#cd /root
#wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz
#tar xvf openjdk-17_linux-x64_bin.tar.gz
#sudo mv jdk-17 /opt/
#echo "export \$JAVA_HOME=/opt/jdk-17" >> /etc/profile.d/jdk.sh
#echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile.d/jdk.sh
#source /etc/profile.d/jdk.sh

#install Jenkins
#https://pkg.jenkins.io/redhat-stable/
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum install -y fontconfig java-17-openjdk jenkins
#yum install jenkins
