# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="AMR-WB audio encoder plugin for GStreamer"
RDEPEND="
	>=media-libs/vo-amrwbenc-0.1.0[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"