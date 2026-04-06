# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/scross01/searxngr.git"
	FALLBACK_COMMIT="2402a29facb164554c0dde206923ccaaf8a062cc" # Feb 27, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/scross01/searxngr/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="SearXNG from the command line, inspired by ddgr and googler."
HOMEPAGE="
	https://github.com/scross01/searxngr
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev server"
RDEPEND+="
	>=dev-python/babel-2.17.0[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-0.0.2[${PYTHON_USEDEP}]
	>=dev-python/html2text-2025.4.15[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-3.0.51[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.9.0_p0[${PYTHON_USEDEP}]
	>=dev-python/rich-14.0.0[${PYTHON_USEDEP}]
	>=dev-python/xdg-base-dirs-6.0.2[${PYTHON_USEDEP}]
	server? (
		www-apps/searxng
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/black-25.1.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-7.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.0.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

pkg_postinst() {
ewarn "You still need to add either a public SearXNG server or use a locally hosted one."
ewarn "Use \`searxngr --config\` to setup the preferred SearXNG instance."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.8.1 (using searxngr-container e12b722, 20260406)
# locally hosted searxngr:  PASSED
# public servers:  ISSUES
# Testing:  searxngr --searxng-url http://127.0.0.1:8080 "gentoo"
