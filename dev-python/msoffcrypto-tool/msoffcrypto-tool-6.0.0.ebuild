# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/nolze/msoffcrypto-tool.git"
	FALLBACK_COMMIT="6d9e72c58de2cf7df1ab45ac0d74ebedac8c58e3" # Jan 12, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/nolze/msoffcrypto-tool/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION=""
HOMEPAGE="
	https://github.com/nolze/msoffcrypto-tool
	https://pypi.org/project/msoffcrypto-tool
"
LICENSE="
	BSD
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev doc"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/cryptography-39.0[${PYTHON_USEDEP}]
	>=dev-python/olefile-0.46[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/pytest-9.0.2[${PYTHON_USEDEP}]
		>=dev-python/coverage-7.5[${PYTHON_USEDEP},toml(+)]
	)
	doc? (
		>=dev-python/sphinx-8[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autobuild-2024.10.02[${PYTHON_USEDEP}]
		>=dev-python/furo-2025.12.19[${PYTHON_USEDEP}]
		>=dev-python/myst-parser-4.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-autoprogram-0.1.8[${PYTHON_USEDEP}]
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
	dodoc "LICENSE.txt"
	dodoc "NOTICE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
