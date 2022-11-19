{% set name = salt.pillar.get('name') %}
/root/state.base.welcome.txt:
  file.managed:
    - user: root
    - group: root
    - mode: 777
    - contents: |
        LET OP dubbel inspringen na "contents"

check_pillar_values:
  test.check_pillar:
    - present:
      - name
    - failhard: True

welcome_page:
  file.managed:
    - name: /var/www/html/index.html
    - contents: |
        <!doctype html>
        <body>
            <h1>Hello, {{ name }}.</h1>
        </body>
