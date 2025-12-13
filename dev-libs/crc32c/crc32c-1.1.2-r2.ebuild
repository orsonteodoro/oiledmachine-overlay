# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=17 # Originally 11

_CXX_STANDARD=(
	"+cxx_standard_cxx11"
	"cxx_standard_cxx14"
	"cxx_standard_cxx17"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]}"
)

inherit cflags-hardened cmake-multilib libstdcxx-slot libcxx-slot

KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
SRC_URI="https://github.com/google/crc32c/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="CRC32C implementation with support for CPU-specific acceleration instructions"
HOMEPAGE="https://github.com/google/crc32c"
LICENSE="BSD"
SLOT="0"
IUSE="
${_CXX_STANDARD[@]}
test
ebuild_revision_6
"
REQUIRED_USE="
	test? (
		^^ (
			cxx_standard_cxx14
			cxx_standard_cxx17
		)
	)
	^^ (
		${_CXX_STANDARD[@]/+}
	)
"
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

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	sed -e "/-Werror/d" \
		-e "/-march=armv8/d" \
		-i "CMakeLists.txt" || die
	cmake_src_prepare
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		$(usex cxx_standard_cxx11 "-DCMAKE_CXX_STANDARD=11" "") # Project default
		$(usex cxx_standard_cxx14 "-DCMAKE_CXX_STANDARD=14" "") # For gtest
		$(usex cxx_standard_cxx17 "-DCMAKE_CXX_STANDARD=17" "") # For gtest
		-DCRC32C_BUILD_TESTS=$(usex test)
		-DCRC32C_BUILD_BENCHMARKS=OFF
		-DCRC32C_USE_GLOG=OFF
	)

	cmake-multilib_src_configure
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES: multilib-support EAPI8
# OILEDMACHINE-OVERLAY-META-REVDEP: leveldb
