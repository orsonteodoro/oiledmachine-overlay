# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit eutils python-single-r1

DESCRIPTION="Google from the terminal"
HOMEPAGE="https://github.com/jarun/googler"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RESTRICT="mirror"
SRC_URI=\
"https://github.com/jarun/${PN}/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"

src_prepare() {
	default
	export PREFIX="/usr"
	export DOCDIR="/usr/share/${P}"
	sed -i -e "s|/share/doc/googler|/share/doc/googler-${PVR}|" \
		Makefile || die
	sed -i -e "s|gzip|#gzip|" \
		-e "s|googler.1.gz|googler.1|g" Makefile || die
}
