{% from "gogland/map.jinja" import gogland with context %}

# Cleanup first
gogland-remove-prev-archive:
  file.absent:
    - name: '{{ gogland.tmpdir }}/{{ gogland.dl.archive_name }}'
    - require_in:
      - gogland-install-dir

gogland-install-dir:
  file.directory:
    - names:
      - '{{ gogland.alt.realhome }}'
      - '{{ gogland.tmpdir }}'
{% if grains.os not in ('MacOS', 'Windows') %}
      - '{{ gogland.prefix }}'
      - '{{ gogland.symhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
    - require_in:
      - gogland-download-archive

gogland-download-archive:
  cmd.run:
    - name: curl {{ gogland.dl.opts }} -o '{{ gogland.tmpdir }}/{{ gogland.dl.archive_name }}' {{ gogland.dl.source_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ gogland.dl.retries }}
        interval: {{ gogland.dl.interval }}
      {% endif %}

{% if grains.os not in ('MacOS') %}
gogland-unpacked-dir:
  file.directory:
    - name: '{{ gogland.alt.realhome }}'
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - force: True
    - onchanges:
      - cmd: gogland-download-archive
{% endif %}

{%- if gogland.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS') %}
gogland-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ gogland.tmpdir }}/{{ gogland.dl.archive_name }}'
     - file_hash: {{ gogland.dl.src_hashsum }}
     - onchanges:
       - cmd: gogland-download-archive
     - require_in:
       - archive: gogland-package-install
  {%- endif %}
{%- endif %}

gogland-package-install:
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ gogland.tmpdir }}/{{ gogland.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  archive.extracted:
    - source: 'file://{{ gogland.tmpdir }}/{{ gogland.dl.archive_name }}'
    - name: '{{ gogland.alt.realhome }}'
    - archive_format: {{ gogland.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ gogland.dl.unpack_opts }}
    - if_missing: '{{ gogland.alt.realcmd }}'
       {% else %}
    - options: {{ gogland.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if gogland.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ gogland.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: gogland-download-archive
    - require_in:
      - gogland-remove-archive

gogland-remove-archive:
  file.absent:
    - names:
      # todo: maybe just delete the tmpdir itself
      - '{{ gogland.tmpdir }}/{{ gogland.dl.archive_name }}'
      - '{{ gogland.tmpdir }}/{{ gogland.dl.archive_name }}.sha256'
    - onchanges:
{%- if grains.os in ('Windows') %}
      - pkg: gogland-package-install
{%- elif grains.os in ('MacOS') %}
      - macpackage: gogland-package-install
{% else %}
      - archive: gogland-package-install

gogland-home-symlink:
  file.symlink:
    - name: '{{ gogland.symhome }}'
    - target: '{{ gogland.alt.realhome }}'
    - force: True
    - onchanges:
      - archive: gogland-package-install

# Update system profile with PATH
gogland-config:
  file.managed:
    - name: /etc/profile.d/gogland.sh
    - source: salt://gogland/files/gogland.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      gogland_home: '{{ gogland.symhome }}'

{% endif %}
