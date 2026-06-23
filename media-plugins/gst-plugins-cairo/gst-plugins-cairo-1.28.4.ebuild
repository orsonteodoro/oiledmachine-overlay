# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin security-critical untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

CHKL_TIMESTAMPS=(
	"x11-libs/cairo-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Video overlay plugin based on cairo for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=x11-libs/cairo-${CAIRO_PV}:=[${MULTILIB_USEDEP},glib]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
