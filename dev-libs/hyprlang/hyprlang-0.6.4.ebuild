# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_11_5" # Support -std=c++23
	"gcc_slot_12_5" # Support -std=c++23
	"gcc_slot_13_3" # Support -std=c++23
	"gcc_slot_14_3" # Support -std=c++23
)

inherit cmake libstdcxx-slot toolchain-funcs

DESCRIPTION="Official implementation library for the hypr config language"
HOMEPAGE="https://github.com/hyprwm/hyprlang"
SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=gui-libs/hyprutils-0.7.1[${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	|| (
		>=sys-devel/gcc-11:*
		>=llvm-core/clang-13:*
	)
"

pkg_setup() {
	[[ "${MERGE_TYPE}" == "binary" ]] && return

	tc-check-min_ver gcc 11
	tc-check-min_ver clang 13

	libstdcxx-slot_verify
}
