#!/bin/sh
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/app-laptop/laptop-mode-tools

source /etc/finit.d/scripts/laptop_mode-lib.sh

start() {
	checkconfig || return 1

	ebegin "Starting laptop_mode"
	# bug #342049 fix
	# check if dir exists and creates if it doesn't
	checkpath "d" "-" "755" "/var/run/laptop-mode-tools"
	touch /var/run/laptop-mode-tools/enabled
	/usr/sbin/laptop_mode auto >/dev/null
	eend $?
}

start
