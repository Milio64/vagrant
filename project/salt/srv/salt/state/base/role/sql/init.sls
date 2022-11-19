/root/role.txt:
  file.managed:
    - user: root
    - group: root
    - mode: 777
    - contents: |
        #LET OP dubbel inspringen na "contents"
        Dit is environment file van "role sql"
