
#Vagrant boxes om te installeren
#https://app.vagrantup.com/boxes/search

projectname=ansible
vm_number=3
vm_name=( "rocky" "debian" "suse" )
#we have to escape the "/" for "sed"
vm_type=( "generic\/rocky8" "generic\/debian9" "generic\/opensuse15" )
vm_cpu=( 2 1 1 )
vm_ipnr=( 192.168.178.25 192.168.178.26 192.168.178.27 )
vm_mem=( 2048 1024 2048 )
case $HOSTNAME in
  EmileWerkkamer)
  ;;
  Emile-SPX)
    #execption from the defaults if needed.
    vm_ipnr=( 192.168.178.30 192.168.178.31 192.168.178.32 )
    vm_mem=( 2048 512 512 )
  ;;
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
	;;
esac
