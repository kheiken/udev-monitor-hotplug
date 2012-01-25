#!/usr/bin/env bash
#
# monitor-hotplug.sh -- Automatically manage external monitors upon connection.
#
# Copyright 2012 Karsten Heiken, karsten -at- disposed.de
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

export DISPLAY=:0.0

PRIMARY=LVDS1
SECONDARY=VGA1

if [[ ! -d /tmp/monitor-hotplug ]]; then
	mkdir /tmp/monitor-hotplug
	echo "on" > /tmp/monitor-hotplug/primary
	echo "off" > /tmp/monitor-hotplug/secondary
fi

logger "monitor was plugged or unplugged"

function primary_active {
	[[ $( grep 'on' /tmp/monitor-hotplug/primary ) ]]
}
function secondary_active {
	[[ $( grep 'on' /tmp/monitor-hotplug/secondary ) ]]
}
function secondary_connected {
	[[ $( xrandr | grep "${SECONDARY} connected" ) ]]
}

function disable_lvds {
	xrandr --output ${PRIMARY} --off
	echo "off" > /tmp/monitor-hotplug/primary
}

function enable_primary {
	logger "enabling primary monitor only"
	xrandr --output ${PRIMARY} --auto --output ${SECONDARY} --off
	echo "on" > /tmp/monitor-hotplug/primary
	echo "off" > /tmp/monitor-hotplug/secondary
}

function enable_secondary {
	logger "enabling secondary monitor only"

	xrandr --output ${SECONDARY} --auto --output ${PRIMARY} --off
	echo "off" > /tmp/monitor-hotplug/primary
	echo "on" > /tmp/monitor-hotplug/secondary
}

function dual {
	logger "enabling both monitors"
	xrandr --output ${PRIMARY} --auto --output ${SECONDARY} --auto --right-of ${PRIMARY}
	echo "on" >> /tmp/monitor-hotplug/primary
	echo "on" >> /tmp/monitor-hotplug/secondary
}

if secondary_connected; then
	if primary_active && secondary_active; then
		enable_secondary
	elif primary_active && ! secondary_active; then
		enable_secondary
	elif ! primary_active && secondary_active; then
		dual
	else
		logger "fallback: enabling primary only"
		enable_primary
	fi
else
	logger "no secondary monitor connected"
	enable_primary
fi
