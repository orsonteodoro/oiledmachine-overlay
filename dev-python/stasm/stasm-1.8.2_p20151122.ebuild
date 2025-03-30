# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PyStasm"

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
FALLBACK_COMMIT="696fca9a4c12207ef175a8c3bdd122b11ae0552b" # Nov 22, 2015
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 flag-o-matic

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mjszczep/PyStasm.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/mjszczep/PyStasm/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Python wrapper for finding features in faces"
HOMEPAGE="
	https://github.com/mjszczep/PyStasm
	https://pypi.org/project/PyStasm
"
LICENSE="
	custom
	BSD
"
# The SIFT patent, hinted in the LICENSE.txt, has expired in 2020.
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
	')
	media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-696fca9-opencv-includes.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	append-flags -I"/usr/include/opencv4/"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
