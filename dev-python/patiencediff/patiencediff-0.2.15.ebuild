# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} "pypy3" )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/breezy-team/patiencediff/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A Patience Diff implementation in Python"
HOMEPAGE="https://github.com/breezy-team/patiencediff"
LICENSE="GPL-2+"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-0.29[${PYTHON_USEDEP}]
	>=dev-python/setuptools-61.2[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
	test? (
		>=dev-util/ruff-0.4.3
	)
"

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		${EPYTHON} -m unittest patiencediff.test_patiencediff || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
