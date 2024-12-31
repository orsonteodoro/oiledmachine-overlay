# Copyright 2024 Orson Teoodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_ENABLED="qt6"
QT5_SUBSLOTS=(
	"5.15.14"
)

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

DESCRIPTION="A Qt5 video sink plugin for GStreamer"
IUSE="egl wayland +X" # Keep default IUSE mirrored with gst-plugins-base
REQUIRED_USE="
	|| (
		egl
		wayland
		X
	)
"
gen_qt5_rdepend() {
	local s
	for s in ${QT5_SUBSLOTS[@]} ; do
		echo "
			(
				dev-qt/qtcore:5/${s}
				dev-qt/qtdeclarative:5/${s}
				dev-qt/qtgui:5/${s}[wayland?,X?]
				~dev-qt/linguist-${s}:0
				egl? (
					dev-qt/qtgui:5/${s}[eglfs]
					media-libs/mesa:=
				)
				wayland? (
					dev-qt/qtwayland:5/${s}
				)
			)
		"
	done
}
RDEPEND="
	|| (
		$(gen_qt5_rdepend)
	)
	dev-qt/qtcore:=
	dev-qt/qtdeclarative:=
	dev-qt/qtgui:=
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
	local emesonargs=(
		-Dqt-egl=$(usex egl "enabled" "disabled")
		-Dqt-wayland=$(usex wayland "enabled" "disabled")
		-Dqt-x11=$(usex X "enabled" "disabled")
		-Dqt-method="qmake"
	)
	gstreamer_multilib_src_configure
}
