#!/bin/sh
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-firewall/iptables/files

source /etc/finit.d/scripts/iptables-lib.sh

stop_pre() {
	checkkernel || return 1
}

stop() {
	if [ "${SAVE_ON_STOP}" = "yes" ] ; then
		save || return 1
	fi

	ebegin "Stopping firewall"
	local has_errors=0 a
	for a in $(cat ${iptables_proc}) ; do
		set_table_policy $a ACCEPT
		[ $? -ne 0 ] && has_errors=1

		${iptables_bin} --wait ${iptables_lock_wait_time} -F -t $a
		[ $? -ne 0 ] && has_errors=1

		${iptables_bin} --wait ${iptables_lock_wait_time} -X -t $a
		[ $? -ne 0 ] && has_errors=1
	done
	eend ${has_errors}
}

stop_pre
stop
