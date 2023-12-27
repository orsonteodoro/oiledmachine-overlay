# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
MESA_PV="22.0.1"
MY_PN="OpenXR-SDK-Source"
NV_DRIVER_VERSION_VULKAN="390.132"
PYTHON_COMPAT=( python3_{8..11} )
XORG_SERVER_PV="21.1.4"
ORG_GH="https://github.com/KhronosGroup"

inherit cmake flag-o-matic python-any-r1 toolchain-funcs

SRC_URI="
${ORG_GH}/${MY_PN}/archive/release-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Generated headers and sources for OpenXR loader."
LICENSE="
	Apache-2.0
	BSD
	CC-BY-4.0
	MIT
"
# See also https://github.com/KhronosGroup/OpenXR-SDK-Source/blob/release-1.0.18/.reuse/dep5
KEYWORDS="~amd64"
HOMEPAGE="https://khronos.org/openxr"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc gles2 +system-jsoncpp video_cards_amdgpu video_cards_intel
video_cards_nvidia video_cards_radeonsi wayland xcb +xlib
"
REQUIRED_USE+="
	^^ (
		xcb
		xlib
		wayland
	)
	|| (
		video_cards_amdgpu
		video_cards_intel
		video_cards_nvidia
		video_cards_radeonsi
	)
"
# U 22.04
DEPEND+="
	${PYTHON_DEPS}
	media-libs/mesa[egl(+),gles2?,libglvnd(+)]
	media-libs/vulkan-loader
	virtual/libc
	system-jsoncpp? (
		dev-libs/jsoncpp
	)
	xcb? (
		>=x11-libs/libxcb-1.14
		>=x11-libs/xcb-util-keysyms-0.4.0
		>=x11-libs/xcb-util-wm-0.4.1
	)
	xlib? (
		x11-base/xorg-proto
		>=x11-libs/libX11-1.7.5
	)
	wayland? (
		>=dev-libs/wayland-1.20.0
		>=dev-libs/wayland-protocols-1.25
		dev-util/wayland-scanner
		>=media-libs/mesa-${MESA_PV}[egl(+)]
	)
	|| (
		video_cards_amdgpu? (
			>=media-libs/mesa-${MESA_PV}[video_cards_radeonsi,vulkan]
			>=x11-base/xorg-drivers-${XORG_SERVER_PV}[video_cards_amdgpu]
		)
		video_cards_intel? (
			>=media-libs/mesa-${MESA_PV}[video_cards_intel,vulkan]
			>=x11-base/xorg-drivers-${XORG_SERVER_PV}[video_cards_intel]
		)
		video_cards_nvidia? (
			>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_VULKAN}
		)
		video_cards_radeonsi? (
			>=media-libs/mesa-${MESA_PV}[video_cards_radeonsi,vulkan]
			>=x11-base/xorg-drivers-${XORG_SERVER_PV}[video_cards_radeonsi]
		)
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		>=dev-python/jinja-3.0.3[${PYTHON_USEDEP}]
	')
	>=dev-util/cmake-3.22.1
	virtual/pkgconfig
	|| (
		>=sys-devel/clang-14.0
		>=sys-devel/gcc-11.2.0
	)
"
S="${WORKDIR}/${MY_PN}-release-${PV}"

src_configure() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	mycmakeargs=(
		-DBUILD_API_LAYERS=OFF
		-DBUILD_CONFORMANCE_TESTS=OFF
		-DBUILD_TESTS=OFF
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
	cmake_src_configure
}

src_install() {
	cmake_src_install
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

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  vulkan-driver-checks
