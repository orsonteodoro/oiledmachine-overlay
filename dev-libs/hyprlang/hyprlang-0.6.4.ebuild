# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat

GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
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
		>=sys-devel/gcc-14:*
		>=llvm-core/clang-17:*
	)
"

pkg_setup() {
	[[ "${MERGE_TYPE}" == "binary" ]] && return

	libstdcxx-slot_verify

	tc-check-min_ver gcc 14
	tc-check-min_ver clang 17
}
