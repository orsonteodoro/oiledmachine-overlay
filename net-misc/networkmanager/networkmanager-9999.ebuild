# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild and init script contains AI generated data.

MY_PN="NetworkManager"

CFLAGS_HARDENED_USE_CASES="security-critical daemon login network untrusted-data sensitive-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CRSH DOS ID II PE USI"
PYTHON_COMPAT=( python3_{10..14} )

CHKL_TIMESTAMPS=(
	"dev-libs/jansson-9999"
	"net-misc/curl-9999"
	"net-misc/dhcpcd-9999"
	"sys-auth/polkit-9999"
	"sys-apps/systemd-9999"
	"sys-auth/elogind-257.9999"
	"sys-libs/libselinux-9999"
	"sys-process/audit-9999"
)

inherit cflags-hardened chkl linux-info meson-multilib fcaps flag-o-matic python-any-r1 \
	readme.gentoo-r1 secure-version systemd toolchain-funcs udev vala virtualx

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="b92182f10fc86b9f11e1f6747810bd465b6ed903"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/NetworkManager/NetworkManager.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/releases/${PV}/downloads/${MY_PN}-${PV}.tar.xz"
fi

DESCRIPTION="A set of co-operative tools that make networking simple and straightforward"
HOMEPAGE="
	https://www.networkmanager.dev
	https://gitlab.freedesktop.org/NetworkManager/NetworkManager
"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE+="
arping audit bluetooth clat +concheck connection-sharing debug dhcpcd doc elogind
gnutls iputils +introspection iptables iwd libedit +modemmanager nbft +nss
nftables ofono ovs policykit +ppp psl resolvconf selinux syslog systemd teamd
test +tools vala +wext +wifi
ebuild_revision_2
"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	filecaps
	bluetooth? ( modemmanager )
	connection-sharing? ( || ( iptables nftables ) )
	doc? ( introspection )
	iwd? ( wifi )
	test? ( tools )
	vala? ( introspection )
	wext? ( wifi )
	^^ ( gnutls nss )
	^^ (
		arping
		iputils
	)
	?? ( elogind systemd )
	?? ( syslog systemd )
"

# net-misc/dhcp is EOL
COMMON_DEPEND="
	!net-misc/dhcp
	sys-apps/util-linux:=[${MULTILIB_USEDEP}]
	>=virtual/libudev-175:=[${MULTILIB_USEDEP}]
	sys-apps/dbus:=[${MULTILIB_USEDEP}]
	net-libs/libndp:=
	>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
	audit? ( >=sys-process/audit-${AUDIT_PV}:= )
	bluetooth? ( >=net-wireless/bluez-${BLUEZ_PV}:= )
	clat? (
		>=dev-libs/libbpf-1.3.0:=
	)
	concheck? ( >=net-misc/curl-${CURL_PV}:= )
	connection-sharing? (
		net-dns/dnsmasq:=[dbus,dhcp]
		iptables? ( net-firewall/iptables:= )
		nftables? ( net-firewall/nftables:= )
	)
	dhcpcd? ( >=net-misc/dhcpcd-${DHCPCD_PV}:= )
	elogind? ( >=sys-auth/elogind-${ELOGIND_PV}:= )
	gnutls? (
		>=net-libs/gnutls-${GNUTLS_PV}:=[${MULTILIB_USEDEP}]
	)
	introspection? ( >=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:= )
	modemmanager? (
		net-misc/mobile-broadband-provider-info:=
		>=net-misc/modemmanager-0.7.991:0=
	)
	nbft? ( >=sys-libs/libnvme-${LIBNVME_PV}:= )
	nss? (
		>=dev-libs/nspr-${NSPR_PV}:=[${MULTILIB_USEDEP}]
		>=dev-libs/nss-${NSS_PV}:=[${MULTILIB_USEDEP}]
	)
	ofono? ( net-misc/ofono:= )
	ovs? ( >=dev-libs/jansson-${JANSSON_PV}:= )
	policykit? ( >=sys-auth/polkit-${POLKIT_PV}:= )
	ppp? ( >=net-dialup/ppp-2.4.5:=[ipv6(+)] )
	psl? ( net-libs/libpsl:= )
	resolvconf? ( virtual/resolvconf:* )
	selinux? (
		sec-policy/selinux-networkmanager:*
		>=sys-libs/libselinux-${LIBSELINUX_PV}:=
	)
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:= )
	teamd? (
		>=dev-libs/jansson-${JANSSON_PV}:=
		>=net-misc/libteam-1.9:=
	)
	tools? (
		>=dev-libs/jansson-${JANSSON_PV}:=
		>=dev-libs/newt-0.52.15:=
		libedit? ( dev-libs/libedit:= )
		!libedit? ( sys-libs/readline:= )
	)
