# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="A QR code overlay plugin for GStreamer"
RDEPEND="
	~media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
	dev-libs/json-glib[${MULTILIB_USEDEP}]
	media-gfx/qrencode[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
