# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{3_3,3_4} )

inherit eutils

DESCRIPTION="Command line Google"
HOMEPAGE="https://github.com/jarun/googler"
SRC_URI="https://github.com/jarun/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}"

src_prepare() {
	eapply_user
}

src_compile() {
	emake
}
