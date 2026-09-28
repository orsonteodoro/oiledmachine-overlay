# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild and metadata.xml uses AI based synthetic data.

# This package is WIP

# TODO package:
# prowler

inherit secure-version

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

IDS_IUSE=(
	"snort"
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

inherit chkl secure-timestamp secure-version verify-binutils

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
${HOST_TYPE_IUSE[@]/+}
${IDS_IUSE[@]}
${LOGGER_IUSE[@]}
${LSM_IUSE[@]}
${NTP_IUSE[@]}
${PASSWORD_MANAGER_IUSE[@]}
${PROFILES_IUSE[@]}
${SANDBOX_IUSE[@]}
+enforce
ebuild_revision_71
"
REQUIRED_USE="
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
	!virtual/dss
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
