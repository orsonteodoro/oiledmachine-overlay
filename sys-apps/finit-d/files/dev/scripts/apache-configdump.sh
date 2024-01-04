#!/bin/sh
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://dev.gentoo.org/~graaff/dist/apache/
# Dumps the configuration of the runing apache server. Requires server-info to be enabled and www-client/lynx.

. /etc/finit.d/scripts/apache-lib.sh

configdump() {
	INFOURL=${INFOURL:-"http://localhost/server-info"}

	checkconfd || return 1

	if ! command -v $(set -- ${LYNX}; echo $1) 2>&1 >/dev/null; then
		eerror "lynx not found! you need to emerge www-client/lynx"
	else
		echo "${APACHE2} started with '${APACHE2_OPTS}'"
		for i in config server list; do
			${LYNX} "${INFOURL}/?${i}" | sed '/Apache Server Information/d;/^[[:space:]]\+[_]\+$/Q'
		done
	fi
}

configdump
