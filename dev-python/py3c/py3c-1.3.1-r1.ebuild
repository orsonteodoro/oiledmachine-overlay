# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A Python 2/3 compatibility layer for C extensions"
HOMEPAGE="https://github.com/encukou/py3c"
LICENSE="
	MIT
	doc? ( CC-BY-SA-3.0 )
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42.2[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP},latex]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/tox[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/encukou/py3c/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_sphinx "doc"

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		tox || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned
