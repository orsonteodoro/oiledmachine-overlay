#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-db/mysql-init-scripts
# =dev-db/mysql-init-scripts-2.3-r6::gentoo

source /etc/conf.d/mysql
source /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"mysql"}

get_config() {
	# my_print_defaults is a binary from *sql package
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

start_verify() {
# Workaround:  cannot get net.lo via initctl
	ifconfig | grep "^lo:"
}

mark_service_starting() {
	:;
}

mark_service_started() {
	:;
}

mark_service_stopped() {
	initctl stop ${SVCNAME}
}

bootstrap_galera() {
	MY_ARGS="--wsrep-new-cluster ${MY_ARGS}"
# TODO:  test or code review mark_*
	mark_service_starting
	if start_verify ; then
		mark_service_started
		return 0
	else
		mark_service_stopped
		return 1
	fi
}

checkconfig() {
	RC_CMD="${1}" # finit-d addition
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

start() {
	RC_CMD="start" # finit-d addition
	# Check for old conf.d variables that mean migration was not yet done.
	set | grep -Esq '^(mysql_slot_|MYSQL_BLOG_PID_FILE|STOPTIMEOUT)'
	rc=$?
	# Yes, MYSQL_INIT_I_KNOW_WHAT_I_AM_DOING is a hidden variable.
	# It does have a use in testing, as it is possible to build a config file
	# that works with both the old and new init scripts simulateously.
	if [ "${rc}" = 0 -a -z "${MYSQL_INIT_I_KNOW_WHAT_I_AM_DOING}" ]; then
		eerror "You have not updated your conf.d for the new mysql-init-scripts-2 revamp."
		eerror "Not proceeding because it may be dangerous."
		return 1
	fi

	# Check the config or die
	if [ ${RC_CMD} != "restart" ] ; then
		checkconfig "${RC_CMD}" || return 1
	fi

	# Now we can startup
	ebegin "Starting $(mysql_svcname)"

	MY_CNF="${MY_CNF:-/etc/${SVCNAME}/my.cnf}"

	if [ ! -r "${MY_CNF}" ] ; then
		eerror "Cannot read the configuration file \`${MY_CNF}'"
		return 1
	fi

	# tail -n1 is critical as these we only want the last instance of the option
	local basedir=$(get_config "${MY_CNF}" basedir | tail -n1)
	local pidfile=$(get_config "${MY_CNF}" 'pid[_-]file' | tail -n1)
	local socket=$(get_config "${MY_CNF}" socket | tail -n1)
	local chroot=$(get_config "${MY_CNF}" chroot | tail -n1)
	local wsrep="$(get_config "${MY_CNF}" 'wsrep[_-]on' | tail -n1 | awk '{print tolower($0)}')"
	local wsrep_new=$(get_config "${MY_CNF}" 'wsrep-new-cluster' | tail -n1)

	if [ -n "${chroot}" ] ; then
		socket="${chroot}/${socket}"
		pidfile="${chroot}/${pidfile}"
	fi

	# Galera: Only check datadir if not starting a new cluster and galera is enabled
	# wsrep_on is not on or wsrep-new-cluster exists in the config or MY_ARGS
	[ "${wsrep}" = "1" ] && wsrep="on"
	if [ "${wsrep}" != "on" ] || [ -n "${wsrep_new}" ] || stringContain 'wsrep-new-cluster' "${MY_ARGS}" ; then

		local datadir=$(get_config "${MY_CNF}" datadir | tail -n1)
		if [ ! -d "${datadir}" ] ; then
			eerror "MySQL datadir \`${datadir}' is empty or invalid"
			eerror "Please check your config file \`${MY_CNF}'"
			return 1
		fi

		if [ ! -d "${datadir}"/mysql ] ; then
			# find which package is installed to report an error
			local EROOT=$(portageq envvar EROOT)
			local DBPKG_P=$(portageq match ${EROOT} $(portageq expand_virtual ${EROOT} virtual/mysql | head -n1))
			if [ -z ${DBPKG_P} ] ; then
				eerror "You don't appear to have a server package installed yet."
			else
				eerror "You don't appear to have the mysql database installed yet."
				eerror "Please run \`emerge --config =${DBPKG_P}\` to have this done..."
			fi
			return 1
		fi
	fi

	local piddir="${pidfile%/*}"
	checkpath "d" "mysql:mysql" "0755" "$piddir"
	rc=$?
	if [ $rc -ne 0 ]; then
		eerror "Directory $piddir for pidfile does not exist and cannot be created"
		return 1
	fi

	local startup_timeout=${STARTUP_TIMEOUT:-900}
	local startup_early_timeout=${STARTUP_EARLY_TIMEOUT:-1000}
	local tmpnice="${NICE:+"--nicelevel "}${NICE}"
	local tmpionice="${IONICE:+"--ionice "}${IONICE}"
	"${basedir}"/sbin/mysqld --defaults-file="${MY_CNF}" ${MY_ARGS}
	local ret=$?
	if [ ${ret} -ne 0 ] ; then
		eend ${ret}
		return ${ret}
	fi

	ewaitfile ${startup_timeout} "${socket}"
	eend $? || return 1

	save_options pidfile "${pidfile}"
	save_options basedir "${basedir}"
}
