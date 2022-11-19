/root/role.txt:
  file.managed:
    - user: root
    - group: root
    - mode: 777
    - contents: |
        #LET OP dubbel inspringen na "contents"
        Dit is environment file van "role tst"
#vim:                    # ID declaration
#  pkg:                  # state declaration
#    - installed         # function declaration


{% if salt.grains.get('os_family') == 'Suse' %}
vim:                    # ID declaration
  pkg:                  # state declaration
    - installed         # function declaration
{% endif %}
{% if salt.grains.get('os_family') == 'RedHat' %}
vim-enhanced:           # ID declaration
  pkg:                  # state declaration
    - installed         # function declaration
{% endif %}
