# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="develop"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/nltk/nltk.git"
	FALLBACK_COMMIT="aca78cb2add4084f76b9eac921d8a73927d7a086" # Aug 18, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/nltk/nltk/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A suite of open source Python modules, data sets, and tutorials supporting research and development in Natural Language Processing"
HOMEPAGE="
	https://github.com/nltk/nltk
	https://pypi.org/project/nltk
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "ChangeLog" "README.md" )

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

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
