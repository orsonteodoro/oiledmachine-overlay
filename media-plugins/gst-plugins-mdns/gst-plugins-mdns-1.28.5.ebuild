# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"
GST_PLUGINS_BUILD_DIR="mdns"
GST_PLUGINS_ENABLED="microdns"

CHKL_TIMESTAMPS=(
	"net-libs/libmicrodns-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="A device provider plugin and RTSP server discovery for GStreamer"
IUSE="
ebuild_revision_23
"
# Force libmicrodns-0.2.0 to avoid critical vulnerability
RDEPEND="
	>=net-libs/libmicrodns-${LIBMICRODNS_PV}:=
	~media-libs/gst-plugins-base-${PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
