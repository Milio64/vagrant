#Vagrant boxes om te installeren
#https://app.vagrantup.com/boxes/search
#hieruit nieuwe vagrant file bouwen win/linux verschillen met start scripts en.......
Vagrant.configure("2") do |config|
  config.vm.define "salt" do |node|
    node.vm.box =  "generic/rocky8"
    node.vm.hostname = "salt"
    node.vm.network "public_network", bridge: "networkcard", ip: "192.168.1.30"
    node.vm.provision "shell", inline: <<-SHELL
      #use parameter to call installscript for product X
      sudo sh /vagrant/vagrantsetup1.sh salt .localdomain
    SHELL
    node.vm.provider "virtualbox" do |vmvbox|
      vmvbox.memory = "2048"
      vmvbox.cpus = 2
    end
  end
  
  config.vm.define "x1ltst001" do |node|
    node.vm.box =  "generic/rocky8"
    node.vm.hostname = "x1ltst001"
    node.vm.network "public_network", bridge: "networkcard", ip: "192.168.1.31"
    node.vm.provision "shell", inline: <<-SHELL
      #use parameter to call installscript for product X
      sudo sh /vagrant/vagrantsetup1.sh salt .localdomain
    SHELL
    node.vm.provider "virtualbox" do |vmvbox|
      vmvbox.memory = "512"
      vmvbox.cpus = 1
    end
  end
  
  config.vm.define "x1lsql002" do |node|
    node.vm.box =  "generic/opensuse15"
    node.vm.hostname = "x1lsql002"
    node.vm.network "public_network", bridge: "networkcard", ip: "192.168.1.32"
    node.vm.provision "shell", inline: <<-SHELL
      #use parameter to call installscript for product X
      sudo sh /vagrant/vagrantsetup1.sh salt .localdomain
    SHELL
    node.vm.provider "virtualbox" do |vmvbox|
      vmvbox.memory = "512"
      vmvbox.cpus = 1
    end
  end
  
  
  #https://www.vagrantup.com/docs/synced-folders/basic_usage
  config.vm.synced_folder "./vagrant", "/vagrant", enable: true
end
