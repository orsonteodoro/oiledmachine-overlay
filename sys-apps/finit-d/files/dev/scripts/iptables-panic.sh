#!/bin/sh
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-firewall/iptables/files

source /etc/finit.d/scripts/iptables-lib.sh

panic() {
	# use iptables autoload capability to load at least all required
	# modules and filter table
	${iptables_bin} --wait ${iptables_lock_wait_time} -S >/dev/null
	if [ $? -ne 0 ] ; then
		eerror "${iptables_bin} failed to load"
		return 1
	fi

	if service_started ${iptables_name}; then
		rc-service ${iptables_name} stop
	fi

	local has_errors=0 a
	ebegin "Dropping all packets"
	for a in $(cat ${iptables_proc}) ; do
		${iptables_bin} --wait ${iptables_lock_wait_time} -F -t $a
		[ $? -ne 0 ] && has_errors=1

		${iptables_bin} --wait ${iptables_lock_wait_time} -X -t $a
		[ $? -ne 0 ] && has_errors=1

		if [ "${a}" != "nat" ]; then
			# The "nat" table is not intended for filtering, the use of DROP is therefore inhibited.
			set_table_policy $a DROP
			[ $? -ne 0 ] && has_errors=1
		fi
	done
	eend ${has_errors}
}

panic
