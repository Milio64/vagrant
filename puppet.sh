projectname=puppet
vm_number=3
vm_name=( "puppet" "rocky8" "sles15" )
#we have to escape the "/" for "sed"
vm_type=( "generic\/rocky8" "generic\/rocky8" "generic\/opensuse15" )
vm_cpu=( 2 1 1 )
vm_ipnr=( 192.168.178.25 192.168.178.26 192.168.178.27 )
vm_mem=( 3072 1024 2048 )
case $HOSTNAME in
  EmileWerkkamer)
  ;;
  Emile-SPX)
    #execption from the defaults if needed.
    vm_ipnr=( 192.168.178.30 192.168.178.31 192.168.178.32 )
    vm_mem=( 3072 512 512 )
  ;;
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
  ;;
esac
