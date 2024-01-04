#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/tor

. /etc/finit.d/scripts/tor-lib.sh

start_pre() {
	checkconfig || return 1
	checkpath "d" "tor:tor" "0755" "/run/tor"
}

start() {
	set -- --user "distcc" --daemon --no-detach ${DISTCCD_OPTS}
	exec "${command}" $@
}

start_pre
start
