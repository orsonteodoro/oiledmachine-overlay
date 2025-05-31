# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="VP8/VP9 video encoder/decoder plugin for GStreamer"
IUSE="
ebuild_revision_13
"
RDEPEND="
	>=media-libs/libvpx-1.7.0:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/glib-utils
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
