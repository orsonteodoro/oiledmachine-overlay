# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Bar codes detection in video streams for GStreamer"
RDEPEND="
	>=media-gfx/zbar-0.23.1[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
