# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Check for Print statements in python files."
HOMEPAGE="https://github.com/JBKahn/flake8-print"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/pycodestyle[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/poetry-core-1.0[${PYTHON_USEDEP}]
	>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/JBKahn/flake8-print/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/${PN}-5.0.0-fix-install.patch"
)

src_install() {
	distutils-r1_src_install
	cd "${S}" || die
	docinto licenses
	dodoc LICENCE
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
