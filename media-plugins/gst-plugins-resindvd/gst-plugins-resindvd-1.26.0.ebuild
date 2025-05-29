# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="DVD playback support plugin for GStreamer"
IUSE="
ebuild_revision_12
"
RDEPEND="
	>=media-libs/libdvdnav-4.1.2:=[${MULTILIB_USEDEP}]
	>=media-libs/libdvdread-4.1.2:=[${MULTILIB_USEDEP}]
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
