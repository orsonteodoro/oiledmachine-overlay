# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Adaptive demuxer plugins for GStreamer"
IUSE="
libgcrypt nettle openssl
ebuild_revision_11
"
REQUIRED_USE="
	|| (
		libgcrypt
		nettle
		openssl
	)
"
RDEPEND="
	>=dev-libs/libxml2-2.8[${MULTILIB_USEDEP}]
	libgcrypt? (
		dev-libs/libgcrypt:=[${MULTILIB_USEDEP}]
	)
	nettle? (
		>=dev-libs/nettle-3.0:0=[${MULTILIB_USEDEP}]
	)
	openssl? (
		dev-libs/openssl:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
RDEPEND="
	${RDEPEND}
	|| (
		net-libs/libsoup:3.0
		net-libs/libsoup:2.4
	)
"

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dhls-crypto=nettle
	)
	gstreamer_multilib_src_configure
}
