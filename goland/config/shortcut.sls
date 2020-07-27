# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if goland.linux.install_desktop_file and grains.os not in ('MacOS',) %}
    {%- if goland.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

goland-config-file-file-managed-desktop-shortcut_file:
  file.managed:
    - name: {{ goland.linux.desktop_file }}
    - source: {{ files_switch(['shortcut.desktop.jinja'],
                              lookup='goland-config-file-file-managed-desktop-shortcut_file'
                 )
              }}
    - mode: 644
    - user: {{ goland.identity.user }}
    - makedirs: True
    - template: jinja
    - context:
      command: {{ goland.command|json }}
                        {%- if grains.os == 'MacOS' %}
      edition: {{ '' if 'edition' not in goland else goland.edition|json }}
      appname: {{ goland.dir.path }}/{{ goland.pkg.name }}
                        {%- else %}
      edition: ''
      appname: {{ goland.dir.path }}
    - onlyif: test -f "{{ goland.dir.path }}/{{ goland.command }}"
                        {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
