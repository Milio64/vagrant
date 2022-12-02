projectname=joomla
vm_number=1
vm_name=( "$projectname" )
#we have to escape the "/" for "sed"
vm_type=( "generic\/oracle8" )
vm_cpu=( 2 1 1 )
vm_ipnr=( 192.168.178.25 )
vm_mem=( 2048 )
domain=.localdomain
case $HOSTNAME in
  EmileWerkkamer)
  ;;
  Emile-SPX)
    #execption from the defaults if needed.
    vm_ipnr=( 192.168.178.30 )
    vm_mem=( 2048 )
  ;;
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
  ;;
esac
