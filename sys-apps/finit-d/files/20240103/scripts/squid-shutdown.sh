#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-proxy/squid

source /etc/finit.d/scripts/squid-lib.sh

stop() {
	ebegin "Stopping ${RC_SVCNAME} with /usr/sbin/squid -k shutdown -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME}"
	if /usr/sbin/squid -k shutdown -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME} ; then
		if [ "x${SQUID_FAST_SHUTDOWN}" = "xyes" ]; then
			einfo "Attempting fast shutdown."
			/usr/sbin/squid -k shutdown -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME}
		fi
		# Now we have to wait until squid has _really_ stopped.
		sleep 1
		if [ -f /run/${RC_SVCNAME}.pid ] ; then
			einfon "Waiting for squid to shutdown ."
			cnt=0
			while [ -f /run/${RC_SVCNAME}.pid ] ; do
				cnt=$(expr $cnt + 1)
				if [ $cnt -gt 60 ] ; then
					# Waited 120 seconds now. Fail.
					echo
					eend 1 "Failed."
					break
				fi
				sleep 2
				printf "."
			done
			echo
		fi
	else
		eerror "Squid shutdown failed, probably service is already down."
	fi
	eend 0
}

stop
