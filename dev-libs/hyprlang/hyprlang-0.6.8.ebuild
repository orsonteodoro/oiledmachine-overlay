# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)

inherit cflags-hardened cmake libcxx-slot libstdcxx-slot toolchain-funcs

DESCRIPTION="Official implementation library for the hypr config language"
HOMEPAGE="https://github.com/hyprwm/hyprlang"
SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE+="
ebuild_revision_1
"
RDEPEND="
	>=gui-libs/hyprutils-0.7.1:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.19
	virtual/pkgconfig
"

pkg_setup() {
	[[ "${MERGE_TYPE}" == "binary" ]] && return

	libcxx-slot_verify
	libstdcxx-slot_verify

	tc-check-min_ver gcc 14
	tc-check-min_ver clang 17
}

src_configure() {
	cflags-hardened_append
	cmake_src_configure
}
