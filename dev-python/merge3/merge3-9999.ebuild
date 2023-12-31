# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3

DESCRIPTION="Python merge3 package"
HOMEPAGE="https://github.com/breezy-team/merge3"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" fallback-commit test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61.2[${PYTHON_USEDEP}]
"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( AUTHORS COPYING README.rst )

src_unpack() {
	EGIT_REPO_URI="https://github.com/breezy-team/merge3.git"
	EGIT_BRANCH="master"
	if use fallback-commit ; then
		EGIT_COMMIT="f5125c948faee69b1d16e63abc66c56d7743eeb2"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout
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
