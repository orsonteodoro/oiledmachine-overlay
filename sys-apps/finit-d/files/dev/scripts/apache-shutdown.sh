#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://dev.gentoo.org/~graaff/dist/apache/

source /etc/finit.d/scripts/apache-lib.sh

stop() {
	if [[ "${RC_CMD}" == "restart" ]] ; then
		checkconfig || return 1
	fi

	PID=$(cat "${PIDFILE}" 2>/dev/null)
	if [[ -z "${PID}" ]] ; then
		einfo "apache not running (no pid file)"
		return 0
	fi

	ebegin "Stopping apache"
	${APACHE2} ${APACHE2_OPTS} -k stop

	local i=0 retval=0
	while \
		( \
			   test -f "${PIDFILE}" \
			|| pgrep -P ${PID} apache2 >/dev/null \
		) \
		&& [ $i -lt ${TIMEOUT} ] \
	; do
		sleep 1 && i=$(expr $i + 1)
	done
	[[ -e "${PIDFILE}" ]] && retval=1

	eend ${retval}
}

stop
