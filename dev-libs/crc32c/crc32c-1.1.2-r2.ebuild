# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
SRC_URI="https://github.com/google/crc32c/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="CRC32C implementation with support for CPU-specific acceleration instructions"
HOMEPAGE="https://github.com/google/crc32c"
LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="
	!test? (
		test
	)
"
BDEPEND="
	test? (
		dev-cpp/gtest
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.1.1-system-testdeps.patch"
)

DOCS=( README.md )

src_prepare() {
	sed -e '/-Werror/d' \
		-e '/-march=armv8/d' \
		-i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=14 # C++14 or later required for >=gtest-1.13.0
		-DCRC32C_BUILD_TESTS=$(usex test)
		-DCRC32C_BUILD_BENCHMARKS=OFF
		-DCRC32C_USE_GLOG=OFF
	)

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES: multilib-support EAPI8
# OILEDMACHINE-OVERLAY-META-REVDEP: leveldb
