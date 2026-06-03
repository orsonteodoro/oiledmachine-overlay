# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/py-pdf/fpdf2.git"
	FALLBACK_COMMIT="3e87ce146f0f663d2308fc27a19bd1dde5509ad2" # Feb 27, 2026
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
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev doc test
ebuild_revision_1
"
RDEPEND+="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.34.0[${PYTHON_USEDEP}]
	!=dev-python/pillow-9.2*
	virtual/pillow[${PYTHON_USEDEP},jpeg,jpeg2k,tiff,truetype,zlib]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61.0[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		dev-python/bandit[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pre-commit[${PYTHON_USEDEP}]
		dev-python/pyright[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-python/semgrep[${PYTHON_USEDEP}]
		dev-python/zizmor[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/mkdocs[${PYTHON_USEDEP}]
		dev-python/mkdocs-git-revision-date-localized-plugin[${PYTHON_USEDEP}]
		dev-python/mkdocs-include-markdown-plugin[${PYTHON_USEDEP}]
		dev-python/mkdocs-macros-plugin[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		dev-python/mkdocs-minify-plugin[${PYTHON_USEDEP}]
		dev-python/mkdocs-redirects[${PYTHON_USEDEP}]
		dev-python/mkdocs-with-pdf[${PYTHON_USEDEP}]
		dev-python/mknotebooks[${PYTHON_USEDEP}]
		dev-python/pdoc3[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/brotli[${PYTHON_USEDEP}]
		dev-python/camelot-py[${PYTHON_USEDEP},base]
		dev-python/endesive[${PYTHON_USEDEP},full]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
		dev-python/tabula-py[${PYTHON_USEDEP}]
		dev-python/uharfbuzz
	)
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

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
