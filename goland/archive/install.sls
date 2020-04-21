# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

goland-package-archive-install:
  pkg.installed:
    - names: {{ goland.pkg.deps|json }}
    - require_in:
      - file: goland-package-archive-install
  file.directory:
    - name: {{ goland.pkg.archive.path }}
    - user: {{ goland.identity.rootuser }}
    - group: {{ goland.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: goland-package-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(goland.pkg.archive) }}
    - retry: {{ goland.retry_option|json }}
    - user: {{ goland.identity.rootuser }}
    - group: {{ goland.identity.rootgroup }}
    - recurse:
        - user
        - group
    - require:
      - file: goland-package-archive-install

    {%- if goland.linux.altpriority|int == 0 %}

goland-archive-install-file-symlink-goland:
  file.symlink:
    - name: /usr/local/bin/goland
    - target: {{ goland.pkg.archive.path }}/{{ goland.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: goland-package-archive-install

    {%- endif %}
