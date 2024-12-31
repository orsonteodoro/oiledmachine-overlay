# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See ext/fluidsynth/meson.build

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~amd64-macos ~arm ~arm64 ~arm64-macos ~x86"

DESCRIPTION="FluidSynth plugin for GStreamer"
RDEPEND="
	>=media-sound/fluidsynth-2.1:=[${MULTILIB_USEDEP}]
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
