# Copyright 2024 Orson Teoodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Keep default IUSE mirrored with gst-plugins-base

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_ENABLED="qt6"

CHKL_TIMESTAMPS=(
	"media-libs/mesa-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

DESCRIPTION="A Qt5 video sink plugin for GStreamer"
IUSE="
egl wayland +X
ebuild_revision_24
"
REQUIRED_USE="
	|| (
		egl
		wayland
		X
	)
"
RDEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtdeclarative:5=
	dev-qt/qtgui:5=[wayland?,X?]
	dev-qt/linguist:5=
	egl? (
		dev-qt/qtgui:5=[eglfs]
		>=media-libs/mesa-${MESA_PV}:=
	)
	wayland? (
		dev-qt/qtwayland:5=
		dev-qt/qtwayland:=
	)

	~media-libs/gst-plugins-base-${PV}:=[opengl,wayland?,X?]
	wayland? (
		media-libs/gst-plugins-base:=[wayland]
		dev-qt/qtwayland:5=
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		-Dqt-egl=$(usex egl "enabled" "disabled")
		-Dqt-wayland=$(usex wayland "enabled" "disabled")
		-Dqt-x11=$(usex X "enabled" "disabled")
		-Dqt-method="qmake"
	)
	gstreamer_multilib_src_configure
}
