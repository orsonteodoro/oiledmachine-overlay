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
	|| (
		policykit
		sudo
	)
	gnome? (
		gtk
	)
	lxde? (
		gtk
	)
	policykit? (
		|| (
			kde
			gnome
			enlightenment
			lxde
			lxqt
			mate
			xfce
		)
	)
"
RDEPEND+="
	policykit? (
		sys-auth/polkit[kde?]
		kde? (
			kde-plasma/polkit-kde-agent
		)
		gnome? (
			gnome-extra/polkit-gnome
		)
		enlightenment? (
			x11-wm/enlightenment[policykit]
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  howdy
