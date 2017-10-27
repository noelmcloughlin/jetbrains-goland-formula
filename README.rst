========
gogland
========

Formula for latest gogland IDE from Jetbrains. 

.. note::
    **** THIS FORMULA IS NOT VALID YET - PENDING 1ST OFFICIAL RELEASE OF GOGLAND ****

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    
Available states
================

.. contents::
    :local:

``gogland``
------------

Downloads the archive from Jetbrains website, unpacks locally and installs to the Operating System.

.. note::

This formula automatically installs latest Jetbrains release. This behaviour may be overridden in pillars.


``gogland.developer``
------------
Create Desktop shortcuts. Optionally retrieve settings file from url/share and save to 'user' (pillar) home directory.


``gogland.linuxenv``
------------
On Linux, the PATH is set for all system users by adding software profile to /etc/profile.d/ directory. Full support for debian linuxenv in supported Linux distributions (i.e. not Archlinux).

.. note::

The linux-linuxenv 'priority' pillar value must be updated for each newly installed release/editions.


Please see the pillar.example for configuration.
To be tested on Linux (Ubuntu, Fedora, Arch, and Suse), MacOS.
