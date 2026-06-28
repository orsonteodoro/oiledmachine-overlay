# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin network security-critical untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.3.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cflags-hardened chkl multilib-build secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="DTLS encoder/decoder with SRTP support plugin for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
