# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="DV demuxer and decoder plugin for GStreamer"
IUSE="
ebuild_revision_13
"
RDEPEND="
	>=media-libs/libdv-0.100[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
