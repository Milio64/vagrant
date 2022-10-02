
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

sed -i 's/^M$//' $basedir/vagrant/vagrant/vagrantsetup1.sh
sed -i 's/^M$//' $basedir/vagrant/vagrant/vagrantsetup2.sh

#Bestaat project al?
if [ -d $projectdir ] ; 
  then
    #Existing project
    ########################################################
    #If $basedir/vagrant/projects/vagrantsetup-$projectname.sh not exist then 
    if [ ! -f $basedir/vagrant/project/vagrantsetup-$projectname.sh ] ;
      then 
        echo "To kickstart your project installationmake new file: "    >> $projectdir/vagrant/message.log
        echo "  $projectdir/vagrant/vagrantsetup-$projectname.sh "      >> $projectdir/vagrant/message.log
        echo "or: "                                                     >> $projectdir/vagrant/message.log
        echo "  $basedir/vagrant/project/vagrantsetup-$projectname.sh"  >> $projectdir/vagrant/message.log
      else
        if [ -f $projectdir/vagrant/vagrantsetup-$projectname.sh ] ;
          then #als niet bestaat in vagrant/project directory
            [ ! -e $basedir/vagrant/project/vagrantsetup-$projectname.sh ] && cp $projectdir/vagrant/vagrantsetup-$projectname.sh $basedir/vagrant/project/
        fi
    fi
    ########################################################
    if [ ! -f $basedir/vagrant/project/.bash_history-$projectname ] ;
      then 
        echo "Dont forget to update $basedir/vagrant/project/.bash_history-$projectname.sh if needed!"  >> $projectdir/vagrant/message.log
        [ -f $projectdir/vagrant/root/.bash_history ] && cp $projectdir/vagrant/root/.bash_history $basedir/vagrant/project/.bash_history-$projectname
    fi
    ########################################################
  else
    #New project
    ########################################################
    #Make directory's and supporting files
    mkdir $projectdir $projectdir/srv
    cp $basedir/vagrant/.gitignore $projectdir/.gitignore
    cp -r $basedir/vagrant/vagrant $projectdir/vagrant

    ########################################################
    if [ -f $basedir/vagrant/project/vagrantsetup-$projectname.sh ] ;
      then
        cp $basedir/vagrant/project/vagrantsetup-$projectname.sh $projectdir/vagrant
      else
        echo "To kickstart your project installationmake new file: "    >> $projectdir/vagrant/message.log
        echo "  $projectdir/vagrant/vagrantsetup-$projectname.sh "      >> $projectdir/vagrant/message.log
        echo "or: "                                                     >> $projectdir/vagrant/message.log
        echo "  $basedir/vagrant/project/vagrantsetup-$projectname.sh"  >> $projectdir/vagrant/message.log
    fi
    ########################################################
    if [ -f $basedir/vagrant/project/.bash_history-$projectname ] ;
      then
        cp $basedir/vagrant/project/.bash_history-$projectname $projectdir/vagrant/root/.bash_history
      else
        echo "if you want history on you VM make new file: "    >> $projectdir/vagrant/message.log
        echo "  $projectdir/vagrant/.bash_history-$projectname.sh "      >> $projectdir/vagrant/message.log
        echo "or: "                                                     >> $projectdir/vagrant/message.log
        echo "  $basedir/vagrant/project/.bash_histroy-$projectname.sh"  >> $projectdir/vagrant/message.log
        echo "Dont forget to update if needed!"  >> $projectdir/vagrant/message.log
    fi
fi

#version control vagrantfile
#[ -e $basedir/vagrant/vagrantfile.template$vm_number ] && echo $basedir/vagrant/vagrantfile.template$vm_number not defined. Exit ; exit 1
[ -e $projectdir/vagrantfile.old ] && rm $projectdir/vagrantfile.old
[ -e $projectdir/vagrantfile ]     && mv $projectdir/vagrantfile $projectdir/vagrantfile.old
[ ! -e $projectdir/vagrantfile ]   && cp $basedir/vagrant/vagrantfile.template$vm_number $projectdir/vagrantfile

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

#"hosts" file will be updated remove old one
[ -f $projectdir/vagrant/hosts ] && rm $projectdir/vagrant/hosts

#MyVars.sh will be updated remove old one
[ -f $projectdir/vagrant/MyVars.sh ] && rm $projectdir/vagrant/MyVars.sh

#Make MyVars.sh to pass variables to VM.
echo "projectname=${projectname}"    >>                $projectdir/vagrant/MyVars.sh
echo "vm_number=${vm_number}"        >>                $projectdir/vagrant/MyVars.sh
echo "vm_name=( ${vm_name[@]} )"     >>                $projectdir/vagrant/MyVars.sh
echo "vm_ipnr=( ${vm_ipnr[@]} )"     >>                $projectdir/vagrant/MyVars.sh

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
  echo ${vm_ipnr[$x]}   ${vm_name[$x]}.localdomain  >> $projectdir/vagrant/hosts
done

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

