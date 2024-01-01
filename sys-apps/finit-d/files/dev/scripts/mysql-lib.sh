#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Scripts from dev-db/mysql-init-scripts at https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-db/mysql-init-scripts
# =dev-db/mysql-init-scripts-2.3-r6::gentoo

source /etc/conf.d/mysql
source /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"mysql"}

get_config() {
	#FIXME:  not portable
	my_print_defaults --defaults-file="$1" mysqld server mariadb |
	sed -n -e "s/^--$2=//p"
}

mysql_svcname() {
	local ebextra=
	case "${SVCNAME}" in
		mysql*) ;;
		*) ebextra=" (mysql)" ;;
	esac
	echo "${SVCNAME}${ebextra}"
}

stringContain() { [ -z "${2##*$1*}" ] && [ -z "$1" -o -n "$2" ]; }

bootstrap_galera() {
	MY_ARGS="--wsrep-new-cluster ${MY_ARGS}"
	mark_service_starting
	if start ; then
		mark_service_started
		return 0
	else
		mark_service_stopped
		return 1
	fi
}

checkconfig() {
	local my_cnf="${MY_CNF:-/etc/${SVCNAME}/my.cnf}"
	local basedir=$(get_config "${my_cnf}" basedir | tail -n1)
	local svc_name=$(mysql_svcname)
	ebegin "Checking mysqld configuration for ${svc_name}"

	if [ ${RC_CMD} = "checkconfig" ] ; then
		# We are calling checkconfig specifically.  Print warnings regardless.
		"${basedir}"/sbin/mysqld --defaults-file="${my_cnf}" --help --verbose > /dev/null
	else
		# Suppress output to check the return value
		"${basedir}"/sbin/mysqld --defaults-file="${my_cnf}" --help --verbose > /dev/null 2>&1

		# If the above command does not return 0,
		# then there is an error to echo to the user
		if [ $? -ne 0 ] ; then
			"${basedir}"/sbin/mysqld --defaults-file="${my_cnf}" --help --verbose > /dev/null
		fi
	fi

	eend $? "${svc_name} config check failed"
}
