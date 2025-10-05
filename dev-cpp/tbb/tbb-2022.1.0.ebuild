# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
)

inherit cmake-multilib flag-o-matic libstdcxx-slot

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://github.com/uxlfoundation/oneTBB"
SRC_URI="https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/oneTBB-${PV}"

LICENSE="Apache-2.0"
# https://github.com/oneapi-src/oneTBB/blob/master/CMakeLists.txt#L53
# libtbb<SONAME>-libtbbmalloc<SONAME>-libtbbbind<SONAME>
SLOT="0/12.15-2.15-3.15"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="!kernel_Darwin? ( sys-apps/hwloc:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2021.13.0-test-atomics.patch
	"${FILESDIR}"/${PN}-2022.0.0_do-not-fortify-source.patch
)

pkg_setup() {
	libstdcxx-slot_verify
}

src_prepare() {
	# Has an #error to force compilation as C but links with C++ library, dies
	# with GLIBCXX_ASSERTIONS as a result.
	sed -i -e '/tbb_add_c_test(SUBDIR tbbmalloc NAME test_malloc_pure_c DEPENDENCIES TBB::tbbmalloc)/d' \
		test/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Workaround for bug #912210
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local mycmakeargs=(
		-DTBB_TEST=$(usex test)
		-DTBB_EXAMPLES=OFF # TODO: add this
		-DTBB_ENABLE_IPO=OFF
		-DTBB_STRICT=OFF
	)

	cmake-multilib_src_configure
}
