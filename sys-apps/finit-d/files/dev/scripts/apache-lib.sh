#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified script from www-servers/apache package
# Initscript tarball:  https://dev.gentoo.org/~graaff/dist/apache/

MAINTENANCE_MODE="0"

source /etc/conf.d/apache2
source /etc/finit.d/scripts/lib.sh

SVC_NAME="apache2"

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

checkconfd() {
	if [[ ! -d ${SERVERROOT} ]] ; then
		eerror "SERVERROOT does not exist: ${SERVERROOT}"
		return 1
	fi
}

checkconfig() {
	get_ready_dir "0775;root:root;/run/apache_ssl_mutex"
	checkconfd || return 1

	OUTPUT=$( ${APACHE2} ${APACHE2_OPTS} -t 2>&1 )
	ret=$?
	if [[ $ret -ne 0 ]] ; then
		eerror "${SVCNAME} has detected an error in your setup:"
		printf "%s\n" "${OUTPUT}"
	fi

	return $ret
}

apache_configtest() {
	ebegin "Checking ${SVCNAME} configuration"
	checkconfig
	eend $?
}
