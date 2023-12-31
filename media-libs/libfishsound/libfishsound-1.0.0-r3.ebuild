# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Simple programming interface to decode and encode audio with vorbis or speex"
HOMEPAGE="https://www.xiph.org/fishsound/"
SRC_URI="https://downloads.xiph.org/releases/libfishsound/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="amd64 x86"
IUSE+=" flac speex"

DEPEND+="
	media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/libvorbis[${MULTILIB_USEDEP}]
	flac? ( media-libs/flac[${MULTILIB_USEDEP}] )
	speex? ( media-libs/speex[${MULTILIB_USEDEP}] )"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
"

# bug #395153
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-pc.patch )

src_prepare() {
	default
	sed -i \
		-e 's:doxygen:doxygen-dummy:' \
		configure || die
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=""
	use flac || myconf="${myconf} --disable-flac"
	use speex || myconf="${myconf} --disable-speex"

	econf \
		--disable-dependency-tracking \
		${myconf}
}

multilib_src_install() {
	emake DESTDIR="${D}" \
		docdir="${D}/usr/share/doc/${PF}" install
	dodoc AUTHORS ChangeLog README
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
