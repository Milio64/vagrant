/root/state.base.all-linux.txt:
  file.managed:
    - user: root
    - group: root
    - mode: 777
    - contents: |
        LET OP dubbel inspringen na "contents"
      
      