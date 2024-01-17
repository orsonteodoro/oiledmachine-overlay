# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SRC_URI=""
S="${WORKDIR}"

DESCRIPTION="finit.d/*.conf files for the finit init system"
HOMEPAGE="
https://troglobit.com/projects/finit/
https://github.com/troglobit/finit
"
LICENSE="
	BSD-2
	MIT
	GPL-2
"
if [[ "${PV}" =~ "99999999" ]] ; then
	# No KEYWORDS for live
	:;
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
fi
RESTRICT="mirror test"
SLOT="0"
IUSE+="
	${SERVICES[@]}
	dash
	+dbus
	hook-scripts
	netlink
"
REQUIRED_USE="
	?? (
		hook-scripts
		netlink
	)
"
RDEPEND="
	!sys-apps/openrc
	app-admin/sudo
	sys-libs/libcap
	sys-process/procps
	dash? (
		app-shells/dash[libedit]
	)
"
PDEPEND="
	sys-apps/finit[dbus?,hook-scripts?,netlink?]
"

pkg_setup() {
	if [[ "${PV}" =~ "99999999" ]] ; then
ewarn
ewarn "This version of the ebuild is currently being converted to an openrc -> finit init converter and considered pre alpha."
ewarn "This will increase the package support init files in a less biased way"
ewarn "Do not use this ebuild this time.  Use the snapshot instead."
ewarn
ewarn "This is the dev version."
	else
einfo "This is the live snapshot version."
	fi
ewarn
ewarn "For wireless, it is recommended to use one of the following instead:"
ewarn
ewarn "  FINIT_COND_NETWORK=\"hook/net/up\"      # needs sys-apps/finit[hook-scripts]"
ewarn "  FINIT_COND_NETWORK=\"net/wlan0/up\"     # needs sys-apps/finit[netlink]"
ewarn "  FINIT_COND_NETWORK=\"net/eth0/up\"      # needs sys-apps/finit[netlink]"
ewarn
ewarn "Prohibited for wireless:"
ewarn
ewarn "  FINIT_COND_NETWORK=\"net/route/default\""
ewarn
ewarn
ewarn "Place one of the above in /etc/portage/env/finit-d.conf"
ewarn
ewarn "Place the following in /etc/portage/package.env:"
ewarn
ewarn "  ${CATEGORY}/${PN} finit-d.conf"
ewarn
}

src_unpack() {
	if [[ "${PV}" =~ "99999999" ]] ; then
		cp -a "${FILESDIR}/dev/"* "${WORKDIR}" || die
	else
		cp -a "${FILESDIR}/${PV}/"* "${WORKDIR}" || die
	fi
}

src_prepare() {
	default
}

src_compile() {
	chmod +x generate.sh || die
	use dash && export FINIT_SHELL="/bin/dash"
	use dash || export FINIT_SHELL="/bin/sh"
	if [ -n "${FINIT_COND_NETWORK}" ] ; then
einfo "Using ${FINIT_COND_NETWORK} for network up."
		export FINIT_COND_NETWORK
	else
einfo "Using net/route/default for network up.  This conditon is bugged.  See metadata.xml for details on FINIT_COND_NETWORK."
		export FINIT_COND_NETWORK="net/route/default"
	fi

	# Save before wipe
	cp -a "${WORKDIR}/confs/getty.conf" "${WORKDIR}" || die
	./generate.sh || die
	cp -a "${WORKDIR}/getty.conf" "${WORKDIR}/confs" || die

	local n=$(cat "${WORKDIR}/needs_net.txt" | wc -l)
	if (( n > 1 )) && ! use hook-scripts && ! use netlink ; then
eerror "You need to enable either hook-scripts or netlink USE flag."
		die
	fi
	local n=$(cat "${WORKDIR}/needs_dbus.txt" | wc -l)
	if (( n > 1 )) && ! use dbus ; then
eerror "You need to enable the dbus USE flag."
		die
	fi

	if has_version "net-firewall/iptables" ; then
		einfo "Generating ip6tables .conf"
		cp -a \
			"confs/net-firewall/iptables/iptables.conf" \
			"confs/net-firewall/iptables/ip6tables.conf" \
			|| die
		sed -i \
			-e "s|-- iptables|-- ip6tables|g" \
			-e "s|name:iptables|name:ip6tables|g" \
			-e "s|set iptables|set ip6tables|g" \
			-e "s|/iptables/|/ip6tables/|g" \
			-e "s|iptables-|ip6tables-|g" \
			-e '1i SVCNAME="ip6tables"' \
			-e '1i RC_SVCNAME="ip6tables"' \
			"confs/net-firewall/iptables/ip6tables.conf" \
			|| die
	fi
}

