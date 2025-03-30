# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Lightning-AI/utilities.git"
	FALLBACK_COMMIT="4111abf52c6f601dc9e1119a3180a6157032c20b" # Mar 27, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/utilities-${PV}"
	SRC_URI="
https://github.com/Lightning-AI/utilities/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Common Python utilities and GitHub Actions in Lightning Ecosystem"
HOMEPAGE="
	https://github.com/Lightning-AI/utilities
	https://pypi.org/project/lightning-utilities
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/packaging-17.1
		dev-python/typing-extensions
	')
"
DEPEND+="
	${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev? (
			>=app-misc/check-jsonschema-0.28.0[${PYTHON_USEDEP}]
			>=dev-python/mypy-1.0.0[${PYTHON_USEDEP}]
			dev-python/types-setuptools[${PYTHON_USEDEP}]
		)
		doc? (
			(
				>=dev-python/sphinx-5.0[${PYTHON_USEDEP}]
				<dev-python/sphinx-6.0[${PYTHON_USEDEP}]
			)
			(
				>=dev-python/myst-parser-1.0.0[${PYTHON_USEDEP}]
				<dev-python/myst-parser-2.0.0[${PYTHON_USEDEP}]
			)
			>=dev-python/docutils-0.16[${PYTHON_USEDEP}]
			>=dev-python/nbsphinx-0.8.5[${PYTHON_USEDEP}]
			>=dev-python/pandoc-1.0[${PYTHON_USEDEP}]
			>=dev-python/pygments-2.4.1[${PYTHON_USEDEP}]
			>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-autodoc-typehints-1.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-paramlinks-0.5.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-togglebutton-0.2[${PYTHON_USEDEP}]
			>=dev-python/sphinx-copybutton-0.3[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-fulltoc-1.0[${PYTHON_USEDEP}]
			dev-python/ipython[${PYTHON_USEDEP},notebook]
			dev-python/pt-lightning-sphinx-theme[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-mockautodoc[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/coverage-7.5.3[${PYTHON_USEDEP}]
			>=dev-python/pytest-8.2.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-5.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-timeout-2.3.1[${PYTHON_USEDEP}]
			dev-python/fire[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"0.11.2\"" "${S}/src/lightning_utilities/__about__.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
