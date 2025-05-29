# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Barcode image scanner plugin using zxing-cpp for GStreamer"
IUSE="
ebuild_revision_10
"
RDEPEND="
	>=media-libs/zxing-cpp-1.4.0
	~media-libs/gst-plugins-base-${PV}:1.0
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
