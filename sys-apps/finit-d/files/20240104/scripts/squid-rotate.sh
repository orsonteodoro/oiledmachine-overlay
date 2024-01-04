#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-proxy/squid

. /etc/finit.d/scripts/squid-lib.sh

rotate() {
	service_started "${RC_SVCNAME}" || return 1
	ebegin "Rotating ${RC_SVCNAME} logs with /usr/sbin/squid -k rotate -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME}"
	"/usr/sbin/squid" -k "rotate" -f "/etc/squid/${RC_SVCNAME}.conf" -n "${SQUID_SVCNAME}"
	eend $?
}

rotate
