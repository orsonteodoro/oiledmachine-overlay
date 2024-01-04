#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/tor

. /etc/finit.d/scripts/tor-lib.sh

start() {
	set -- --hush --runasdaemon 0 --pidfile "${pidfile}"
	exec "${command}" "$@"
}

start
