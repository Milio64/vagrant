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

#ECDSA key fingerprint is SHA256:OlU04fBH8I7g94t38Y6x05UVtiBKkt2ZUKBABDsIKw0