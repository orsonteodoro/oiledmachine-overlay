#!/bin/sh
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/app-laptop/laptop-mode-tools

. /etc/finit.d/scripts/laptop_mode-lib.sh

reload() {
	if ! service_started "${SVCNAME}" ; then
		eerror "${SVCNAME} has not yet been started"
		return 1
	fi

	ebegin "Reloading laptop_mode"
	"/usr/sbin/laptop_mode" stop >/dev/null
	rm -f "/var/run/laptop-mode-tools/"*
	"/usr/sbin/laptop_mode" auto force >/dev/null
	eend $?
}

reload
