# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BUILD_TARGETS="clean default"
PYTHON_COMPAT=( python3_{8..11} )
inherit git-r3 linux-mod

DESCRIPTION="Performance-oriented Congestion Control"
HOMEPAGE="
http://www.pccproject.net
https://github.com/PCCproject/PCC-Kernel
"
LICENSE="BSD GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" allegro doc vivace"
REQUIRED_USE="
	^^ ( allegro vivace )
"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
"
EGIT_COMMIT="2fcc56c33f8cc3742e5ec05c1f658c9b13a9ae13"
S="${WORKDIR}"
RESTRICT="mirror"
MODULE_NAMES=""

pkg_setup() {
	if use allegro ; then
		MODULE_NAMES+="
			tcp_pcc(net/ipv4:"${WORKDIR}/allegro/src")
		"
	fi
	if use vivace ; then
		MODULE_NAMES+="
			tcp_pcc(net/ipv4:"${WORKDIR}/vivace/src")
		"
	fi
	linux-mod_pkg_setup
}

src_unpack() {
	EGIT_REPO_URI="https://github.com/PCCproject/PCC-Kernel.git"
	if use allegro ; then
		EGIT_COMMIT="HEAD"
		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="allegro"
		git-r3_fetch
		git-r3_checkout
	fi
	if use vivace ; then
		EGIT_COMMIT="HEAD"
		EGIT_BRANCH="vivace"
		EGIT_CHECKOUT_DIR="vivace"
		git-r3_fetch
		git-r3_checkout
	fi
}

src_install() {
	linux-mod_src_install
	if use allegro ; then
		cd "${WORKDIR}/allegro" || die
		dodoc LICENSE
		docinto allegro
		use doc && "${WORKDIR}/allegro/src/README.rst"
	fi
	if use vivace ; then
		cd "${WORKDIR}/vivace" || die
		dodoc LICENSE
		docinto vivace
		use doc && "${WORKDIR}/allegro/src/README.rst"
	fi
}
