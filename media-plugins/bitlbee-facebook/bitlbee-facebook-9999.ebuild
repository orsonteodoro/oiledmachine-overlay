# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

EGIT_REPO_URI="https://github.com/jgeboski/bitlbee-facebook.git"
inherit git-r3 autotools

DESCRIPTION="The Facebook protocol plugin for bitlbee. This plugin uses the Facebook Mobile API."
HOMEPAGE="https://github.com/jgeboski/bitlbee-facebook"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"
DEPEND="
	>=dev-libs/glib-2.28.0:2
	>=dev-libs/json-glib-0.14.0
	>=net-im/bitlbee-3.4[plugins]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"

src_prepare() {
	default
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
