# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This package is WIP

# Zero-tolerance policy
KERNEL_PV="6.17.8"

ANTIVIRUS_IUSE=(
	"clamav"
)

FIREWALL_IUSE=(
	"firewalld"
	"iptables"
	"nftables"
	"shorewall"
	"ufw"
)

KERNEL_IUSE=(
	"custom-kernel"
	"gentoo-sources"
	"git-sources"
	"ot-sources"
	"vanilla-sources"
)

LOGGER_IUSE=(
	"auditd"
	"rsyslog"
	"syslog-ng"
)

LSM_IUSE=(
	"apparmor"
	"selinux"
	"smack"
	"tomoyo"
)

NTP_IUSE=(
	"chrony"
	"ntp"
	"ntpsec"
)

DESCRIPTION="Requirements for security-critical secure data storage"
KEYWORDS="~amd64 ~arm64"
LICENSE="metapackage"
IUSE="
${ANTIVIRUS_IUSE[@]}
${FIREWALL_IUSE[@]}
${KERNEL_IUSE[@]}
${LOGGER_IUSE[@]}
${LSM_IUSE[@]}
${NTP_IUSE[@]}
+enforce standard relaxed
"
REQUIRED_USE="
	^^ (
		standard
		relaxed
	)
	standard? (
		clamav

		^^ (
			firewalld
			iptables
			nftables
			ufw
		)

		!custom-kernel
		|| (
			gentoo-sources
		)

		auditd
		^^ (
			rsyslog
			syslog-ng
		)

		^^ (
			apparmor
			selinux
		)
		|| (
			apparmor
			selinux
		)

		^^ (
			chrony
			ntp
		)

	)
	relaxed? (
		clamav

		^^ (
			chrony
			ntp
			ntpsec
		)

		^^ (
			firewalld
			iptables
			nftables
			shorewall
			ufw
		)

		|| (
			custom-kernel
			gentoo-sources
			git-sources
			ot-sources
			vanilla-sources
		)

		^^ (
			rsyslog
			syslog-ng
		)
		auditd

		^^ (
			apparmor
			selinux
		)
		|| (
			apparmor
			selinux
			smack
			tomoyo
		)

	)
"
SLOT="0"

ANTIVIRUS_DEPENDS="
	clamav? (
		app-antivirus/clamav
	)
"

FIREWALL_DEPENDS="
	iptables? (
		net-firewall/iptables
	)
"

LOGGER_DEPENDS="
	auditd? (
		sys-process/audit
	)
	rsyslog? (
		app-admin/rsyslog
	)
	syslog-ng? (
		app-admin/syslog-ng
	)
	virtual/logger
"

KERNEL_DEPENDS="
	!sys-kernel/gentoo-kernel
	!sys-kernel/gentoo-kernel-bin
	!sys-kernel/vanilla-kernel
	gentoo-sources? (
		>=sys-kernel/gentoo-sources-${KERNEL_PV}
	)
	git-sources? (
		>=sys-kernel/git-sources-${KERNEL_PV%.*}_rc0
	)
	ot-sources? (
		>=sys-kernel/ot-sources-${KERNEL_PV}
	)
	vanilla-sources? (
		>=sys-kernel/vanilla-sources-${KERNEL_PV}
	)
"

NTP_DEPENDS="
	chrony? (
		net-misc/chrony
	)
	ntp? (
		net-misc/ntp
	)
	ntpsec? (
		net-misc/ntpsec
	)
"

LSM_DEPENDS="
	apparmor? (
		sys-apps/apparmor
	)
	smack? (
		sys-apps/smack-utils
	)
	selinux? (
		sec-policy/selinux-base
	)
	tomoyo? (
		sys-apps/tomoyo-tools
	)
"

RDEPEND="
	enforce? (
		${ANTIVIRUS_DEPENDS}
		${FIREWALL_DEPENDS}
		${LOGGER_DEPENDS}
		${LSM_DEPENDS}
		${NTP_DEPENDS}
		>=sys-kernel/linux-firmware-20251021
		sys-kernel/mitigate-id[enforce?]
		sys-kernel/mitigate-dos[enforce?]
		sys-kernel/mitigate-dt[enforce?]
	)
"

PDEPEND="
	enforce? (
		${KERNEL_DEPENDS}
	)
"
