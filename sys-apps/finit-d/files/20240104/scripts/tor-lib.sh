#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/tor
# =net-vpn/tor-0.4.7.16::gentoo

. /etc/conf.d/tor
. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"tor"}

command="/usr/bin/tor"
pidfile="/run/tor/tor.pid"
retry=${GRACEFUL_TIMEOUT:-60}
stopsig="INT"
command_progress="yes"

checkconfig() {
	"${command}" --verify-config --hush > /dev/null 2>&1
	if [ $? -ne 0 ] ; then
		eerror "Tor configuration (/etc/tor/torrc) is not valid."
		eerror "Example is in /etc/tor/torrc.sample"
		return 1
	fi
}
