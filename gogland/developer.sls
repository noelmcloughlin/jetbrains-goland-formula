{% from "gogland/map.jinja" import gogland with context %}

{% if gogland.prefs.user not in (None, 'undefined_user') %}

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
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ gogland.jetbrains.edition }}
    - runas: {{ gogland.prefs.user }}
    - require:
      - file: gogland-desktop-shortcut-add
   {% else %}
  file.managed:
    - source: salt://gogland/files/gogland.desktop
    - name: {{ gogland.homes }}/{{ gogland.prefs.user }}/Desktop/gogland.desktop
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
    - onlyif: test -f {{ gogland.symhome }}/{{ gogland.command }}
    - context:
      home: {{ gogland.symhome }}
      command: {{ gogland.command }}
   {% endif %}


  {% if gogland.prefs.importurl or gogland.prefs.importdir %}

gogland-prefs-importfile:
   {% if gogland.prefs.importdir %}
  file.managed:
    - onlyif: test -f {{ gogland.prefs.importdir }}/{{ gogland.prefs.myfile }}
    - name: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.myfile }}
    - source: {{ gogland.prefs.importdir }}/{{ gogland.prefs.myfile }}
    - user: {{ gogland.prefs.user }}
    - makedirs: True
        {% if salt['grains.get']('os_family') in ('Suse') %}
    - group: users
        {% elif grains.os not in ('MacOS') %}
        #inherit Darwin ownership
    - group: {{ gogland.prefs.user }}
        {% endif %}
    - if_missing: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.myfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{gogland.homes}}/{{gogland.prefs.user}}/{{gogland.prefs.myfile}} {{gogland.prefs.importurl}}
    - runas: {{ gogland.prefs.user }}
    - if_missing: {{ gogland.homes }}/{{ gogland.prefs.user }}/{{ gogland.prefs.myfile }}
   {% endif %}

  {% endif %}

{% endif %}

