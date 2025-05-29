# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network untrusted-data"

inherit cflags-hardened multilib-minimal

SRC_URI="https://downloads.xiph.org/releases/opus/${P}.tar.gz"

DESCRIPTION="A high-level decoding and seeking API for .opus files"
HOMEPAGE="https://www.opus-codec.org/"
LICENSE="BSD"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64"
IUSE="
doc fixed-point +float +http libressl static-libs
ebuild_revision_13
"
RDEPEND="media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/opus[${MULTILIB_USEDEP}]
	http? (
		!libressl? (
			dev-libs/openssl:0=[${MULTILIB_USEDEP}]
		)
		libressl? (
			dev-libs/libressl:0=[${MULTILIB_USEDEP}]
		)
	)
"
DEPEND="
	${RDEPEND}
	doc? (
		app-text/doxygen
	)
"
REQUIRED_USE="
	^^ (
		fixed-point
		float
	)
"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	cflags-hardened_append
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable fixed-point)
		$(use_enable float)
		$(use_enable http)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi
