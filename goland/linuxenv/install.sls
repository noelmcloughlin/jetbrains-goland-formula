# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

goland-linuxenv-home-file-symlink:
  file.symlink:
    - name: /opt/goland
    - target: {{ goland.pkg.archive.path }}
    - onlyif: test -d '{{ goland.pkg.archive.path }}'
    - force: True

        {% if goland.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

goland-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: golandhome
    - link: /opt/goland
    - path: {{ goland.pkg.archive.path }}
    - priority: {{ goland.linux.altpriority }}
    - retry: {{ goland.retry_option|json }}

goland-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: golandhome
    - path: {{ goland.pkg.archive.path }}
    - onchanges:
      - alternatives: goland-linuxenv-home-alternatives-install
    - retry: {{ goland.retry_option|json }}

goland-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: goland
    - link: {{ goland.linux.symlink }}
    - path: {{ goland.pkg.archive.path }}/{{ goland.command }}
    - priority: {{ goland.linux.altpriority }}
    - require:
      - alternatives: goland-linuxenv-home-alternatives-install
      - alternatives: goland-linuxenv-home-alternatives-set
    - retry: {{ goland.retry_option|json }}

goland-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: goland
    - path: {{ goland.pkg.archive.path }}/{{ goland.command }}
    - onchanges:
      - alternatives: goland-linuxenv-executable-alternatives-install
    - retry: {{ goland.retry_option|json }}

        {%- else %}

goland-linuxenv-alternatives-install-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (goland.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
