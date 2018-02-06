{% from "goland/map.jinja" import goland with context %}

# Cleanup first
goland-remove-prev-archive:
  file.absent:
    - name: '{{ goland.tmpdir }}/{{ goland.dl.archive_name }}'
    - require_in:
      - goland-extract-dirs

goland-extract-dirs:
  file.directory:
    - names:
      - '{{ goland.tmpdir }}'
{% if grains.os not in ('MacOS', 'Windows',) %}
      - '{{ goland.jetbrains.realhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
    - clean: True
    - require_in:
      - goland-download-archive

goland-download-archive:
  cmd.run:
    - name: curl {{ goland.dl.opts }} -o '{{ goland.tmpdir }}/{{ goland.dl.archive_name }}' {{ goland.dl.source_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ goland.dl.retries }}
        interval: {{ goland.dl.interval }}
      {% endif %}

{%- if goland.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS',) %}
goland-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ goland.tmpdir }}/{{ goland.dl.archive_name }}'
     - file_hash: {{ goland.dl.src_hashsum }}
     - onchanges:
       - cmd: goland-download-archive
     - require_in:
       - archive: goland-package-install
  {%- endif %}
{%- endif %}

goland-package-install:
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ goland.tmpdir }}/{{ goland.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  # Linux
  archive.extracted:
    - source: 'file://{{ goland.tmpdir }}/{{ goland.dl.archive_name }}'
    - name: '{{ goland.jetbrains.realhome }}'
    - archive_format: {{ goland.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ goland.dl.unpack_opts }}
    - if_missing: '{{ goland.jetbrains.realcmd }}'
       {% else %}
    - options: {{ goland.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if goland.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ goland.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: goland-download-archive
    - require_in:
      - goland-remove-archive

goland-remove-archive:
  file.absent:
    - name: '{{ goland.tmpdir }}'
    - onchanges:
{%- if grains.os in ('Windows',) %}
      - pkg: goland-package-install
{%- elif grains.os in ('MacOS',) %}
      - macpackage: goland-package-install
{% else %}
      #Unix
      - archive: goland-package-install

{% endif %}
