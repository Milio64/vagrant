#Defined multie states in base 
base:
  '*':
      - all-systems
  '^..l*':
    - match: pcre
    - all-linux
  '^x1*':
    - match: pcre
    - env/x1/
  '^..ltst*':
    - match: pcre
    - role/tst/
  '^..lsql*':
    - match: pcre
    - role/sql/

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
