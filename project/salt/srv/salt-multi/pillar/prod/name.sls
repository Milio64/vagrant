{% set lookup = {
    'x1lsql101': "dit is minion1 ",
    'salt': "dit is salt master",
    'x1ltst101': "bla bla"
} %}
{% set name = lookup[grains.id] %}

name: {{ name }}
#name1: {{ name | json() }}
