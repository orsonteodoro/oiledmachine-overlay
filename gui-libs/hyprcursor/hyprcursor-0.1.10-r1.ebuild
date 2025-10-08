# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_11_5" # Support -std=c++23
	"gcc_slot_12_5" # Support -std=c++23
	"gcc_slot_13_4" # Support -std=c++23
	"gcc_slot_14_3" # Support -std=c++23
)

inherit cmake libstdcxx-slot

DESCRIPTION="The hyprland cursor format, library and utilities"
HOMEPAGE="https://github.com/hyprwm/hyprcursor"
SRC_URI="https://github.com/hyprwm/hyprcursor/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv"

# Disable tests since as per upstream, tests require a theme to be installed
# See also https://github.com/hyprwm/hyprcursor/commit/94361fd8a75178b92c4bb24dcd8c7fac8423acf3
RESTRICT="test"

RDEPEND="
	dev-cpp/tomlplusplus[${LIBSTDCXX_USEDEP}]
	dev-cpp/tomlplusplus:=
	>=dev-libs/hyprlang-0.4.2[${LIBSTDCXX_USEDEP}]
	dev-libs/hyprlang:=
	dev-libs/libzip
	gnome-base/librsvg:2
	x11-libs/cairo
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/0.1.10-llvm-fix.patch
	"${FILESDIR}"/0.1.10-fstream.patch
)

pkg_setup() {
	libstdcxx-slot_verify
}
