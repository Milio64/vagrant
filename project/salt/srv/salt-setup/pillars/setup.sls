dir_config: /etc/salt/master.d
git_server: ssh://root@192.168.178.136:/volume1/git-repos
dir_base: /srv/salt-nas
dir_type:
  - states
  - pillars

environments: d1
#uitzondering voor een node
###########################################################################################################
{% if salt.grains.get('host') == 'salt-master2' %}
roles: lsal
{% endif %}

{% if salt.grains.get('host') == 'dltst302' %}
roles: ltst
{% endif %}

{% if salt.grains.get('host') == 'd1lsql002' %}
roles: lsql
{% endif %}
