#!/bin/sh
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://dev.gentoo.org/~graaff/dist/apache/
# patchset: gentoo-apache-2.4.46-r6
# =www-servers/apache-2.4.57:2::gentoo

MAINTENANCE_MODE="0"

source /etc/conf.d/apache2
source /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"apache2"}

# Apply default values for some conf.d variables.
PIDFILE="${PIDFILE:-/var/run/apache2.pid}"
TIMEOUT=${TIMEOUT:-15}
SERVERROOT="${SERVERROOT:-/usr/lib64/apache2}"
CONFIGFILE="${CONFIGFILE:-/etc/apache2/httpd.conf}"
LYNX="${LYNX:-lynx -dump}"
STATUSURL="${STATUSURL:-http://localhost/server-status}"
RELOAD_TYPE="${RELOAD_TYPE:-graceful}"

# Append the server root and configuration file parameters to the
# user's APACHE2_OPTS.
APACHE2_OPTS="${APACHE2_OPTS} -d ${SERVERROOT}"
APACHE2_OPTS="${APACHE2_OPTS} -f ${CONFIGFILE}"

# The path to the apache2 binary.
APACHE2="/usr/sbin/apache2"

configtest() {
	ebegin "Checking ${SVCNAME} configuration"
	checkconfig
	eend $?
}

checkconfd() {
	if [ ! -d ${SERVERROOT} ]; then
		eerror "SERVERROOT does not exist: ${SERVERROOT}"
		return 1
	fi
}

checkconfig() {
	get_ready_dir "0775" "-" "/run/apache_ssl_mutex"
	checkconfd || return 1

	OUTPUT=$( ${APACHE2} ${APACHE2_OPTS} -t 2>&1 )
	ret=$?
	if [ $ret -ne 0 ]; then
		eerror "${SVCNAME} has detected an error in your setup:"
		printf "%s\n" "${OUTPUT}"
	fi

	return $ret
}

