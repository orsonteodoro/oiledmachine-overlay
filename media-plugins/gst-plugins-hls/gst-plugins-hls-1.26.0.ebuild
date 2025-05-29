# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin network untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="HTTP live streaming plugin for GStreamer"
IUSE="
libgcrypt nettle openssl
ebuild_revision_10
"
REQUIRED_USE="
	|| (
		libgcrypt
		nettle
		openssl
	)
"
RDEPEND="
	libgcrypt? (
		dev-libs/libgcrypt[${MULTILIB_USEDEP}]
	)
	nettle? (
		>=dev-libs/nettle-3.0:0=[${MULTILIB_USEDEP}]
	)
	openssl? (
		dev-libs/openssl[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}/gst-plugins-bad-1.18.4-use-system-libs-hls.patch"
)

src_prepare() {
	default
	gstreamer_system_library \
		gstadaptivedemux_dep:gstadaptivedemux \
		gsturidownloader_dep:gsturidownloader
}

multilib_src_configure() {
	cflags-hardened_append
	local crypto_provider
	if use libgcrypt ; then
		crypto_provider="libcrypt"
	elif use nettle ; then
		crypto_provider="nettle"
	elif use openssl ; then
		crypto_provider="openssl"
	fi
	local emesonargs=(
		-Dhls-crypto=${crypto_provider}
	)
	gstreamer_multilib_src_configure
}

pkg_postinst() {
einfo
einfo "media-plugins/gst-plugins-adaptivedemux2 provides an alternative HLS"
einfo "demuxer option (hlsdemux2)"
einfo
}
