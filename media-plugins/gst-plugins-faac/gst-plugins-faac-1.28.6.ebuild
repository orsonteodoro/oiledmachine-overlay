# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin sensitive-data untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

CHKL_TIMESTAMPS=(
	"media-libs/faac-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="AAC audio encoder plugin for GStreamer"
IUSE="
ebuild_revision_24
"
RDEPEND="
	>=media-libs/faac-${FAAC_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
