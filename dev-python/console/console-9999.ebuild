# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mixmastamyk/console.git"
	FALLBACK_COMMIT="4405ffcb32c5cd84c0f3390af59bcb69c048fece" # Nov 7, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/mixmastamyk/console/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
	inherit pypi
fi

DESCRIPTION="Comprehensive utility library for terminals. “Better… Stronger… Faster.”"
HOMEPAGE="
	https://github.com/mixmastamyk/console
	https://pypi.org/project/console
"
LICENSE="
	LGPL-3+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" figlet webcolors"
RDEPEND+="
	>=dev-python/ezenv-0.92[${PYTHON_USEDEP}]
	dev-python/jinxed[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	figlet? (
		dev-python/pyfiglet[${PYTHON_USEDEP}]
	)
	webcolors? (
		dev-python/webcolors[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.rst" )

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
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
