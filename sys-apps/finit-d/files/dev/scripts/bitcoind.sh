#!/bin/sh

source /etc/finit.d/scripts/bitcoind-lib.sh

required_files="${BITCOIND_CONFIGFILE}"
pidfile="${BITCOIND_PIDFILE}"
in_background_fake="start"

start_pre() {
	get_ready_file "0660" "${BITCOIND_USER}:${BITCOIND_GROUP}" "${BITCOIND_CONFIGFILE}"
	get_ready_dir "0750" "${BITCOIND_USER}:${BITCOIND_GROUP}" "${BITCOIND_DATADIR}"
	get_ready_dir "0755" "${BITCOIND_USER}:${BITCOIND_GROUP}" "${BITCOIND_LOGDIR}"
	get_ready_dir "0755" "${BITCOIND_USER}:${BITCOIND_GROUP}" "${BITCOIND_PIDDIR}"

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
