Introduction
------------

This script will automatically activate an external monitor when you connect
it, disable it when you disconnect it. You get the point...

Additionally it adds a call to the ACPI handler in /etc/acpi/handler.sh that
maps the Switchdisplay-button to this script.


Usage
-----

Check monitor-hotplug.sh for the actual names of your devices. LVDS1 and VGA1
are the names in my setup.

To install this script, the ACPI handler and udev rule:

    $ sudo make install

Don't like this script?

    $ sudo make uninstall

From now on:

* your external monitor will be enabled when you connect it
* your external monitor will be disabled (and internal enabled) when you
  disconnect it
* when you press the output-switch-button-thingie on your laptop you will
  switch between dual-mode and external only.


Disclaimer
----------

If you use this script, your computer may eat your face or other terrible
things might happen. You know the drill, don't you?
