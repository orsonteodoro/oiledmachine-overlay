#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-db/mysql-init-scripts

source /etc/finit.d/scripts/mysql-lib.sh

stop() {
	RC_CMD="${1}" # finit-d addition
	if [ ${RC_CMD} = "restart" ] ; then
		checkconfig "${RC_CMD}" || return 1
	fi

	ebegin "Stopping $(mysql_svcname)"

	local pidfile="$(get_options pidfile)"
	local basedir="$(get_options basedir)"
	local stop_timeout=${STOP_TIMEOUT:-120}

	kill -SIGQUIT $(cat "${pidfile}")
	eend $?
}

stop "${1}"
