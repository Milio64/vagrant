projectname=puppet
vm_name=( "$projectname" "rocky8" "debian9" "sles15" )
#Type box Linux/Windows
vm_type=( "L" "L" "L" "L" )
vm_type=( "generic/rocky8" "generic/rocky8" "generic/debian9" "generic/opensuse15" )
vm_cpu=( 2 1 1 1 )
vm_ipnr=( 25 26 27 28 )
vm_mem=( 4096 1024 1024 1024 )
domain=.localdomain
case $HOSTNAME in
  EmileWerkkamer)
  ;;
  Emile-SPX)
    #execption from the defaults if needed.
    vm_ipnr=( 192.168.178.30 192.168.178.31 192.168.178.32 192.168.178.33 )
    vm_mem=( 3072 512 512 512)
  ;;
  Emile-Lenovo)
  ;;
  *)
  ;;
esac
