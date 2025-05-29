# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-base"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

DESCRIPTION="A cdparanoia based CD Digital Audio (CDDA) source plugin for GStreamer"
IUSE="
ebuild_revision_10
"
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

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
