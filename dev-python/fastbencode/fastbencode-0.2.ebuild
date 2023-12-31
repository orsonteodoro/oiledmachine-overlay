# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Fast implementation of bencode"
HOMEPAGE="https://github.com/breezy-team/fastbencode"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/setuptools-61.2[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"
SRC_URI="
https://github.com/breezy-team/fastbencode/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		${EPYTHON} setup.py test || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  breezy