"
RDEPEND="${COMMON_DEPEND}
	acct-group/plugdev:*
	arping? (
		net-analyzer/arping:=
	)
	iputils? (
		net-misc/iputils:=[arping(+)]
	)
	wifi? (
		!iwd? ( >=net-wireless/wpa_supplicant-${WPA_SUPPLICANT_PV}:=[dbus] )
		iwd? ( >=net-wireless/iwd-${IWD_PV}:= )
	)
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.18:=
	net-libs/libndp:=[${MULTILIB_USEDEP}]
	ppp? ( elibc_musl? ( net-libs/ppp-defs:= ) )
	test? ( >=dev-libs/jansson-${JANSSON_PV}:= )
"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		>=dev-libs/libxslt-${LIBXSLT_PV}
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2
	)
	introspection? (
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		>=dev-lang/perl-${PERL_PV}
		>=dev-libs/libxslt-${LIBXSLT_PV}
	)
	vala? ( $(vala_depend) )
	test? (
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]')
	)
"

python_check_deps() {
	if use introspection; then
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
	fi
	if use test; then
		python_has_version "dev-python/dbus-python[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	if use connection-sharing; then
		if kernel_is lt 5 1; then
			CONFIG_CHECK="~NF_NAT_IPV4 ~NF_NAT_MASQUERADE_IPV4"
		else
			CONFIG_CHECK="~NF_NAT ~NF_NAT_MASQUERADE"
		fi
		linux-info_pkg_setup
	fi

	if use introspection || use test; then
		python-any-r1_pkg_setup
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	DOC_CONTENTS="To modify system network connections without needing to enter the
		root password, add your user account to the 'plugdev' group."

	default
	use vala && vala_setup

	sed -i \
		-e 's#/usr/bin/sed#/bin/sed#' \
		data/84-nm-drivers.rules \
		|| die
}

meson_nm_program() {
	usex "$1" "-D${2:-$1}=$3" "-D${2:-$1}=no"
}

meson_nm_native_program() {
	multilib_native_usex "$1" "-D${2:-$1}=$3" "-D${2:-$1}=no"
}

get_fcaps() {
	#
	# Only use what is needed
	#
	# cap_net_admin - allow daemon to configure and control network devices/interfaces, routing tables, IP addresses, firewalls, wireless config, promiscuous mode, system authentication files
	# cap_dac_override - bypass DAC to change interface files or resolv.conf
	# cap_net_raw - allow to use raw or packet sockets for DHCP, ARP, neighbor discovery, Wi-Fi scanning
	# cap_bpf - allow for traffic monitoring and packet filtering
	# cap_net_bind_service - allow to use privileged ports for DHCP
	# cap_setgid - perform dropping privileges in helpers as non-root group
	# cap_setuid - perform dropping privileges in helpers as non-root user
	# cap_sys_module - allow to load network drivers, VPNs
	# cap_audit_write - write to system log
	# cap_kill - allow to terminate child processes (DHCP, wpa_supplicant, VPN daemon)
	# cap_sys_chroot - lockdown child process or plugins for file isolation
	# =ep - allowed to use these capabilities and apply immediately upon execution
	#
	local caps=""
	local nm_caps=${NM_CAPS:-"default"}
	if [[ "${nm_caps}" == "default" ]] ; then
		caps="cap_net_admin,cap_dac_override,cap_net_raw,cap_bpf,cap_net_bind_service,cap_setgid,cap_setuid,cap_sys_module,cap_audit_write,cap_kill,cap_sys_chroot"
	elif [[ "${nm_caps}" == "home" ]] ; then
	# For home user with WPA + DHCP
		caps="cap_net_admin,cap_net_raw,cap_net_bind_service,cap_bpf"
	elif [[ "${nm_caps}" == "minimal" ]] ; then
		caps="cap_net_admin,cap_net_raw,cap_net_bind_service"
	else
		caps="${nm_caps}"
	fi
	if [[ -z "${caps}" ]] ; then
eerror "QA: NM_CAPS cannot be empty."
eerror "QA: NM_CAPS:  ${NM_CAPS}"
		die
	fi
	echo "${caps}"
}

