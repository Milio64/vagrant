projectname=win10
vm_name=( "$projectname" )
#Type box Linux/Windows
vm_type=( "W" )
vm_type=( "baunegaard/win10pro-da" )
vm_cpu=( 1 )
vm_ipnr=( 36 )
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
