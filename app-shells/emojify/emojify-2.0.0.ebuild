# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Emoji on the command line"
HOMEPAGE="https://github.com/mrowa44/emojify"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="doc"
RDEPEND="app-shells/bash"
DEPEND="${RDEPEND}"
SRC_URI="https://github.com/mrowa44/emojify/archive/${PV}.tar.gz -> ${P}.tar.gz"
inherit eutils
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
DOC=( README.md )

src_install() {
	exeinto /usr/bin
	doexe "${S}/emojify"
}
