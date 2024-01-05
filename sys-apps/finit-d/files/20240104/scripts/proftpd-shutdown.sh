#!/bin/sh
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-ftp/proftpd

. /etc/finit.d/scripts/proftpd-lib.sh

RC_CMD="stop"

stop() {
	[ "${RC_CMD}" != "restart" ] || check_configuration || return 1
	ebegin "Stopping ProFTPD"
	kill -SIGTERM $(cat /run/proftpd/proftpd.pid)
	eend $?
}

stop
