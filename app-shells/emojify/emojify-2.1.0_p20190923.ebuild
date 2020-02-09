# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Emoji on the command line"
HOMEPAGE="https://github.com/mrowa44/emojify"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="doc"
RDEPEND="app-shells/bash"
EGIT_COMMIT="2bd4a6618b50d5e9930d7310fcd9cfb95869fe09"
SRC_URI="\
https://github.com/mrowa44/emojify/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit eutils
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( README.md )

src_install() {
	exeinto /usr/bin
	doexe "${S}/emojify"
	dodoc LICENSE.md
}
