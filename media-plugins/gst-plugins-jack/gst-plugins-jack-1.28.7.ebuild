# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# >=jack-1.9.7 is provided by pipewire[jack-sdk] as well

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

CHKL_TIMESTAMPS=(
	"media-sound/jack2-9999"
	"media-video/pipewire-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="JACK audio server source/sink plugin for GStreamer"
IUSE="
jack2 pipewire
ebuild_revision_23
"
REQUIRED_USE="
	|| (
		jack2
		pipewire
	)
"
RDEPEND="
	jack2? (
		>=media-sound/jack2-${JACK2_PV}:=[${MULTILIB_USEDEP}]
	)
	pipewire? (
		>=media-video/pipewire-${PIPEWIRE_PV}:=[${MULTILIB_USEDEP},jack-sdk(-)]
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
