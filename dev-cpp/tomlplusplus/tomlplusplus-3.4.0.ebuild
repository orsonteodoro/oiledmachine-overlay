# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # D13 (LTS), F41 compatible, hyprland compatible
	"gcc_slot_13_4" # U24 (LTS) compatible
	"gcc_slot_12_4" # D12 (LTS) compatible
	"gcc_slot_11_5" # U22 (LTS) compatible
)

inherit libstdcxx-slot meson

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
