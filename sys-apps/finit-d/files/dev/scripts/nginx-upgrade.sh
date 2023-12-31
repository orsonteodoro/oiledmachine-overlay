#!/bin/bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Sampled from nginx.initd-r4 from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/nginx/files
# Upgrade the nginx binary without losing connections.

source /etc/finit.d/scripts/nginx-lib.sh

upgrade() {
	local pid="/run/nginx.pid"
	configtest || return 1
	ebegin "Upgrading nginx"

	einfo "Sending USR2 to old binary"
	kill -SIGUSR2 $(cat "${pidfile}")

	einfo "Sleeping 3 seconds before pid-files checking"
	sleep 3

	if [[ ! -f "${pidfile}.oldbin" ]] ; then
		eerror "File with old pid not found"
		return 1
	fi

	if [[ ! -f "${pidfile}" ]] ; then
		eerror "New binary failed to start"
		return 1
	fi

	einfo "Sleeping 3 seconds before WINCH"
	sleep 3
	# Cannot send "SIGWINCH" using start-stop-daemon yet, https://bugs.gentoo.org/604986
	kill -SIGWINCH $(cat "${pidfile}.oldbin")

	einfo "Sending QUIT to old binary"
	kill -SIGQUIT $(cat "${pidfile}.oldbin")

	einfo "Upgrade completed"
	eend $? "Upgrade failed"
}

upgrade
