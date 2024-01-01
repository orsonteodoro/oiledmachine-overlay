#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://dev.gentoo.org/~graaff/dist/apache/
# Kills all children and reloads the configuration.

source /etc/finit.d/scripts/apache-lib.sh

reload() {
	checkconfig || return 1

	if [[ "${RELOAD_TYPE}" = "restart" ]] ; then
		ebegin "Restarting apache"
		${APACHE2} ${APACHE2_OPTS} -k restart
		eend $?
	elif [[ "${RELOAD_TYPE}" = "graceful" ]] ; then
		ebegin "Gracefully restarting apache"
		${APACHE2} ${APACHE2_OPTS} -k graceful
		eend $?
	else
		eerror "${RELOAD_TYPE} is not a valid RELOAD_TYPE. Please edit /etc/conf.d/apache"
	fi
}
