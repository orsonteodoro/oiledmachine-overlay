#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# =net-irc/znc-1.8.2-r2:0/1.8.2::gentoo

source /etc/conf.d/znc
source /etc/finit.d/scripts/lib.sh

pidfile="${ZNC_PIDFILE:-/run/znc/znc.pid}"

start_pre() {
	get_ready_dir "0770" "znc:znc" "/run/znc"
}

start() {
	znc --datadir "${ZNC_DATADIR}" --foreground &
	pid="$!"
	echo "${pid}" > "${pidfile}"
	kill -SIGCONT ${pid}
}

start_pre
start
