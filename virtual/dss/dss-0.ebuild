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

# File Integrity Monitoring
FIM_IUSE=(
	"aide"
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
${FIM_IUSE[@]}
${FIREWALL_IUSE[@]}
${KERNEL_IUSE[@]}
${LOGGER_IUSE[@]}
${LSM_IUSE[@]}
${NTP_IUSE[@]}
+enforce standard relaxed
ebuild_revision_2
"
REQUIRED_USE="
	^^ (
		standard
		relaxed
	)

	custom-kernel? (
		!standard
		relaxed
	)
	git-sources? (
		!standard
		relaxed
	)
	ntpsec? (
		!standard
		relaxed
	)
	ot-sources? (
		!standard
		relaxed
	)
	shorewall? (
		!standard
		relaxed
	)
	smack? (
		!standard
		relaxed
	)
	tomoyo? (
		!standard
		relaxed
	)
	vanilla-sources? (
		!standard
		relaxed
	)

	standard? (
		aide
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
		aide
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
			smack
			tomoyo
		)

	)
"
SLOT="0"

ANTIVIRUS_DEPENDS="
	aide? (
		app-forensics/aide
	)
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

src_configure() {
	use enforce || return
	local is_flag_violation=0
	if is-flagq '-ffast-math' ; then
# Prevent non-deterministic floats or ensure integrity of mathematical/financial modeling.
eerror "-ffast-math is disallowed systemwide for CFLAGS/CXXFLAGS.  Remove from /etc/portage/make.conf and re-emerge @world to continue."
		is_flag_violation=1
	fi
	if is-flagq '-Ofast' ; then
# Prevent non-deterministic floats or ensure integrity of mathematical/financial modeling.
eerror "-Ofast is disallowed systemwide for CFLAGS/CXXFLAGS.  Remove from /etc/portage/make.conf and re-emerge @world to continue."
		is_flag_violation=1
	fi
	if is-flagq '-O3' ; then
# Prevent _FORTIFY_SOURCE checks from being optimized/dropped out at security-critical checkpoints.
eerror "-O3 is disallowed systemwide for CFLAGS/CXXFLAGS.  Remove from /etc/portage/make.conf and re-emerge @world to continue."
		is_flag_violation=1
	fi
	if is-flagq '-O0' ; then
# Ensure _FORTIFY_SOURCE checks are being used.
eerror "-O0 is disallowed systemwide for CFLAGS/CXXFLAGS.  Remove from /etc/portage/make.conf and re-emerge @world to continue."
		is_flag_violation=1
	fi

# 90% is security-critical.  A-grade security quality.
# Estimated _FORTIFY_SOURCE coverage:
#    -O0:  0%
#    -O1:  95 - 98%
#    -Oz:  92 - 97%
#    -Os:  93 - 98%
#    -O2:  90 - 96%
#    -O3:  80 - 92%
# -Ofast:  50 - 70%

	if is-flagq '-O1' || is-flagq '-O2' || is-flagq '-Oz' || is-flagq '-Os' ; then
		:
	else
# If optimization level is not set, it defaults to -O0.
eerror "CFLAGS/CXXFLAGS requires an explicit optimization level.  Update /etc/portage/make.conf and re-emerge @world to continue."
eerror "Valid optimization levels for security-critical for data security:  -O1, -O2, -Oz, -Os"
		is_flag_violation=1
	fi
	if (( ${is_flag_violation} == 1 )) ; then
		die
	fi
}
