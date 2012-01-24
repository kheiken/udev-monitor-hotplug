install:
	install -m 644 -o root -g root 99_monitor-hotplug.rules /etc/udev/rules.d/
	install -m 744 -o root -g root monitor-hotplug.sh /usr/local/bin/
	patch -p1 /etc/acpi/handler.sh acpi_handler.patch

uninstall:
	rm /etc/udev/rules.d/99_monitor-hotplug.rules
	rm /usr/local/bin/monitor-hotplug.sh
	patch -R -p1 /etc/acpi/handler.sh acpi_handler.patch
