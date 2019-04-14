{% from "goland/map.jinja" import goland with context %}

{% if grains.os not in ('MacOS', 'Windows',) %}

goland-home-symlink:
  file.symlink:
    - name: '{{ goland.jetbrains.home }}/goland'
    - target: '{{ goland.jetbrains.realhome }}'
    - onlyif: test -d {{ goland.jetbrains.realhome }}
    - force: True

# Update system profile with PATH
goland-config:
  file.managed:
    - name: /etc/profile.d/goland.sh
    - source: salt://goland/files/goland.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      home: '{{ goland.jetbrains.home }}/goland'

  # Linux alternatives
  {% if goland.linux.altpriority > 0 and grains.os_family not in ('Arch',) %}

# Add goland-home to alternatives system
goland-home-alt-install:
  alternatives.install:
    - name: goland-home
    - link: '{{ goland.jetbrains.home }}/goland'
    - path: '{{ goland.jetbrains.realhome }}'
    - priority: {{ goland.linux.altpriority }}
    - retry:
        attempts: 2
        until: True

goland-home-alt-set:
  alternatives.set:
    - name: goland-home
    - path: {{ goland.jetbrains.realhome }}
    - onchanges:
      - alternatives: goland-home-alt-install
    - retry:
        attempts: 2
        until: True

# Add to alternatives system
goland-alt-install:
  alternatives.install:
    - name: goland
    - link: {{ goland.linux.symlink }}
    - path: {{ goland.jetbrains.realcmd }}
    - priority: {{ goland.linux.altpriority }}
    - require:
      - alternatives: goland-home-alt-install
      - alternatives: goland-home-alt-set
    - retry:
        attempts: 2
        until: True

goland-alt-set:
  alternatives.set:
    - name: goland
    - path: {{ goland.jetbrains.realcmd }}
    - onchanges:
      - alternatives: goland-alt-install
    - retry:
        attempts: 2
        until: True

  {% endif %}

  {% if goland.linux.install_desktop_file %}
goland-global-desktop-file:
  file.managed:
    - name: {{ goland.linux.desktop_file }}
    - source: salt://goland/files/goland.desktop
    - template: jinja
    - context:
      home: {{ goland.jetbrains.realhome }}
      command: {{ goland.command }}
      edition: {{ goland.jetbrains.edition }}
    - onlyif: test -f {{ goland.jetbrains.realhome }}/{{ goland.command }}
  {% endif %}

{% endif %}
