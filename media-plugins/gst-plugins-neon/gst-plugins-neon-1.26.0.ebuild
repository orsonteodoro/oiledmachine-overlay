# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~ppc64 ~x86"

DESCRIPTION="HTTP client source plugin for GStreamer"
IUSE="
ebuild_revision_12
"
RDEPEND="
	>=net-libs/neon-0.27[${MULTILIB_USEDEP}]
	<=net-libs/neon-0.33.99[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
