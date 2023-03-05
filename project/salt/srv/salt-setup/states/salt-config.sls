
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
