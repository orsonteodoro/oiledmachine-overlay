# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Python library for requesting root privileges"
HOMEPAGE="https://github.com/barneygale/elevate"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" sudo policykit"
IUSE+=" gtk gnome enlightenment kde lxqt lxde mate xfce"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	|| ( sudo policykit )
	gnome? ( gtk )
	lxde? ( gtk )
	policykit? ( || ( kde gnome enlightenment lxqt lxde mate xfce ) )"
RDEPEND+="
	${PYTHON_DEPS}
	sudo? ( app-admin/sudo )
	policykit? (
		sys-auth/polkit[kde?]
		kde? ( kde-plasma/polkit-kde-agent )
		gnome? ( gnome-extra/polkit-gnome )
		enlightenment? ( x11-wm/enlightenment[policykit] )
		lxqt? ( lxqt-base/lxqt-policykit )
		lxde? (
			|| (
				lxde-base/lxsession
				lxqt-base/lxqt-policykit
			)
		)
		mate? ( mate-extra/mate-polkit )
		xfce? ( xfce-base/xfce4-session[policykit] )
	)"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
EGIT_COMMIT="78e82a8a75e6c7ffba9cf5df86931770eacb9d13"
SRC_URI="
https://github.com/barneygale/elevate/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( COPYING.txt README.rst )
