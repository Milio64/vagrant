projectname=oraclelinux
vm_name=( "salt" "x1ltst001" "x1lsql002" )
#Type box Linux/Windows
vm_type=( "L" "L" "L" )
vm_type=( "generic/oracle8" "generic/rocky8" "generic/opensuse15" )
vm_cpu=( 2 1 1 )
vm_ipnr=( 25 26 27 )
vm_mem=( 2048 1024 2048 )
domain=.localdomain
case $HOSTNAME in
  EmileWerkkamer)
  ;;
  Emile-SPX)
    #execption from the defaults if needed.
    vm_ipnr=( 30 31 32 )
    vm_mem=( 2048 512 512 )
  ;;
  *)
    echo Hostname not defined, cant set the bridged networkcard automatic
  ;;
esac
