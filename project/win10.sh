projectname=win10
vm_number=1
vm_name=( "$projectname" )
#we have to escape the "/" for "sed"
vm_type=( "baunegaard\/win10pro-da" )
vm_cpu=( 1 )
vm_ipnr=( 192.168.178.36 )
vm_mem=( 1024 )
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
