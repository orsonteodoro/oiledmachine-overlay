# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See ext/fluidsynth/meson.build

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

CHKL_TIMESTAMPS=(
	"media-sound/fluidsynth-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~amd64 ~amd64-macos ~arm ~arm64 ~arm64-macos ~x86"

DESCRIPTION="FluidSynth plugin for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=media-sound/fluidsynth-${FLUIDSYNTH_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		-Dgpl=enabled
	)
	gstreamer_multilib_src_configure
}
