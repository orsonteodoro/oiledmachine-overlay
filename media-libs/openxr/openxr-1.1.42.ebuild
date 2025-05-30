# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

CMAKE_BUILD_TYPE="Release"
MESA_PV="22.0.1"
MY_PN="OpenXR-SDK-Source"
PYTHON_COMPAT=( "python3_"{8..13} )

inherit cmake flag-o-matic python-any-r1 toolchain-funcs

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
S="${WORKDIR}/${MY_PN}-release-${PV}"
SRC_URI="
https://github.com/KhronosGroup/${MY_PN}/archive/release-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Generated headers and sources for OpenXR loader."
LICENSE="
	Apache-2.0
	Boost-1.0
	BSD
	CC-BY-4.0
	MIT
"
# See also https://github.com/KhronosGroup/OpenXR-SDK-Source/blob/release-1.0.18/.reuse/dep5
HOMEPAGE="
	https://khronos.org/openxr
	https://github.com/KhronosGroup/OpenXR-SDK-Source
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc gles2 +system-jsoncpp wayland xcb +xlib
"
REQUIRED_USE+="
	^^ (
		xcb
		xlib
		wayland
	)
"
DEPEND+="
	${PYTHON_DEPS}
	media-libs/mesa[egl(+),libglvnd(+)]
	media-libs/vulkan-drivers
	media-libs/vulkan-loader
	virtual/libc
	gles2? (
		media-libs/mesa[gles2(+),opengl]
	)
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
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	$(python_gen_any_dep '
		>=dev-python/jinja2-3.0.3[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	>=dev-build/cmake-3.22.1
	virtual/pkgconfig
	|| (
		>=llvm-core/clang-14.0
		>=sys-devel/gcc-11.2.0
	)
"

src_configure() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
	mycmakeargs=(
		-DBUILD_API_LAYERS=OFF
		-DBUILD_CONFORMANCE_TESTS=OFF
		-DBUILD_TESTS=OFF
		-DBUILD_WITH_SYSTEM_JSONCPP=$(usex system-jsoncpp)
	)
	if use xlib ; then
		mycmakeargs+=(
			-DPRESENTATION_BACKEND=xlib
		)
	elif use xcb ; then
		mycmakeargs+=(
			-DPRESENTATION_BACKEND=xcb
		)
	elif use wayland ; then
		mycmakeargs+=(
			-DPRESENTATION_BACKEND=wayland
		)
	else
		die "Must choose a PRESENTATION_BACKEND"
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc ".reuse/dep5"
	dodoc "LICENSES/"*
	dodoc "COPYING.adoc"
	mv \
		"${ED}/usr/share/doc/${PN}/LICENSE" \
		"${ED}/usr/share/doc/${PN}-${PVR}/licenses" \
		|| die
	rm -rf \
		"${ED}/usr/share/doc/${PN}" \
		|| die
	if use doc ; then
		docinto "readmes"
		dodoc "CHANGELOG.SDK.md"
		mv \
			"${ED}/usr/share/doc/${P}/README.md" \
			"${ED}/usr/share/doc/${P}/readmes" \
			|| die
	else
		rm -rf "${ED}/usr/share/doc/${P}/README.md"
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  vulkan-driver-checks
