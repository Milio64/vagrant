# vagrant
This is my setup for a quick test environments within a Vagrant.

If i work on a windows machine
I always install software on my windows machines:
virualbox, vagrant, mobaxterm, gitbash
From a Mobaxterm terminal i call "start.sh"

Goal:
Quick start on all my systems the same environment.
but take care they never get in each others way

Workflow:
- copy "vagrantfile.template" file
- replace the "keywords" in the "vagrantfile" with "sed".
- Make sure the systems IP numbers are known if i start the virtual machine. (VM)
- Start a install script on the VM's

Testen for: 
-salt/stack
  (I have a private repository for salt states/pillars where i working on)
-Ansible (I must add a windows system for testing to)
-puppet (work in progress)



Allert!
Some vagrant boxes make a keyfile in: /.vagrant/machines/host/virtualbox/private_key
