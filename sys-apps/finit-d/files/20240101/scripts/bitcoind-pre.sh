#!/bin/bash

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
