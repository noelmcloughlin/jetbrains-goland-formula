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
        appname: {{ goland.pkg.name }}
        edition: {{ '' if 'edition' not in goland else goland.edition|json }}
        command: {{ goland.command|json }}
              {%- if goland.pkg.use_upstream_macapp %}
        path: {{ goland.pkg.macapp.path }}
    - onlyif: test -f "{{ goland.pkg.macapp.path }}/{{ goland.command }}"
              {%- else %}
        path: {{ goland.pkg.archive.path }}
    - onlyif: test -f {{ goland.pkg.archive.path }}/{{ goland.command }}
              {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
