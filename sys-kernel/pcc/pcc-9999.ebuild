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
LICENSE="
	allegro? (
		BSD GPL-2
	)
	vivace? (
		BSD GPL-2
	)
"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" allegro doc +vivace"
REQUIRED_USE="
	^^ ( allegro vivace )
"
RDEPEND+="
"
DEPEND+="
"
BDEPEND+="
	|| (
		sys-devel/gcc
		sys-devel/clang
	)
"
S="${WORKDIR}"
RESTRICT="mirror"
MODULE_NAMES=""
MAKEOPTS="-j1"

pkg_setup() {
	if use allegro ; then
		MODULE_NAMES+="
			tcp_pcc(kernel/net/ipv4:"${WORKDIR}/allegro/src")
		"
	fi
	if use vivace ; then
		MODULE_NAMES+="
			tcp_pcc(kernel/net/ipv4:"${WORKDIR}/vivace/src")
		"
	fi
	if use allegro || use vivace ; then
		linux-mod_pkg_setup
	fi
}

src_unpack() {
	if use allegro ; then
		EGIT_REPO_URI="https://github.com/PCCproject/PCC-Kernel.git"
		EGIT_COMMIT="HEAD"
		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="${WORKDIR}/allegro"
		git-r3_fetch
		git-r3_checkout
	fi
	if use vivace ; then
		EGIT_REPO_URI="https://github.com/PCCproject/PCC-Kernel.git"
		EGIT_COMMIT="HEAD"
		EGIT_BRANCH="vivace"
		EGIT_CHECKOUT_DIR="${WORKDIR}/vivace"
		git-r3_fetch
		git-r3_checkout
	fi
}

src_compile() {
	if use allegro || use vivace ; then
		linux-mod_src_compile
	fi
}

src_install() {
	if use allegro || use vivace ; then
		linux-mod_src_install
	fi
	if use allegro ; then
		cd "${WORKDIR}/allegro" || die
		docinto "allegro"
		dodoc "LICENSE"
		use doc && dodoc "src/README.rst"
	fi
	if use vivace ; then
		cd "${WORKDIR}/vivace" || die
		docinto "vivace"
		dodoc "LICENSE"
		use doc && dodoc "src/README.rst"
	fi
}
