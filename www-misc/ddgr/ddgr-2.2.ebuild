# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{8..11} )

inherit python-single-r1

SRC_URI="
https://github.com/jarun/ddgr/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

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

src_install() {
	python_scriptinto "$(python_get_sitedir)/${PN}"
	python_doexe "ddgr"
	dosym "$(python_get_scriptdir)/ddgr" "/usr/bin/ddgr"
	doman "ddgr.1"
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
