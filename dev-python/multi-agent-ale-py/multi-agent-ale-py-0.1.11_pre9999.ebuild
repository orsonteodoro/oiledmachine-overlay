# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# There is a strange versioning in this package:
# 0.1.11 is >=May 24, 2021
# 0.1.1 is >=May 23, 2020
# 0.6.1 is <May 23, 2020

MY_PN="Multi-Agent-ALE"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
# Upstream does not list python support for this version but, live
# is up to 3.10

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Farama-Foundation/Multi-Agent-ALE.git"
	EGIT_BRANCH="master"
	FALLBACK_COMMIT="668c9b8f5690b478a738646fee5d68e2536fe7a8" # Dec 11, 2022
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/Farama-Foundation/Multi-Agent-ALE/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="A fork of the the Arcade Learning Environment (ALE) platform for AI research with multiplayer support"
HOMEPAGE="https://github.com/Farama-Foundation/Multi-Agent-ALE"
LICENSE="
	GPL-2
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc examples test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	>=dev-build/cmake-3.14
	dev-build/ninja
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "ChangeLog" "README.md" "doc/manual/manual.pdf" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	doins \
		"Copyright.txt" \
		"License.txt" \
		"README-SDL.txt"
	docinto readmes
	if use doc ; then
		einstalldocs
	fi
	if use examples ; then
		insinto "/usr/share/${PN}/examples"
		doins -r "doc/examples/"*
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
