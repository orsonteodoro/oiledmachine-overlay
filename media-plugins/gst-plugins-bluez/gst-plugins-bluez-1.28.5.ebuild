# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"net-wireless/bluez-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="AVDTP source/sink and A2DP sink plugin for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=net-wireless/bluez-${BLUEZ_PV}:=[${MULTILIB_USEDEP}]
	>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/gdbus-codegen
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
