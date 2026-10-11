# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin security-critical sensitive-data untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

CHKL_TIMESTAMPS=(
	"media-libs/libjpeg-turbo-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="JPEG image encoder/decoder plugin for GStreamer"
IUSE="
ebuild_revision_24
"
RDEPEND="
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
