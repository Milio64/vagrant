#certificaat maken op basis van hostname naam

pad=/etc/salt/pki/master/git-sshkey

if [ ! -d $pad ]; then
  mkdir $pad
fi

if [ ! -f $pad/$HOSTNAME ]; then
	ssh-keygen -b 4048 -t rsa -N '' -C "$HOSTNAME" -f $pad/$HOSTNAME
fi



#ssh key accepteren! werkt het nu?
#salt salt ssh.set_known_host user=root hostname=github.com
