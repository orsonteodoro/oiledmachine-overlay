#!/bin/sh

source /etc/finit.d/scripts/bitcoind-lib.sh

required_files="${BITCOIND_CONFIGFILE}"
pidfile="${BITCOIND_PIDFILE}"
in_background_fake="start"

start_pre() {
	checkpath "f" "${BITCOIND_USER}:${BITCOIND_GROUP}" "0660" "${BITCOIND_CONFIGFILE}"
	checkpath "d" "${BITCOIND_USER}:${BITCOIND_GROUP}" "0750" "${BITCOIND_DATADIR}"
	checkpath "d" "${BITCOIND_USER}:${BITCOIND_GROUP}" "0755" "${BITCOIND_LOGDIR}"
	checkpath "d" "${BITCOIND_USER}:${BITCOIND_GROUP}" "0755" "${BITCOIND_PIDDIR}"

        checkconfig
}

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

start_pre
start
