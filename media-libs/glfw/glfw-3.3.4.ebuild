# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="The Portable OpenGL FrameWork"
HOMEPAGE="https://www.glfw.org/"
SRC_URI="https://github.com/glfw/glfw/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
IUSE+=" wayland"

RDEPEND="
	x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	!wayland? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXinerama[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
		media-libs/mesa[egl,wayland,${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	!wayland? ( x11-libs/libXi[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-protocols-1.15[${MULTILIB_USEDEP}] )
"
BDEPEND="
	wayland? ( kde-frameworks/extra-cmake-modules )
"

src_configure() {
	configure_abi() {
		local mycmakeargs=(
			-DGLFW_BUILD_EXAMPLES=no
			-DGLFW_USE_WAYLAND="$(usex wayland)"
			-DBUILD_SHARED_LIBS=1
		)
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
}
