#!/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-proxy/squid

source /etc/finit.d/scripts/squid-lib.sh

start() {
	checkconfig || return 1
	get_ready_dir "0750;squid:squid;/run/squid"

	# see https://wiki.squid-cache.org/MultipleInstances
	ebegin "Starting squid (service name squid) with KRB5_KTNAME=\"${SQUID_KEYTAB}\" /usr/sbin/squid ${SQUID_OPTS} -f /etc/squid/squid.conf -n squid"
	KRB5_KTNAME="${SQUID_KEYTAB}" /usr/sbin/squid ${SQUID_OPTS} -f /etc/squid/squid.conf -n squid
	eend $? && sleep 1
}

start
