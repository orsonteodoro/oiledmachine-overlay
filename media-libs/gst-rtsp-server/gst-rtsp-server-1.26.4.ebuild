# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# gst-plugins-base for many used elements and API
# gst-plugins-good for rtprtxsend and rtpbin elements, maybe more
# gst-plugins-srtp for srtpenc and srtpdec elements

CFLAGS_HARDENED_USE_CASES="network untrusted-data server"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE HO"

inherit cflags-hardened check-compiler-switch flag-o-matic gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="A GStreamer based RTSP server library"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
LICENSE="LGPL-2+"
IUSE="
examples +introspection static-libs
ebuild_revision_16
"
RDEPEND="
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-good-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-plugins/gst-plugins-srtp-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	introspection? (
		>=dev-libs/gobject-introspection-1.31.1:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

pkg_setup() {
	check-compiler-switch_start
	gstreamer-meson_pkg_setup
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
	local emesonargs=(
		-Dintrospection=$(multilib_native_usex introspection "enabled" "disabled")
	)
	gstreamer_multilib_src_configure
}

multilib_src_install_all() {
	einstalldocs
	if use examples ; then
		docinto "examples"
		dodoc "${S}/examples/"*".c"
	fi
}
