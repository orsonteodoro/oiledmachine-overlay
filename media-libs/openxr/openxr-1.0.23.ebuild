# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-utils eutils flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Generated headers and sources for OpenXR loader."
HOMEPAGE="https://khronos.org/openxr"
LICENSE="Apache-2.0
	BSD
	CC-BY-4.0
	MIT"
# See also https://github.com/KhronosGroup/OpenXR-SDK-Source/blob/release-1.0.18/.reuse/dep5
KEYWORDS="~amd64"
ORG_GH="https://github.com/KhronosGroup"
SLOT="0/${PV}"
MY_PN="OpenXR-SDK-Source"
SRC_URI="
${ORG_GH}/${MY_PN}/archive/release-${PV}.tar.gz
	-> ${P}.tar.gz"
NV_DRIVER_VERSION_VULKAN="390.132"
IUSE+=" doc egl gles2 +system-jsoncpp video_cards_amdgpu
video_cards_i965 video_cards_iris
video_cards_nvidia video_cards_radeonsi wayland xcb +xlib"
REQUIRED_USE+=" ^^ ( xlib xcb wayland )"
DEPEND+=" ${PYTHON_DEPS}
	|| (
		video_cards_amdgpu? (
	media-libs/mesa[video_cards_radeonsi,vulkan]
	x11-base/xorg-drivers[video_cards_amdgpu]
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
	$(python_gen_any_dep '>=dev-python/jinja-2[${PYTHON_USEDEP}]')
	>=dev-util/cmake-3.0
	sys-devel/clang"
CMAKE_BUILD_TYPE=Release
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-release-${PV}"

src_configure() {
	export CC=clang
	export CXX=clang++
	strip-unsupported-flags
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

src_install() {
	cmake-utils_src_install
	docinto licenses
	dodoc .reuse/dep5
	dodoc LICENSES/*
	dodoc COPYING.adoc
	mv "${ED}/usr/share/doc/${PN}/LICENSE" \
		"${ED}/usr/share/doc/${PN}-${PVR}/licenses" || die
	rm -rf "${ED}/usr/share/doc/${PN}" || die
	if use doc ; then
		docinto readmes
		dodoc CHANGELOG.SDK.md
		mv "${ED}/usr/share/doc/${P}/README.md" \
			"${ED}/usr/share/doc/${P}/readmes" || die
	else
		rm -rf "${ED}/usr/share/doc/${P}/README.md"
	fi
}
