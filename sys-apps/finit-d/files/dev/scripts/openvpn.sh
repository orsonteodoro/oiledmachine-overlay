#!/bin/bash
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/openvpn

. /etc/finit.d/scripts/openvpn-lib.sh

start() {
	# If we are re-called by the openvpn gentoo-up.sh script
	# then we don't actually want to start openvpn
	[ "${IN_BACKGROUND}" = "true" ] && return 0

	ebegin "Starting ${SVCNAME}"

	checkconfig || return 1

	local args="" reenter=${RE_ENTER:-"no"}
	# If the config file does not specify the cd option, we do
	# But if we specify it, we override the config option which we do not want
	if ! grep -q "^[ 	]*cd[ 	].*" "${VPNCONF}" ; then
		args="${args} --cd ${VPNDIR}"
	fi

	# We mark the service as inactive and then start it.
	# When we get an authenticated packet from the peer then we run our script
	# which configures our DNS if any and marks us as up.
	if [ "${DETECT_CLIENT:-yes}" = "yes" ] && \
	grep -q "^[ 	]*remote[ 	].*" "${VPNCONF}" ; then
		reenter="yes"
		args="${args} --up-delay --up-restart"
		args="${args} --script-security 2"
		args="${args} --up /etc/openvpn/up.sh"
		args="${args} --down-pre --down /etc/openvpn/down.sh"

		# Warn about setting scripts as we override them
		if grep -Eq "^[ 	]*(up|down)[ 	].*" "${VPNCONF}" ; then
			ewarn "WARNING: You have defined your own up/down scripts"
			ewarn "As you're running as a client, we now force Gentoo specific"
			ewarn "scripts to be run for up and down events."
			ewarn "These scripts will call /etc/openvpn/${SVCNAME}-{up,down}.sh"
			ewarn "where you can put your own code."
		fi

		# Warn about the inability to change ip/route/dns information when
		# dropping privs
		if grep -q "^[ 	]*user[ 	].*" "${VPNCONF}" ; then
			ewarn "WARNING: You are dropping root privileges!"
			ewarn "As such openvpn may not be able to change ip, routing"
			ewarn "or DNS configuration."
		fi
	else
		# So we're a server. Run as openvpn unless otherwise specified
		grep -q "^[ 	]*user[ 	].*" "${VPNCONF}" || args="${args} --user openvpn"
		grep -q "^[ 	]*group[ 	].*" "${VPNCONF}" || args="${args} --group openvpn"
	fi

	# Ensure that our scripts get the PEER_DNS variable
	[ -n "${PEER_DNS}" ] && args="${args} --setenv PEER_DNS ${PEER_DNS}"

	[ "${reenter}" = "yes" ] && mark_service_inactive "${SVCNAME}"
	set -- --config "${VPNCONF}" --writepid "${VPNPID}" --daemon --setenv "SVCNAME" "${SVCNAME}" ${args}
	"/usr/sbin/openvpn" "$@"
	eend $? "Check your logs to see why startup failed"
}

