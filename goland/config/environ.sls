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
              {%- if goland.pkg.use_upstream_macapp %}
        path: '/Applications/{{ goland.pkg.name }}{{ '\ %sE'|format(goland.edition) }}.app/Contents/MacOS'
              {%- else %}
        path: {{ goland.pkg.archive.path }}/bin
              {%- endif %}
        environ: {{ goland.environ|json }}
    - require:
      - sls: {{ sls_package_install }}
