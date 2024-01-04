#!/bin/sh
# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License, v2 or later

. /etc/conf.d/pppoe-server
pidfile="/run/pppoe-server.pid"

start() {
	local name=$(hostname)
	exec pppoe-server -I ${PPPOE_INTERFACE:-"eth0"} -C ${AC_NAME:-"${name}"} -S ${SERVICE_NAME:-"default"} -N ${MAX_SESSIONS:-64} -x ${MAX_SESESSION_PER_MAC:-1} -L ${LOCAL_IP:-"10.0.0.1."} -k -F ${OTHER_OPTIONS}
}

start
