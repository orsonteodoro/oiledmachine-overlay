#!/bin/sh
# =net-irc/ergo-2.12.0::gentoo

source /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"ergo"}
RC_SVCNAME="${SVCNAME}"

command=/usr/bin/ergo
command_args="run --conf ${ERGO_CONFIGFILE:-'/etc/ergo/ircd.yaml'}"
pidfile="/var/run/${RC_SVCNAME}.pid"
output_log="/var/log/${RC_SVCNAME}.out"
error_log="/var/log/${RC_SVCNAME}.err"

start_pre() {
	get_ready_file "0640" "ergo:ergo" "/var/log/ergo.out" &
	get_ready_file "0640" "ergo:ergo" "/var/log/ergo.err"
}

start() {
	"${command}" ${command_args} 2>"${error_log}" 1>"${output_log}" &
	pid="$!"
	echo "${pid}" > "${pidfile}"
	kill -SIGCONT ${pid}
}

start_pre
start
