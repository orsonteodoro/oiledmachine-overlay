# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DESCRIPTION="H.264 encoder/decoder plugin for GStreamer"
RDEPEND="
	>=media-libs/openh264-1.3.0:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
