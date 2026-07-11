# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Keep default IUSE mirrored with gst-plugins-base

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_ENABLED="qt6"

inherit secure-version

CHKL_TIMESTAMPS=(
	"dev-qt/qtbase-${QTBASE6_PV}"
	"dev-qt/qtdeclarative-${QTDECLARATIVE6_PV}"
	"dev-qt/qttools-${QTTOOLS6_PV}"
	"dev-qt/qtwayland-${QTWAYLAND6_PV}"
)

inherit cflags-hardened chkl gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

DESCRIPTION="A Qt6 video sink plugin for GStreamer"
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
	>=dev-qt/qtbase-${QTBASE6_PV}:6=[gui,wayland?,X?]
	>=dev-qt/qtdeclarative-${QTDECLARATIVE6_PV}:6=
	>=dev-qt/qttools-${QTTOOLS6_PV}:6=[linguist,qml]
	~media-libs/gst-plugins-base-${PV}:=[opengl,wayland?,X?]
	egl? (
		media-libs/mesa:=
	)
	wayland? (
		media-libs/gst-plugins-base:=[wayland]
		>=dev-qt/qtwayland-${QTWAYLAND6_PV}:6=
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
