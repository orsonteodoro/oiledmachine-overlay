#!/bin/sh
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://dev.gentoo.org/~graaff/dist/apache/
# A graceful stop advises the children to exit after the current request and stops the server.

. /etc/finit.d/scripts/apache-lib.sh

gracefulstop() {
	checkconfig || return 1
	ebegin "Gracefully stopping ${SVCNAME}"
	"${APACHE2}" ${APACHE2_OPTS} -k "graceful-stop"
	eend $?
}

gracefulstop
