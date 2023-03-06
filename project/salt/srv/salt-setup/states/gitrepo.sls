GIT_install:
  pkg.installed:
    - name: git


{% for type in pillar.get('dir_type', {}) %}
GIT_{{type}}:
  git.cloned:
    - name: {{ pillar['git_server'] }}/{{type}}
    - target: {{ pillar['dir_base'] }}/{{type}}/base
    - identity: /root/.ssh/id_rsa
    - branch: base
    #- force_checkout: True
    #- force_reset: True
   
{% endfor %}

