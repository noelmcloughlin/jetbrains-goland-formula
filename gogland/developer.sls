{% from "gogland/map.jinja" import gogland with context %}

{% if gogland.prefs.user not in (None, 'undfined', 'undefined_user') %}

  {% if grains.os == 'MacOS' %}
gogland-desktop-shortcut-clean:
  file.absent:
    - name: '{{ gogland.homes }}/{{ gogland.prefs.user }}/Desktop/Gogland'
    - require_in:
      - file: gogland-desktop-shortcut-add
  {% endif %}

gogland-desktop-shortcut-add:
  {% if grains.os == 'MacOS' %}
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://gogland/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ gogland.prefs.user }}
      homes: {{ gogland.homes }}
      edition: {{ gogland.jetbrains.edition }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ gogland.jetbrains.edition }}
    - runas: {{ gogland.prefs.user }}
    - require:
      - file: gogland-desktop-shortcut-add
   {% else %}
   #Linux
  file.managed:
    - source: salt://gogland/files/gogland.desktop
    - name: {{ gogland.homes }}/{{ gogland.prefs.user }}/Desktop/gogland{{ gogland.jetbrains.edition }}.desktop
    - user: {{ gogland.prefs.user }}
    - makedirs: True
      {% if salt['grains.get']('os_family') in ('Suse') %} 
    - group: users
      {% else %}
    - group: {{ gogland.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ gogland.jetbrains.realcmd }}
    - context:
      home: {{ gogland.jetbrains.realhome }}
      command: {{ gogland.command }}
   {% endif %}


  {% if gogland.prefs.jarurl or gogland.prefs.jardir %}

gogland-prefs-importfile:
   {% if gogland.prefs.jardir %}
  file.managed:
    - onlyif: test -f {{ gogland.prefs.jardir }}/{{ gogland.prefs.jarfile }}
    - name: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.jarfile }}
    - source: {{ gogland.prefs.jardir }}/{{ gogland.prefs.jarfile }}
    - user: {{ gogland.prefs.user }}
    - makedirs: True
        {% if grains.os_family in ('Suse') %}
    - group: users
        {% elif grains.os not in ('MacOS') %}
        #inherit Darwin ownership
    - group: {{ gogland.prefs.user }}
        {% endif %}
    - if_missing: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.jarfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{gogland.homes}}/{{gogland.prefs.user}}/{{gogland.prefs.jarfile}} {{gogland.prefs.jarurl}}
    - runas: {{ gogland.prefs.user }}
    - if_missing: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.jarfile }}
   {% endif %}

  {% endif %}

{% endif %}

