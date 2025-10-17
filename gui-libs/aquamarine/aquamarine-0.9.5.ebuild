# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}
)

inherit cmake libcxx-slot libstdcxx-slot

DESCRIPTION="Aquamarine is a very light linux rendering backend library"
HOMEPAGE="https://github.com/hyprwm/aquamarine"

if [[ "${PV}" == *"9999"* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"

# Upstream states that the simpleWindow test is broken, see bug 936653
RESTRICT="test"
RDEPEND="
	>=dev-libs/libinput-1.26.0
	dev-libs/libffi
	dev-libs/wayland
	>=dev-util/hyprwayland-scanner-0.4.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-util/hyprwayland-scanner:=
	>=gui-libs/hyprutils-0.8.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
	media-libs/libdisplay-info:=
	media-libs/libglvnd
	media-libs/mesa[opengl]
	sys-apps/hwdata
	>=sys-auth/seatd-0.8.0
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	virtual/libudev
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"

BDEPEND="
	dev-build/cmake
	dev-util/wayland-scanner
	virtual/pkgconfig
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	sed -i "/add_compile_options(-O3)/d" "${S}/CMakeLists.txt" || die
	cmake_src_prepare
}
