#!/bin/bash
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/openvpn

. /etc/finit.d/scripts/openvpn-lib.sh

stop() {
	# If we are re-called by the openvpn gentoo-down.sh script
	# then we don't actually want to stop openvpn
	if [ "${IN_BACKGROUND}" = "true" ] ; then
		mark_service_inactive "${SVCNAME}"
		return 0
	fi

	ebegin "Stopping ${SVCNAME}"
	set -- --config "${VPNCONF}"
	"/usr/sbin/openvpn" "$@"
	kill -SIGTERM $(cat "${VPNPID}")
	eend $?
}

