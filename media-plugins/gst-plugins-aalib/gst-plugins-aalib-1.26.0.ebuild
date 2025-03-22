# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="aalib text console plugin for GStreamer"
RDEPEND="
	media-libs/aalib[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-good-${PV}:1.0[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
RDEPEND="
	${RDEPEND}
"
