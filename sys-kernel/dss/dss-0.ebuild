# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild and metadata.xml uses AI based synthetic data or clarification/notes.

# This package is WIP

# TODO package:
# app-admin/wazuh-agent
# app-admin/wazuh-docker
# prowler

# For the compliant, only certified components (e.g. FIPS) should be listed.

# ossec
#   logging
#   fim
#   policy enforcement
# wazuh
#   secure config (check tampering)
#   secure sys (deps -> cve mapping)
#   track & monitor (log)
#   regular test (fim)

#HOST_TYPE_IUSE:
#	"audit"		# Computer #1
#	"+production"	# Computer #2, same as !audit

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
	"ossec"
	"samhain"
	"tripwire"
	"wazuh"
)

FIREWALL_IUSE=(
	"firewalld"
	"iptables"
	"nftables"
	"shorewall"
	"ufw"
)

HIDS_IUSE=(
	"ossec"
	"wazuh"
)

NIDS_IUSE=(
	"snort"
)

LOGGER_IUSE=(
	"auditd"
	"ossec"
	"rsyslog"
	"syslog-ng"
	"wazuh"
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

PASSWORD_MANAGER_IUSE=(
	"keepass"
	"keepassxc"
	"kpcli"
	"secrets"
)

PROFILES_IUSE=(
	"casual"
	"compliant"
	"flexible"
)

SANDBOX_IUSE=(
	"firejail"
)

SECURITY_ARCHITECTURE_ROLE=(
	"dmz"
	"endpoint"
	"internal-chokepoint"
	"internet-edge"
	"soc"
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
${HIDS_IUSE[@]}
${LOGGER_IUSE[@]}
${LSM_IUSE[@]}
${NIDS_IUSE[@]}
${NTP_IUSE[@]}
${PASSWORD_MANAGER_IUSE[@]}
${PROFILES_IUSE[@]}
${SANDBOX_IUSE[@]}
${SECURITY_ARCHITECTURE_ROLE[@]}
audit +enforce
ebuild_revision_72
"
REQUIRED_USE="
	?? (
		rsyslog
		syslog-ng
	)
	^^ (
		${PROFILES_IUSE[@]}
	)

	^^ (
		${SECURITY_ARCHITECTURE_ROLE[@]}
	)

	!audit? (
		!lynis
		!openscap
		casual? (
			!auditd
			!aide
			!nftables
		)
	)

	audit? (
		casual? (
			auditd
			aide
			nftables
		)
		|| (
			lynis
			openscap
		)
	)

	compliant? (
		!ecryptfs
		!keepass
		!keepassxc
		!kpcli
		!ntpsec
		!samhain
		!secrets
		!shorewall
		!smack
		!tomoyo
		!tripwire
		!veracrypt
	)

	aide? (
		!casual
		^^ (
			compliant
			flexible
		)
	)
	apparmor? (
		!selinux
		^^ (
			casual
			compliant
			flexible
		)
	)
	auditd? (
		^^ (
			casual
			compliant
			flexible
		)
	)
	chrony? (
		^^ (
			casual
			compliant
			flexible
		)
	)
	clamav? (
		^^ (
			casual
			compliant
			flexible
		)
	)
	dm-crypt? (
		^^ (
			casual
			compliant
			flexible
		)
	)
	ecryptfs? (
		!compliant
		^^ (
			casual
			flexible
		)
	)
	firejail? (
		casual
		!compliant
	)
	firewalld? (
		!casual
		^^ (
			compliant
			flexible
		)
	)
	iptables? (
		!casual
		^^ (
			compliant
			flexible
		)
	)
	keepass? (
		casual
		!compliant
	)
	keepassxc? (
		casual
		!compliant
	)
	kpcli? (
		casual
		!compliant
	)
	lynis? (
		audit
	)
	nftables? (
		!casual
		^^ (
			compliant
			flexible
		)
	)
	ntp? (
		^^ (
			casual
			compliant
			flexible
		)
	)
	ntpsec? (
		^^ (
			casual
			flexible
		)
	)
	openscap? (
		audit
	)
	ossec? (
		!casual
		^^ (
			compliant
			flexible
		)
	)
	rsyslog? (
		^^ (
			compliant
			flexible
		)
	)
	samhain? (
		!casual
		!compliant
		flexible
	)
	shorewall? (
		!casual
		^^ (
			flexible
		)
	)
	secrets? (
		casual
		!compliant
	)
	selinux? (
		!apparmor
		!casual
		^^ (
			compliant
			flexible
		)
	)
	shorewall? (
		^^ (
			flexible
		)
	)
	smack? (
		!casual
		!compliant
		flexible
	)
	snort? (
		!endpoint
		!soc
		^^ (
			internal-chokepoint
			internet-edge
			dmz
		)
	)
	syslog-ng? (
		^^ (
			compliant
			flexible
		)
	)
	tomoyo? (
		!casual
		!compliant
		flexible
	)
	tripwire? (
		!casual
		!compliant
		flexible
	)
	ufw? (
		!casual
		^^ (
			compliant
			flexible
		)
	)
	veracrypt? (
		!compliant
		^^ (
			casual
			flexible
		)
	)
	wazuh? (
		!casual
		^^ (
			endpoint
			soc
		)
		^^ (
			compliant
			flexible
		)
	)

	casual? (
		!audit? (
			|| (
				${PASSWORD_MANAGER_IUSE[@]}
			)
			firejail

			!firewalld
			!iptables
			!nftables
			!shorewall
			!ufw

			!rsyslog
			!syslog-ng

			!ossec
			!wazuh

			!snort

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
		^^ (
			ossec
			wazuh
		)
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
		^^ (
			ossec
			wazuh
		)
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
	!lynis (
		!app-forensics/lynis
	)
	!openscap? (
		!app-forensics/openscap
	)
	lynis? (
		app-forensics/lynis[audit]
	)
	openscap? (
		app-forensics/openscap[oscap,python]
	)
"

ANTIVIRUS_DEPENDS="
	!clamav? (
		!app-antivirus/clamav
	)
	clamav? (
		app-antivirus/clamav[milter,unrar]
	)
"

CLOUD_COMPLIANCE_DEPENDS="
	!prowler? (
		!app-admin/prowler
	)
	prowler? (
		app-admin/prowler
	)
"

FIM_DEPENDS="
	!aide? (
		app-forensics/aide
	)
	!samhain? (
		!app-forensics/samhain
	)
	!tripwire? (
		!app-admin/tripwire
	)
	aide? (
		app-forensics/aide[acl,zlib]
	)
	samhain? (
		app-forensics/samhain[mysql,postgres]
	)
	tripwire? (
		app-admin/tripwire[ssl]
	)
"

NIDS_DEPENDS="
	!snort? (
		!net-analyzer/snort
	)
	snort? (
		!audit? (
			net-analyzer/snort[flexresp]
		)
		audit? (
			net-analyzer/snort[openappid]
		)
	)
"

DATA_ENCRYPTION_DEPENDS="
	!dm-crypt? (
		!sys-fs/cryptsetup
	)
	!ecryptfs? (
		!sys-fs/ecryptfs-utils
	)
	!veracrypt? (
		!app-crypt/veracrypt
	)
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

# Assets = Hardware, servers, endpoints, cloud workloads, network devices under SOC protection
# EDR = Endpoint Detection and Response [behavioral analysis, remediation, active containment]
# Endpoint = User facing devices (laptops, mobile phones, workstations)
# DMZ = Demilitarized Zone [network Segment in the middle between internal and external network]
# IC = Internal Chokepoint [between critical network segments and VLANs to detect lateral movement]
# IE = Internet Edge [inside or outside the perimeter of the firewall]
# IDS = Intrustion Detection System [alert of signature/policy violations on system or network]
#   HIDS - Host-based IDS
#   NIDS - Network-based IDS
# SEIM = Security Information and Event Management [the software in SOC]
# SOC = Security Operations Center [monitoring center]
# XDR = Extended Detection and Response [aggregates and correlates across assets beyond endpoints]
HIDS_DEPENDS="
	!ossec? (
		!net-analyzer/ossec-hids
	)
	!wazuh? (
		!app-admin/wazuh-agent
		!app-admin/wazuh-docker
	)
	ossec? (
		net-analyzer/ossec-hids
	)
	wazuh? (
		endpoint? (
			app-admin/wazuh-agent
		)
		soc? (
			app-admin/wazuh-docker
		)
	)
"

FIREWALL_DEPENDS="
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
"

LOGGER_DEPENDS="
	!auditd? (
		!sys-process/audit
	)
	!ossec? (
		!app-admin/ossec-hids
	)
	!rsyslog? (
		!app-admin/rsyslog
	)
	!syslog-ng? (
		!app-admin/syslog-ng
	)

	auditd? (
		sys-process/audit[python]
	)
	ossec? (
		!audit? (
			net-analyzer/ossec-hids[agent,-mysql,-server]
		)
		audit? (
			net-analyzer/ossec-hids[mysql,server]
		)
	)
	rsyslog? (
		!app-admin/syslog-ng
		app-admin/rsyslog[mysql,relp,ssl]
		virtual/logger
	)
	syslog-ng? (
		!app-admin/rsyslog
		app-admin/syslog-ng[mongodb,redis,ssl]
		virtual/logger
	)
"

NTP_DEPENDS="
	!chrony? (
		!net-misc/chrony
	)
	!ntp? (
		!net-misc/ntp
	)
	!ntpsec? (
		!net-misc/ntpsec
	)
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

PASSWORD_MANAGER_DEPENDS="
	!keepass? (
		!app-admin/keepass
	)
	!keepassxc? (
		!app-admin/keepassxc
	)
	!kpcli? (
		!app-admin/kpcli
	)
	!secrets? (
		!gnome-extra/secrets
	)
	keepass? (
		app-admin/keepass
	)
	keepassxc? (
		app-admin/keepassxc
	)
	kpcli? (
		app-admin/kpcli
	)
	secrets? (
		gnome-extra/secrets
	)
"

SANDBOX_DEPENDS="
	!firejail? (
		!sys-apps/firejail
	)
	firejail? (
		sys-apps/firejail
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
		${EDR_DEPENDS}
		${FIM_DEPENDS}
		${FIREWALL_DEPENDS}
		${HIDS_DEPENDS}
		${LOGGER_DEPENDS}
		${LSM_DEPENDS}
		${NIDS_DEPENDS}
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
