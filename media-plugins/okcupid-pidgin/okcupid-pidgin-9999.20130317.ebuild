# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit toolchain-funcs subversion eutils git-r3

DESCRIPTION="okcupid-pidgin"
HOMEPAGE="https://code.google.com/p/okcupid-pidgin/"
COMMIT="b2ff1ecd2f397f0d358fb1a825c73992bc5f4efb"
SRC_URI="https://github.com/EionRobb/okcupid-pidgin/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-im/pidgin
         dev-libs/json-glib"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"

src_unpack() {
	unpack "${A}"
}

src_prepare() {
	EPATCH_OPTS="-F 500" epatch "${FILESDIR}/${PN}.patch"
	cd "${S}"
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	insinto "/usr/lib/purple-2/"
	doins libokcupid.so libokcupid64.so
	insinto "/usr/share/pixmaps/pidgin/protocols/16"
	doins icons/16/okcupid.png
	insinto "/usr/share/pixmaps/pidgin/protocols/22"
	doins icons/22/okcupid.png
	insinto "/usr/share/pixmaps/pidgin/protocols/48"
	doins icons/48/okcupid.png
}
