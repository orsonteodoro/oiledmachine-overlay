# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This file is AI generated but ebuild maintainer edited.

#
# EDR security architecture and capabilities:
#
# wazuh-docker (SEIM, XDR, FIM analysis, HIDS analysis/management) management server for the Security Operation Center (SOC)
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
# wazuh-agent (FIM monitoring, HIDS collection/monitoring) for the endpoints
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
# EDR - Endpoint Detection and Response [behavioral analysis, remediation, active containment]
# Endpoint - User facing devices (laptops, mobile phones, workstations)
# FIM - File Integrity Monitoring
# IDS - Intrustion Detection System [alert of signature/policy violations on system or network]
#   HIDS - Host-based IDS
#   NIDS - Network-based IDS
# SEIM - Security Information and Event Management [the software in SOC]
# SOC - Security Operations Center [monitoring center]
# XDR - Extended Detection and Response [aggregates and correlates across assets beyond endpoints]

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=17
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

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"app-arch/bzip2-9999"
	"app-arch/libarchive-9999"
	"app-arch/xz-utils-9999"
	"dev-cpp/nlohmann_json-9999"
	"dev-db/sqlite-9999"
	"dev-libs/cJSON-9999"
	"dev-libs/libffi-9999"
	"dev-libs/libpcre2-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"net-misc/curl-9999"
	"sys-process/procps-9999"
)

inherit cflags-hardened chkl libcxx-slot libstdcxx-slot linux-info python-single-r1 sandbox-changes secure-version systemd

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
IUSE="
-big-endian -geoip -inotify openrc selinux +sysc +syscat -system-libs systemd
ebuild_revision_3
"
REQUIRED_USE="
	^^ (
		openrc
		systemd
	)
"
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
	geoip? (
		dev-libs/geoip
	)
	openrc? (
		>=sys-apps/openrc-${OPENRC_PV}:*
	)
	systemd? (
		>=sys-apps/systemd-${SYSTEMD_PV}:*
	)
	system-libs? (
		$(secure-version_gen_openssl_depends)
		>=app-arch/bzip2-${BZIP2_PV}:=
		>=app-arch/libarchive-${LIBARCHIVE_PV}:=
		>=app-arch/xz-utils-${XZ_UTILS_PV}:=
		>=dev-cpp/cpp-httplib-${CPP_HTTPLIB_PV}:=
		>=dev-cpp/nlohmann_json-${NLOHMANN_JSON_PV}:=
		>=dev-libs/cJSON-${CJSON_PV}:=
		>=dev-libs/libffi-${LIBFFI_PV}:=
		>=dev-libs/libpcre2-${LIBPCRE2_PV}:=
		>=net-misc/curl-${CURL_PV}:=
		>=sys-apps/dbus-${DBUS_PV}:=
		>=sys-process/procps-${PROCPS_PV}:=
		app-arch/rpm:=[sqlite]
			>=dev-db/sqlite-${SQLITE_PV}:=
			>=virtual/zlib-${ZLIB_PV}:=
			dev-lang/lua:=
			dev-libs/popt:=
		app-pda/libplist:=
		dev-cpp/benchmark:=
		dev-cpp/gtest:=
                dev-libs/libbpf-bootstrap:=
		dev-libs/libyaml:=
		dev-libs/msgpack:=
		dev-libs/rocksdb:=
		sys-apps/pacman:=
		sys-libs/db:=
		sys-process/audit:=
	)
"
BDEPEND="
	$(secure-version_gen_python_depends '3.11-3.14')
	>=dev-build/cmake-3.12.4
	>=net-misc/curl-${CURL_PV}
	app-alternatives/tar
	app-alternatives/gzip
	dev-util/patchelf
	dev-build/make
	sys-apps/findutils
	sys-devel/gcc:=
	virtual/pkgconfig
"
PATCHES=(
)

