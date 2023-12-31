#!/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-proxy/squid

source /etc/finit.d/scripts/squid-lib.sh

rotate() {
	initctl | grep "running" | grep "squid" || return 1
	ebegin "Rotating squid logs with /usr/sbin/squid -k rotate -f /etc/squid/squid.conf -n squid"
	/usr/sbin/squid -k rotate -f /etc/squid/squid.conf -n squid
	eend $?
}

rotate
