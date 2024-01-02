#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/nginx/files
# =www-servers/nginx-1.25.3:mainline::gentoo

RC_CMD="${1}"

source /etc/finit.d/scripts/nginx-lib.sh

stop_pre() {
	if [ "${RC_CMD}" = "restart" ]; then
		configtest || return 1
	fi
}

stop() {
	kill -SIGTERM $(cat "${pidfile}")
}

stop_post() {
	rm -f "${pidfile}"
}

if stop_pre ; then
	stop
	stop_post
fi
