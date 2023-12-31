# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

DESCRIPTION="FluidSynth plugin for GStreamer"
KEYWORDS="~amd64 ~x86"

# See ext/fluidsynth/meson.build
RDEPEND="
	>=media-sound/fluidsynth-1.0:=[${MULTILIB_USEDEP}]
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
