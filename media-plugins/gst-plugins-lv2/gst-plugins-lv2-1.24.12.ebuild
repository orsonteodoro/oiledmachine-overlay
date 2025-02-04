# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

DESCRIPTION="LV2 elements for GStreamer"
RDEPEND="
	media-libs/lv2[${MULTILIB_USEDEP}]
	>=media-libs/lilv-0.22[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
