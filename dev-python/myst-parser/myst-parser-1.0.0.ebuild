# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# sphinx-autodoc2
# sphinx-design2
# sphinx-copybutton
# sphinx-pyscript
# sphinx-tippy
# sphinx-togglebutton
# sphinxext-rediraffe

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..10} )

inherit distutils-r1

SRC_URI="
https://github.com/executablebooks/MyST-Parser/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

DESCRIPTION="An extended commonmark compliant parser, with bridges to docutils/sphinx"
HOMEPAGE="
	https://github.com/executablebooks/MyST-Parser
	https://myst-parser.readthedocs.io/
"
LICENSE="
	MIT
"
#KEYWORDS="~amd64" # Ebuild needs test
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" codestyle doc linkify rtd test test-docutils"
REQUIRED_USE="
	doc? (
		linkify
		rtd
	)
"
RDEPEND+="
	(
		>=dev-python/docutils-0.15[${PYTHON_USEDEP}]
		<dev-python/docutils-0.20[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/markdown-it-py-1.0.0[${PYTHON_USEDEP}]
		<dev-python/markdown-it-py-3.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/sphinx-5[${PYTHON_USEDEP}]
		<dev-python/sphinx-7[${PYTHON_USEDEP}]
	)
	>=dev-python/jinja2-2[${PYTHON_USEDEP}]
	>=dev-python/mdit-py-plugins-0.3.4[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]

"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	(
		>=dev-python/flit-core-3.4[${PYTHON_USEDEP}]
		<dev-python/flit-core-4[${PYTHON_USEDEP}]
	)
	codestyle? (
		$(python_gen_any_dep '
			>=dev-vcs/pre-commit-3.0[${PYTHON_SINGLE_USEDEP}]
		')
	)
	linkify? (
		>=dev-python/linkify-it-py-1.0[${PYTHON_USEDEP}]
	)
	rtd? (
		>=dev-python/pydata-sphinx-theme-0.13.0_rc4[${PYTHON_USEDEP}]
		>=dev-python/sphinx-book-theme-1.0.0_rc2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-tippy-0.3.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autodoc2-0.4.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxext-opengraph-0.7.5[${PYTHON_USEDEP}]
		>=dev-python/sphinxext-rediraffe-0.2.7[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-design2[${PYTHON_USEDEP}]
		dev-python/sphinx-pyscript[${PYTHON_USEDEP}]
		dev-python/sphinx-togglebutton[${PYTHON_USEDEP}]
	)
	test? (
		(
			>=dev-python/pytest-7[${PYTHON_USEDEP}]
			<dev-python/pytest-8[${PYTHON_USEDEP}]
		)
		>=dev-python/pytest-param-files-0.3.4[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
		dev-python/sphinx-pytest[${PYTHON_USEDEP}]

		dev-python/black[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-util/ruff
	)
	test-docutils? (
		(
			>=dev-python/pytest-7[${PYTHON_USEDEP}]
			<dev-python/pytest-8[${PYTHON_USEDEP}]
		)
		>=dev-python/pytest-param-files-0.3.4[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "docs/index.md" "README.md" )

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# A previous myst_parser ebuild did exist but this was independently created.
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
