# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{8..11} ) # Upstream tests up to 3.9

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/JBKahn/flake8-print/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Check for print statements in Python files"
HOMEPAGE="https://github.com/JBKahn/flake8-print"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/pycodestyle[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/poetry-core-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-5.0.0-fix-install.patch"
)

distutils_enable_tests "pytest"

src_install() {
	distutils-r1_src_install
	cd "${S}" || die
	docinto "licenses"
	dodoc "LICENCE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
