# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild and metadata.xml uses AI based synthetic data.

# This package is WIP

# TODO package:
# prowler

KERNEL_MIN_SLOT="6.12" # inclusive
KERNEL_MIN_LTS_SLOT="6.12" # inclusive
KERNEL_MAX_LTS_SLOT="6.18" # inclusive
LTS_VERSIONS=("5.10" "5.15" "6.1" "6.6" "6.12" "6.18")
ACTIVE_VERSIONS=("5.10" "5.15" "6.1" "6.6" "6.12" "6.18" "7.1" "7.2" "7.3")
STABLE_OR_MAINLINE_VERSIONS=("7.1" "7.2" "7.3")
ALL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "5.10" "5.11" "5.12" "5.13" "5.14" "5.15" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.1" "6.2" "6.3" "6.4" "6.5" "6.6" "6.7" "6.8" "6.9" "6.11" "6.12" "6.13" "6.14" "6.15" "6.16" "6.17" "6.18" "6.19" "7.0" "7.1"
	"7.2" "7.3"
)
EOL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "5.11" "5.12" "5.13" "5.14" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.2" "6.3" "6.4" "6.5" "6.7" "6.8" "6.9" "6.10" "6.11" "6.13" "6.14" "6.15" "6.16" "6.17" "6.19" "7.0"
)

CHKL_TIMESTAMPS=(
	"sys-apps/util-linux-9999"
	"sys-kernel/linux-next-9999"
	"sys-kernel/ot-sources-7.3.9999"
	"sys-kernel/raspberrypi-image-9999"
	"sys-kernel/vanilla-kernel-6.1.9999"
	"sys-kernel/vanilla-kernel-6.6.9999"
	"sys-kernel/vanilla-kernel-6.12.9999"
	"sys-kernel/vanilla-kernel-6.18.9999"
)

inherit secure-version

MULTISLOT_LATEST_KERNEL_RELEASE=("${LINUX_KERNEL_5_10_PV}" "${LINUX_KERNEL_5_15_PV}" "${LINUX_KERNEL_6_1_PV}" "${LINUX_KERNEL_6_6_PV}" "${LINUX_KERNEL_6_12_PV}" "${LINUX_KERNEL_6_18_PV}" "${LINUX_KERNEL_7_1_PV}" "${LINUX_KERNEL_7_2_PV}" "${LINUX_KERNEL_7_3_RC_PV}")

ANTIVIRUS_IUSE=(
	"clamav"
)

AUDITING_IUSE=(
	"lynis"
	"openscap"
)

CLOUD_COMPLIANCE_IUSE=(
	"prowler"
)

DATA_ENCRYPTION_IUSE=(
	"dm-crypt"
	"ecryptfs"
	"veracrypt"
)

# File Integrity Monitoring
FIM_IUSE=(
	"aide"
	"samhain"
	"tripwire"
)

FIREWALL_IUSE=(
	"firewalld"
	"iptables"
	"nftables"
	"shorewall"
	"ufw"
)

FIRMWARE_IUSE=(
	"intel-microcode"
	"linux-firmware"
)

IDS_IUSE=(
	"snort"
)

KERNEL_IUSE=(
	"custom-kernel"
	"gentoo-sources"
	"git-sources"
	"linux-next"
	"ot-sources"
	"vanilla-sources"
)

