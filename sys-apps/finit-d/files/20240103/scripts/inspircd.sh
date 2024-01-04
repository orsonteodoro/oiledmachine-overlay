#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

. /etc/finit.d/scripts/inspircd-lib.sh

start() {
	set -- ${INSPIRCD_OPTS} --config "${INSPIRCD_CONFIGFILE}"
	exec "${command}" "$@"
}

start
