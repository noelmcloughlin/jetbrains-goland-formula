{% from "gogland/map.jinja" import gogland with context %}

{% if grains.os not in ('MacOS', 'Windows',) %}

gogland-home-symlink:
  file.symlink:
    - name: '{{ gogland.jetbrains.home }}/gogland'
    - target: '{{ gogland.jetbrains.realhome }}'
    - onlyif: test -d {{ gogland.jetbrains.realhome }}
    - force: True

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
      home: '{{ gogland.jetbrains.home }}/gogland'

  # Debian alternatives
  {% if gogland.linux.altpriority > 0 %}
     {% if grains.os_family not in ('Arch',) %}

# Add gogland-home to alternatives system
gogland-home-alt-install:
  alternatives.install:
    - name: gogland-home
    - link: '{{ gogland.jetbrains.home }}/gogland'
    - path: '{{ gogland.jetbrains.realhome }}'
    - priority: {{ gogland.linux.altpriority }}

gogland-home-alt-set:
  alternatives.set:
    - name: goglandhome
    - path: {{ gogland.jetbrains.realhome }}
    - onchanges:
      - alternatives: gogland-home-alt-install

# Add intelli to alternatives system
gogland-alt-install:
  alternatives.install:
    - name: gogland
    - link: {{ gogland.linux.symlink }}
    - path: {{ gogland.jetbrains.realcmd }}
    - priority: {{ gogland.linux.altpriority }}
    - require:
      - alternatives: gogland-home-alt-install
      - alternatives: gogland-home-alt-set

gogland-alt-set:
  alternatives.set:
    - name: gogland
    - path: {{ gogland.jetbrains.realcmd }}
    - onchanges:
      - alternatives: gogland-alt-install

     {% endif %}
  {% endif %}

{% endif %}
