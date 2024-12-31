# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# orion

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/lebrice/SimpleParsing.git"
	FALLBACK_COMMIT="8bec5025fcbd9e0fed67abfeb90db87d57c29a35" # Nov 27, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/SimpleParsing-${PV}"
	SRC_URI="
https://github.com/lebrice/SimpleParsing/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A small utility for simplifying and cleaning up argument parsing scripts."
HOMEPAGE="
	https://github.com/lebrice/SimpleParsing
	https://pypi.org/project/simple-parsing
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested and missing dependency
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test toml yaml"
RDEPEND+="
	>=dev-python/docstring-parser-0.15[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
	toml? (
		dev-python/tomli[${PYTHON_USEDEP}]
		dev-python/tomli-w[${PYTHON_USEDEP}]
	)
	yaml? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_any_dep '
		dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
	')
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]

		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/orion[${PYTHON_USEDEP}]

		dev-python/flake8[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_test() {
	pytest || die
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
