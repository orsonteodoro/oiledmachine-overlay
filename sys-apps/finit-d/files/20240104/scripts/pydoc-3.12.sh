#!/bin/sh
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public Licence v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-lang/python

. /etc/finit.d/scripts/lib.sh

start() {
	local pydoc_port="${PYDOC3_12_PORT-${PYDOC_PORT}}"

	if [ -z "${pydoc_port}" ]; then
		eerror "Port not set"
		return 1
	fi

	#ebegin "Starting pydoc server on port ${pydoc_port}"
	set -- -p "${pydoc_port}"
	exec /usr/bin/pydoc3.12 "$@"
	#eend $?
}
