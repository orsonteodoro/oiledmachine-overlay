# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} "pypy3" )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	EGIT_REPO_URI="https://github.com/breezy-team/merge3.git"
	FALLBACK_COMMIT="deea4acaacb3c4a53cab286490550c32d5d0c2b4" # May 5, 2024
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/breezy-team/merge3/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="Python implementation of 3-way merge"
HOMEPAGE="https://github.com/breezy-team/merge3"
LICENSE="GPL-2+"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" fallback-commit test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61.2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-util/ruff
	)
"
DOCS=( "AUTHORS" "COPYING" "README.rst" )

unpack_live() {
	if use fallback-commit ; then
		EGIT_COMMIT="${FALLBACK_COMMIT}"
	fi
	git-r3_fetch
	git-r3_checkout
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		${EPYTHON} -m unittest test_merge3 || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  breezy
