#!/bin/sh
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

source /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"distccd"}
RC_SVCNAME="${SVCNAME}"

command="${DISTCCD_EXEC:-/usr/bin/distccd}"
pidfile="/run/${RC_SVCNAME}.pid"
command_args="--user distcc --daemon --no-detach ${DISTCCD_OPTS}"

start() {
	export TMPDIR="${TMPDIR:-/tmp}"
	declare -a "args=(${command_args})"
	exec "${command}" "${args[@]}"
}

start
