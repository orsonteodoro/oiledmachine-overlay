# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

CHKL_TIMESTAMPS=(
	"dev-libs/libxml2-9999"
	"dev-libs/libgcrypt-9999"
	"dev-libs/nettle-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.3.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cflags-hardened chkl multilib-build secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Adaptive demuxer plugins for GStreamer"
IUSE="
libgcrypt nettle openssl
ebuild_revision_24
"
REQUIRED_USE="
	|| (
		libgcrypt
		nettle
		openssl
	)
"
RDEPEND="
	>=dev-libs/libxml2-${LIBXML2_PV}:=[${MULTILIB_USEDEP}]
	libgcrypt? (
		>=dev-libs/libgcrypt-${LIBGCRYPT_PV}:=[${MULTILIB_USEDEP}]
	)
	nettle? (
		>=dev-libs/nettle-${NETTLE_PV}:=[${MULTILIB_USEDEP}]
	)
	openssl? (
		$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
	)
"
DEPEND="
	${RDEPEND}
"
RDEPEND="
	${RDEPEND}
	>=net-libs/libsoup-${LIBSOUP_PV}:=
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		-Dhls-crypto="nettle"
	)
	gstreamer_multilib_src_configure
}