symlink_hooks() {
	local pairs=(
		"hook_banner_fn:hook/sys/banner"
		"hook_rootfs_up_fn:hook/mount/root"
		"hook_mount_error_fn:hook/mount/error"
		"hook_mount_post_fn:hook/mount/post"
		"hook_basefs_up_fn:hook/mount/all"
		"hook_svc_plugin_fn:hook/svc/plugin"
		"hook_network_up_fn:hook/net/up"
		"hook_svc_up_fn:hook/svc/up"
		"hook_system_up_fn:hook/sys/up"
		# "hook_svc_reconf_fn:"
		# "hook_runlevel_change_fn:"
		"hook_network_dn_fn:hook/net/down"
		"hook_shutdown_fn:hook/sys/shutdown"
		"hook_svc_dn_fn:hook/svc/down"
		"hook_system_dn_fn:hook/sys/down"
	)

	local need_hooks=0
	for row in ${pairs[@]} ; do
		local hook="${row%:*}"
		local fragment="${row#*:}"
		if grep -q "${hook}" "${ED}/lib/finit/scripts/${pkg}/${script}" ; then
			need_hooks=1
			dosym \
				"/lib/finit/scripts/${pkg}/${script}" \
				"/libexec/finit/${fragment}/${script}"
		fi
	done

	if (( ${need_hooks} == 1 )) && ! use hook-scripts ; then
eerror "You need to enable the hook-scripts USE flag."
		die
	fi
}

install_scripts() {
	local pkg="${1}"
	exeinto "/lib/finit/scripts/${pkg}"
	[[ -e "${WORKDIR}/scripts/${pkg}" ]] || return
	pushd "${WORKDIR}/scripts/${pkg}" >/dev/null 2>&1 || die
		for script in $(ls) ; do
			is_blacklisted_svc "${script}" && continue
			doexe "${script}"
			fowners root:root "/lib/finit/scripts/${pkg}/${script}"
			fperms 0750 "/lib/finit/scripts/${pkg}/${script}"

			symlink_hooks
		done
	popd >/dev/null 2>&1 || die
}

install_lib() {
	local script="${1}"
	exeinto "/lib/finit/scripts/lib"
	doexe "${script}"
	fowners "root:root" "/lib/finit/scripts/lib/${script}"
	fperms 0750 "/lib/finit/scripts/lib/${script}"
}

is_blacklisted_pkg() {
	local pkg="${1}"
	local x
	for x in ${FINIT_BLACKLIST_PKGS} ; do
		if [[ "${pkg}" == "${x}" ]] ; then
			return 0
		fi
	done
	return 1
}

is_blacklisted_svc() {
	local svc
	svc="${1/.conf}"
	svc="${svc/.sh}"
	local x
	for x in ${FINIT_BLACKLIST_SVCNAMES} ; do
		if [[ "${svc}" == "${x}" ]] ; then
			return 0
		fi
	done
	return 1
}

generate_netifrc_instances() {
	local pkg="net-misc/netifrc"
	local iface
	for iface in $(ls /sys/class/net) ; do
		[[ "${iface}" == "lo" ]] && continue
		is_blacklisted_svc "net@${iface}" && continue
		einfo "Creating instance net@${iface}.conf"
		dosym \
			"/etc/finit.d/available/${pkg}/net@.conf" \
			"/etc/finit.d/available/${pkg}/net@${iface}.conf"
		dosym \
			"/etc/finit.d/available/${pkg}/net@.conf" \
			"/etc/finit.d/enabled/net@${iface}.conf"
	done
}

gen_start_start_daemon_wrapper() {
# A response to:  grep -r -e "start-stop-daemon" /lib/netifrc/net
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/start-stop-daemon"
#!${FINIT_SHELL}
. /lib/finit/scripts/lib/lib.sh
start_stop_daemon \$@
EOF
	fperms 0750 /usr/bin/start-stop-daemon
}

