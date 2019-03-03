# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools multilib-minimal multilib-build

DESCRIPTION="Improved JPEG encoder based on libjpeg-turbo"
HOMEPAGE="https://github.com/mozilla/mozjpeg"
SRC_URI="https://github.com/mozilla/mozjpeg/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD IJG ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	eapply_user
	eautoreconf || die
	multilib_copy_sources
}

multilib_src_install() {
	# wrapper to use renamed libjpeg.so (allows coexistence with libjpeg-turbo)
	echo -e '#!/bin/sh\nLD_PRELOAD=libmozjpeg.so .$(basename $0) "$@"' > wrapper
	newbin wrapper mozcjpeg
	newbin wrapper mozjpegtran

	newbin .libs/cjpeg .mozcjpeg
	newbin .libs/jpegtran .mozjpegtran
	newlib.so .libs/libjpeg.so.62.2.0 libmozjpeg.so
	dodoc README.md README-mozilla.txt usage.txt wizard.txt
}
