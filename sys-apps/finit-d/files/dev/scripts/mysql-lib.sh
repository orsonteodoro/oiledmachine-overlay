#!/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Scripts from dev-db/mysql-init-scripts at https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-db/mysql-init-scripts

source /etc/conf.d/mysql
source /etc/finit.d/scripts/lib.sh

get_config() {
	# Not portable
	#FIXME
	exit 1
}

checkconfig() {
	local my_cnf="${MY_CNF:-/etc/${SVCNAME}/my.cnf}"
	local basedir=$(get_config "${my_cnf}" basedir | tail -n1)
	local svc_name=$(mysql_svcname)
	ebegin "Checking mysqld configuration for ${svc_name}"

	if [[ ${RC_CMD} = "checkconfig" ]] ; then
		# We are calling checkconfig specifically.  Print warnings regardless.
		"${basedir}/sbin/mysqld" --defaults-file="${my_cnf}" --help --verbose > /dev/null
	else
		# Suppress output to check the return value
		"${basedir}/sbin/mysqld" --defaults-file="${my_cnf}" --help --verbose > /dev/null 2>&1

		# If the above command does not return 0,
		# then there is an error to echo to the user
		if [[ $? -ne 0 ]] ; then
			"${basedir}/sbin/mysqld" --defaults-file="${my_cnf}" --help --verbose > /dev/null
		fi
	fi

	eend $? "${svc_name} config check failed"
}

mysql_svcname() {
	local ebextra=
	case "${SVCNAME}" in
		mysql*) ;;
		*) ebextra=" (mysql)" ;;
	esac
	echo "${SVCNAME}${ebextra}"
}
