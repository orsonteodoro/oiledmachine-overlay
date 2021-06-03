# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils python-single-r1

DESCRIPTION="DuckDuckGo from the terminal"
HOMEPAGE="https://github.com/jarun/ddgr"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SRC_URI="
https://github.com/jarun/ddgr/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
SLOT="0"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RDEPEND+=" ${PYTHON_DEPS}"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
RESTRICT="mirror"
S="${WORKDIR}/${P}"

pkg_setup() {
	python_setup
}

src_install() {
	SITEDIR="/usr/$(get_libdir)/${EPYTHON}/site-packages"
	python_scriptinto "${SITEDIR}/${PN}"
	python_doexe ddgr
	dosym "/usr/lib/python-exec/${EPYTHON}/ddgr" "/usr/bin/ddgr"
	doman ddgr.1
}
