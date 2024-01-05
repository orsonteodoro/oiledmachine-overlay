#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/varnish

. /etc/finit.d/scripts/varnishd-lib.sh

stop_pre() {
	if [ "${RC_CMD}" = "restart" ] ; then
		checkconfig || return 1
	fi
}

stop() {
	kill -SIGTERM $(cat "${VARNISHD_PID}")
}

stop_pre
stop
