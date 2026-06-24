# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"dev-libs/wayland-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/libxkbcommon-9999"
	"x11-libs/pixman-9999"
)

inherit chkl cmake libcxx-slot libstdcxx-slot secure-version

DESCRIPTION="A modern C++ Wayland-native GUI toolkit"
HOMEPAGE="https://github.com/hyprwm/hyprtoolkit"

if [[ "${PV}" =~ "9999" ]]; then
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"
fi

LICENSE="BSD"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE="test"

BDEPEND="
	test? (
		dev-cpp/gtest
	)
"
RDEPEND="
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/hyprgraphics-0.5.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/hyprlang-0.6.8:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/iniparser-${INIPARSER_PV}:=
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=dev-libs/wayland-protocols-1.47:=
	>=gui-libs/aquamarine-0.10.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprutils-0.11.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	media-libs/libglvnd:=
"
DEPEND="
	${RDEPEND}
	>=dev-util/hyprwayland-scanner-0.4.5:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-util/wayland-scanner-1.24.0:=
"
BDEPEND="
	dev-cpp/gtest[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-build/cmake-3.19
	virtual/pkgconfig
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
