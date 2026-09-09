# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin security-critical untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

CHKL_TIMESTAMPS=(
	"dev-libs/libxml2-9999"
	"x11-libs/cairo-9999"
	"x11-libs/pango-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="TTML subtitles support for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=dev-libs/libxml2-${LIBXML2_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-${CAIRO_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/pango-${PANGO_PV}:=[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
