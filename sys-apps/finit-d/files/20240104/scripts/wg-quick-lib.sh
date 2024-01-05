#!/bin/sh
# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/wireguard-tools
# =net-vpn/wireguard-tools-1.0.20210914::gentoo

. /etc/finit.d/scripts/lib.sh

CONF="${SVCNAME#*.}"

checkconfig() {
	if [ "$CONF" = "$SVCNAME" ]; then
		eerror "You cannot call this init script directly. You must create a symbolic link to it with the configuration name:"
		eerror "    ln -s /etc/init.d/wg-quick /etc/init.d/wg-quick.vpn0"
		eerror "And then call it instead:"
		eerror "    /etc/init.d/wg-quick.vpn0 start"
		return 1
	fi
	return 0
}
