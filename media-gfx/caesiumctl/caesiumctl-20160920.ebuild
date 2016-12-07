# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Caesium Command Line Tools - Lossy/lossless image compression tool using mozjpeg and zopflipng"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
CAESIUMCTL_COMMIT="9326392bb30396a9d83ca09273c2bea52b68a4f2"
SRC_URI="https://github.com/Lymphatus/CaesiumCLT/archive/${CAESIUMCTL_COMMIT}.zip -> caesiumctl-${CAESIUMCTL_COMMIT}.zip"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE=""

RDEPEND="media-libs/libjpeg-turbo
         media-libs/mozjpeg
         >=app-arch/zopfli-1.0.1
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/CaesiumCLT-${CAESIUMCTL_COMMIT}"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	FILES=$(grep -l -r -e "zopflipng/zopflipng_lib.h" ./)
	for f in $FILES
	do
		sed -i -e "s|zopflipng/zopflipng_lib.h|zopflipng_lib.h|g" "$f"
	done
	econf || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

pkg_postinst() {
	true
}
