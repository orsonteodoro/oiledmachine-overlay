# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CRSH CE DOS HO IO OOBR UAF"

CHKL_TIMESTAMPS=(
	"app-text/ghostscript-gpl-9999"
	"dev-libs/expat-9999"
	"dev-libs/libxml2-9999"
	"media-libs/freetype-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libpng-9999"
	"x11-libs/libX11-9999"
)

inherit autotools cflags-hardened chkl gnome2-utils secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="94b932de7a4aa6bceb0ff630c65b4aa9cc1dfd1e"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/caolanm/libwmf.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/caolanm/libwmf/releases/download/v${PV}/${P}.tar.gz"
fi

DESCRIPTION="Library for reading vector images in Microsoft's Windows Metafile Format (WMF)"
HOMEPAGE="
	https://github.com/caolanm/libwmf
	https://wvware.sourceforge.net/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE+=" debug doc expat X"

RDEPEND="
	>=app-text/ghostscript-gpl-${GHOSTSCRIPT_GPL_PV}:=
	media-fonts/urw-fonts:=
	>=media-libs/freetype-${FREETYPE_PV}:=
	>=media-libs/libpng-${LIBPNG_PV}:=
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	>=virtual/zlib-${ZLIB_PV}:=
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=
	expat? ( >=dev-libs/expat-${EXPAT_PV}:= )
	!expat? ( >=dev-libs/libxml2-${LIBXML2_PV}:= )
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=
		>=x11-libs/libXt-${LIBXT_PV}:=
		x11-libs/libXpm:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS BUILDING ChangeLog CREDITS INSTALL NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.8.4-libpng-1.5.patch
	"${FILESDIR}"/${PN}-0.2.8.4-pngfix.patch
	"${FILESDIR}"/${PN}-94b932d-underlinked-plugin.patch
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	# For underlinked patch
	eautoreconf
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	# Support for GD is disabled, since it's never linked, even, when enabled
	# See https://bugs.gentoo.org/268161
	local myeconfargs=(
		--disable-gd
		$(use_enable debug)
		$(use_with expat)
		$(use_with !expat libxml2)
		$(use_with X x)
		--with-fontdir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-freetype
		--with-gsfontdir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-gsfontmap="${EPREFIX}"/usr/share/ghostscript/9.21/Resource/Init/Fontmap
		--with-jpeg
		--with-layers
		--with-png
		--with-sys-gd
		--with-zlib
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	# We unbundle the fonts from media-fonts/urw-fonts
	rm -r "${ED}"/usr/share/fonts/urw-fonts || die
}

pkg_postinst() {
	gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	gnome2_gdk_pixbuf_update
}
