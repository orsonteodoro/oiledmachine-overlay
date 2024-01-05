#!/bin/sh
. /etc/finit.d/scripts/tox-dht-daemon-lib.sh

start() {
	ebegin "Starting tox-dht-bootstrap daemon"

	set -- --config "/etc/tox-bootstrapd.conf"
	exec "/usr/bin/tox-bootstrapd" "$@"

	eend $?
}

start
