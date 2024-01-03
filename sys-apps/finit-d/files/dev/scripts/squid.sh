#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-proxy/squid

. /etc/finit.d/scripts/squid-lib.sh

start() {
	checkconfig || return 1
	checkpath "d" "squid:squid" "0750" "/run/${RC_SVCNAME}"

	# see https://wiki.squid-cache.org/MultipleInstances
	ebegin "Starting ${RC_SVCNAME} (service name ${SQUID_SVCNAME}) with KRB5_KTNAME=\"${SQUID_KEYTAB}\" /usr/sbin/squid ${SQUID_OPTS} -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME}"
	KRB5_KTNAME="${SQUID_KEYTAB}" /usr/sbin/squid ${SQUID_OPTS} -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME}
	eend $? && sleep 1
}

start
