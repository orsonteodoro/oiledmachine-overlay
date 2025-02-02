# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# autodoc_pydantic
# linkchecker
# nbdoc
# sphinx-typlog-theme

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="🦜🔗 Build context-aware reasoning applications"
HOMEPAGE="
	https://github.com/langchain-ai/langchain
	https://pypi.org/project/langchain
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" codespell dev doc lint"
RDEPEND+="
	>=dev-python/black-24.2.0[${PYTHON_USEDEP}]
	codespell? (
		>=dev-util/codespell-2.2.0[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-util/ruff-0.4.0
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/ipykernel-6.29.2[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/autodoc_pydantic-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/myst-parser-0.18.1[${PYTHON_USEDEP}]
		>=dev-python/nbsphinx-0.8.9[${PYTHON_USEDEP}]
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autobuild-2021.3.14[${PYTHON_USEDEP}]
		>=dev-python/sphinx-book-theme-0.3.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-typlog-theme-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-panels-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
		>=dev-python/myst-nb-0.17.1[${PYTHON_USEDEP}]
		>=dev-python/linkchecker-10.2.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-copybutton-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/nbdoc-0.0.82[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )
PATCHES=(
)

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
