# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="H.265 decoder plugin for GStreamer"
RDEPEND="
	>=media-libs/libde265-0.9[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
