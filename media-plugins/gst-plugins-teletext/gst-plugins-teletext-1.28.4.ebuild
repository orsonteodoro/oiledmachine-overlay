# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin security-critical untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"
GST_PLUGINS_BUILD_DIR="teletextdec"
GST_PLUGINS_ENABLED="teletext"

inherit cflags-hardened secure-version gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="VBI subtitles plugin for GStreamer"
IUSE="
ebuild_revision_24
"
RDEPEND="
	>=media-libs/zvbi-${ZVBI_PV}:=[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
