# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils flag-o-matic meson multilib-minimal python-any-r1

MY_PN="gst-omx"
DESCRIPTION="GStreamer OpenMAX IL wrapper plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-omx.html"
LICENSE="LGPL-2.1"
KEYWORDS="~arm ~amd64"
SLOT="1.0/${PV}"
IUSE+=" rpi omx-bellagio omx-tizonia examples test"
REQUIRED_USE+="
	^^ ( rpi omx-bellagio omx-tizonia )"
# FIXME: What >=media-libs/gst-plugins-bad-1.4.0:1.0[gl] stuff for non-rpi?
RDEPEND+="
	>=dev-libs/glib-2.44.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-good-${PV}:1.0[${MULTILIB_USEDEP}]
	rpi? (
		media-libs/raspberrypi-userland
		>=media-libs/gst-plugins-bad-1.4.0:1.0[egl,gles2,rpi,${MULTILIB_USEDEP}]
	)
	omx-bellagio? ( >=media-libs/libomxil-bellagio-0.9.3:=[${MULTILIB_USEDEP}] )
	omx-tizonia? ( >=media-sound/tizonia-0.19.0:=[${MULTILIB_USEDEP}] )"
DEPEND+=" ${RDEPEND}
	>=dev-util/gtk-doc-am-1.3"
BDEPEND+=" ${BDEPEND}
	${PYTHON_DEPS}
	>=dev-util/meson-0.47
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]"
SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-${PV}"

multilib_src_configure() {
	GST_PLUGINS_BUILD=""
	local emesonargs=()
	if use rpi; then
		emesonargs+=( -Dtarget=rpi )
		emesonargs+=( -Dheader_path=/opt/vc/include/IL )
	fi
	if use omx-bellagio; then
		emesonargs+=( -Dtarget=bellagio )
	fi
	if use omx-tizonia; then
		emesonargs+=( -Dtarget=tizonia )
	fi
	emesonargs+=(
		$(meson_use examples)
		$(meson_use test tests)
	)

	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	einstalldocs
}
