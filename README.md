# vagrant
This is my setup for a quick test environments within a Vagrant.

If i work on a windows machine but the setup can also be used on linux system.
First install:
virualbox, vagrant, mobaxterm, gitbash
From a Mobaxterm terminal i call "start.sh projectname"

Goal:
Quick start on all my systems the same environment.
but take care they never get in each others way

Workflow:
- copy "vagrantfile.template" file
- replace the "keywords" in the "vagrantfile" with "sed".
- Make sure the systems IP numbers are known if i start the virtual machine. (VM)
- Start a install script on the newly created VM's

Testen for: 
-salt/stack (works)
-Ansible (I must add a windows system for testing to)
-puppet (works for 'rocky8 and debian" sles in progress)

Greetings Milio
