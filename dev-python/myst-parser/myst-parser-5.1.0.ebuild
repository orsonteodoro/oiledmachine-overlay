# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
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

DISTUTILS_USE_PEP517="flit"
MY_PN="MyST-Parser"
PYTHON_COMPAT=( "python3_"{11..14} )

inherit cro distutils-r1

SRC_URI="
https://github.com/executablebooks/MyST-Parser/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

DESCRIPTION="An extended commonmark compliant parser, with bridges to docutils/sphinx"
HOMEPAGE="
	https://github.com/executablebooks/MyST-Parser
	https://myst-parser.readthedocs.io/
"
LICENSE="
	MIT
"
KEYWORDS="~amd64"
SLOT="0"
IUSE+=" code-style doc linkify rtd test test-docutils"
REQUIRED_USE="
	doc? (
		linkify
		rtd
	)
"
RDEPEND+="
	>=dev-python/docutils-0.20[${PYTHON_USEDEP}]
	<dev-python/docutils-0.23[${PYTHON_USEDEP}]

	$(cro dev-python/markdown-it-py 4.2 '[${PYTHON_USEDEP}]')

	$(cro dev-python/mdit-py-plugins 0.6 '[${PYTHON_USEDEP}]')
	>=dev-python/mdit-py-plugins-0.6.1[${PYTHON_USEDEP}]

	>=dev-python/sphinx-8[${PYTHON_USEDEP}]
	<dev-python/sphinx-10[${PYTHON_USEDEP}]

	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]

"
DEPEND+="
	${RDEPEND}
"
TRASH="
"
BDEPEND+="
	>=dev-python/flit-core-3.4[${PYTHON_USEDEP}]
	<dev-python/flit-core-4[${PYTHON_USEDEP}]

	code-style? (
		$(python_gen_any_dep '
			>=dev-vcs/pre-commit-4.0[${PYTHON_SINGLE_USEDEP}]
			<dev-vcs/pre-commit-5.0[${PYTHON_SINGLE_USEDEP}]
		')
	)
	linkify? (
		$(cro dev-python/linkify-it-py 2.0 '[${PYTHON_USEDEP}]')
	)
	rtd? (
		>=dev-python/sphinx-8[${PYTHON_USEDEP}]
		>=dev-python/sphinx-tippy-0.4.3[${PYTHON_USEDEP}]
		$(cro dev-python/sphinx-book-theme 1.1 '[${PYTHON_USEDEP}]')
		$(cro dev-python/sphinx-autodoc2 0.5.0 '[${PYTHON_USEDEP}]')
		$(cro dev-python/sphinxext-opengraph 0.13.0 '[${PYTHON_USEDEP}]')
		$(cro dev-python/sphinxext-rediraffe 0.3.0 '[${PYTHON_USEDEP}]')
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-design[${PYTHON_USEDEP}]
		dev-python/sphinx-pyscript[${PYTHON_USEDEP}]
		dev-python/sphinx-togglebutton[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-9[${PYTHON_USEDEP}]
		<dev-python/pytest-10[${PYTHON_USEDEP}]

		$(cro dev-python/pytest-param-files 0.6.0 '[${PYTHON_USEDEP}]')
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP},toml(+)]
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
		$(cro dev-python/sphinx-pytest 0.3.0 '[${PYTHON_USEDEP}]')
		<dev-python/pygments-2.21[${PYTHON_USEDEP}]

		>=dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-8.2[${PYTHON_USEDEP}]
		dev-python/types-urllib3[${PYTHON_USEDEP}]

		>=dev-util/ruff-0.14.11
	)
	test-docutils? (
		>=dev-python/pytest-9[${PYTHON_USEDEP}]
		<dev-python/pytest-10[${PYTHON_USEDEP}]

		$(cro dev-python/pytest-param-files 0.6.0 '[${PYTHON_USEDEP}]')
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
