projectname=jenkins
vm_number=1
vm_name=( "$projectname" )
#we have to escape the "/" for "sed"
vm_type=( "generic\/rocky8" )
vm_cpu=( 1 )
vm_ipnr=( 192.168.178.35 )
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
