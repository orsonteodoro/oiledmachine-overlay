#!/bin/sh
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"distccd"}
RC_SVCNAME="${SVCNAME}"

command=${DISTCCD_EXEC:-"/usr/bin/distccd"}
pidfile="/run/${RC_SVCNAME}.pid"

start() {
	export TMPDIR=${TMPDIR:-"/tmp"}
	set -- --user "distcc" --daemon --no-detach ${DISTCCD_OPTS}
	exec "${command}" "$@"
}

start
