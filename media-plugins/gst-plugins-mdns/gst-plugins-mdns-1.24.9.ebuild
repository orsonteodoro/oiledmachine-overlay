# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"
GST_PLUGINS_BUILD_DIR="mdns"
GST_PLUGINS_ENABLED="microdns"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="A device provider plugin and RTSP server discovery for GStreamer"
# Force libmicrodns-0.2.0 to avoid critical vulnerability
RDEPEND="
	>=net-libs/libmicrodns-0.2.0
	~media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"