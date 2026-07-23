# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"dev-cpp/tomlplusplus-9999"
	"dev-libs/hyprlang-9999"
	"dev-libs/libzip-9999"
	"gnome-base/librsvg-9999"
	"x11-libs/cairo-9999"
)

inherit chkl cmake libcxx-slot libstdcxx-slot secure-version

DESCRIPTION="The hyprland cursor format, library and utilities"
HOMEPAGE="https://github.com/hyprwm/hyprcursor"

if [[ ${PV} == *9999* ]]; then
	FALLBACK_COMMIT="39435900785d0c560c6ae8777d29f28617d031ef"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprcursor.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/hyprwm/hyprcursor/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv"
fi

LICENSE="BSD"
SOVER="0"
SLOT="0/${SOVER}"

# Disable tests since as per upstream, tests require a theme to be installed
# See also https://github.com/hyprwm/hyprcursor/commit/94361fd8a75178b92c4bb24dcd8c7fac8423acf3
RESTRICT="test"

RDEPEND="
	>=dev-cpp/tomlplusplus-${TOMLPLUSPLUS_PV}:=[${LIBSTDCXX_USEDEP_LTS}]
	>=dev-libs/hyprlang-${HYPRLANG_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/libzip-${LIBZIP_PV}:=
	>=gnome-base/librsvg-${LIBRSVG_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
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
	cmake_src_configure
}
