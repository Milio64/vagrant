case $HOSTNAME in
  EmileWerkkamer)
	#fixed netwerk always this network
	vm_netwerk="192.168.178."	
  ;;
  Emile-SPX)
	vm_netwerk="192.168.178."
	#below was in Langsuan
	#vm_netwerk="192.168.1.
  ;;
  Emile-Lenovo)
	vm_netwerk="192.168.178."	
  ;;
  *)
	#the default for my systems
	vm_netwerk="192.168.178."	
  ;;
esac
