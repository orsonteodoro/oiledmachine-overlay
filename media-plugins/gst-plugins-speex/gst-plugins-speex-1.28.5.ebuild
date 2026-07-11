# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

CHKL_TIMESTAMPS=(
	"media-libs/speex-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Speex encoder/decoder plugin for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=media-libs/speex-${SPEEX_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
