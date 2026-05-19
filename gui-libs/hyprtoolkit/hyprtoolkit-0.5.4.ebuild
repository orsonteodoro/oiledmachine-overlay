# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

inherit cmake libcxx-slot libstdcxx-slot

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
DEPEND="
	>=dev-libs/hyprgraphics-0.5.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/hyprgraphics:=
	>=dev-libs/hyprlang-0.6.8[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/hyprlang:=
	>=gui-libs/aquamarine-0.10.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	gui-libs/aquamarine:=
	>=gui-libs/hyprutils-0.11.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
	dev-libs/glib:2
	>=dev-libs/iniparser-4.2.6
	>=dev-libs/wayland-1.24.0
	>=dev-libs/wayland-protocols-1.47
	media-libs/libglvnd
	>=x11-libs/cairo-1.18.4
	>=x11-libs/libdrm-2.4.131
	>=x11-libs/libxkbcommon-1.11.0
	>=x11-libs/pango-1.57.0
	>=x11-libs/pixman-0.46.4
"
RDEPEND="
	${DEPEND}
	>=dev-util/hyprwayland-scanner-0.4.5[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-util/wayland-scanner-1.24.0
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
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
