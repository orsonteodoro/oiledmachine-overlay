# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# >=jack-1.9.7 is provided by pipewire[jack-sdk] as well

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="JACK audio server source/sink plugin for GStreamer"
IUSE="
ebuild_revision_10
"
RDEPEND="
	|| (
		>=media-sound/jack2-1.9.7[${MULTILIB_USEDEP}]
		media-video/pipewire[${MULTILIB_USEDEP},jack-sdk(-)]
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
