# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CHKL_TIMESTAMPS=(
	"app-arch/zstd-9999"
	"dev-db/sqlite-9999"
	"dev-libs/glib-2.90.9999"
	"dev-libs/libxml2-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libpng-9999"
	"media-libs/openjpeg-9999"
	"media-libs/tiff-9999"
	"x11-libs/cairo-9999"
)

inherit cflags-hardened chkl secure-version meson

if [[ "${PV}" == *"9999"* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openslide/openslide"
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz
	"
	HTML_DOCS=(
		"doc/html/."
	)
fi

DESCRIPTION="C library with simple interface to read virtual slides"
HOMEPAGE="https://openslide.org/"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE+="
doc test valgrind
ebuild_revision_1
"
RDEPEND="
	>=app-arch/zstd-${ZSTD_PV}:=
	>=dev-db/sqlite-${SQLITE_PV}:=
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
	>=dev-libs/libxml2-${LIBXML2_PV}:=
	>=media-libs/libdicom-1.0.5:=
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	>=media-libs/libpng-${LIBPNG_PV}:=
	>=media-libs/openjpeg-${OPENJPEG_PV}:=
	>=media-libs/tiff-${TIFF_PV}:=
	>=virtual/zlib-${ZLIB_PV}:=
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	virtual/libc
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	elibc_musl? (
		>=sys-libs/musl-${MUSL_PV}:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/meson-0.53.2
	doc? (
		>=app-text/doxygen-1.8.17
	)
	valgrind? (
		>=dev-debug/valgrind-3.15.0
	)
"

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		$(meson_feature doc)
		$(meson_feature test)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	find "${D}" -name "*.la" -type f -delete || die
	einstalldocs
}
