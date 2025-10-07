# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# A ebuild fork of the wlroots 0.18.2 ebuild.

inherit meson

DESCRIPTION="Pluggable, composable, unopinionated modules for building a Wayland compositor"
HOMEPAGE="https://gitlab.freedesktop.org/wlroots/wlroots"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/hyprwm/wlroots-hyprland.git"
	inherit git-r3
	S="${WORKDIR}/wlroots-hyprland-${EGIT_COMMIT}"
	SLOT="0"
else
	EGIT_COMMIT="e9d04a67ff8d92c917cb55cdc66878d8e89b22f6"
	KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
	S="${WORKDIR}/wlroots-hyprland-${EGIT_COMMIT}"
	SRC_URI="
		https://github.com/hyprwm/wlroots-hyprland/archive/${EGIT_COMMIT}.tar.gz
			-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
	"
	SLOT="0"
fi

LICENSE="MIT"
IUSE="+libinput +drm +session vulkan x11-backend xcb-errors X"
REQUIRED_USE="
	drm? (
		session
	)
	libinput? (
		session
	)
	xcb-errors? (
		|| (
			x11-backend
			X
		)
	)
"

DEPEND="
	>=dev-libs/wayland-1.23.0
	media-libs/libglvnd
	|| (
		>=media-libs/mesa-24.1.0_rc1[opengl]
		<media-libs/mesa-24.1.0_rc1[egl(+),gles2]
	)
	>=x11-libs/libdrm-2.4.122
	x11-libs/libxkbcommon
	>=x11-libs/pixman-0.42.0
	drm? (
		media-libs/libdisplay-info:=
		sys-apps/hwdata
	)
	libinput? (
		>=dev-libs/libinput-1.19.0:=
	)
	session? (
		sys-auth/seatd:=
		virtual/libudev
	)
	vulkan? (
		dev-util/glslang:=
		dev-util/vulkan-headers
		media-libs/vulkan-loader
	)
	xcb-errors? (
		x11-libs/xcb-util-errors
	)
	x11-backend? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-renderutil
	)
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-wm
		x11-base/xwayland
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.35
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local backends=(
		$(usev drm)
		$(usev libinput)
		$(usev x11-backend 'x11')
	)
	local meson_backends=$(IFS=','; echo "${backends[*]}")
	local emesonargs=(
		$(meson_feature xcb-errors)
		-Dexamples=false
		-Drenderers=$(usex vulkan 'gles2,vulkan' gles2)
		$(meson_feature X xwayland)
		-Dbackends=${meson_backends}
		$(meson_feature session)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc "docs/"*
}

pkg_postinst() {
	ewarn "This ebuild fork is EOL (End Of Life), so it may have security issues as time passes."
	elog "You must be in the input group to allow your compositor"
	elog "to access input devices via libinput."
}
