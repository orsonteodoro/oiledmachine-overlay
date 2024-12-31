# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="DVD playback support plugin for GStreamer"
RDEPEND="
	>=media-libs/libdvdnav-4.1.2:=[${MULTILIB_USEDEP}]
	>=media-libs/libdvdread-4.1.2:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	local emesonargs=(
		-Dgpl=enabled
	)
	gstreamer_multilib_src_configure
}
