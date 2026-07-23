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
	"dev-libs/hyprlang-9999"
	"dev-libs/wayland-9999"
	"gui-libs/hyprutils-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/libxkbcommon-9999"
	"x11-libs/pixman-9999"
)

inherit chkl cmake libcxx-slot libstdcxx-slot secure-version

DESCRIPTION="A modern C++ Wayland-native GUI toolkit"
HOMEPAGE="https://github.com/hyprwm/hyprtoolkit"

if [[ "${PV}" =~ "9999" ]]; then
	FALLBACK_COMMIT="67d9012d7d3a902a6a37e313fbfaf56ce7d3c53e"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprtoolkit.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="https://github.com/hyprwm/hyprtoolkit/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"
fi

LICENSE="BSD"
RESTRICT="
	!test? (
		test
	)
"
SOVER="5"
SLOT="0/${SOVER}"
IUSE="test"

BDEPEND="
	test? (
		dev-cpp/gtest
	)
"
RDEPEND="
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/hyprgraphics-0.5.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/hyprlang-${HYPRLANG_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/iniparser-${INIPARSER_PV}:=
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=dev-libs/wayland-protocols-1.47:=
	>=gui-libs/aquamarine-0.10.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprutils-${HYPRUTILS_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=media-libs/libglvnd-${LIBGLVND_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
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

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover=$(grep -E -e "SOVERSION [0-9]+" "${S}/CMakeLists.txt" | grep -E -o -e "[0-9]+")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
