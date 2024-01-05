#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/varnish
# =www-servers/varnish-7.1.2-r2:0/2::gentoo

. /etc/conf.d/varnishd
. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"varnishd"}

VARNISHD_PID=${VARNISHD_PID:-"/run/${SVCNAME}.pid"}
CONFIGFILES=${CONFIGFILE:-"/etc/varnish/default.vcl"}

command=${VARNISHD:-"/usr/sbin/varnishd"}
pidfile="${VARNISHD_PID}"

configtest() {
	ebegin "Checking ${SVCNAME} configuration"
	checkconfig
	eend $?
}

checkconfig() {
	"${VARNISHD}" -C -f "${CONFIGFILE}" >/dev/null 2>&1
	ret=$?
	if [ $ret -ne 0 ]; then
		eerror "${SVCNAME} has detected an error in your setup:"
		"${VARNISHD}" -C -f "${CONFIGFILE}"
	fi

	return $ret
}
