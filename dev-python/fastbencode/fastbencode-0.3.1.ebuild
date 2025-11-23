# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CYTHON_SLOT="0.29"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} )

inherit cython distutils-r1

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/breezy-team/fastbencode/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Fast implementation of bencode"
HOMEPAGE="https://github.com/breezy-team/fastbencode"
LICENSE="GPL-2+"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
test
ebuild_revision_1
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/setuptools-61.2[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/cython:=
	test? (
		>=dev-util/ruff-0.4.3
	)
"

python_configure() {
	cython_python_configure
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		${EPYTHON} setup.py test || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  breezy
