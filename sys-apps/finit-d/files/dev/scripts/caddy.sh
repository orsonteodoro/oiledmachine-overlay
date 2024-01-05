#!/bin/sh
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

. /etc/finit.d/scripts/caddy-lib.sh

default_start() {
	set -- ${command_args}
	exec "${command}" "$@" >"${logfile}" 2>&1
}

start() {
    checkconfig || { eerror "Invalid configuration file !" && return 1; }
	checkpath "d" "root"            "755" "${pidfile%/*}"
	checkpath "d" "${command_user}" "755" "${logfile%/*}"
	default_start
}

start
