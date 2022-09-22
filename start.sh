
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
  *)
    basedir=/c/werk/github
esac

#define variable in external file
#########################################################################################
#########################################################################################
if [ -f $basedir/vagrant/$1.sh ]
  then
    source $basedir/vagrant/$1.sh
  else
    echo "file '$basedir/vagrant/$1.sh' not found, exit"
    exit 1
fi

projectdir=$basedir/$projectname

#new projectdir
if [ ! -d $projectdir ] ; 
  then
    mkdir $projectdir $projectdir/srv
    cp $basedir/vagrant/.gitignore $projectdir/.gitignore
    cp -r $basedir/vagrant/share $projectdir/share

    #onnodige config file weghalen uit project directory
    rm -f $basedir/vagrant/share/vagrant-install-*.sh
    if [ -f $basedir/vagrant/share/vagrant-install-$projectname.sh ] then
        cp $basedir/vagrant/share/vagrant-install-$projectname.sh $projectdir/share
      else
        cp $basedir/vagrant/share/vagrant-install-.sh $projectdir/share
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
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
  ;;
esac
#########################################################################################
#########################################################################################
#make sure host variables are available on VM
[ -f $projectdir/share/MyVars.sh ] && rm $projectdir/share/MyVars.sh

#change keywords in vagrantfile
declare -i i=0
for (( x=0; x<$vm_number; x++))
do
  ((i++)) 
  sed -i 's/vm_name'$i'/'${vm_name[$x]}'/g' $projectdir/vagrantfile
  sed -i 's/vm_type'$i'/'${vm_type[$x]}'/g' $projectdir/vagrantfile
  sed -i 's/vm_ipnr'$i'/'${vm_ipnr[$x]}'/g' $projectdir/vagrantfile
  sed -i 's/vm_cpu'$i'/'${vm_cpu[$x]}'/g'   $projectdir/vagrantfile
  sed -i 's/vm_mem'$i'/'${vm_mem[$x]}'/g'   $projectdir/vagrantfile
  
  echo ${vm_name[$x]}=${vm_ipnr[$x]} >>     $projectdir/share/MyVars.sh
done

sed -i 's/projectname/'$projectname'/g'     $projectdir/vagrantfile

pwd=$(pwd)

if [ "$pwd" = "$projectdir" ];
  then
    vagrant up
  else
    cd $projectdir
    echo "'vagrant up' to start the test environment"
    cmd
fi
