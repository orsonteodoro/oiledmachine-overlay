# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit git-r3 autotools

DESCRIPTION="The Facebook protocol plugin for bitlbee. This plugin uses the Facebook Mobile API."
HOMEPAGE="https://github.com/jgeboski/bitlbee-facebook"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jgeboski/bitlbee-facebook.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

DEPEND="dev-libs/glib:2
>=net-im/bitlbee-3.2.2[plugins]
>=sys-libs/zlib-1.2.8-r1"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--enable-minimal-flags
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
