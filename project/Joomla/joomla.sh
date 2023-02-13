projectname=joomla
vm_name=( "$projectname" )
#Type box Linux/Windows
vm_type=( "L"  )
vm_type=( "generic/oracle8" )
vm_cpu=( 2 )
vm_ipnr=( 25 )
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
  Emile-Lenovo)
  ;;
  *)
  ;;
esac
