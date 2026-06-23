# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin security-critical untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.3.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cflags-hardened chkl gstreamer-meson secure-version

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="AES encryption/decryption plugin for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=dev-libs/openssl-1.1.0:=[${MULTILIB_USEDEP}]
	|| (
		~dev-libs/openssl-4.0.9999
		~dev-libs/openssl-3.6.9999
		~dev-libs/openssl-3.5.9999
		~dev-libs/openssl-3.4.9999
		~dev-libs/openssl-3.3.9999
		~dev-libs/openssl-3.0.9999
		
		~dev-libs/openssl-${OPENSSL_PV_4_0_PV}
		~dev-libs/openssl-${OPENSSL_PV_3_6_PV}
		~dev-libs/openssl-${OPENSSL_PV_3_5_PV}
		~dev-libs/openssl-${OPENSSL_PV_3_4_PV}
		~dev-libs/openssl-${OPENSSL_PV_3_3_PV}
		~dev-libs/openssl-${OPENSSL_PV_3_0_PV}
	)
	~media-libs/gst-plugins-base-${PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	chkl_check_many_timestamps
	gstreamer_multilib_src_configure
}
