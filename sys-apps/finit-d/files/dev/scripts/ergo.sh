#!/bin/sh
# =net-irc/ergo-2.12.0::gentoo

. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"ergo"}
RC_SVCNAME="${SVCNAME}"

command="/usr/bin/ergo"
pidfile="/var/run/${RC_SVCNAME}.pid"
output_log="/var/log/${RC_SVCNAME}.out"
error_log="/var/log/${RC_SVCNAME}.err"

start() {
	set -- run --conf ${ERGO_CONFIGFILE:-"/etc/ergo/ircd.yaml"}
	exec "${command}" "$@" 2>"${error_log}" 1>"${output_log}"
}

start
