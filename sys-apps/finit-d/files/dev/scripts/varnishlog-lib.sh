#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/varnish
# =www-servers/varnish-7.1.2-r2:0/2::gentoo

. /etc/conf.d/varnishlog
. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"varnishlog"}

VARNISHLOG_PID=${VARNISHLOG_PID:-"/run/${SVCNAME}.pid"}

command=${VARNISHLOG:-"/usr/bin/varnishlog"}
pidfile="${VARNISHLOG_PID}"

rotate() {
	ebegin "Rotating log file"
	kill -SIGHUP $(cat "${VARNISHLOG_PID}")
	eend $?
}

flush() {
	ebegin "Flushing any outstanding transactions"
	kill -SIGUSR1 $(cat "${VARNISHLOG_PID}")
	eend $?
}
