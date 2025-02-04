# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-base"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

DESCRIPTION="A cdparanoia based CD Digital Audio (CDDA) source plugin for GStreamer"
RDEPEND="
	>=media-sound/cdparanoia-3.10.2[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	gstreamer_system_package audio_dep:gstreamer-audio
}