src_install() {
	local PKGS=( $(cat "${WORKDIR}/pkgs.txt") )
	local pkg
	for pkg in ${PKGS[@]} ; do
		# Duplicate, already done by finit
		[[ "${pkg}" == "sys-apps/dbus" ]] && continue
		[[ "${pkg}" == "sys-fs/udev-init-scripts" ]] && continue
		is_blacklisted_pkg "${pkg}" && continue

		insinto "/etc/finit.d/available/${pkg}"
		pushd "${WORKDIR}/confs/${pkg}" >/dev/null 2>&1 || die
			local svc
			for svc in $(ls) ; do
				is_blacklisted_svc "${svc}" && continue
				doins "${svc}"
				dosym \
					"/etc/finit.d/available/${pkg}/${svc}" \
					"/etc/finit.d/enabled/${svc}"
			done
		popd >/dev/null 2>&1 || die
		install_scripts "${pkg}"
	done

	if is_blacklisted_pkg "net-misc/netifrc" ; then
		:;
	elif has_version "net-misc/netifrc" ; then
		generate_netifrc_instances
	fi

	insinto "/etc/finit.d/available/${CATEGORY}/${PN}"
	doins "${WORKDIR}/confs/getty.conf"
	dosym \
		"/etc/finit.d/available/${CATEGORY}/${PN}/getty.conf" \
		"/etc/finit.d/enabled/getty.conf"

	insinto "/etc"
	doins "${WORKDIR}/rc.local"
	doins "${WORKDIR}/finit.conf"
	install_lib "lib.sh"
	install_lib "event.sh"

	if is_blacklisted_pkg "net-firewall/iptables" ; then
		:;
	elif is_blacklisted_svc "ip6tables" ; then
		:;
	elif has_version "net-firewall/iptables" ; then
		dosym \
			/lib/finit/scripts/net-firewall/iptables/iptables.sh \
			/lib/finit/scripts/net-firewall/iptables/ip6tables.sh
	fi

	# Broken default settings.  Requires METALOG_OPTS+=" -N" for some kernels.
	rm -f "${ED}/etc/finit.d/enabled/metalog.conf"

	# Causes indefinite pause
	rm -f "${ED}/etc/finit.d/enabled/iptables.conf"
	rm -f "${ED}/etc/finit.d/enabled/ip6tables.conf"

	gen_start_start_daemon_wrapper
}

pkg_postinst() {
ewarn
ewarn "Your configs must be correct and exist or you may see crash listed in"
ewarn "initctl.  Debug messages are disabled."
ewarn
ewarn "You must use etc-update for changes to take effect."
ewarn "Save your work before running \`initctl reload\`."
ewarn
	if use netlink ; then
ewarn
ewarn "You may need to disconnect/reconnect not by automated means in order to"
ewarn "trigger network up event."
ewarn
	fi
	if has_version "app-admin/metalog" ; then
ewarn
ewarn "-N may need to be added to METALOG_OPTS in /etc/conf.d/metalog or it"
ewarn "may cause a indefinite pause."
ewarn
ewarn "The /etc/finit.d/enabled/metalog.conf has been disabled to avoid"
ewarn "indefinite pause on misconfigured metalog."
ewarn
	fi
	if has_version "net-misc/netifrc" ; then
ewarn
ewarn "net-misc/netifrc is currently broken.  Use net-misc/networkmanager"
ewarn "instead."
ewarn
ewarn "For <iface> do:  ln -s /etc/finit.d/enabled/net@.conf /etc/finit.d/enabled/net@<iface>.conf"
ewarn "For eth0 do:  ln -s /etc/finit.d/enabled/net@.conf /etc/finit.d/enabled/net@eth0.conf"
ewarn "For wlan0 do:  ln -s /etc/finit.d/enabled/net@.conf /etc/finit.d/enabled/net@wlan0.conf"
ewarn "For wlp0s18f2u2 do:  ln -s /etc/finit.d/enabled/net@.conf /etc/finit.d/enabled/net@wlp0s18f2u2.conf"
ewarn
ewarn "For possible <iface>, see /sys/class/net or ifconfig."
ewarn
ewarn "Autoconnect is broken, you must manually run it by doing"
ewarn "INIT=openrc IFACE=<iface> /lib/finit/scripts/net-misc/netifrc/net@.sh start"
ewarn
	fi
	if has_version "dev-db/mysql-init-scripts" ; then
ewarn
ewarn "You must manually disable some of the mysql-init-scripts in"
ewarn "/etc/finit.d/enabled to prevent blocking init progression or"
ewarn "through FINIT_BLACKLIST_SVCNAMES.  See metadata.xml for details."
ewarn
	fi
ewarn
ewarn "IMPORTANT"
ewarn
ewarn "A rescue cd is required to unstuck the init system."
ewarn
ewarn "Any failed in [S] runlevel may cause an indefinite pause."
ewarn
ewarn "Failed [S] should be moved to runlevels [12345] for rescue, [2345] for"
ewarn "non-network, or [345] for network or deleted from /etc/finit.d/enabled."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# networkmanager - fail
# netifrc (autoconnect) - passed
# netifrc (manually connect) - passed
# logger (sysklogd) - passed
# tty - passed