LOGGER_IUSE=(
	"auditd"
	"ossec"
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

HOST_TYPE_IUSE=(
	"audit"		# Computer #1
	"+production"	# Computer #2
)

PASSWORD_MANAGER_IUSE=(
	"kpcli"
	"keepass"
	"keepassxc"
)

PROFILES_IUSE=(
	"casual"
	"compliant"
	"flexible"
)

SANDBOX_IUSE=(
	"firejail"
)

CHKL_TIMESTAMPS=(
	"sys-kernel/linux-next-9999"
	"sys-kernel/linux-firmware-99999999"
	"sys-kernel/ot-sources-7.3.9999"
)

KERNEL_FLAVORS=(
	"kernel_flavor_gentoo-kernel"
	"kernel_flavor_gentoo-kernel-bin"
	"kernel_flavor_gentoo-sources"
	"kernel_flavor_git-sources"
	"kernel_flavor_linux-next"
	"kernel_flavor_ot-sources"
	"kernel_flavor_vanilla-kernel"
	"kernel_flavor_vanilla-sources"
)

KERNEL_SLOTS=(
	# Deny delayed update slots.
	#"kernel_slot_5_10"
	#"kernel_slot_5_15"
	#"kernel_slot_6_1"
	#"kernel_slot_6_1_live"
	#"kernel_slot_6_6"
	#"kernel_slot_6_6_live"
	# Allow only early update slots.
	"kernel_slot_6_12"
	"kernel_slot_6_12_live"
	"kernel_slot_6_18"
	"kernel_slot_6_18_live"
	"kernel_slot_7_1"
	"kernel_slot_7_2"
	"kernel_slot_rc"
	"kernel_slot_live"
)

inherit chkl dss secure-timestamp secure-version verify-binutils

DESCRIPTION="Requirements for security-critical secure data storage"
KEYWORDS="~amd64 ~arm64"
LICENSE="metapackage"
IUSE="
${ANTIVIRUS_IUSE[@]}
${AUDITING_IUSE[@]}
${CLOUD_COMPLIANCE_IUSE[@]}
${DATA_ENCRYPTION_IUSE[@]}
${FIM_IUSE[@]}
${FIREWALL_IUSE[@]}
${FIRMWARE_IUSE[@]}
${HOST_TYPE_IUSE[@]/+}
${IDS_IUSE[@]}
${KERNEL_FLAVORS[@]}
${KERNEL_IUSE[@]}
${KERNEL_SLOTS[@]}
${LOGGER_IUSE[@]}
${LSM_IUSE[@]}
${NTP_IUSE[@]}
${PASSWORD_MANAGER_IUSE[@]}
${PROFILES_IUSE[@]}
${SANDBOX_IUSE[@]}
+enforce
ebuild_revision_52
"
REQUIRED_USE="
	|| (
		${KERNEL_FLAVORS[@]}
	)
	|| (
		${KERNEL_SLOTS[@]}
	)
	^^ (
		${PROFILES_IUSE[@]}
	)
	^^ (
		${HOST_TYPE_IUSE[@]/+}
	)
	?? (
		rsyslog
		syslog-ng
	)

	aide? (
		!audit
		production
	)
	auditd? (
		!audit
		production
	)
	clamav? (
		!audit
		production
	)
	custom-kernel? (
		!compliant
		flexible
	)
	lynis? (
		audit
		!production
	)
	ntpsec? (
		!compliant
		flexible
	)
	openscap? (
		audit
		!production
	)
	ot-sources? (
		!compliant
		flexible
	)
	shorewall? (
		!compliant
		flexible
	)
	samhain? (
		!compliant
		audit
		flexible
	)
	smack? (
		!compliant
		flexible
	)
	tomoyo? (
		!compliant
		flexible
	)
	tripwire? (
		!compliant
		audit
		flexible
	)
	ufw? (
		audit
		!production
	)
	vanilla-sources? (
		!compliant
		flexible
	)
	veracrypt? (
		!compliant
		flexible
	)

	casual? (
		production? (
			|| (
				${PASSWORD_MANAGER_IUSE[@]}
			)
			firejail

			!firewalld
			!iptables
			!nftables
			!shorewall
			!ufw

			!ossec
			!rsyslog
			!syslog-ng

			!auditd

			!aide
			!samhain
			!tripwire

			!lynis
			!openscap

			!apparmor
			!selinux
			!smack
			!tomoyo

		)

		audit? (
			auditd
			|| (
				lynis
				openscap
			)

			aide

			nftables
		)

		|| (
			custom-kernel
			gentoo-sources
			ot-sources
			vanilla-sources
		)

		^^ (
			chrony
			ntp
			ntpsec
		)
	)
	compliant? (
		audit? (
			|| (
				lynis
				openscap
			)
		)

		|| (
			aide
		)
		clamav

		dm-crypt

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
		ossec
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
	flexible? (
		audit? (
			|| (
				lynis
				openscap
			)
		)

		|| (
			aide
			ossec
			samhain
			tripwire
		)
		clamav

		|| (
			dm-crypt
			ecryptfs
			veracrypt
		)

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
			ot-sources
			vanilla-sources
		)

		auditd
		ossec
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

# We force remove most of the tools if disabled to prevent weaponization except for availability issue.

AUDIT_DEPENDS="
	audit? (
		lynis? (
			app-forensics/lynis[audit]
		)
		openscap? (
			app-forensics/openscap[oscap,python]
		)
	)
	production? (
		!app-forensics/lynis
		!app-forensics/openscap
	)

	!lynis (
		!app-forensics/lynis
	)
	!openscap? (
		!app-forensics/openscap
	)

"

ANTIVIRUS_DEPENDS="
	audit? (
		!app-antivirus/clamav
	)
	production? (
		clamav? (
			app-antivirus/clamav[milter,unrar]
		)
	)

	!clamav? (
		!app-antivirus/clamav
	)
"

CLOUD_COMPLIANCE_DEPENDS="
	audit? (
		prowler? (
			app-admin/prowler
		)
	)
	production? (
		!app-admin/prowler
	)

	!prowler? (
		!app-admin/prowler
	)
"

FIM_DEPENDS="
	audit? (
		samhain? (
			app-forensics/samhain[mysql,postgres]
		)
		tripwire? (
			app-admin/tripwire[ssl]
		)
	)
	production? (
		!app-admin/tripwire
		!app-forensics/samhain
		aide? (
			app-forensics/aide[acl,zlib]
		)
	)

	!samhain? (
		!app-forensics/samhain
	)
	!tripwire? (
		!app-admin/tripwire
	)
"

IDS_DEPENDS="
	audit? (
		snort? (
			net-analyzer/snort[openappid]
		)
	)
	production? (
		snort? (
			net-analyzer/snort[flexresp]
		)
	)

	!snort? (
		!net-analyzer/snort
	)
"

DATA_ENCRYPTION_DEPENDS="
	app-crypt/gnupg[smartcard,ssl]
	dm-crypt? (
		sys-fs/cryptsetup
	)
	ecryptfs? (
		sys-fs/ecryptfs-utils
	)
	veracrypt? (
		app-crypt/veracrypt
	)
"

FIREWALL_DEPENDS="
	firewalld? (
		net-firewall/firewalld
	)
	iptables? (
		net-firewall/iptables
	)
	nftables? (
		net-firewall/nftables
	)
	shorewall? (
		net-firewall/shorewall
	)
	ufw? (
		net-firewall/ufw
	)

	production? (
		!net-firewall/ufw
	)

	!firewalld? (
		!net-firewall/firewalld
	)
	!iptables? (
		!net-firewall/iptables
	)
	!nftables? (
		!net-firewall/nftables
	)
	!shorewall? (
		!net-firewall/shorewall
	)
	!ufw? (
		!net-firewall/ufw
	)

"

# Based on latest security advisory
# Mitigate against transient execution CPU vulnerabilities.
FIRMWARE_DEPENDS="
	intel-microcode? (
		>=sys-firmware/intel-microcode-${INTEL_MICROCODE_PV}
	)
	linux-firmware? (
		>=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV}
	)
"

LOGGER_DEPENDS="
	audit? (
		ossec? (
			app-admin/ossec-hids[mysql,server]
		)
	)

	production? (
		auditd? (
			sys-process/audit[python]
		)
		ossec? (
			app-admin/ossec-hids[agent,-mysql,-server]
		)
		rsyslog? (
			!app-admin/syslog-ng
			app-admin/rsyslog[mysql,relp,ssl]
		)
		syslog-ng? (
			!app-admin/rsyslog
			app-admin/syslog-ng[mongodb,redis,ssl]
		)
		virtual/logger
	)

	auditd? (
		!sys-process/audit
	)
	ossec? (
		!app-admin/ossec-hids
	)
	rsyslog? (
		!app-admin/rsyslog
	)
	syslog-ng? (
		!app-admin/syslog-ng
	)
"

#
# The latest stable is supported for architectural security design update or to
# mitigate against lazy backport maintainers or the possibility of a missed
# backport which has been observed.
#
# The only the last 2 latest LTS are supported for binary drivers and
# out-of-tree drivers for security reasons.  The 2 newer LTS branches are
# typically updated before the remaining older LTS that have lag time for
# update events.
#
# KASAN is preferred over KFENCE for higher security score.  This is why
# gentoo-kernel and gentoo-kernel-bin are banned.  KFENCE is B+ grade (89%) but
# KASAN is A- grade (90%).  Security-critical is strictly 90% score or better on
# this overlay.
#
# The sys-kernel/gentoo-sources is allowed if using KASAN otherwise it
# should be reconfigured to use it.
#
KERNEL_DEPENDS="
	$(gen_render_kernels_list_v2)
	gentoo-sources? (
		sys-kernel/gentoo-sources:=
		|| (
			~sys-kernel/gentoo-sources-${LINUX_KERNEL_7_2_PV}
			~sys-kernel/gentoo-sources-${LINUX_KERNEL_7_1_PV}
			~sys-kernel/gentoo-sources-${LINUX_KERNEL_6_18_PV}
			~sys-kernel/gentoo-sources-${LINUX_KERNEL_6_12_PV}
		)
	)
	git-sources? (
		sys-kernel/git-sources:=
		|| (
			~sys-kernel/git-sources-${LINUX_KERNEL_7_3_RC_PV}
		)
	)
	linux-next? (
		sys-kernel/linux-next:=
		|| (
			~sys-kernel/linux-next-9999
		)
	)
	ot-sources? (
		sys-kernel/ot-sources:=
		|| (
			~sys-kernel/ot-sources-7.3.9999
			~sys-kernel/ot-sources-${LINUX_KERNEL_7_2_PV}
			~sys-kernel/ot-sources-${LINUX_KERNEL_7_1_PV}
			~sys-kernel/ot-sources-${LINUX_KERNEL_6_18_PV}
			~sys-kernel/ot-sources-${LINUX_KERNEL_6_12_PV}
		)
	)
	vanilla-sources? (
		sys-kernel/vanilla-sources:=
		|| (
			~sys-kernel/vanilla-sources-${LINUX_KERNEL_7_2_PV}
			~sys-kernel/vanilla-sources-${LINUX_KERNEL_7_1_PV}
			~sys-kernel/vanilla-sources-${LINUX_KERNEL_6_18_PV}
			~sys-kernel/vanilla-sources-${LINUX_KERNEL_6_12_PV}
		)
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

	!apparmor? (
		!sys-apps/apparmor
	)
	!smack? (
		!sys-apps/smack-utils
	)
	!selinux? (
		!sec-policy/selinux-base
	)
	!tomoyo? (
		!sys-apps/tomoyo-tools
	)
"

PASSWORD_MANAGER_DEPENDS="
	kpcli? (
		app-admin/kpcli
	)
	keepass? (
		app-admin/keepass
	)
	keepassxc? (
		app-admin/keepassxc
	)
"

SANDBOX_DEPENDS="
	firejail? (
		sys-apps/firejail
	)

	!firejail? (
		!sys-apps/firejail
	)
"

# Prevent password keyboard snooping, show password screen grabs
BANNED_RDEPEND="
	!x11-base/xorg-server
	!x11-base/xlibre
"

RDEPEND="
	enforce? (
		${BANNED_RDEPEND}
		${ANTIVIRUS_DEPENDS}
		${CLOUD_COMPLIANCE_DEPENDS}
		${DATA_ENCRYPTION_DEPENDS}
		${FIM_DEPENDS}
		${FIREWALL_DEPENDS}
		${IDS_DEPENDS}
		${LOGGER_DEPENDS}
		${LSM_DEPENDS}
		${NTP_DEPENDS}
		${PASSWORD_MANAGER_DEPENDS[@]}
		${SANDBOX_DEPENDS}
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
# Estimated _FORTIFY_SOURCE [lightweight ASan] coverage:
#    -O1:  95 - 98%
#    -Os:  93 - 98%
#    -Oz:  92 - 97%
#    -O2:  90 - 96%
#    -O3:  80 - 92%
# -Ofast:  50 - 70%
#    -O0:  0%

	if is-flagq '-O1' || is-flagq '-O2' || is-flagq '-Oz' || is-flagq '-Os' ; then
		:
	else
# If optimization level is not set, it defaults to -O0.
eerror "CFLAGS/CXXFLAGS requires an explicit optimization level.  Update /etc/portage/make.conf and re-emerge @world to continue."
eerror "Valid optimization levels for security-critical data security:  -O1, -O2, -Oz, -Os"
		is_flag_violation=1
	fi
	if (( ${is_flag_violation} == 1 )) ; then
		die
	fi

	if use linux-firmware ; then
		chkl_check_many_timestamps
	fi

	verify-binutils_check
}

pkg_postinst() {
einfo "The optional sys-kernel/mitigate-dos is also provided and can be emerged directly."
einfo "The optional sys-kernel/mitigate-dt is also provided and can be emerged directly."
einfo "The optional sys-kernel/mitigate-id is also provided and can be emerged directly."
}
