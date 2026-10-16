# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This file is AI generated but ebuild maintainer edited.

#
# Security architecture:
#
# wazuh-docker (SEIM, XDR, FIM analysis) management server for the Security Operation Center (SOC)
# - Single node deployment choices
#   - Cloud VM
#   - Mini PC
#   - Home lab server
#   - High end single board computer (e.g. RPi)
# - Multi node deployment choices
#   - Cloud VM
#   - On-premise server for enterprise
#   - With or without VMs, but independent VMs are used for true high availability
#
# wazuh-agent (FIM monitoring) for the endpoints
# - Deployment choices
#   - Cloud VMs
#   - Containers and hosts
#   - Laptops
#   - Physical/virtual servers
#   - Workstations
#   - Not the Wazuh server
#   - Not for firewalls/routers
#
# Assets - Hardware, servers, endpoints, cloud workloads, network devices under SOC protection
# FIM - File Integrity Monitoring
# SEIM - Security Information and Event Management [the software in SOC]
# SOC - Security Operations Center [monitoring center]
# XDR - Extended Detection and Response [aggregates and correlates across assets beyond endpoints]

PYTHON_COMPAT=( "python3_"{11..14} )

# Soft checks: warn, do not die (agent still works without realtime/whodata)
CONFIG_CHECK="
	~INOTIFY_USER
	~AUDIT
	~BPF
	~BPF_SYSCALL
	~DEBUG_INFO_BTF
"

WARNING_INOTIFY_USER="CONFIG_INOTIFY_USER is required for real-time File Integrity Monitoring (syscheck realtime=yes)."
WARNING_AUDIT="CONFIG_AUDIT is required for who-data (audit provider) and correct loginuid attribution."
WARNING_BPF="CONFIG_BPF is required for who-data eBPF provider (kernel ≥ 5.8 recommended)."
WARNING_BPF_SYSCALL="CONFIG_BPF_SYSCALL is required for who-data eBPF provider."
WARNING_DEBUG_INFO_BTF="CONFIG_DEBUG_INFO_BTF (BTF) is required for modern eBPF who-data; without it the agent falls back or skips eBPF."

CHKL_TIMESTAMPS=(
	"dev-libs/libpcre2-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
)

inherit chkl linux-info python-single-r1 secure-version systemd

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/wazuh-${PV}"
SRC_URI="https://github.com/wazuh/wazuh/archive/v${PV}.tar.gz -> wazuh-${PV}.tar.gz"

DESCRIPTION="Wazuh agent – endpoint security monitoring"
HOMEPAGE="
	https://wazuh.com/
	https://documentation.wazuh.com/
	https://github.com/wazuh/wazuh
	https://github.com/wazuh/wazuh-agent
"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
DEPEND="
	$(secure-version_gen_openssl_depends)
	>=dev-libs/libpcre2-${LIBPCRE2_PV}:=
	>=sys-libs/zlib-${ZLIB_PV}:=
	net-libs/libpcap:=
"
RDEPEND="
	${DEPEND}
	acct-group/wazuh:*
	acct-user/wazuh:*
"
BDEPEND="
	$(secure-version_gen_python_depends '3.11-3.14')
	dev-build/cmake
	sys-devel/gcc
	sys-devel/make
	virtual/pkgconfig
"

pkg_setup() {
ewarn "${PN} is under construction"
	python-single-r1_pkg_setup
	linux-info_pkg_setup
	if [[ -n "${WAZUH_MANGEMENT_SERVER_IP}" ]] ; then
eerror "The WAZUH_MANGEMENT_SERVER_IP per-package environment variable must be set before emerging."
eerror "It points to the IP address or FQDN of the central Wazah manager/server."
		die
	fi
}

src_configure() {
	chkl_check_many_timestamps
}

# Wazuh install.sh is interactive; we drive it non-interactively
src_compile() {
	cd src || die
	emake TARGET=agent deps
	emake TARGET=agent
}

