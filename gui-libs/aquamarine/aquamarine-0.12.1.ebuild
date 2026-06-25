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

CHKL_TIMESTAMPS=(
	"dev-libs/libffi-9999"
	"dev-libs/libinput-9999"
	"dev-libs/wayland-9999"
	"media-libs/libdisplay-info-9999"
	"media-libs/mesa-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libxkbcommon-9999"
	"x11-libs/pango-9999"
	"x11-libs/pixman-9999"
)

inherit chkl cmake libcxx-slot libstdcxx-slot secure-version

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
SLOT="0/"$(ver_cut "1-2" "${PV}")

# Upstream states that the simpleWindow test is broken, see bug 936653
RESTRICT="test"
RDEPEND="
	>=dev-libs/libinput-${LIBINPUT_PV}:=
	>=dev-libs/libffi-${LIBFFI_PV}:=
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=dev-util/hyprwayland-scanner-0.4.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprutils-0.8.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=media-libs/libdisplay-info-${LIBDISPLAY_INFO_PV}:=
	media-libs/libglvnd:=
	>=media-libs/mesa-${MESA_PV}:=[opengl]
	sys-apps/hwdata:=
	>=sys-auth/seatd-0.9.2:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	virtual/libudev:=
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols:=
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

src_configure() {
	chkl_check_many_timestamps
	cmake_src_configure
}
