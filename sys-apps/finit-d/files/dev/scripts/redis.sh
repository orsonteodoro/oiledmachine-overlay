#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# =dev-db/redis-7.2.3::gentoo

. /etc/conf.d/redis
. /etc/finit.d/scripts/lib.sh

: ${REDIS_DIR:="/var/lib/redis"}
: ${REDIS_CONF:="/etc/redis/redis.conf"}
: ${REDIS_OPTS:="${REDIS_CONF}"}
: ${REDIS_USER:="redis"}
: ${REDIS_GROUP:="redis"}
: ${REDIS_TIMEOUT:=30}

SVCNAME=${SVCNAME:-"redis"}
RC_SVCNAME="${SVCNAME}"

command="/usr/sbin/redis-server"
pidfile="/run/${RC_SVCNAME}.pid"

start() {
	set -- ${REDIS_OPTS} --daemonize "no"
	exec "${command}" $@
}

start
