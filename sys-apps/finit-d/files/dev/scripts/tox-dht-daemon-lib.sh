#!/bin/sh

. /etc/finit.d/scripts/lib.sh

PIDDIR="/run/tox-bootstrapd"
PIDFILE="${PIDDIR}/tox-bootstrapd.pid"
KEYSDIR="/var/lib/tox-bootstrapd"
TOX_USER="tox"
TOX_GROUP="tox"
