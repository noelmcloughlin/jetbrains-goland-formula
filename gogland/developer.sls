{% from "gogland/map.jinja" import gogland with context %}

{% if gogland.prefs.user %}

gogland-desktop-shortcut-clean:
  file.absent:
    - name: '{{ gogland.homes }}/{{ gogland.prefs.user }}/Desktop/Gogland'
    - require_in:
      - file: gogland-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

gogland-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://gogland/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ gogland.prefs.user }}
      homes: {{ gogland.homes }}
      edition: {{ gogland.jetbrains.edition }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ gogland.jetbrains.edition }}
    - runas: {{ gogland.prefs.user }}
    - require:
      - file: gogland-desktop-shortcut-add
    - require_in:
      - file: gogland-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

gogland-desktop-shortcut-install:
  file.managed:
    - source: salt://gogland/files/gogland.desktop
    - name: {{ gogland.homes }}/{{ gogland.prefs.user }}/Desktop/gogland{{ gogland.jetbrains.edition }}.desktop
    - makedirs: True
    - user: {{ gogland.prefs.user }}
       {% if gogland.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ gogland.prefs.group }}
       {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ gogland.jetbrains.realcmd }}
    - context:
      home: {{ gogland.jetbrains.realhome }}
      command: {{ gogland.command }}


  {% if gogland.prefs.jarurl or gogland.prefs.jardir %}

gogland-prefs-importfile:
  file.managed:
    - onlyif: test -f {{ gogland.prefs.jardir }}/{{ gogland.prefs.jarfile }}
    - name: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.jarfile }}
    - source: {{ gogland.prefs.jardir }}/{{ gogland.prefs.jarfile }}
    - makedirs: True
    - user: {{ gogland.prefs.user }}
       {% if gogland.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ gogland.prefs.group }}
       {% endif %}
    - if_missing: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.jarfile }}
  cmd.run:
    - unless: test -f {{ gogland.prefs.jardir }}/{{ gogland.prefs.jarfile }}
    - name: curl -o {{gogland.homes}}/{{gogland.prefs.user}}/{{gogland.prefs.jarfile}} {{gogland.prefs.jarurl}}
    - runas: {{ gogland.prefs.user }}
    - if_missing: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.jarfile }}
  {% endif %}


{% endif %}