pkg_setup() {
ewarn "${PN} is under construction"
	if use system-libs ; then
ewarn "You are using an untested USE flag.  Not every ebuild for it is packaged yet."
	fi
	python-single-r1_pkg_setup
	linux-info_pkg_setup
	if [[ -z "${WAZUH_MANGEMENT_SERVER_IP}" ]] ; then
eerror
eerror "The WAZUH_MANGEMENT_SERVER_IP per-package environment variable must be"
eerror "set before emerging.  It points to the IP address or FQDN of the"
eerror "central Wazah manager/server."
eerror
eerror "Example contents of /etc/portage/env/${PN}.conf:"
eerror
eerror "WAZUH_MANGEMENT_SERVER_IP=\"192.168.1.5\""
eerror
eerror "Contents of /etc/portage/package.env:"
eerror
eerror "${CATEGORY}/${PN} ${PN}.conf"
eerror
eerror
		die
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify

	L=(
		"cJSON"
		"curl"
		"libdb"
		"libffi"
		"libyaml"
		"openssl"
		"procps"
		"sqlite"
		"zlib"
		"audit-userspace"
		"msgpack"
		"bzip2"
		"nlohmann"
		"googletest"
		"libpcre2"
		"libplist"
		"pacman"
		"libarchive"
		"popt"
		"lua"
		"rpm"
		"rocksdb"
		"lzma"
		"cpp-httplib"
		"benchmark"
		"libbpf-bootstrap"
		"dbus"
	)

	use system-libs || sandbox-changes_no_network_sandbox "For downloading prebuilt vendored dependencies (${L[@]})"
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
}

# Wazuh install.sh is interactive; we drive it non-interactively
src_compile() {
	cd src || die

	local hardening_cflags hardening_ldflags
	# Mirror upstream intent, or drop if you prefer pure Portage
	hardening_cflags="-fstack-protector-strong -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fPIC"
	hardening_ldflags="-Wl,-z,relro -Wl,-z,now -Wl,-pie"

	local all_cflags="${hardening_cflags} ${CFLAGS}"
	local all_cxxflags="${hardening_cflags} ${CXXFLAGS}"
	local all_ldflags="${hardening_ldflags} ${LDFLAGS}"

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "OSSEC_CFLAGS:  ${all_cflags}"
einfo "OSSEC_CXXFLAGS:  ${all_cxxflags}"
einfo "OSSEC_LDFLAGS:  ${all_ldflags}"

	emake \
		V=1 \
		TARGET=agent \
		DISABLE_SYSC=$(usex sysc '0' '1') \
		DISABLE_SYSCAT=$(usex syscat '0' '1') \
		EXTERNAL_SRC_ONLY=$(usex system-libs '0' '1') \
		USE_BIG_ENDIAN=$(usex big-endian '1' '') \
		USE_GEOIP=$(usex geoip '1' '') \
		USE_INOTIFY=$(usex inotify '1' '0') \
		USE_SELINUX=$(usex selinux '1' '') \
		deps

	emake \
		V=1 \
		TARGET=agent \
		DISABLE_SYSC=$(usex sysc '0' '1') \
		DISABLE_SYSCAT=$(usex syscat '0' '1') \
		EXTERNAL_SRC_ONLY=$(usex system-libs '0' '1') \
		USE_BIG_ENDIAN=$(usex big-endian '1' '') \
		USE_GEOIP=$(usex geoip '1' '') \
		USE_INOTIFY=$(usex inotify '1' '0') \
		USE_SELINUX=$(usex selinux '1' '') \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		OSSEC_CFLAGS="${all_cflags}" \
		OSSEC_LDFLAGS="${all_ldflags}" \
		AR_LDFLAGS="${all_ldflags}" \
		CMAKE_OPTS="-DCMAKE_C_FLAGS=${all_cflags} -DCMAKE_CXX_FLAGS=${all_cxxflags} -DCMAKE_EXE_LINKER_FLAGS=${all_ldflags} -DCMAKE_SHARED_LINKER_FLAGS=${all_ldflags} -DCMAKE_POSITION_INDEPENDENT_CODE=ON"
}

