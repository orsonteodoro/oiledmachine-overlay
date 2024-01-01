#!/bin/sh
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/app-laptop/laptop-mode-tools

source /etc/finit.d/scripts/laptop_mode-lib.sh

stop() {
	ebegin "Stopping laptop_mode"
	rm -f /var/run/laptop-mode-tools/enabled
	/usr/sbin/laptop_mode stop >/dev/null
	eend $?
}

stop
