# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-ugly"

inherit cflags-hardened gstreamer-meson

#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="H.264 encoder plugin for GStreamer"
IUSE="
ebuild_revision_3
"
# 20180806 ensures us X264_BUILD >= 156
RDEPEND="
	>=media-libs/x264-0.0.20180806:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dgpl=enabled
	)
	gstreamer_multilib_src_configure
}
