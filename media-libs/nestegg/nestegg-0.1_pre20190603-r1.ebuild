# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools multilib-minimal multilib-build

DESCRIPTION="WebM demuxer"
HOMEPAGE="https://github.com/kinetiknz/nestegg/"
LICENSE="ISC"
KEYWORDS="~amd64 ~x86"
COMMIT="9d5b774db2bb5a982c1438a17ad1bcaf6ea03cbd"
SRC_URI="https://github.com/kinetiknz/nestegg/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"
SLOT="0/${PV}"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"
RESTRICT="mirror"

src_prepare() {
	eapply_user
	eautoreconf || die
	multilib_copy_sources
}

multilib_src_install() {
	emake install DESTDIR="$D"
}
