# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Google from the terminal"
HOMEPAGE="https://github.com/jarun/googler"
EGIT_COMMIT="7e725573f801c587df7688a07f9fc7a9408d76eb"
SRC_URI="https://github.com/jarun/${PN}/archive/${EGIT_COMMIT}.zip -> ${P}.zip"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
PYTHON_COMPAT=( python{3_5,3_6,3_7,3_8} )
inherit eutils
SLOT="0"
RDEPEND="${DEPEND}"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	export PREFIX="/usr"
	export DOCDIR="/usr/share/${P}"
	sed -i -e "s|/share/doc/googler|/share/doc/googler-${PVR}|" \
		Makefile || die
	sed -i -e "s|gzip|#gzip|" \
		-e "s|googler.1.gz|googler.1|g" Makefile || die
}
