projectname=samira
vm_number=2
vm_name=( "rocky8" "win10" )
#we have to escape the "/" for "sed"
vm_type=( "generic\/rocky8" "baunegaard\/win10pro-da" )
vm_cpu=( 2 2 )
vm_ipnr=( 192.168.178.25 192.168.178.26)
vm_mem=( 1024 2048)
domain=.localdomain

#execption from the defaults if needed.
case $HOSTNAME in
  EmileWerkkamer)
  ;;
  Emile-SPX)
  ;;
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
  ;;
esac
