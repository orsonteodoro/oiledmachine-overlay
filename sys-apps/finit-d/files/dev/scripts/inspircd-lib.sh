#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# =net-irc/inspircd-3.16.1::gentoo

SVCNAME=${SVCNAME:-"inspircd"}

: ${INSPIRCD_USER:="inspircd"}
: ${INSPIRCD_GROUP:="inspircd"}
: ${INSPIRCD_CONFIGFILE:="/etc/inspircd/inspircd.conf"}
: ${INSPIRCD_PIDFILE:="/run/inspircd/inspircd.pid"}
: ${INSPIRCD_SSDARGS:="--quiet --wait 1000"}
: ${INSPIRCD_TERMTIMEOUT:="TERM/25/KILL/5"}
: ${INSPIRCD_OPTS:=""}
pidfile="${INSPIRCD_PIDFILE}"

command="/usr/bin/inspircd"
command_args="${INSPIRCD_OPTS} --config \"${INSPIRCD_CONFIGFILE}\""

source /etc/finit.d/scripts/lib.sh
