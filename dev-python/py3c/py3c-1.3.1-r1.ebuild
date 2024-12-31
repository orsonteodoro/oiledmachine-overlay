# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} ) # Upstream tests up to 3.10

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/encukou/py3c/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A Python 2/3 compatibility layer for C extensions"
HOMEPAGE="https://github.com/encukou/py3c"
LICENSE="
	MIT
	doc? (
		CC-BY-SA-3.0
	)
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42.2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP},latex]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/tox[${PYTHON_USEDEP}]
	)
"

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
