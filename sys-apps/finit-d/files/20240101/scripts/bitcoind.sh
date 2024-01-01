#!/bin/sh

source /etc/finit.d/scripts/bitcoind-lib.sh

start() {
	ebegin "Starting ${name}"

	if "${BITCOIND_BIN}" \
		-daemonwait \
		-pid="${BITCOIND_PIDFILE}" \
		-conf="${BITCOIND_CONFIGFILE}" \
		-datadir="${BITCOIND_DATADIR}" \
		-debuglogfile="${BITCOIND_LOGDIR}/debug.log" \
		${BITCOIND_OPTS}
	then
		chmod g+r "${BITCOIND_DATADIR}/.cookie"
	else
		killall -9 "${SVCNAME}"
	fi &
}

start
