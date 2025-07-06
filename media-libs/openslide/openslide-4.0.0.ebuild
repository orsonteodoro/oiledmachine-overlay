# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

inherit meson

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
IUSE="doc test valgrind"
RDEPEND="
	>=dev-db/sqlite-3.31.1
	>=dev-libs/glib-2.64.6
	>=dev-libs/gobject-introspection-1.64.0
	>=dev-libs/libxml2-2.9.10
	>=media-libs/libjpeg-turbo-2.0.3
	>=media-libs/openjpeg-2.1.0:2
	>=media-libs/tiff-4.1.0:0
	>=media-libs/libdicom-1.0.5
	>=sys-libs/zlib-1.2.11
	>=x11-libs/gdk-pixbuf-2.40.0
	>=x11-libs/cairo-1.2
	virtual/libc
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
