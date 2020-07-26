# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}

goland-macos-app-install-curl:
  file.directory:
    - name: {{ goland.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ goland.dir.tmp }}/goland-{{ goland.version }} "{{ goland.pkg.macapp.source }}"
    - unless: test -f {{ goland.dir.tmp }}/goland-{{ goland.version }}
    - require:
      - file: goland-macos-app-install-curl
      - pkg: goland-macos-app-install-curl
    - retry: {{ goland.retry_option|json }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
goland-macos-app-install-checksum:
  module.run:
    - onlyif: {{ goland.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ goland.dir.tmp }}/goland-{{ goland.version }}
    - file_hash: {{ goland.pkg.macapp.source_hash }}
    - require:
      - cmd: goland-macos-app-install-curl
    - require_in:
      - macpackage: goland-macos-app-install-macpackage
  file.absent:
    - name: {{ goland.dir.tmp }}/goland-{{ goland.version }}
    - onfail:
      - module: goland-macos-app-install-checksum

goland-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ goland.dir.tmp }}/goland-{{ goland.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: goland-macos-app-install-curl
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://goland/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      appname: {{ goland.pkg.name }}
      edition: {{ '' if 'edition' not in goland else goland.edition }}
      user: {{ goland.identity.user }}
      homes: {{ goland.dir.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ goland.identity.user }}
    - require:
      - file: goland-macos-app-install-macpackage

    {%- else %}

goland-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The goland macpackage is only available on MacOS

    {%- endif %}
