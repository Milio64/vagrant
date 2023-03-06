#Thuis heb ik op het moment slechts 1 envirionment en role
#Als ik test systeem toevoeg altijd file aanmaken.
SALT GRAINS thuis:
  file.managed:
    - name: /etc/salt/grains
    - user: root
    - group: root
    - mode: 600
    - contents: |
        environments:
          - d1
        roles:
          - {{ pillar['roles'] }}

{% set delay = salt['config.get']('minion_restart_in_seconds', 5) %}
restart-the-minion:
  #https://gist.github.com/vernondcole/090048cc24c3e1d84fd2c283347bd6fa
  file.managed:
    - name: /tmp/run_command_later.py
    - source: salt://run_command_later.py
    - mode: 775
  cmd.run:
    - require:
      - file: restart-the-minion
    - order: last
    - name: "/tmp/run_command_later.py {{ delay }} systemctl restart salt-minion"
    - bg: true  {# do not wait for completion of this command #}
    - watch:
       - file: /etc/salt/grains    
