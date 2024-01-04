#!/bin/sh
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-firewall/iptables/files
# =net-firewall/iptables-1.8.9:0/1.8.3::gentoo

. /etc/conf.d/iptables
. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"iptables"}

iptables_lock_wait_time=${IPTABLES_LOCK_WAIT_TIME:-"60"}
iptables_lock_wait_interval=${IPTABLES_LOCK_WAIT_INTERVAL:-"1000"}

iptables_name="${SVCNAME}"
case "${iptables_name}" in
	iptables|ip6tables) ;;
	*) iptables_name="iptables" ;;
esac

iptables_bin="/sbin/${iptables_name}"
case "${iptables_name}" in
	iptables)  iptables_proc="/proc/net/ip_tables_names"
	           iptables_save="${IPTABLES_SAVE}";;
	ip6tables) iptables_proc="/proc/net/ip6_tables_names"
	           iptables_save="${IP6TABLES_SAVE}";;
esac

set_table_policy() {
	local has_errors=0 chains table="$1" policy="$2"
	case "${table}" in
		nat)    chains="PREROUTING POSTROUTING OUTPUT";;
		mangle) chains="PREROUTING INPUT FORWARD OUTPUT POSTROUTING";;
		filter) chains="INPUT FORWARD OUTPUT";;
		*)      chains="";;
	esac

	local chain
	for chain in ${chains} ; do
		"${iptables_bin}" --wait ${iptables_lock_wait_time} -t "${table}" -P "${chain}" "${policy}"
		[ $? -ne 0 ] && has_errors=1
	done

	return ${has_errors}
}

checkkernel() {
	if [ ! -e "${iptables_proc}" ] ; then
		eerror "Your kernel lacks ${iptables_name} support, please load"
		eerror "appropriate modules and try again."
		return 1
	fi
	return 0
}

checkconfig() {
	if [ -z "${iptables_save}" -o ! -f "${iptables_save}" ] ; then
		eerror "Not starting ${iptables_name}.  First create some rules then run:"
		eerror "/etc/init.d/${iptables_name} save"
		return 1
	fi
	return 0
}

checkrules() {
	ebegin "Checking rules"
	"${iptables_bin}-restore" --test ${SAVE_RESTORE_OPTIONS} < "${iptables_save}"
	eend $?
}

save() {
	ebegin "Saving ${iptables_name} state"
	local dir=$(dirname "${iptables_save}")
	checkpath "d" "-" "0775" "${dir}"
	checkpath "f" "-" "0600" "${iptables_save}"
	"${iptables_bin}-save" ${SAVE_RESTORE_OPTIONS} > "${iptables_save}"
	eend $?
}
