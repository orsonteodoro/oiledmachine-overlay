# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

DESCRIPTION="Musepack plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
# See ext/musepack/meson.build
RDEPEND="
	media-sound/musepack-tools:=[${MULTILIB_USEDEP}]
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
