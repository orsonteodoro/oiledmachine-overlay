#!/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/tor

source /etc/finit.d/scripts/tor-lib.sh

reload() {
	checkconfig || return 1
	ebegin "Reloading Tor configuration"
	start-stop-daemon -s HUP --pidfile ${pidfile}
	eend $?
}

reload
