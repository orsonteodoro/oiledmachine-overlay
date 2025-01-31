# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PN is the same as pypi name

# TODO package:
# compressed-rtf
# ebcdic
# RTFDE

MY_PN="msg-extractor"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/TeamMsgExtractor/msg-extractor.git"
	FALLBACK_COMMIT="373f6c161d3ba63392f5c084fb3e113188158ca1" # Oct 22, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/TeamMsgExtractor/msg-extractor/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Extracts emails and attachments saved in Microsoft Outlook's .msg files"
HOMEPAGE="
	https://github.com/TeamMsgExtractor/msg-extractor
	https://pypi.org/project/extract-msg
"
LICENSE="
	GPL-3.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc encoding mime pillow"
RDEPEND+="
	>=dev-python/olefile-0.47[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-4.2[${PYTHON_USEDEP}]
	>=dev-python/compressed-rtf-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/ebcdic-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.11.1[${PYTHON_USEDEP}]
	>=dev-python/RTFDE-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/red-black-tree-mod-1.20[${PYTHON_USEDEP}]
	encoding? (
		dev-python/chardet[${PYTHON_USEDEP}]
	)
	mime? (
		dev-python/python-magic[${PYTHON_USEDEP}]
	)
	pillow? (
		virtual/pillow[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.rst" )

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
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
