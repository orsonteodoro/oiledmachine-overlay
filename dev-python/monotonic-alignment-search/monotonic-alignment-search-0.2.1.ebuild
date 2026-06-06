# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit cython distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/tts-hub/monotonic_alignment_search.git"
	FALLBACK_COMMIT="ac3869a6ed9d059f84fdda5fbe8c94e1631eaa1f" # Oct 15, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/tts-hub/monotonic_alignment_search/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Monotonically align text and speech"
HOMEPAGE="
	https://github.com/tts-hub/monotonic_alignment_search
	https://pypi.org/project/monotonic-alignment-search
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cpu cuda dev"
RDEPEND+="
	virtual/numpy[${PYTHON_USEDEP}]
	cpu? (
		>=dev-python/pytorch-1.12.1[${PYTHON_USEDEP}]
	)
	cuda? (
		>=dev-python/pytorch-1.12.1[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61[${PYTHON_USEDEP}]
	>=dev-python/cython-3.0.0:3.0[${PYTHON_USEDEP}]
	virtual/numpy
	dev? (
		>=dev-python/coverage-7.6.4[${PYTHON_USEDEP}]
		~dev-python/mypy-1.18.2[${PYTHON_USEDEP}]
		$(python_gen_any_dep '
			>=dev-vcs/pre-commit-4.0.1[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/pytest-8.3.3[${PYTHON_USEDEP}]
		>=dev-python/reuse-6[${PYTHON_USEDEP}]
		~dev-util/ruff-0.14.0
	)

"
DOCS=( "CITATION.cff" "README.md" )

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
