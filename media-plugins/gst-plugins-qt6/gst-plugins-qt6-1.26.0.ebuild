# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Keep default IUSE mirrored with gst-plugins-base

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_ENABLED="qt6"
QT6_SUBSLOTS=(
	"6.9.0"
	"6.8.2"
	"6.8.1"
	"6.8.0"
	"6.7.3"
	"6.7.2"
	"6.7.1"
	"6.7.0"
)

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

DESCRIPTION="A Qt6 video sink plugin for GStreamer"
IUSE="
egl wayland +X
ebuild_revision_13
"
REQUIRED_USE="
	|| (
		egl
		wayland
		X
	)
"
gen_qt6_rdepend() {
	local s
	for s in ${QT6_SUBSLOTS[@]} ; do
		echo "
			(
				dev-qt/qtbase:6/${s}[gui,wayland?,X?]
				dev-qt/qtdeclarative:6/${s}
				dev-qt/qttools:6/${s}[linguist,qml]
				egl? (
					dev-qt/qtbase:6/${s}[eglfs]
					media-libs/mesa:=
				)
				wayland? (
					dev-qt/qtwayland:6/${s}[qml]
				)
			)
		"
	done
}
RDEPEND="
	|| (
		$(gen_qt6_rdepend)
	)
	dev-qt/qtbase:=
	dev-qt/qtdeclarative:=
	dev-qt/qttools:=
	~media-libs/gst-plugins-base-${PV}:1.0[opengl,wayland?,X?]
	wayland? (
		media-libs/gst-plugins-base[wayland]
		dev-qt/qtwayland:=
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dqt-egl=$(usex egl "enabled" "disabled")
		-Dqt-wayland=$(usex wayland "enabled" "disabled")
		-Dqt-x11=$(usex X "enabled" "disabled")
		-Dqt-method="qmake"
	)
	gstreamer_multilib_src_configure
}
