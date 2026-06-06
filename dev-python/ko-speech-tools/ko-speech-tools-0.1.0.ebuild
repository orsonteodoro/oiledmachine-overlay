# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="uv-build"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/eginhard/ko-speech-tools.git"
	FALLBACK_COMMIT="c34801426b39272b8d5b1f2d869397a670ff649c" # Oct 2, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/eginhard/ko-speech-tools/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Korean speech/NLP tools"
HOMEPAGE="
	https://github.com/eginhard/ko-speech-tools
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev g2p"
RDEPEND+="
	dev-python/dek[${PYTHON_USEDEP}]
	g2p? (
		>=dev-python/mecab-ko-1.0.2[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/coverage-7.10.7[${PYTHON_USEDEP}]
		>=dev-python/pre-commit-4.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.4.2[${PYTHON_USEDEP}]
		>=dev-python/reuse-5.1.1[${PYTHON_USEDEP}]
		~dev-util/ruff-0.13.2
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
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
