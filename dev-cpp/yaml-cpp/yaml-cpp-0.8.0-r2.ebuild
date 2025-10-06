# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8, U24
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3, U24 (default)
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8, U22 (default), U24
)

inherit cmake-multilib libstdcxx-slot

KEYWORDS="~amd64"
SRC_URI="https://github.com/jbeder/yaml-cpp/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

DESCRIPTION="YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"
LICENSE="MIT"
SLOT="0/0.8"
IUSE="test"
RESTRICT="
	!test? (
		test
	)
"
DEPEND="
	test? (
		dev-cpp/gtest[${MULTILIB_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/yaml-cpp-0.8.0-gtest.patch"
	"${FILESDIR}/yaml-cpp-0.8.0-gcc13.patch"
	"${FILESDIR}/yaml-cpp-0.8.0-include-cstdint.patch"
	"${FILESDIR}/yaml-cpp-0.8.0-cmake2.patch"
)

src_prepare() {
	rm -r test/gtest-1.11.0 || die

	cmake_src_prepare
	libstdcxx-slot_verify
}

src_configure() {
	local mycmakeargs=(
		-DYAML_BUILD_SHARED_LIBS=ON
		-DYAML_CPP_BUILD_TOOLS=OFF # Don't have install rule
		-DYAML_CPP_BUILD_TESTS=$(usex test)
	)
	cmake-multilib_src_configure
}
