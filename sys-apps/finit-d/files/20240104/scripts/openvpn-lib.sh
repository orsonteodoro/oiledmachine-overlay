#!/bin/bash
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/openvpn
# =net-vpn/openvpn-2.6.4::gentoo

VPNDIR=${VPNDIR:-"/etc/openvpn"}
VPN=${SVCNAME#*.}
if [ -n "${VPN}" ] && [ "${SVCNAME}" != "openvpn" ]; then
	VPNPID="/run/openvpn.${VPN}.pid"
else
	VPNPID="/run/openvpn.pid"
fi
VPNCONF="${VPNDIR}/${VPN}.conf"

. /etc/conf.d/openvpn
. /etc/finit.d/scripts/lib.sh

checkconfig() {
	# Linux has good dynamic tun/tap creation
	if [ $(uname -s) = "Linux" ] ; then
		if [ ! -e /dev/net/tun ]; then
			if ! modprobe tun ; then
				eerror "TUN/TAP support is not available" \
					"in this kernel"
				return 1
			fi
		fi
		if [ -h /dev/net/tun ] && [ -c /dev/misc/net/tun ]; then
			ebegin "Detected broken /dev/net/tun symlink, fixing..."
			rm -f "/dev/net/tun"
			ln -s "/dev/misc/net/tun" "/dev/net/tun"
			eend $?
		fi
		return 0
	fi

	# Other OS's don't, so we rely on a pre-configured interface
	# per vpn instance
	local ifname=$(sed -n -e 's/[[:space:]]*dev[[:space:]][[:space:]]*\([^[:space:]]*\).*/\1/p' "${VPNCONF}")
	if [ -z "${ifname}" ] ; then
		eerror "You need to specify the interface that this openvpn" \
			"instance should use" \
			"by using the dev option in ${VPNCONF}"
		return 1
	fi

	if ! ifconfig "${ifname}" >/dev/null 2>/dev/null ; then
		# Try and create it
		echo > /dev/"${ifname}" >/dev/null
	fi
	if ! ifconfig "${ifname}" >/dev/null 2>/dev/null ; then
		eerror "${VPNCONF} requires interface ${ifname}" \
			"but that does not exist"
		return 1
	fi
}

