#!/usr/bin/env bash
export DISPLAY=:0.0

PRIMARY=LVDS1
SECONDARY=VGA1

if [[ ! -d /var/local/monitor ]]; then
	mkdir /var/local/monitor
	echo "on" > /var/local/monitor/primary
	echo "off" > /var/local/monitor/secondary
fi

logger "monitor was plugged or unplugged"

function primary_active {
	[[ $( grep 'on' /var/local/monitor/primary ) ]]
}
function secondary_active {
	[[ $( grep 'on' /var/local/monitor/secondary ) ]]
}
function secondary_connected {
	[[ $( xrandr | grep "${SECONDARY} connected" ) ]]
}

function disable_lvds {
	xrandr --output ${PRIMARY} --off
	echo "off" > /var/local/monitor/primary
}

function enable_primary {
	logger "enabling primary monitor only"
	xrandr --output ${PRIMARY} --auto --output ${SECONDARY} --off
	echo "on" > /var/local/monitor/primary
	echo "off" > /var/local/monitor/secondary
}

function enable_secondary {
	logger "enabling secondary monitor only"

	xrandr --output ${SECONDARY} --auto --output ${PRIMARY} --off
	echo "off" > /var/local/monitor/primary
	echo "on" > /var/local/monitor/secondary
}

function dual {
	logger "enabling both monitors"
	xrandr --output ${PRIMARY} --auto --output ${SECONDARY} --auto --right-of ${PRIMARY}
	echo "on" >> /var/local/monitor/primary
	echo "on" >> /var/local/monitor/secondary
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
