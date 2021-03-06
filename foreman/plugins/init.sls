{% from "foreman/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('foreman:lookup')) %}

include:
  - foreman

{% if datamap.pluginsrepo.manage|default(True) == True %}
  {% if salt['grains.get']('os_family') == 'Debian' %}
foremanplugins_repo:
  pkgrepo:
    - managed
    - name: deb {{ datamap.pluginsrepo.url }} {{ datamap.pluginsrepo.dist }} {{ datamap.pluginsrepo.comps }}
    - file: /etc/apt/sources.list.d/foremanplugins.list
    - key_url: {{ datamap.pluginsrepo.keyurl }}
  {% endif %}
{% endif %}

{% for p in datamap.plugins.manage|default([]) %}
plugin-{{ p }}: {# TODO: reload/ restart foreman #}
  pkg:
    - installed
    - name: ruby-foreman-{{ p }}
{% endfor %}
