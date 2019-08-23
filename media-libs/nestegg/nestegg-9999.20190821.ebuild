# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools multilib-minimal multilib-build

DESCRIPTION="WebM demuxer"
HOMEPAGE="https://github.com/kinetiknz/nestegg/"
COMMIT="773adcc29d2c52891421c0b0c10059abf9bc17ea"
SRC_URI="https://github.com/kinetiknz/nestegg/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	eapply_user
	eautoreconf || die
	multilib_copy_sources
}

multilib_src_install() {
	emake install DESTDIR="$D"
}
