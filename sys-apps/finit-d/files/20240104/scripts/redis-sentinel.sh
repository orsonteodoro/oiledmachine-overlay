#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# =dev-db/redis-7.2.3::gentoo

. /etc/conf.d/redis-sentinel
. /etc/finit.d/scripts/lib.sh

: ${REDIS_SENTINEL_DIR:="/tmp"}
: ${REDIS_SENTINEL_CONF:="/etc/redis/sentinel.conf"}
: ${REDIS_SENTINEL_USER:="redis"}
: ${REDIS_SENTINEL_GROUP:="redis"}
: ${REDIS_SENTINEL_TIMEOUT:=30}

SVCNAME=${SVCNAME:-"redis-sentinel"}
RC_SVCNAME="${SVCNAME}"

command="/usr/sbin/redis-sentinel"
pidfile="/run/${RC_SVCNAME}.pid"

start() {
	set -- "${REDIS_SENTINEL_CONF}"
	exec "${command}" "$@"
}

start
