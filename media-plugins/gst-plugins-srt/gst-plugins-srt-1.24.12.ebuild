# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Secure reliable transport (SRT) transfer plugin for GStreamer"
RDEPEND="
	>=net-libs/srt-1.3.0:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/glib-utils
"