get_mycaps() {
	local caps=""
	local nm_caps=${NM_CAPS:-"default"}
	if [[ "${nm_caps}" == "default" || "${nm_caps}" == "home" || "${nm_caps}" == "minimal" ]] ; then
		caps="${nm_caps}"
	else
		caps="${nm_caps}"
	fi
	if [[ -z "${caps}" ]] ; then
eerror "QA: NM_CAPS cannot be empty."
eerror "QA: NM_CAPS:  ${NM_CAPS}"
		die
	fi
	echo "${caps}"
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	# Workaround for LLD on musl systems (bug #959603)
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	# LTO is restricted in older clang for unclear reasons.
	# https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/issues/593
	# https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/merge_requests/2053
	tc-is-clang && [[ $(clang-major-version) -lt 18 ]] && filter-lto

	has_version "sys-apps/openrc[-bash]" && die "Re-emerge with sys-apps/openrc[bash]"

	local caps=$(get_fcaps)
einfo "caps:  ${caps}"
	if use systemd ; then
		caps=$(echo "${caps}" | tr "," " " | tr "[a-z]" "[A-Z]" | sed -e "s|=ep$||g")
		sed -i -e "s|CAP_NET_ADMIN CAP_DAC_OVERRIDE CAP_NET_RAW CAP_BPF CAP_NET_BIND_SERVICE CAP_SETGID CAP_SETUID CAP_SYS_MODULE CAP_AUDIT_WRITE CAP_KILL CAP_SYS_CHROOT|${caps}|g" \
			"data/NetworkManager.service.in" \
			|| die
	fi

	# Follow order of options in meson_options.txt
	local emesonargs=(
		--localstatedir="${EPREFIX}/var" # overrride eclass ${EPREFIX}/var/lib

		# system paths
		-Dsystemdsystemunitdir=$(systemd_get_systemunitdir)
		-Dsystem_ca_path=/etc/ssl/certs
		-Dudev_dir=$(get_udevdir)
		-Ddbus_conf_dir=/usr/share/dbus-1/system.d
		-Dkernel_firmware_dir=/lib/firmware
		-Diptables=/sbin/iptables
		-Dnft=/sbin/nft
		-Ddnsmasq=/usr/sbin/dnsmasq

		# platform
		-Ddist_version=${PVR}
		$(meson_native_use_bool policykit polkit)
		$(meson_native_use_bool policykit config_auth_polkit_default)
		#-Dmodify_system=true # Build time check said that it is not allowed for security reasons
		-Dpolkit_agent_helper_1=/usr/lib/polkit-1/polkit-agent-helper-1
		$(meson_native_use_bool selinux)
		$(meson_native_use_bool systemd systemd_journal)
		-Dconfig_wifi_backend_default=$(multilib_native_usex iwd iwd default)
		-Dhostname_persist=gentoo
		-Dlibaudit=$(multilib_native_usex audit)

		# features
		$(meson_native_use_bool wext)
		$(meson_native_use_bool wifi)
		$(meson_native_use_bool iwd)
		$(meson_native_use_bool ppp)
		-Dpppd=/usr/sbin/pppd
		$(meson_native_use_bool modemmanager modem_manager)
		$(meson_native_use_bool ofono)
		$(meson_native_use_bool concheck)
		$(meson_native_use_bool teamd teamdctl)
		$(meson_native_use_bool ovs)
		$(meson_native_use_bool tools nmcli)
		$(meson_native_use_bool tools nmtui)
		$(meson_native_use_bool tools nm_cloud_setup)
		$(meson_native_use_bool bluetooth bluez5_dun)
		$(meson_native_use_bool nbft)

		# configuration plugins
		-Dconfig_plugins_default=keyfile
		-Difcfg_rh=false
		-Difupdown=false
		-Dconfig_migrate_ifcfg_rh_default=false

		# handlers for resolv.conf
		$(meson_nm_native_program resolvconf "" /sbin/resolvconf)
		-Dnetconfig=no
		-Dconfig_dns_rc_manager_default=auto

		# dhcp clients
		$(meson_nm_program dhcpcd "" /sbin/dhcpcd)

		# miscellaneous
		$(meson_native_use_bool clat)
		$(meson_native_use_bool introspection)
		$(meson_native_use_bool vala vapi)
		$(meson_native_use_bool doc docs)
		$(meson_native_use_bool doc man)
		-Dtests=$(multilib_native_usex test)
		$(meson_native_true firewalld_zone)
		-Dmore_asserts=0
		$(meson_use debug more_logging)
		-Dvalgrind=no
		-Dvalgrind_suppressions=
		-Dld_gc=false
		$(meson_native_use_bool psl libpsl)
		-Dqt=false
	)

	if multilib_is_native_abi && use wext; then
		emesonargs+=( -Dwext=force )
	fi

	if multilib_is_native_abi && use systemd; then
		emesonargs+=( -Dsession_tracking_consolekit=false )
		emesonargs+=( -Dsession_tracking=systemd )
		emesonargs+=( -Dsuspend_resume=systemd )
		emesonargs+=( -Dsystemdsystemgeneratordir=$(systemd_get_systemgeneratordir) )
	elif multilib_is_native_abi && use elogind; then
		emesonargs+=( -Dsession_tracking_consolekit=false )
		emesonargs+=( -Dsession_tracking=elogind )
		emesonargs+=( -Dsuspend_resume=elogind )
		emesonargs+=( -Dsystemdsystemgeneratordir=no )
	else
		emesonargs+=( -Dsession_tracking_consolekit=false )
		emesonargs+=( -Dsession_tracking=no )
		emesonargs+=( -Dsuspend_resume=auto )
		emesonargs+=( -Dsystemdsystemgeneratordir=no )
	fi

	if multilib_is_native_abi && use syslog; then
		emesonargs+=( -Dconfig_logging_backend_default=syslog )
	elif multilib_is_native_abi && use systemd; then
		emesonargs+=( -Dconfig_logging_backend_default=journal )
	else
		emesonargs+=( -Dconfig_logging_backend_default=default )
	fi

	if multilib_is_native_abi && use dhcpcd; then
		emesonargs+=( -Dconfig_dhcp_default=dhcpcd )
	else
		emesonargs+=( -Dconfig_dhcp_default=internal )
	fi

	if use nss; then
		emesonargs+=( -Dcrypto=nss )
	else
		emesonargs+=( -Dcrypto=gnutls )
	fi

	if use tools ; then
		emesonargs+=( -Dreadline=$(usex libedit libedit libreadline) )
	else
		emesonargs+=( -Dreadline=none )
	fi

	# Same hack as net-dialup/pptpd to get proper plugin dir for ppp, bug #519986
	if use ppp; then
		local PPPD_VER=`best_version net-dialup/ppp`
		PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
		PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
		emesonargs+=( -Dpppd_plugin_dir=/usr/$(get_libdir)/pppd/${PPPD_VER} )
	fi

	meson_src_configure
}

