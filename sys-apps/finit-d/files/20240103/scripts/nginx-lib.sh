#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/nginx/files
# =www-servers/nginx-1.25.3:mainline::gentoo

source /etc/conf.d/nginx
source /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"nginx"}

NGINX_CONFIGFILE=${NGINX_CONFIGFILE:-/etc/nginx/nginx.conf}
command="/usr/sbin/nginx"
command_args="-g 'daemon off;' -c \"${NGINX_CONFIGFILE}\""
start_stop_daemon_args=${NGINX_SSDARGS:-"--wait 1000"}
pidfile=${NGINX_PIDFILE:-/run/nginx.pid}
user=${NGINX_USER:-nginx}
group=${NGINX_GROUP:-nginx}
retry=${NGINX_TERMTIMEOUT:-"TERM/60/KILL/5"}

configtest() {
	ebegin "Checking nginx' configuration"
	${command} -c "${NGINX_CONFIGFILE}" -t -q

	if [ $? -ne 0 ]; then
		${command} -c "${NGINX_CONFIGFILE}" -t
	fi

	eend $? "failed, please correct errors above"
}
