#!/bin/sh

. /etc/finit.d/scripts/bitcoind-lib.sh

stop() {
	ebegin "Stopping ${name}"
	kill -SIGTERM $(cat "${BITCOIND_PIDFILE}")
	eend $?
}

stop
