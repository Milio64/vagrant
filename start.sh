
#Check parameter is given
#if [ -v 1 ]; then echo Set; else echo Not set && exit; fi

#define variable
#########################################################################################
#########################################################################################
case $HOSTNAME in
  EmileWerkkamer)
    basedir=/c/werk/github
  ;;
  Emile-SPX)
    basedir=/drives/c/werk/github
  ;;
  Emile-Lenovo)
    basedir=/drives/c/werk/github
  ;;
  *)
    basedir=/drives/c/werk/github
  ;;
esac

#define variable in external file
#########################################################################################
#########################################################################################
if [ -f $basedir/vagrant/project/$1.sh ]
  then
    source $basedir/vagrant/project/$1.sh
  else
    echo "file '$basedir/vagrant/project/$1.sh' bestaat niet"
    echo "maak deze aan en start opnieuw"
    echo "exit"
    exit 1
fi

projectdir=$basedir/$projectname

#Bestaat project al?
if [ -d $projectdir ] ; 
  then

    #Existing project
    ########################################################
    #If $basedir/vagrant/projects/vagrantsetup$projectname.sh not exist then copy 
    if [ ! -f $basedir/vagrant/project/vagrantsetup-$projectname.sh ] ;
      then 
        [ -f $projectdir/share/vagrantsetup-$projectname.sh ] && cp $projectdir/share/vagrantsetup-$projectname.sh $basedir/vagrant/project/
      else  
        echo "Dont forget to update $basedir/vagrant/project/vagrantsetup-$projectname.sh if needed!" >> $projectdir/share/message.log
    fi
    ########################################################
    if [ ! -f $basedir/vagrant/project/.bash_history-$projectname.sh ] ;
      then 
        [ -f $projectdir/share/.bash_history-projectname.sh ] && cp $projectdir/share/.bash_history$projectname.sh $basedir/vagrant/project/
      else  
        echo "Dont forget to update $basedir/vagrant/project/.bash_history-$projectname.sh if needed!"  >> $projectdir/share/message.log
    fi
    ########################################################
    #MyVars.sh will be updated remove old one
    [ -f $projectdir/share/MyVars.sh ] && rm $projectdir/share/MyVars.sh

  else
    #New project
    ########################################################
    #Make directory's and supporting files
    mkdir $projectdir $projectdir/srv
    cp $basedir/vagrant/.gitignore $projectdir/.gitignore
    cp -r $basedir/vagrant/share $projectdir/share
    if [ -f $basedir/vagrant/project/vagrantsetup-$projectname.sh ] ;
      then
        cp $basedir/vagrant/project/vagrantsetup-$projectname.sh $projectdir/share
      else
        echo "make new file: $projectdir/share/vagrantsetup-$projectname.sh to kickstart your project installation"  >> $projectdir/share/message.log
        echo "Dont forget to update $basedir/vagrant/project/vagrantsetup-$projectname.sh if needed!"  >> $projectdir/share/message.log
    fi
fi

#version control vagrantfile
[ -f $projectdir/vagrantfile.old ] && rm $projectdir/vagrantfile.old
[ -f $projectdir/vagrantfile ]     && mv $projectdir/vagrantfile $projectdir/vagrantfile.old
[ ! -f $projectdir/vagrantfile ]   && cp $basedir/vagrant/vagrantfile.template $projectdir/vagrantfile

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


#change keywords in vagrantfile
declare -i i=0
for (( x=0; x<$vm_number; x++ ))
do
  ((i++)) 
  sed -i 's/vm_name'$i'/'${vm_name[$x]}'/g' $projectdir/vagrantfile
  sed -i 's/vm_type'$i'/'${vm_type[$x]}'/g' $projectdir/vagrantfile
  sed -i 's/vm_ipnr'$i'/'${vm_ipnr[$x]}'/g' $projectdir/vagrantfile
  sed -i 's/vm_cpu'$i'/'${vm_cpu[$x]}'/g'   $projectdir/vagrantfile
  sed -i 's/vm_mem'$i'/'${vm_mem[$x]}'/g'   $projectdir/vagrantfile
  
  echo ${vm_name[$x]}=${vm_ipnr[$x]} >>     $projectdir/share/MyVars.sh
done
echo "vm_number=${vm_number}"          >>     $projectdir/share/MyVars.sh
echo "vm_name=( ${vm_name[@]} )"              >>     $projectdir/share/MyVars.sh
echo "vm_ipnr=( ${vm_ipnr[@]} )"              >>     $projectdir/share/MyVars.sh

sed -i 's/projectname/'$projectname'/g'     $projectdir/vagrantfile

pwd=$(pwd)
if [ "$pwd" = "$projectdir" ] ;
  then
    vagrant up
  else
    cd $projectdir
    echo "'vagrant up' to start the test environment"
    cmd
fi

