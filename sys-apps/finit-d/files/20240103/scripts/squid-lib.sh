#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-proxy/squid
# =net-proxy/squid-6.5::gentoo

. /etc/conf.d/squid
. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"squid"}
RC_SVCNAME="${SVCNAME}"
SQUID_SVCNAME=$( echo "${RC_SVCNAME}" | tr -cd '[a-zA-Z0-9]' )

checkconfig() {
	local CONFFILES="/etc/squid/${RC_SVCNAME}.conf /etc/squid/${RC_SVCNAME}.include /etc/squid/${RC_SVCNAME}.include.*"
	if [ ! -f "/etc/squid/${RC_SVCNAME}.conf" ]; then
		eerror "You need to create /etc/squid/${RC_SVCNAME}.conf first."
		eerror "The main configuration file and all included file names should have the following format:"
		eerror "${CONFFILES}"
		eerror "An example can be found in /etc/squid/squid.conf.default"
		return 1
	fi

	local PIDFILE=$(cat ${CONFFILES} 2>/dev/null 3>/dev/null | awk '/^[ \t]*pid_filename[ \t]+/ { print $2 }')
	[ -z "${PIDFILE}" ] && PIDFILE="/run/squid.pid"
	if [ "/run/${RC_SVCNAME}.pid" != "${PIDFILE}" ]; then
		eerror "/etc/squid/${RC_SVCNAME}.conf must set pid_filename to"
		eerror "   /run/${RC_SVCNAME}.pid"
		eerror "CAUTION: http_port, cache_dir and *_log parameters must be different than"
		eerror "         in any other instance of squid."
		eerror "Make sure the main configuration file and all included file names have the following format:"
		eerror "${CONFFILES}"
		return 1
	fi

	# Maximum file descriptors squid can open is determined by:
	# a basic default of N=1024
	#  ... altered by ./configure --with-filedescriptors=N
	#  ... overridden on production by squid.conf max_filedescriptors (if,
	#  and only if, setrlimit() RLIMIT_NOFILE is able to be built+used).
	# Since we do not configure hard coded # of filedescriptors anymore,
	# there is no need for ulimit calls in the init script.
	# Use max_filedescriptors in squid.conf instead.

	local CACHE_SWAP=$(cat ${CONFFILES} 2>/dev/null 3>/dev/null | awk '/^[ \t]*cache_dir[ \t]+/ { if ( $2 == "rock" ) printf "%s/rock ", $3; else if ( $2 == "coss" ) printf "%s/stripe ", $3; else printf "%s/00 ", $3; }')
	[ -z "$CACHE_SWAP" ] && CACHE_SWAP="/var/cache/squid/00"

	local x
	for x in $CACHE_SWAP ; do
		if [ ! -e $x ] ; then
			ebegin "Initializing cache directory ${x%/*}"
			local ORIG_UMASK=$(umask)
			umask 027

			if ! (mkdir -p ${x%/*} && chown squid ${x%/*}) ; then
				eend 1
				return 1
			fi

			local INIT_CACHE_RESPONSE="$(/usr/sbin/squid -z -N -f /etc/squid/${RC_SVCNAME}.conf -n ${SQUID_SVCNAME} 2>&1)"
			if [ $? != 0 ] || echo "$INIT_CACHE_RESPONSE" | grep -q "erminated abnormally" ; then
				umask $ORIG_UMASK
				eend 1
				echo "$INIT_CACHE_RESPONSE"
				return 1
			fi

			umask $ORIG_UMASK
			eend 0
			break
		fi
	done

	return 0
}
