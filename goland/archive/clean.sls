# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}

goland-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ goland.dir.tmp }}
              {%- if grains.os == 'MacOS' %}
      - {{ goland.dir.path }}/{{ goland.pkg.name }}*{{ goland.edition }}*.app
              {%- else %}
      - {{ goland.dir.path }}
              {%- endif %}
