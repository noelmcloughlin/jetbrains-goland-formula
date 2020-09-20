# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if goland.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}
    {%- if grains.os != 'Windows' %}

include:
  - {{ sls_package_install }}

goland-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ goland.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='goland-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ goland.identity.rootuser }}
    - group: {{ goland.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      environ: {{ goland.environ|json }}
                      {%- if goland.pkg.use_upstream_macapp %}
      edition:  {{ '' if not goland.edition else ' %sE'|format(goland.edition) }}.app/Contents/MacOS
      appname: {{ goland.dir.path }}/{{ goland.pkg.name }}
                      {%- else %}
      edition: ''
      appname: {{ goland.dir.path }}/bin
                      {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
