# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Rapptz/discord.py.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/Rapptz/discord.py/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="An API wrapper for Discord written in Python"
HOMEPAGE="
	https://github.com/Rapptz/discord.py
	https://pypi.org/project/discord.py
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc speed test voice"
RDEPEND+="
	>=dev-python/aiohttp-3.7.4[${PYTHON_USEDEP}]
	speed? (
		>=dev-python/orjson-3.5.4[${PYTHON_USEDEP}]
		>=dev-python/aiodns-1.1[${PYTHON_USEDEP}]
		app-arch/brotli[${PYTHON_USEDEP},python]
	)
	voice? (
		dev-python/pynacl[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	doc? (
		>=dev-python/sphinx-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-trio-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-websupport-1.2.4[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-applehelp-1.0.4[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-devhelp-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-htmlhelp-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-jsmath-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-qthelp-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-serializinghtml-1.1.5[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx-inline-tabs-2023.4.21[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/typing-extensions-4.3[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" "README.ja.rst" )

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
