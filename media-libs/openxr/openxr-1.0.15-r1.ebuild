# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-utils eutils python-single-r1 toolchain-funcs

DESCRIPTION="Generated headers and sources for OpenXR loader."
HOMEPAGE="https://khronos.org/openxr"
LICENSE="Apache-2.0 MIT"
KEYWORDS="~amd64"
ORG_GH="https://github.com/KhronosGroup"
SLOT="0/${PV}"
MY_PN="OpenXR-SDK-Source"
SRC_URI="
${ORG_GH}/${MY_PN}/archive/release-${PV}.tar.gz
	-> ${P}.tar.gz"
NV_DRIVER_VERSION_VULKAN="390.132"
IUSE+=" egl gles2 +system-jsoncpp video_cards_amdgpu video_cards_amdgpu-pro \
video_cards_amdgpu-pro-lts video_cards_i965 video_cards_iris \
video_cards_nvidia video_cards_radeonsi wayland xcb +xlib"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
		^^ ( xlib xcb wayland )"
DEPEND+=" ${PYTHON_DEPS}
	|| (
		video_cards_amdgpu? (
	media-libs/mesa[video_cards_radeonsi,vulkan]
	x11-base/xorg-drivers[video_cards_amdgpu]
		)
		video_cards_amdgpu-pro? (
	media-libs/mesa:=[video_cards_radeonsi]
	x11-drivers/amdgpu-pro[-opengl_pro,opengl_mesa,vulkan]
		)
		video_cards_amdgpu-pro-lts? (
	media-libs/mesa:=[video_cards_radeonsi]
	x11-drivers/amdgpu-pro-lts[-opengl_pro,opengl_mesa,vulkan]
		)
		video_cards_i965? (
	media-libs/mesa[video_cards_i965,vulkan]
	x11-base/xorg-drivers[video_cards_i965]
		)
		video_cards_iris? (
	media-libs/mesa[video_cards_iris,vulkan]
		)
		video_cards_nvidia? (
	>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_VULKAN}
		)
		video_cards_radeonsi? (
	media-libs/mesa[video_cards_radeonsi,vulkan]
	x11-base/xorg-drivers[video_cards_radeonsi]
		)
	)
	media-libs/mesa[egl?,gles2?,libglvnd(+)]
	media-libs/vulkan-loader
	system-jsoncpp? ( dev-libs/jsoncpp )
	virtual/libc
	xcb? (
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-wm
	)
	xlib? (
		x11-libs/libX11
		x11-base/xorg-proto
	)
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		media-libs/mesa[egl]
	)"
#	x11-libs/libXrandr
#	x11-libs/libXxf86vm
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	>=dev-util/cmake-3.0"
CMAKE_BUILD_TYPE=Release
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-release-${PV}"

src_configure() {
	mycmakeargs=(
		-DBUILD_API_LAYERS=OFF
		-DBUILD_TESTS=OFF
		-DBUILD_CONFORMANCE_TESTS=OFF
		-DBUILD_WITH_SYSTEM_JSONCPP=$(usex system-jsoncpp)
	)
	if use xlib ; then
		mycmakeargs+=( -DPRESENTATION_BACKEND=xlib )
	elif use xcb ; then
		mycmakeargs+=( -DPRESENTATION_BACKEND=xcb )
	elif use wayland ; then
		mycmakeargs+=( -DPRESENTATION_BACKEND=wayland )
	else
		die "Must choose a PRESENTATION_BACKEND"
	fi
	cmake-utils_src_configure
}
