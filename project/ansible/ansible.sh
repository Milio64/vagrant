#Vagrant boxes om te installeren
#https://app.vagrantup.com/boxes/search
projectname=ansible

vm_name=( "$projectname" "debian" "suse" )
#Type box Linux/Windows
vm_type=( "L" "L" "L" )
#we have to escape the "/" for "sed"
vm_type=( "generic\/rocky8" "generic\/debian9" "generic\/opensuse15" )

vm_ipnr=( 25 26 27 )

vm_cpu=( 2 1 1 )
vm_mem=( 2048 1024 2048 )
domain=.localdomain
case $HOSTNAME in
  EmileWerkkamer)
  ;;
  Emile-SPX)
    #execption from the defaults if needed.
    vm_ipnr=( 30 31 32 )
    vm_mem=( 2048 512 512 )
  ;;
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
	;;
esac
