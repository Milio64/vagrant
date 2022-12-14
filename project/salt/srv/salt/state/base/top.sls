#Defined states
base:
  '*':
    - all-systems
  '^(..l*)':
    - match: pcre
    - all-linux
  '^(x1*)':
    - match: pcre
    - env/x1/
  '^(..ltst)':
    - match: pcre
    - role/tst/


#voorbeelden
#  'os:(RedHat|CentOS)':
#      - match: grain_pcre
#      - repos.epel
#  'foo,bar,baz':
#      - match: list
#      - database
#  'somekey:abc':
#      - match: pillar
#      - xyz
#  'nag1* or G@role:monitoring':
#      - match: compound
#      - nagios.server
