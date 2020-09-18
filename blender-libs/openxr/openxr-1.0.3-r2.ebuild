# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This is the last version released for c++11

EAPI=7
DESCRIPTION="Generated headers and sources for OpenXR loader."
HOMEPAGE="https://khronos.org/openxr"
KEYWORDS="~amd64"
LICENSE="Apache-2.0 MIT"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-utils eutils python-single-r1 toolchain-funcs
ORG_GH="https://github.com/KhronosGroup"
SLOT="0/${PV}"
MY_PN="OpenXR-SDK-Source"
SRC_URI="\
	${ORG_GH}/${MY_PN}/archive/release-${PV}.tar.gz
-> ${P}.tar.gz"
NV_DRIVER_VERSION_VULKAN="390.132"
IUSE="+system-jsoncpp video_cards_amdgpu video_cards_amdgpu-pro \
video_cards_amdgpu-pro-lts video_cards_i965 video_cards_iris \
video_cards_nvidia video_cards_radeonsi wayland xcb +xlib"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( xlib xcb wayland )
"
RDEPEND="${PYTHON_DEPS}
	|| (
		video_cards_amdgpu? (
	blender-libs/mesa:=[video_cards_radeonsi,vulkan]
	x11-base/xorg-drivers[video_cards_amdgpu]
		)
		video_cards_amdgpu-pro? (
	blender-libs/mesa:=[video_cards_radeonsi,vulkan]
	x11-drivers/amdgpu-pro[-opengl_pro,opengl_mesa,vulkan]
		)
		video_cards_amdgpu-pro-lts? (
	blender-libs/mesa:=[video_cards_radeonsi,vulkan]
	x11-drivers/amdgpu-pro[-opengl_pro,opengl_mesa,vulkan]
		)
		video_cards_i965? (
	blender-libs/mesa:=[video_cards_i965,vulkan]
	x11-base/xorg-drivers[video_cards_i965]
		)
		video_cards_iris? (
	blender-libs/mesa:=[video_cards_iris,vulkan]
		)
		video_cards_nvidia? (
	>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_VULKAN}
		)
		video_cards_radeonsi? (
	blender-libs/mesa:=[video_cards_radeonsi,vulkan]
	x11-base/xorg-drivers[video_cards_radeonsi]
		)
	)
	blender-libs/mesa:=[libglvnd]
	media-libs/vulkan-loader
	system-jsoncpp? ( dev-libs/jsoncpp )
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
		blender-libs/mesa:=[egl]
	)"
#	x11-libs/libXrandr
#	x11-libs/libXxf86vm
DEPEND="${RDEPEND}"
CMAKE_BUILD_TYPE=Release
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-release-${PV}"

iprfx() {
	echo "${EPREFIX}/usr/$(get_libdir)/blender/${PN}/usr"
}

src_configure() {
	ewarn "This ebuild-package is a Work in Progress (WIP)"
	mycmakeargs=(
		-DBUILD_API_LAYERS=OFF
		-DBUILD_TESTS=OFF
		-DBUILD_CONFORMANCE_TESTS=OFF
		-DBUILD_WITH_SYSTEM_JSONCPP=$(usex system-jsoncpp)
		-DCMAKE_CXX_EXTENSIONS=OFF
		-DCMAKE_INSTALL_PREFIX="$(iprfx)"
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

	if has_version 'blender-libs/mesa:=[libglvnd]' ; then
		einfo "Detected blender-libs/mesa:=[libglvnd]"
		export CMAKE_LIBRARY_PATH="\
${EROOT}/usr/$(get_libdir);${CMAKE_LIBRARY_PATH}"
		export CMAKE_INCLUDE_PATH="\
${EROOT}/usr/include;${CMAKE_INCLUDE_PATH}"

		mycmakeargs+=(
			-DOPENGL_egl_LIBRARY=/usr/$(get_libdir)/libEGL.so
			-DOPENGL_glx_LIBRARY=/usr/$(get_libdir)/libGLX.so
			-DOPENGL_opengl_LIBRARY=/usr/$(get_libdir)/libOpenGL.so
		)
	else
		einfo "Detected blender-libs/mesa:=[-libglvnd]"
		export CMAKE_LIBRARY_PATH="\
${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir);${CMAKE_LIBRARY_PATH}"
		export CMAKE_INCLUDE_PATH="\
${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/include;${CMAKE_INCLUDE_PATH}"

		mycmakeargs+=(
			-DOPENGL_egl_LIBRARY="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libEGL.so"
			-DOPENGL_gl_LIBRARY="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libGL.so"
		)
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	cp -aT "${ED}/usr/share" "${ED}/$(iprfx)" || die
	rm -rf "${ED}/usr/share" || die
}
