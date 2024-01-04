#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/varnish

. /etc/conf.d/varnishlog
. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"varnishlog"}

VARNISHLOG_PID=${VARNISHLOG_PID:-"/run/${SVCNAME}.pid"}

command=${VARNISHLOG:-"/usr/bin/varnishlog"}
command_args="-D -P ${VARNISHLOG_PID} ${VARNISHLOG_OPTS}"
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
