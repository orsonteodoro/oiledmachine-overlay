#!/bin/sh
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://dev.gentoo.org/~graaff/dist/apache/

. /etc/finit.d/scripts/apache-lib.sh

start() {
	checkconfig || return 1

	if [ -n "${STARTUPERRORLOG}" ] ; then
		# We must make sure that we only append to APACHE2_OPTS
		# in start() and not in stop() or anywhere else that may
		# be executed along with start(), see bug #566726.
		APACHE2_OPTS="${APACHE2_OPTS} -E ${STARTUPERRORLOG}"
	fi

	ebegin "Starting ${SVCNAME}"
	# Use start stop daemon to apply system limits #347301 
	${APACHE2} ${APACHE2_OPTS} -k start

	local i=0 retval=1
	while [ $i -lt ${TIMEOUT} ] ; do
		if [ -e "${PIDFILE}" ] ; then
			retval=0
			break
		fi
		sleep 1 && i=$(expr $i + 1)
	done

	eend ${retval}
}

start
