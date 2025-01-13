# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="WebP image format support for GStreamer"
RDEPEND="
	>=media-libs/libwebp-0.2.1[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
