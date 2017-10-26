{% from "gogland/map.jinja" import gogland with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

  {% if grains.os_family not in ('Arch') %}

# Add pyCharmhome to alternatives system
gogland-home-alt-install:
  alternatives.install:
    - name: goglandhome
    - link: {{ gogland.symhome }}
    - path: {{ gogland.alt.realhome }}
    - priority: {{ gogland.alt.priority }}

gogland-home-alt-set:
  alternatives.set:
    - name: goglandhome
    - path: {{ gogland.alt.realhome }}
    - onchanges:
      - alternatives: gogland-home-alt-install

# Add to alternatives system
gogland-alt-install:
  alternatives.install:
    - name: gogland
    - link: {{ gogland.symlink }}
    - path: {{ gogland.alt.realcmd }}
    - priority: {{ gogland.alt.priority }}
    - require:
      - alternatives: gogland-home-alt-install
      - alternatives: gogland-home-alt-set

gogland-alt-set:
  alternatives.set:
    - name: gogland
    - path: {{ gogland.alt.realcmd }}
    - onchanges:
      - alternatives: gogland-alt-install

  {% endif %}

{% endif %}