multilib_src_test() {
	if use test && multilib_is_native_abi; then
		python_setup
		virtx meson_src_test
	fi
}

multilib_src_install() {
	meson_src_install
	if ! multilib_is_native_abi; then
		rm -r "${ED}"/{etc,usr/{bin,lib/NetworkManager,share},var} || die
	fi
}

multilib_src_install_all() {
	! use systemd && readme.gentoo_create_doc

	newinitd "${FILESDIR}/init.d.NetworkManager-r3" NetworkManager
	newconfd "${FILESDIR}/conf.d.NetworkManager" NetworkManager


	local caps=$(get_mycaps)
	sed -i -e "s|@NM_CAPS@|${caps}|g" "${ED}/etc/init.d/NetworkManager"

	# Need to keep the /etc/NetworkManager/dispatched.d for dispatcher scripts
	keepdir /etc/NetworkManager/dispatcher.d

	# Provide openrc net dependency only when nm is connected
	exeinto /etc/NetworkManager/dispatcher.d
	newexe "${FILESDIR}/10-openrc-status-r4" 10-openrc-status
	sed -e "s:@EPREFIX@:${EPREFIX}:g" \
		-i "${ED}/etc/NetworkManager/dispatcher.d/10-openrc-status" || die

	keepdir /etc/NetworkManager/system-connections
	chmod 0600 "${ED}"/etc/NetworkManager/system-connections/.keep* # bug #383765, upstream bug #754594

	# Allow users in plugdev group to modify system connections
	insinto /usr/share/polkit-1/rules.d/
	doins "${FILESDIR}"/01-org.freedesktop.NetworkManager.settings.modify.system.rules

	insinto /usr/lib/NetworkManager/conf.d #702476
	doins "${S}"/examples/nm-conf.d/31-mac-addr-change.conf

	if use iwd; then
		# This goes to $nmlibdir/conf.d/ and $nmlibdir is '${prefix}'/lib/$PACKAGE, thus always lib, not get_libdir
		cat <<-EOF > "${ED}"/usr/lib/NetworkManager/conf.d/iwd.conf || die
		[device]
		wifi.backend=iwd
		EOF
	fi

	mv "${ED}"/usr/share/doc/{NetworkManager/examples/,${PF}} || die
	rmdir "${ED}"/usr/share/doc/NetworkManager || die

	# Empty
	rmdir "${ED}"/var{/lib{/NetworkManager,},} || die

	# https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/issues/1653
	# https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/merge_requests/2068
	# prebuilt manpages aren't installed by meson
	if ! use doc ; then
		if [[ -e "NetworkManager.conf.5" ]] ; then
			doman man/*.[1578]
		fi
	fi
}

pkg_postinst() {
	udev_reload

	systemd_reenable NetworkManager.service
	! use systemd && readme.gentoo_print_elog

	if [[ -e "${EROOT}/etc/NetworkManager/nm-system-settings.conf" ]]; then
		ewarn "The ${PN} system configuration file has moved to a new location."
		ewarn "You must migrate your settings from ${EROOT}/etc/NetworkManager/nm-system-settings.conf"
		ewarn "to ${EROOT}/etc/NetworkManager/NetworkManager.conf"
		ewarn
		ewarn "After doing so, you can remove ${EROOT}/etc/NetworkManager/nm-system-settings.conf"
	fi

	# NM fallbacks to plugin specified at compile time (upstream bug #738611)
	# but still show a warning to remember people to have cleaner config file
	if [[ -e "${EROOT}/etc/NetworkManager/NetworkManager.conf" ]]; then
		if grep plugins "${EROOT}/etc/NetworkManager/NetworkManager.conf" | grep -q ifnet; then
			ewarn
			ewarn "You seem to use 'ifnet' plugin in ${EROOT}/etc/NetworkManager/NetworkManager.conf"
			ewarn "Since it won't be used, you will need to stop setting ifnet plugin there."
			ewarn
		fi
	fi

	# NM shows lots of errors making nmcli almost unusable, bug #528748 upstream bug #690457
	if grep -r "psk-flags=1" "${EROOT}"/etc/NetworkManager/; then
		ewarn "You have psk-flags=1 setting in above files, you will need to"
		ewarn "either reconfigure affected networks or, at least, set the flag"
		ewarn "value to '0'."
	fi

	if use dhcpcd; then
		ewarn "You have enabled USE=dhcpcd, but NetworkManager since"
		ewarn "version 1.20 defaults to the internal DHCP client. If the internal client"
		ewarn "works for you, and you're happy with, the alternative USE flags can be"
		ewarn "disabled. If you want to use dhcpcd, then you need to tweak"
		ewarn "the main.dhcp configuration option to use one of them instead of internal."
		# https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/merge_requests/1988
		ewarn
	fi

	local caps=$(get_fcaps)
	export FILECAPS=(
		"${caps}=ep" "usr/sbin/NetworkManager"
	)
	fcaps_pkg_postinst
}

pkg_postrm() {
	udev_reload
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 87a7700 20260615
# nmtui:  passed
# internet:  passed
