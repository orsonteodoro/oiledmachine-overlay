# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="libdc1394 IIDC camera source plugin for GStreamer"
RDEPEND="
	>=media-libs/libdc1394-2.2.5[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
