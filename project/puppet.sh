projectname=puppet
vm_number=4
vm_name=( "puppet" "rocky8" "debian9" "sles15" )
#we have to escape the "/" for "sed"
vm_type=( "generic\/rocky8" "generic\/rocky8" "generic\/debian9" "generic\/opensuse15" )
vm_cpu=( 2 1 1 1 )
vm_ipnr=( 192.168.178.25 192.168.178.26 192.168.178.27 192.168.178.28 )
vm_mem=( 4096 1024 1024 1024 )
case $HOSTNAME in
  EmileWerkkamer)
  ;;
  Emile-SPX)
    #execption from the defaults if needed.
    vm_ipnr=( 192.168.178.30 192.168.178.31 192.168.178.32 192.168.178.33 )
    vm_mem=( 3072 512 512 512)
  ;;
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
  ;;
esac
