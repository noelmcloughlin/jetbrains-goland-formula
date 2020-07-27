# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}

goland-macos-app-clean-files:
  file.absent:
    - names:
      - {{ goland.dir.tmp }}
                  {%- if grains.os == 'MacOS' %}
      - {{ goland.dir.path }}/{{ goland.pkgoland.name }}*{{ goland.edition }}*.app
                  {%- else %}
      - {{ goland.dir.path }}
                  {%- endif %}

    {%- else %}

goland-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The goland macpackage is only available on MacOS

    {%- endif %}
