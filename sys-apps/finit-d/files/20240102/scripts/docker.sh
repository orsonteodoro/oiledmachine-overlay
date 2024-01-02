#!/bin/sh
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# =app-containers/docker-24.0.5::gentoo

source /etc/conf.d/docker
source /etc/finit.d/scripts/lib.sh

command="${DOCKERD_BINARY:-/usr/bin/dockerd}"
pidfile="${DOCKER_PIDFILE:-/run/${RC_SVCNAME}.pid}"
command_args="-p \"${pidfile}\" ${DOCKER_OPTS}"
DOCKER_LOGFILE="${DOCKER_LOGFILE:-/var/log/${RC_SVCNAME}.log}"
DOCKER_ERRFILE="${DOCKER_ERRFILE:-${DOCKER_LOGFILE}}"
DOCKER_OUTFILE="${DOCKER_OUTFILE:-${DOCKER_LOGFILE}}"
rc_ulimit="${DOCKER_ULIMIT:--c unlimited -n 1048576 -u unlimited}"

start_pre() {
	checkpath "f" "root:docker" "0644" "$DOCKER_LOGFILE"
}

start() {
	ulimit ${rc_ulimit}
	"${command}" ${command_args} 2>"${DOCKER_ERRFILE}" 1>"${DOCKER_OUTFILE}" &
	pid="$!"
	echo "${pid}" > "${pidfile}"
	kill -SIGCONT ${pid}
}

start_pre
start
