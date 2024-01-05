#!/bin/sh
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

SVCNAME=${SVCNAME:-"caddy"}
RC_SVCNAME="${SVCNAME}"

pidfile=${pidfile:-"/run/${RC_SVCNAME}.pid"}
command="/usr/bin/caddy"
command_user=${command_user:-"http:http"}
caddy_config=${caddy_config:-"/etc/caddy/Caddyfile"}
command_args=${command_args:-"run --config ${caddy_config}"}
command_background="true"
logfile=${logfile:-"/var/log/${RC_SVCNAME}/${RC_SVCNAME}.log"}
start_stop_daemon_args="--user ${command_user%:*} --group ${command_user#*:}
	--stdout ${logfile} --stderr ${logfile}"

: ${supervisor:="supervise-daemon"}
: ${respawn_delay:=5}
: ${respawn_max:=10}
: ${respawn_period:=60}

. /etc/finit.d/scripts/lib.sh

checkconfig() {
    if [ ! -f "${caddy_config}" ] ; then
        ewarn "${caddy_config} does not exist."
        return 1
    fi
    "${command}" "validate" --config "${caddy_config}" >> "${logfile}" 2>&1
}
