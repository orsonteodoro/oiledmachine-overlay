#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-proxy/squid

. /etc/finit.d/scripts/squid-lib.sh

reload() {
	checkconfig || return 1
	ebegin "Reloading ${RC_SVCNAME} with /usr/sbin/squid -k reconfigure -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME}"
	/usr/sbin/squid -k reconfigure -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME}
	eend $?
}

reload
