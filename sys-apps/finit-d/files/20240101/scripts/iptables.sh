#!/bin/sh
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-firewall/iptables/files

source /etc/finit.d/scripts/iptables-lib.sh

start() {
	ebegin "Loading ${iptables_name} state and starting firewall"
	${iptables_bin}-restore --wait ${iptables_lock_wait_time} ${SAVE_RESTORE_OPTIONS} < "${iptables_save}"
	eend $?
}

start
