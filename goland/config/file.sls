# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'config' in goland and goland.config and goland.config_file %}
    {%- if goland.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}
    {%- if grains.os != 'Windows' %}

include:
  - {{ sls_package_install }}

goland-config-file-managed-config_file:
  file.managed:
    - name: {{ goland.config_file }}
    - source: {{ files_switch(['file.default.jinja'],
                              lookup='goland-config-file-file-managed-config_file'
                 )
              }}
    - mode: 640
    - user: {{ goland.identity.rootuser }}
    - group: {{ goland.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      config: {{ goland.config|json }}
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
{%- endif %}
