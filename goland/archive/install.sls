# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

goland-package-archive-install:
              {%- if grains.os == 'Windows' %}
  chocolatey.installed:
    - force: False
              {%- else %}
  pkg.installed:
              {%- endif %}
    - names: {{ goland.pkg.deps|json }}
    - require_in:
      - file: goland-package-archive-install

              {%- if goland.flavour|lower == 'windows' %}

  file.managed:
    - name: {{ goland.dir.tmp }}/goland.exe
    - source: {{ goland.pkg.archive.source }}
    - makedirs: True
    - source_hash: {{ goland.pkg.archive.source_hash }}
    - force: True
  cmd.run:
    - name: {{ goland.dir.tmp }}/goland.exe
    - require:
      - file: goland-package-archive-install

              {%- else %}

  file.directory:
    - name: {{ goland.dir.path }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: goland-package-archive-install
                 {%- if grains.os != 'Windows' %}
    - user: {{ goland.identity.rootuser }}
    - group: {{ goland.identity.rootgroup }}
    - recurse:
        - user
        - group
        - mode
                 {%- endif %}
  archive.extracted:
    {{- format_kwargs(goland.pkg.archive) }}
    - retry: {{ goland.retry_option|json }}
                 {%- if grains.os != 'Windows' %}
    - user: {{ goland.identity.rootuser }}
    - group: {{ goland.identity.rootgroup }}
    - recurse:
        - user
        - group
                 {%- endif %}
    - require:
      - file: goland-package-archive-install

              {%- endif %}
              {%- if grains.kernel|lower == 'linux' and goland.linux.altpriority|int == 0 %}

goland-archive-install-file-symlink-goland:
  file.symlink:
    - name: /usr/local/bin/{{ goland.command }}
    - target: {{ goland.dir.path }}/{{ goland.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: goland-package-archive-install

              {%- elif goland.flavour|lower == 'windowszip' %}

goland-archive-install-file-shortcut-goland:
  file.shortcut:
    - name: C:\Users\{{ goland.identity.rootuser }}\Desktop\{{ goland.dirname }}.lnk
    - target: {{ goland.dir.archive }}\{{ goland.dirname }}\{{ goland.command }}
    - working_dir: {{ goland.dir.archive }}\{{ goland.dirname }}\bin
    - icon_location: {{ goland.dir.archive }}\{{ goland.dirname }}\bin\goland.ico
    - makedirs: True
    - force: True
    - user: {{ goland.identity.rootuser }}
    - require:
      - archive: goland-package-archive-install

              {%- endif %}
