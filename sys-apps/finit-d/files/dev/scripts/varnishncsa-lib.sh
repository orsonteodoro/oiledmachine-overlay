#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/varnish
# =www-servers/varnish-7.1.2-r2:0/2::gentoo

. /etc/conf.d/varnishncsa
. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"varnishncsa"}

VARNISHNCSA_PID=${VARNISHNCSA_PID:-"/run/${SVCNAME}.pid"}

command=${VARNISHNCSA:-"/usr/bin/varnishncsa"}
pidfile="${VARNISHNCSA_PID}"

rotate() {
	ebegin "Rotating log file"
	kill -SIGHUP $(cat "${VARNISHNCSA_PID}")
	eend $?
}

flush() {
	ebegin "Flushing any outstanding transactions"
	kill -SIGUSR1 $(cat "${VARNISHNCSA_PID}")
	eend $?
}
