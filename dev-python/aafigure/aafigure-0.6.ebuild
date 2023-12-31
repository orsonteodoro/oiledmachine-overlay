# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="ASCII art to image converter"
HOMEPAGE="
https://launchpad.net/aafigure
"
LICENSE="
	BSD
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
DEPEND+="
"
# The zlib requirement is pillow packager's fault
RDEPEND+="
	${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP},zlib]
	dev-python/reportlab[${PYTHON_USEDEP}]
"
BDEPEND+="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
SRC_URI="
mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGES.txt README.rst )

distutils_enable_sphinx "documentation"

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE.txt
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		pushd "test" || die
			${EPYTHON} test_diagrams.py || die
		popd || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
