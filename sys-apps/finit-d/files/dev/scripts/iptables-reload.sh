#!/bin/sh
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-firewall/iptables/files

source /etc/finit.d/scripts/iptables-lib.sh

reload() {
	checkkernel || return 1
	checkrules || return 1
	ebegin "Flushing firewall"
	local has_errors=0 a
	for a in $(cat ${iptables_proc}) ; do
		${iptables_bin} --wait ${iptables_lock_wait_time} -F -t $a
		[ $? -ne 0 ] && has_errors=1

		${iptables_bin} --wait ${iptables_lock_wait_time} -X -t $a
		[ $? -ne 0 ] && has_errors=1
	done
	eend ${has_errors}

	start
}

reload
