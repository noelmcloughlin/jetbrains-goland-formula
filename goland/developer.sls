{% from "goland/map.jinja" import goland with context %}

{% if goland.prefs.user %}

goland-desktop-shortcut-clean:
  file.absent:
    - name: '{{ goland.homes }}/{{ goland.prefs.user }}/Desktop/Goland'
    - require_in:
      - file: goland-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

goland-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://goland/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ goland.prefs.user }}
      homes: {{ goland.homes }}
      edition: {{ goland.jetbrains.edition }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ goland.jetbrains.edition }}
    - runas: {{ goland.prefs.user }}
    - require:
      - file: goland-desktop-shortcut-add
    - require_in:
      - file: goland-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

goland-desktop-shortcut-install:
  file.managed:
    - source: salt://goland/files/goland.desktop
    - name: {{ goland.homes }}/{{ goland.prefs.user }}/Desktop/goland{{ goland.jetbrains.edition }}.desktop
    - makedirs: True
    - user: {{ goland.prefs.user }}
       {% if goland.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ goland.prefs.group }}
       {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ goland.jetbrains.realcmd }}
    - context:
      home: {{ goland.jetbrains.realhome }}
      command: {{ goland.command }}


  {% if goland.prefs.jarurl or goland.prefs.jardir %}

goland-prefs-importfile:
  file.managed:
    - onlyif: test -f {{ goland.prefs.jardir }}/{{ goland.prefs.jarfile }}
    - name: {{ goland.homes }}/{{ goland.prefs.user }}/{{ goland.prefs.jarfile }}
    - source: {{ goland.prefs.jardir }}/{{ goland.prefs.jarfile }}
    - makedirs: True
    - user: {{ goland.prefs.user }}
       {% if goland.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ goland.prefs.group }}
       {% endif %}
    - if_missing: {{ goland.homes }}/{{ goland.prefs.user }}/{{ goland.prefs.jarfile }}
  cmd.run:
    - unless: test -f {{ goland.prefs.jardir }}/{{ goland.prefs.jarfile }}
    - name: curl -o {{goland.homes}}/{{goland.prefs.user}}/{{goland.prefs.jarfile}} {{goland.prefs.jarurl}}
    - runas: {{ goland.prefs.user }}
    - if_missing: {{ goland.homes }}/{{ goland.prefs.user }}/{{ goland.prefs.jarfile }}
  {% endif %}


{% endif %}

