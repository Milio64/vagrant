#onderstaande gaat fout als minion niet gedefineerd is in deze tabel.
{% set lookup = {
    'x1lsql002': "dit is minion1 ",
    'salt': "dit is salt master",
    'x1ltst001': "nog iets",
    '*': "defaul waarde, dit werkt niet"
} %}

{% set name = lookup[grains.id] %}

name: {{ name }}
#name1: {{ name | json() }}
