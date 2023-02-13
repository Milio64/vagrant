projectname=test
vm_name=( "$projectname" )
#Type box Linux/Windows
vm_type=( "L"  )
vm_type=( "generic/rocky8" )
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
