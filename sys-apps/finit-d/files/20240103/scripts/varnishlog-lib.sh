#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/varnish

source /etc/conf.d/varnishlog
source /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"varnishlog"}

VARNISHLOG_PID=${VARNISHLOG_PID:-/run/${SVCNAME}.pid}

command="${VARNISHLOG:-/usr/bin/varnishlog}"
command_args="-D -P ${VARNISHLOG_PID} ${VARNISHLOG_OPTS}"
pidfile="${VARNISHLOG_PID}"

rotate() {
	ebegin "Rotating log file"
	start-stop-daemon -p ${VARNISHLOG_PID} -s SIGHUP
	eend $?
}

flush() {
	ebegin "Flushing any outstanding transactions"
	start-stop-daemon -p ${VARNISHLOG_PID} -s SIGUSR1
	eend $?
}
