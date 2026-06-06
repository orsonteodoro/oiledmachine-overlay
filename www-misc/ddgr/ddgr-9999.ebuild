# Copyright 2022-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_12" )

inherit python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/jarun/ddgr.git"
	FALLBACK_COMMIT="3cb98894060459f6e107d827b75b862d7288b9e8" # Jun 5, 2026
	IUSE+=" fallback-commit"
	inherit git-r3
else
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/jarun/ddgr/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="DuckDuckGo from the terminal"
HOMEPAGE="https://github.com/jarun/ddgr"
LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
"
RESTRICT="mirror"

pkg_setup() {
	python-single-r1_pkg_setup
}

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
	python_scriptinto "$(python_get_sitedir)/${PN}"
	python_doexe "ddgr"
	dosym "$(python_get_scriptdir)/ddgr" "/usr/bin/ddgr"
	doman "ddgr.1"
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
