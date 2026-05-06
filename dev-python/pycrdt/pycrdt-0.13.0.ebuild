# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/y-crdt/pycrdt.git"
	FALLBACK_COMMIT="5f3a6001b9fea5cc2feee931da7f3b4fd524bdfb" # Oct 11, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/y-crdt/pycrdt/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="CRDTs based on Yrs"
HOMEPAGE="
	https://github.com/y-crdt/pycrdt
	https://pypi.org/project/pycrdt
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev doc test types"
RDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/typing_extensions-4.15.0[${PYTHON_USEDEP}]
			<dev-python/typing_extensions-5.0.0[${PYTHON_USEDEP}]
		)
		dev-python/exceptiongroup[${PYTHON_USEDEP}]
	' python3_10)
	(
		>=dev-python/anyio-4.4.0[${PYTHON_USEDEP}]
		<dev-python/anyio-5.0.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	(
		>=dev-util/maturin-1.8.0[${PYTHON_USEDEP}]
		<dev-util/maturin-2[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/mkdocs[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		dev-python/mkdocstrings[${PYTHON_USEDEP},python(+)]
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/exceptiongroup[${PYTHON_USEDEP}]
		' python3_10)
		(
			>=dev-python/pydantic-2.5.2[${PYTHON_USEDEP}]
			<dev-python/pydantic-3[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/pytest-8.3.5[${PYTHON_USEDEP}]
			<dev-python/pytest-10[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/trio-0.25.1[${PYTHON_USEDEP}]
			<dev-python/trio-0.34[${PYTHON_USEDEP}]
		)
		>=dev-python/coverage-7[${PYTHON_USEDEP},toml(+)]
		dev-python/anyio[${PYTHON_USEDEP}]
	)
	types? (
		>=dev-python/mypy-1.19.0[${PYTHON_USEDEP}]
		dev-python/pytest-mypy-testing[${PYTHON_USEDEP}]
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

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
