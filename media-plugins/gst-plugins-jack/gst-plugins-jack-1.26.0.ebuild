# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# >=jack-1.9.7 is provided by pipewire[jack-sdk] as well

GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="JACK audio server source/sink plugin for GStreamer"
RDEPEND="
	|| (
		>=media-sound/jack2-1.9.7[${MULTILIB_USEDEP}]
		media-video/pipewire[${MULTILIB_USEDEP},jack-sdk(-)]
	)
"
DEPEND="
	${RDEPEND}
"
