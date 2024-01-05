#!/bin/sh
# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/wireguard-tools

. /etc/finit.d/scripts/wg-quic-lib.sh

stop() {
	checkconfig || return 1
	ebegin "Stopping $description for $CONF"
	wg-quick down "$CONF"
	eend $? "Failed to stop $description for $CONF"
}

stop
