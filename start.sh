
function gateway()
#########################################################################################
{
	test1=$(ipconfig)
	test2=$(grep "Default Gateway . . . . . . . . . : $1" <<< "$test1")
	test3=${test2:39:52}
	winping $test3

	if [ $? == 0 ];then	
			echo "Available network used in vagrantfile: "$1"X"
		else
			echo "Network '"$1"X' is niet beschikbaar!"
			echo "pas variable 'vm_netwerk' aan in config bestand"
            return 9
	fi
}

function winping()
#########################################################################################
{
	#$1 is IPnr waarop we ping test doen
	##########################################
	test=$(ping -n 1 $1) 
	case "$test" in 
		*"Approximate round trip times in milli-seconds"*)
			#echo Ping naar $1 GELUKT
			return 0
			;;
		*"Destination host unreachable"*)
			#echo Ping naar $1 NIET GELUKT
			return 1
			;;
		*"Request timed out"*)
			#echo Ping naar $1 NIET GELUKT geen route naar system
			return 9
			;;
	esac
} 

#check environment
if [ -d /drives/c ]
  then
    #Mobaxterm/cygwin shell
    basedir=/drives/c/werk/github/vagrant
  else
    #WinGit shell
    basedir=/c/werk/github/vagrant
fi

#files in start/vagrant directory controleren op juiste line-end
#########################################################################################
for file in $basedir/start/vagrant/*; do
    if  [ -f $file ]; then sed -i 's/\r$//' $file; fi
done

#files in project directory controleren op juist lineend
#########################################################################################
for file in $basedir/start/project/$1/*; do
    if  [ -f $file ]; then sed -i 's/\r$//' $file; fi
done

#define variable in external file
#########################################################################################
if [ ! -f $basedir/start/project/$1/$1.sh ]; then
    echo "file '$basedir/start/project/$1/$1.sh' bestaat niet"
    echo "maak deze aan en start opnieuw"
    echo "exit"
    exit 1
fi

#make project directory in "start project"
if [ ! -d $basedir/start/project/$1 ]; then 
  mkdir $basedir/start/project/$1
  cd $basedir/start/project/$1; 
fi

#read project variable
source $basedir/start/project/$1/$1.sh

#read network variable
source $basedir/start/project/network.sh

#define projectdir
projectdir=$basedir/$projectname

#project dir dont exist
if [ ! -d $projectdir ];   
  then
    #New project
    ########################################################
    #Make directory's and supporting files
    mkdir $projectdir $projectdir

    cp $basedir/start/.gitignore $projectdir/.gitignore
    #copy default settings to project
    cp -r $basedir/start/vagrant/ $projectdir/vagrant/
    #copy extra settings to project
    cp -r $basedir/start/project/$projectname/. $projectdir/vagrant
 fi


#copy ssh-key from mobaxterm host to vagrant project directory.
#DONT PUT a SSH-KEY in a GIT repo
if [ ! -d $projectdir/vagrant/host-sshkey ];   
  then
    mkdir $projectdir $projectdir/vagrant/host-sshkey
    cp ~/.ssh/id_rsa* $projectdir/vagrant/host-sshkey
fi

#set right so i can change files
chmod 777 $projectdir -R

########################################################
if [ ! -f $basedir/vagrant/project/$projectname/vagrantsetup-$projectname.sh ] ;
  then
    echo "To kickstart your project installation make new file: "                >> $projectdir/vagrant/message.log
    echo "  $basedir/vagrant/project/$projectname/vagrantsetup-$projectname.sh"  >> $projectdir/vagrant/message.log
fi
########################################################

#check of netwerk juist gedefineerd is in project file 
gateway $vm_netwerk
########################################################


#gedefineerd IP nr in project file nog controleren of ze vrij zijn....
#melding geven als je NIET beschikbaar zijn op het netwerk!
COUNT=${#vm_name[@]}
for (( i=0; i<$COUNT; i++ ))
do
	winping $vm_netwerk${vm_ipnr[$i]}
	if [ $? == 0 ];then	
		echo "VM met name: "${vm_name[$i]}" met IP nr "$vm_netwerk${vm_ipnr[$i]}" is al ingebruik op netwerk!"
	fi

done	
	
#version control vagrantfile
########################################################
file=$projectdir/vagrantfile
[ -e $file.old ] && rm $file.old
[ -e $file ]     && mv $file $file.old

#build vagrantfile
#head
echo '#Vagrant boxes om te installeren' >> $file
echo '#https://app.vagrantup.com/boxes/search' >> $file
echo '#hieruit nieuwe vagrant file bouwen win/linux verschillen met start scripts en.......' >> $file
echo 'Vagrant.configure("2") do |config|' >> $file

#body
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
  
  echo $vm_netwerk${vm_ipnr[$i]}'   '${vm_name[$i]}$domain >> $projectdir/vagrant/hosts

done

#end vagrantfile
echo '  ' >> $file
echo '  #https://www.vagrantup.com/docs/synced-folders/basic_usage' >> $file
echo '  config.vm.synced_folder "./vagrant", "/vagrant", enable: true' >> $file
echo 'end' >> $file

#Virtualization host dependent variable.
#########################################################################################
#########################################################################################
#Modify the vagrantfile by replacing template keyword with values from variables
#sed -i 's/SEARCH_REGEX/REPLACEMENT/g' INPUTFILE
case $HOSTNAME in
  Emile-Werkkamer)
    networkcard="networkcard/Intel(R) Ethernet Connection I217-LM"
    #sed -i 's/networkcard/'$networkcard'/g' $projectdir/vagrantfile
    #gives error so i do it hardcoded in de case statement
    sed -i 's/networkcard/Intel(R) Ethernet Connection I217-LM/g' $projectdir/vagrantfile
  ;;
  Emile-SPX)
    networkcard="Dell Wireless 1820A 802.11ac"
    sed -i 's/networkcard/Dell Wireless 1820A 802.11ac/g' $projectdir/vagrantfile
  ;;
  Emile-Lenovo)
      
    #kijken of via wifi werkt of via cable
    #netsh wlan show interfaces
    #The Wireless AutoConfig Service (wlansvc) is not running.
    #feedback op mijn desktop systeem
    
    #kijken of via wifi werkt of via cable
    #netsh wlan show interfaces
    
    netsh wlan show interfaces
    echo $?
    #return waarde 1 geen wlan
    #return waarde 0 wel wlan
      
    networkcard="Realtek RTL8723BE Wireless LAN 802.11n PCI-E NIC"
    networkcard="Realtek PCIe GBE Family Controller"
    #nog check maken welke netwerk kaart actief is!
    #voor nu alleen wifi card
    sed -i 's/networkcard/Realtek RTL8723BE Wireless LAN 802.11n PCI-E NIC/g' $projectdir/vagrantfile
  ;;
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
  ;;
esac
#########################################################################################
#########################################################################################

#"hosts" file will be updated remove old one
[ -f $projectdir/vagrant/hosts ] && rm $projectdir/vagrant/hosts

#MyVars.sh will be updated remove old one
[ -f $projectdir/vagrant/MyVars.sh ] && rm $projectdir/vagrant/MyVars.sh

#Make MyVars.sh to pass variables to VM.
echo "projectname=${projectname}"                   >> $projectdir/vagrant/MyVars.sh
echo "vm_name=( ${vm_name[@]} )"                    >> $projectdir/vagrant/MyVars.sh
echo "vm_netwerk=$vm_netwerk"                       >> $projectdir/vagrant/MyVars.sh
echo "vm_ipnr=( ${vm_ipnr[@]} )"                    >> $projectdir/vagrant/MyVars.sh
echo "domain=$domain"                               >> $projectdir/vagrant/MyVars.sh

pwd=$(pwd)
if [ "$pwd" = "$projectdir" ] ;
  then
    vagrant box update
    vagrant up
  else
    cd $projectdir
    echo "cd $projectdir"
    echo "'vagrant box update' to update environment"
    echo "'vagrant up' to start the $projectname environment"
    echo "vagrant fouten soms alleen te starten vanuit een comand box not a bashshell"
fi

