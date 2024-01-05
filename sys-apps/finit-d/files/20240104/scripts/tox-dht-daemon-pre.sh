#!/bin/sh
. /etc/finit.d/scripts/tox-dht-daemon-lib.sh

start_pre() {
	checkpath "d" "${TOX_USER}:${TOX_GROUP}" "${PIDDIR}"
	checkpath "d" "${TOX_USER}:${TOX_GROUP}" "${KEYSDIR}"
}

start_pre
