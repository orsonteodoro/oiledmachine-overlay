# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Requires >= 2.4.3 but prefers >= 2.4.6

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

inherit cflags-hardened gstreamer-meson

DESCRIPTION="Icecast server sink plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~ppc64 ~x86"

IUSE="
ebuild_revision_12
"
RDEPEND="
	>=media-libs/libshout-2.4.3[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
