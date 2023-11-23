# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python library for requesting root privileges"
HOMEPAGE="https://github.com/barneygale/elevate"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" policykit sudo"
IUSE+=" enlightenment gnome gtk kde lxde lxqt mate xfce"
REQUIRED_USE+="
	gnome? (
		gtk
	)
	lxde? (
		gtk
	)
	policykit? (
		|| (
			enlightenment
			gnome
			kde
			lxde
			lxqt
			mate
			xfce
		)
	)
	|| (
		policykit
		sudo
	)
"
RDEPEND+="
	policykit? (
		sys-auth/polkit[kde?]
		enlightenment? (
			x11-wm/enlightenment[policykit]
		)
		gnome? (
			gnome-extra/polkit-gnome
		)
		kde? (
			kde-plasma/polkit-kde-agent
		)
		lxde? (
			|| (
				lxde-base/lxsession
				lxqt-base/lxqt-policykit
			)
		)
		lxqt? (
			lxqt-base/lxqt-policykit
		)
		mate? (
			mate-extra/mate-polkit
		)
		xfce? (
			xfce-base/xfce4-session[policykit]
		)
	)
	sudo? (
		app-admin/sudo
	)
"
DEPEND+="
	${RDEPEND}
"
EGIT_COMMIT="78e82a8a75e6c7ffba9cf5df86931770eacb9d13"
SRC_URI="
https://github.com/barneygale/elevate/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( COPYING.txt README.rst )

pkg_postinst() {
einfo
einfo "A polkit agent needs to be running in the background in the desktop"
einfo "before this can work."
einfo
einfo "Alternative desktops should test for graphical sudo via pkexec to ensure"
einfo "correctness."
einfo
einfo "Use \`equery f <pkgname>\` to see the name of the polkit agent."
einfo
einfo "enlightenment:	x11-wm/enlightenment"
einfo "gnome:		gnome-extra/polkit-gnome"
einfo "kde:		kde-plasma/polkit-kde-agent"
einfo "lxde:		lxde-base/lxsession"
einfo "			lxqt-base/lxqt-policykit"
einfo "lxqt:		lxqt-base/lxqt-policykit"
einfo "mate:		mate-extra/mate-polkit"
einfo "sudo:		app-admin/sudo"
einfo "xfce4:		xfce-base/xfce4-session"
einfo
einfo "You may place the agent in ~/.xinitrc as follows for X:"
einfo "<agent> &"
einfo
einfo "You may need to manually run the agent for Wayland based desktops:"
einfo "<agent> &"
einfo
einfo "sudo does not need to be run in the background."
einfo
ewarn
ewarn "SECURITY NOTICE"
ewarn
ewarn "Using insecure widgets or agents that do not sanitize sensitive data,"
ewarn "lock sensitive data in volatile memory, or use widgets or data types"
ewarn "that are not designed to store sensitive data can weaken security."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  howdy
