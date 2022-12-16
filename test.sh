
projectname=salt
vm_name=( "$projectname" "x1ltst001" "x1lsql002" )

#Type box Linux/Windows
vm_type=( "L" "L" "L" )
#we have to escape the "/" for "sed"
vm_box=( "generic\/rocky8" "generic\/rocky8" "generic\/opensuse15" )

vm_cpu=( 2 1 1 )
vm_netwerk="192.168.178."
vm_ipnr=( 25 26 27 )
vm_mem=( 2048 1024 2048 )
domain=.localdomain



#ping $vm_netwerk${vm_ipnr[$i]}
SYSTEM=192.168.1.2
			ping -c 2 $SYSTEM > /dev/null 2>&1	#Als SYSTEM niet te pingen is, dan systeem overslaan
			rc=$?
			if [[ $rc -eq 0 ]]; then
        echo Ping naar $SYSTEM NIET GELUKT
        else 
        echo Ping naar $SYSTEM GELUKT
      fi
SYSTEM=192.168.1.1
			ping -c 2 $SYSTEM > /dev/null 2>&1	#Als SYSTEM niet te pingen is, dan systeem overslaan
			rc=$?
			if [[ $rc -eq 0 ]]; then
        echo Ping naar $SYSTEM NIET GELUKT
        else 
        echo Ping naar $SYSTEM GELUKT
      fi


      
exit

file=vagrantfile

#build vagrantfile
#head
echo '#Vagrant boxes om te installeren' >> $file
echo '#https://app.vagrantup.com/boxes/search' >> $file
echo '#hieruit nieuwe vagrant file bouwen win/linux verschillen met start scripts en.......' >> $file
echo 'Vagrant.configure("2") do |config|' >> $file

COUNT=${#vm_name[@]}
for (( i=0; i<$COUNT; i++ ))
do
  echo '  config.vm.define "'${vm_name[$i]}'" do |node|' >> $file
  echo '    node.vm.box =  "'${vm_box[$i]}'"' >> $file
  echo '    node.vm.hostname = "'${vm_name[$i]}'"' >> $file
  echo '    node.vm.network "public_network", bridge: "networkcard", ip: "'$vm_netwerk${vm_ipnr[$i]}'"' >> $file
  #exception for Linux boxes
  if [ "${vm_type[$i]}" = "L" ]; then
  echo '    node.vm.provision "shell", inline: <<-SHELL' >> $file
  echo '      #use parameter to call installscript for product X' >> $file
  echo '      sudo sh /vagrant/vagrantsetup1.sh' $projectname $domain >> $file
  echo '    SHELL' >> $file
  fi
  echo '    node.vm.provider "virtualbox" do |vmvbox|' >> $file
  echo '      vmvbox.memory = "'${vm_mem[$i]}'"' >> $file
  echo '      vmvbox.cpus = '${vm_cpu[$i]} >> $file
  echo '    end' >> $file
  echo '  end' >> $file
  echo '  ' >> $file
done

#close vagrantfile
echo '  ' >> $file
echo '  #https://www.vagrantup.com/docs/synced-folders/basic_usage' >> $file
echo '  config.vm.synced_folder "./vagrant", "/vagrant", enable: true' >> $file
echo 'end' >> $file









