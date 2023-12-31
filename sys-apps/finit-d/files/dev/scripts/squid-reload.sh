#!/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-proxy/squid

source /etc/finit.d/scripts/squid-lib.sh

reload() {
	checkconfig || return 1
	ebegin "Reloading squid with /usr/sbin/squid -k reconfigure -f /etc/squid/squid.conf -n squid"
	/usr/sbin/squid -k reconfigure -f /etc/squid/squid.conf -n squid
	eend $?
}

reload
