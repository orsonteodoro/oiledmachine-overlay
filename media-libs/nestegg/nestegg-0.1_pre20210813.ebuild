# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils autotools multilib-minimal

DESCRIPTION="WebM demuxer"
HOMEPAGE="https://github.com/kinetiknz/nestegg/"
LICENSE="ISC"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="ec6adfbbf979678e3058cc4695257366f39e290b"
SRC_URI="
https://github.com/kinetiknz/nestegg/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}.tar.gz"
SLOT="0/${PV}"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	eautoreconf || die
	multilib_copy_sources
}

multilib_src_install() {
	emake install DESTDIR="${D}"
}