src_install() {
	# Non-interactive install into a temporary prefix, then move
	# The official install.sh expects to run as root and writes to /var/ossec
	# We use a DESTDIR-like approach via environment variables where possible.

	# Create the expected user/group early
	# (acct-* packages already did this)

	# Run the install script in unattended mode
	# See: https://documentation.wazuh.com/current/deployment-options/wazuh-from-sources/
	export USER_LANGUAGE="en"
	export USER_NO_STOP="y"
	export USER_INSTALL_TYPE="agent"
	export USER_DIR="/var/ossec"
	export USER_DELETE_DIR="n"
	export USER_ENABLE_ACTIVE_RESPONSE="y"
	export USER_ENABLE_SYSCHECK="y"
	export USER_ENABLE_ROOTCHECK="y"
	export USER_ENABLE_OPENSCAP="n"
	export USER_ENABLE_CISCAT="n"
	export USER_ENABLE_SYSCOLLECTOR="y"
	export USER_UPDATE="y"
	export USER_AGENT_SERVER_IP="${WAZUH_MANGEMENT_SERVER_IP}"
	export USER_AGENT_CONFIG_PROFILE="generic"
	export DOWNLOAD_CONTENT="y"

	# The install script installs directly; we need to trick it into DESTDIR
	# Current upstream install.sh does not fully support DESTDIR.
	# Practical approach used by other distros: install into image and copy.

	# Simpler reliable method for overlays:
	# 1. Build binaries already done in src_compile
	# 2. Call install.sh with a custom PREFIX if supported, otherwise
	#    install manually the key files.

	# --- Practical manual install (most robust for Gentoo) ---
	local ossec="/var/ossec"

	# Create directory structure
	dodir "${ossec}"/{bin,etc,logs,queue,var,active-response,wodles,ruleset,tmp,agentless}

	# Copy the compiled agent binaries
	cd src || die
	exeinto "${ossec}/bin"
	doexe wazuh-agentd
	doexe wazuh-execd
	doexe wazuh-logcollector
	doexe wazuh-modulesd
	doexe wazuh-syscheckd
	doexe manage_agents
	doexe agent-auth
	# add any other binaries produced

	# Config templates
	insinto "${ossec}/etc"
	doins ../etc/ossec.conf
	doins ../etc/internal_options.conf
	doins ../etc/local_internal_options.conf
	# ... (copy the rest of the etc/ tree as needed)

	# Create runtime dirs with correct ownership
	keepdir "${ossec}"/{logs,queue,var,tmp}
	fowners wazuh:wazuh "${ossec}"
	fowners -R wazuh:wazuh "${ossec}"/{logs,queue,var,tmp}

	# OpenRC service
	newinitd "${FILESDIR}"/wazuh-agent.initd wazuh-agent
	newconfd "${FILESDIR}"/wazuh-agent.confd wazuh-agent

	# systemd unit if you want (optional)
	systemd_dounit "${FILESDIR}"/wazuh-agent.service
}

pkg_postinst() {
elog
elog "The Wazuh agent was installed under \`/var/ossec\`."
elog
elog "Manual maintenance tasks still need to be completed."
elog
elog "1. Set the manager address in /var/ossec/etc/ossec.conf:"
elog
elog "     <client>"
elog "       <server>"
elog "         <address>${WAZUH_MANGEMENT_SERVER_IP}</address>"
elog "       </server>"
elog "     </client>"
elog
elog "2. (Optional) Enroll the agent:"
elog
elog "     /var/ossec/bin/agent-auth -m ${WAZUH_MANGEMENT_SERVER_IP}"
elog
elog "3. Start the agent:"
elog

    if use systemd || [[ -d /run/systemd/system ]]; then
elog "     systemctl daemon-reload"
elog "     systemctl enable --now wazuh-agent"
elog
elog "   Status / logs:"
elog
elog "     systemctl status wazuh-agent"
elog "     journalctl -u wazuh-agent -f"
    else
elog "     rc-update add wazuh-agent default"
elog "     rc-service wazuh-agent start"
elog
elog "   Status:"
elog
elog "     rc-service wazuh-agent status"
elog "     /var/ossec/bin/wazuh-control status"
    fi

elog
elog "Config test (any init):"
elog
elog "  /var/ossec/bin/wazuh-agentd -t"
elog
elog "If start fails after a crash, remove a stale lock:"
elog
elog "  rm -rf /var/ossec/var/start-script-lock"
elog
elog
elog "Kernel features used by the agent:"
elog
elog "  - CONFIG_INOTIFY_USER : realtime FIM"
elog "  - CONFIG_AUDIT        : who-data (audit) + loginuid"
elog "  - CONFIG_BPF + BTF    : who-data (eBPF), kernel ≥ 5.8 preferred"
elog
elog
elog "Tune inotify watches if you monitor too many files:"
elog
elog "  fs.inotify.max_user_watches = 1048576"
elog
}