src_install() {
	# Non-interactive install into a temporary prefix, then move
	# The official install.sh expects to run as root and writes to /var/ossec
	# We use a DESTDIR-like approach via environment variables where possible.

	# The /var/ossec is the historical location.  Wazuh is fork of OSSEC.
	# The install location is still being used in other distros.
	# The lib is mostly hardcoded.  Do not change to $(get_libdir).

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
	local ossec="/var/ossec"
	cd "${S}/src" || die

	# Classic Make binaries (top of src/)
	local bins=(
		"active-responses"
		"agent-auth"
		"manage_agents"
		"wazuh-agentd"
		"wazuh-execd"
		"wazuh-logcollector"
		"wazuh-modulesd"
		"wazuh-syscheckd"
	)

	exeinto "${ossec}/bin"
	local b
	for b in "${bins[@]}"; do
		[[ -x ${b} ]] || die "missing binary: ${b}"
		doexe "${b}"
	done

	# FIM: CMake output
	local syscheck_bin="syscheckd/build/bin/wazuh-syscheckd"
	[[ -x ${syscheck_bin} ]] || die "missing ${syscheck_bin} (syscheckd CMake build failed?)"
	doexe "${syscheck_bin}"

	# Shared libs used at runtime (rpath often points at ../lib)
	exeinto "${ossec}/lib"

	local L=(
		# Obtained from:  find /var/tmp/portage/app-admin/wazuh-agent-4.14.9/work/wazuh-4.14.9/src/ -name "*.so*" | cut -f 10- -d "/" | sed -e "/Makefile.soname/d" -e "/fips.module.sources/d"
		"shared_modules/rsync/build/lib/librsync.so"
		"shared_modules/dbsync/build/lib/libdbsync.so"
		"libstdc++.so.6"
		"libwazuhext.so"
		"data_provider/build/lib/libsysinfo.so"
		"syscheckd/build/lib/libfimebpf.so"
		"syscheckd/build/lib/libfimdb.so"
		"libgcc_s.so.1"
		"external/libdb/build_unix/.libs/libdb-18.1.so"
		"external/libffi/server/.libs/libffi.so.6"
		"external/libffi/server/.libs/libffi.so.6.0.4"
		"external/libffi/server/.libs/libffi.so"
		"external/rocksdb/build/librocksdb.so"
		"external/rocksdb/build/librocksdb.so.8"
		"external/rocksdb/build/librocksdb.so.8.3.2"
		"external/libbpf-bootstrap/build/libbpf/libbpf.so"
		"external/curl/lib/.libs/libcurl.so.4.8.0"
		"external/curl/lib/.libs/libcurl.so"
		"external/curl/lib/.libs/libcurl.so.4"
		"external/audit-userspace/lib/.libs/libaudit.so"
		"external/audit-userspace/lib/.libs/libaudit.so.1.0.0"
		"external/audit-userspace/lib/.libs/libaudit.so.1"
		"external/libarchive/.libs/libarchive.so.13"
		"external/libarchive/.libs/libarchive.so"
		"external/libarchive/.libs/libarchive.so.13.8.1"
		"wazuh_modules/syscollector/build/lib/libsyscollector.so"
		"libwazuhshared.so"
	)

	# Adjust to whatever actually exists in your tree:
	doexe "${L[@]}" 2>/dev/null || true

	# Config templates
	insinto "${ossec}/"
	doins -r ../etc

	# Create runtime dirs with correct ownership
	keepdir "${ossec}"/{logs,queue,var,tmp}
	fowners wazuh:wazuh "${ossec}"
	fowners -R wazuh:wazuh "${ossec}"/{logs,queue,var,tmp}

	# OpenRC service
	if use openrc ; then
		newinitd "${FILESDIR}"/wazuh-agent.initd wazuh-agent
		newconfd "${FILESDIR}"/wazuh-agent.confd wazuh-agent
	fi

	# systemd unit if you want (optional)
	if use systemd ; then
		systemd_dounit "${FILESDIR}"/wazuh-agent.service
	fi

	# Fix and unpollute RPATHs
	local L
	L=(
		$(find "${ED}/var/ossec/bin" -type f)
		$(find "${ED}/var/ossec/lib" -type f)
	)
	patchelf --remove-rpath "${L[@]}" || die
	local x
	for x in "${L[@]}" ; do
		patchelf --add-rpath "/var/ossec/lib" "${x}" || die
	done
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
