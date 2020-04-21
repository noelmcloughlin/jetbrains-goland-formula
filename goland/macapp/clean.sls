# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}

goland-macos-app-clean-files:
  file.absent:
    - names:
      - {{ goland.dir.tmp }}
      - /Applications/{{ goland.pkg.name }}{{ ' %sE'|format(goland.edition) if goland.edition else '' }}.app

    {%- else %}

goland-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The goland macpackage is only available on MacOS

    {%- endif %}
