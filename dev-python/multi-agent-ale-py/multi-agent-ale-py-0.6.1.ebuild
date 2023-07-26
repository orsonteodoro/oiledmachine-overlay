# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Multi-Agent-ALE"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="The Arcade Learning Environment (ALE) -- a platform for AI research."
HOMEPAGE="https://github.com/Farama-Foundation/Multi-Agent-ALE"
LICENSE="
	GPL-2
	Apache-2.0
"
# Apache-2.0 - doc/examples/RLGlueAgent.c
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc examples test"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	>=dev-util/cmake-3.14
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-util/ninja
"
SRC_URI="
https://github.com/Farama-Foundation/Multi-Agent-ALE/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( ChangeLog README.md doc/manual/manual.pdf )

src_install() {
	distutils-r1_src_install
	docinto licenses
	doins Copyright.txt License.txt README-SDL.txt
	docinto readmes
	if use doc ; then
		einstalldocs
	fi
	if use examples ; then
		insinto /usr/share/${PN}/examples
		doins -r doc/examples/*
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
