# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/py-pdf/fpdf2.git"
	FALLBACK_COMMIT="b9cfbb6d8ca1eb034e826fd358194e899a1daf28" # Dec 16, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/py-pdf/fpdf2/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Simple PDF generation for Python"
HOMEPAGE="
	https://py-pdf.github.io/fpdf2/
	https://github.com/py-pdf/fpdf2
	https://pypi.org/project/fpdf2
"
LICENSE="
	LGPL-3+
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc"
RDEPEND+="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
	virtual/pillow[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	insinto "/usr/share/${PN}"
	doins -r "contributors"
	if use doc ; then
		insinto "/usr/share/${PN}"
		dodoc -r "docs"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
