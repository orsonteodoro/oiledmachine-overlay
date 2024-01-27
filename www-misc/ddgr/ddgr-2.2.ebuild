# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-single-r1

DESCRIPTION="DuckDuckGo from the terminal"
HOMEPAGE="https://github.com/jarun/ddgr"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SRC_URI="
https://github.com/jarun/ddgr/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
SLOT="0"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RDEPEND+=" ${PYTHON_DEPS}"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
RESTRICT="mirror"
S="${WORKDIR}/${P}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	python_scriptinto "$(python_get_sitedir)/${PN}"
	python_doexe ddgr
	dosym "$(python_get_scriptdir)/ddgr" "/usr/bin/ddgr"
	doman ddgr.1
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
