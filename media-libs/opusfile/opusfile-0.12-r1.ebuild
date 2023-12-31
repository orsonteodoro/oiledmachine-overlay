# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="A high-level decoding and seeking API for .opus files"
HOMEPAGE="https://www.opus-codec.org/"
SRC_URI="https://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc fixed-point +float +http libressl static-libs"

RDEPEND="media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/opus[${MULTILIB_USEDEP}]
	http? (
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

REQUIRED_USE="^^ ( fixed-point float )"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable fixed-point)\
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
