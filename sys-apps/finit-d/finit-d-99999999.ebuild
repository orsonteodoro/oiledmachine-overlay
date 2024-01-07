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
	app-admin/sudo
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
}

install_scripts() {
	local pkg="${1}"
	exeinto "/lib/finit/scripts/${pkg}"
	[[ -e "${WORKDIR}/scripts/${pkg}" ]] || return
	pushd "${WORKDIR}/scripts/${pkg}" >/dev/null 2>&1 || die
		for script in $(ls) ; do
			doexe "${script}"
			fowners root:root "/lib/finit/scripts/${pkg}/${script}"
			fperms 0750 "/lib/finit/scripts/${pkg}/${script}"
		done
	popd >/dev/null 2>&1
}

install_lib() {
	local script="${1}"
	exeinto "/lib/finit/scripts/lib"
	doexe "${script}"
	fowners "root:root" "/lib/finit/scripts/lib/${script}"
	fperms 0750 "/lib/finit/scripts/lib/${script}"
}

src_install() {
	local PKGS=( $(cat "${WORKDIR}/pkgs.txt") )
	local pkgs
	for pkg in ${PKGS[@]} ; do
		# Duplicate, already done by finit
		[[ "${pkg}" == "sys-apps/dbus" ]] && continue
		[[ "${pkg}" == "sys-fs/udev-init-scripts" ]] && continue

		insinto "/etc/finit.d/available/${pkg}"
		pushd "${WORKDIR}/confs/${pkg}" || die
			for svc in $(ls) ; do
				doins "${svc}"
				dodir "/etc/finit.d/enabled"
				dosym \
					"/etc/finit.d/available/${pkg}/${svc}" \
					"/etc/finit.d/enabled/${svc}"
			done
		popd
		install_scripts "${pkg}"
	done

	insinto "/etc/finit.d/available/${CATEGORY}/${PN}"
	doins "${WORKDIR}/confs/getty.conf"
	dodir "/etc/finit.d/enabled"
	dosym \
		"/etc/finit.d/available/${CATEGORY}/${PN}/getty.conf" \
		"/etc/finit.d/enabled/getty.conf"

	insinto "/etc"
	doins "${WORKDIR}/rc.local"
	doins "${WORKDIR}/finit.conf"
	install_lib "lib.sh"
	install_lib "event.sh"
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
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
