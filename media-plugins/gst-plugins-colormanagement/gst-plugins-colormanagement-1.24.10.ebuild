# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Color management correction GStreamer plugins"
RDEPEND="
	>=media-libs/lcms-2.7:2[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
