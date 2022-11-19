#core.sls file in pillars\base
#Default os voor productie systemen is SLES
#We administreren alleen de uitzonderingen...

omgeving: base

#waarde een tweede keer defineren gaat fout!
#info: some data
packages:
  - git
  - htop
  - mc


{% if salt.grains.get('os_family') == 'Suse' %}
info: some data
packages-extra:
  - vim
{% endif %}


{% if salt.grains.get('os_family') == 'RedHat' %}
info: some extra data
packages-extra:
  - vim-enhanced

{% endif %}
