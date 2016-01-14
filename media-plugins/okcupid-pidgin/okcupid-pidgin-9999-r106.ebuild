# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs subversion eutils

DESCRIPTION="okcupid-pidgin"
HOMEPAGE="https://code.google.com/p/okcupid-pidgin/"
ESVN_REPO_URI="http://okcupid-pidgin.googlecode.com/svn/trunk/"
ESVN_PROJECT="okcupid-pidgin-read-only"
ESVN_REVISION="106"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-im/pidgin
         dev-libs/json-glib"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_unpack() {
    subversion_src_unpack
    cd "${S}"
    EPATCH_OPTS="-F 500" epatch "${FILESDIR}/${PN}.patch"
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
