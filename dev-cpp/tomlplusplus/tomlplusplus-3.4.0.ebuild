# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit libcxx-slot libstdcxx-slot meson

DESCRIPTION="TOML config file parser and serializer"
HOMEPAGE="
https://marzer.github.io/tomlplusplus/
https://github.com/marzer/tomlplusplus
"
SRC_URI="https://github.com/marzer/tomlplusplus/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="dev-build/cmake"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	local emesonargs=(
		-Dbuild_lib=true
		-Dgenerate_cmake_config=true
		-Duse_vendored_libs=true # for test dependencies, header only and very restrictive version requirements
		$(meson_use test build_tests)
	)

	meson_src_configure
}

src_test() {
	local emesontestargs=(
		'tests - C'
	)

	meson_src_test "${emesontestargs[@]}"
}
