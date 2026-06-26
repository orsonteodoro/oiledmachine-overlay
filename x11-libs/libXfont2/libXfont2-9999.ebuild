# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See also https://cgit.freedesktop.org/xorg/lib/libXfont

XORG_DOC=doc
XORG_PACKAGE_NAME=libxfont

CHKL_TIMESTAMPS=(
	"app-arch/bzip2-9999"
	"media-libs/freetype-9999"
)

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="dd5ff35403e9dcf8acdd4c8879eed65268d3ef94"
fi

inherit chkl secure-version xorg-3

DESCRIPTION="X.Org Xfont library"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="bzip2 truetype"
REQUIRED_USE="
"

RDEPEND="
	>=virtual/zlib-${ZLIB_PV}:=
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	>=x11-libs/libfontenc-${LIBFONTENC_PV}:=
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:= )
	truetype? ( >=media-libs/freetype-${FREETYPE_PV}:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto:=
	x11-libs/xtrans:="

src_configure() {
	chkl_check_many_timestamps
	local XORG_CONFIGURE_OPTIONS=(
		--enable-ipv6
		$(use_enable doc devel-docs)
		$(use_with doc xmlto)
		$(use_with bzip2)
		$(use_enable truetype freetype)
		--without-fop
	)
	xorg-3_src_configure
}
