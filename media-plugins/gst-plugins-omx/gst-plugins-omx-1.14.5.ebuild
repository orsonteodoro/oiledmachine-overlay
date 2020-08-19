# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic meson multilib-minimal

MY_PN="gst-omx"
DESCRIPTION="GStreamer OpenMAX IL wrapper plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-omx.html"
SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="~arm ~amd64"
IUSE="rpi omx-bellagio omx-tizonia examples test"

# FIXME: What >=media-libs/gst-plugins-bad-1.4.0:1.0[gl] stuff for non-rpi?
RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-good-${PV}:1.0[${MULTILIB_USEDEP}]
	rpi? (
		media-libs/raspberrypi-userland
		>=media-libs/gst-plugins-bad-1.4.0:1.0[egl,gles2,rpi,${MULTILIB_USEDEP}]
	)
	omx-bellagio? ( >=media-libs/libomxil-bellagio-0.9.3:=[${MULTILIB_USEDEP}] )
	omx-tizonia? ( >=media-sound/tizonia-0.1.0:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.3
	>=dev-util/meson-0.36
	virtual/pkgconfig
"
REQUIRED_USE="^^ ( rpi omx-bellagio omx-tizonia )"

S="${WORKDIR}/${MY_PN}-${PV}"

multilib_src_configure() {
	GST_PLUGINS_BUILD=""
	local emesonargs=()
	if use rpi; then
		emesonargs+=( -Dwith_omx_target=rpi )
		emesonargs+=( -Dwith_omx_header_path=/opt/vc/include/IL )
	fi
	if use omx-bellagio; then
		emesonargs+=( -Dwith_omx_target=bellagio )
	fi
	if use omx-tizonia; then
		emesonargs+=( -Dwith_omx_target=tizonia )
	fi

	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	einstalldocs
}
