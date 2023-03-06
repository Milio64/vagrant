
SALTMASTER CONFIG:
  file.managed:
    - name: {{ pillar['dir_config'] }}/git-nas.conf
    - user: root
    - group: root
    - mode: 644
    - contents: |
        file_roots:
          base:
            - {{ pillar['dir_base'] }}/state/base

        pillar_roots:
          base:
            - {{ pillar['dir_base'] }}/pillar/base

Remove setup config:
  file.absent:
    - name: {{ pillar['dir_config'] }}/salt-setup.conf
    
{% set delay = salt['config.get']('master_restart_in_seconds', 5) %}
restart-the-master:
  #https://gist.github.com/vernondcole/090048cc24c3e1d84fd2c283347bd6fa
  file.managed:
    - name: /tmp/run_command_later.py
    - source: salt://run_command_later.py
    - mode: 775
  cmd.run:
    - require:
      - file:  /tmp/run_command_later.py
    - order: last
    - name: "/tmp/run_command_later.py {{ delay }} systemctl restart salt-master"
    - bg: true  {# do not wait for completion of this command #}
    - watch:
       - file: {{ pillar['dir_config'] }}/git-nas.conf
