if [ -d /drives/c ]
  then
    basedir=/drives/c/werk/github/vagrant
  else
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
    if [ ! -d $basedir/start/project/$1 ]; then mkdir $basedir/start/project/$1 && cd $basedir/start/project/$1; fi
    exit 1
fi


#read project variable
source $basedir/start/project/$1/$1.sh

#define projectdir
projectdir=$basedir/$projectname

#project dir dont exist
if [ ! -d $projectdir ];   
  then
    #New project
    ########################################################
    #Make directory's and supporting files
    mkdir $projectdir $projectdir/srv

    cp $basedir/start/.gitignore $projectdir/.gitignore
    #copy default settings to project
    cp -r $basedir/start/vagrant $projectdir/vagrant
    #copy extra settings to project
    cp -r $basedir/start/project/$projectname/. $projectdir/vagrant
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
                                                                          

#version control vagrantfile
########################################################
[ -e $projectdir/vagrantfile.old ] && rm $projectdir/vagrantfile.old
[ -e $projectdir/vagrantfile ]     && mv $projectdir/vagrantfile $projectdir/vagrantfile.old
[ ! -e $projectdir/vagrantfile ]   && cp $basedir/start/vagrantfile.template$vm_number $projectdir/vagrantfile

#Virtualization host dependent variable.
#########################################################################################
#########################################################################################
#Modify the vagrantfile by replacing template keyword with values from variables
#sed -i 's/SEARCH_REGEX/REPLACEMENT/g' INPUTFILE
case $HOSTNAME in
  EmileWerkkamer)
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
echo "vm_number=${vm_number}"                       >> $projectdir/vagrant/MyVars.sh
echo "vm_name=( ${vm_name[@]} )"                    >> $projectdir/vagrant/MyVars.sh
echo "vm_ipnr=( ${vm_ipnr[@]} )"                    >> $projectdir/vagrant/MyVars.sh
echo "domain=$domain"                               >> $projectdir/vagrant/MyVars.sh

#change keywords in vagrantfile
declare -i i=0
for (( x=0; x<$vm_number; x++ ))
do
  ((i++)) 
  sed -i 's/vm_name'$i'/'${vm_name[$x]}'/g'            $projectdir/vagrantfile
  sed -i 's/vm_type'$i'/'${vm_type[$x]}'/g'            $projectdir/vagrantfile
  sed -i 's/vm_ipnr'$i'/'${vm_ipnr[$x]}'/g'            $projectdir/vagrantfile
  sed -i 's/vm_cpu'$i'/'${vm_cpu[$x]}'/g'              $projectdir/vagrantfile
  sed -i 's/vm_mem'$i'/'${vm_mem[$x]}'/g'              $projectdir/vagrantfile
  
  echo ${vm_name[$x]}=${vm_ipnr[$x]}                >> $projectdir/vagrant/MyVars.sh
  echo ${vm_ipnr[$x]}   ${vm_name[$x]}$domain       >> $projectdir/vagrant/hosts
done

sed -i 's/projectname/'$projectname'/g'                $projectdir/vagrantfile
sed -i 's/domain/'$domain'/g'                          $projectdir/vagrantfile

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
fi

