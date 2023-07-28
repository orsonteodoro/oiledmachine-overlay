# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Multi-Agent-ALE"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
# Upstream does not list python support for this version but, live
# is up to 3.10

inherit distutils-r1

if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Farama-Foundation/Multi-Agent-ALE.git"
	EGIT_BRANCH="master"
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/Farama-Foundation/Multi-Agent-ALE/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

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
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( ChangeLog README.md doc/manual/manual.pdf )

src_unpack() {
	use fallback-commit && EGIT_COMMIT="668c9b8f5690b478a738646fee5d68e2536fe7a8" # Dec 11, 2022
	git-r3_fetch
	git-r3_checkout
}

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
