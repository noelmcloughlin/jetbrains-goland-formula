# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}

   {%- if goland.pkg.use_upstream_macapp %}
       {%- set sls_package_clean = tplroot ~ '.macapp.clean' %}
   {%- else %}
       {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
   {%- endif %}

include:
  - {{ sls_package_clean }}

goland-config-clean-file-absent:
  file.absent:
    - names:
      - /tmp/dummy_list_item
               {%- if goland.config_file and goland.config %}
      - {{ goland.config_file }}
               {%- endif %}
               {%- if goland.environ_file %}
      - {{ goland.environ_file }}
               {%- endif %}
               {%- if grains.kernel|lower == 'linux' %}
      - {{ goland.linux.desktop_file }}
               {%- elif grains.os == 'MacOS' %}
      - {{ goland.dir.homes }}/{{ goland.identity.user }}/Desktop/{{ goland.pkg.name }}*{{ goland.edition }}*
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean }}
