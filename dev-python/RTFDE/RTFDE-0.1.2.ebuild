# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/seamustuohy/RTFDE.git"
	FALLBACK_COMMIT="368a04d75b2f056f2c6a740580b5b0b448c3544f" # Jun 22, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/seamustuohy/RTFDE/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="RTFDE: RTF De-Encapsulator - A python3 library for extracting encapsulated \`HTML\` & \`plain text\` content from the \`RTF\` bodies of .msg files"
HOMEPAGE="
	https://github.com/seamustuohy/RTFDE
"
LICENSE="
	LGPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev msg_parse"
RDEPEND+="
	>=app-forensics/oletools-0.56[${PYTHON_USEDEP}]
	>=dev-python/lark-1.1.8[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/coverage-7.2.2[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.6[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.1[${PYTHON_USEDEP}]
		>=dev-python/pdoc3-0.10.0[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	msg_parse? (
		>=dev-python/extract-msg-0.27[${PYTHON_USEDEP}]
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
