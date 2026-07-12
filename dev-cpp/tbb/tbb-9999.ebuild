# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX11[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}"
)

inherit cmake-multilib flag-o-matic libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="0e2d2c0bb9eb7995930ea4b6b7264bda8b34a039"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/oneTBB-${PV}"
	EGIT_REPO_URI="https://github.com/uxlfoundation/oneTBB.git"
	if [[ "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://github.com/uxlfoundation/oneTBB"
S="${WORKDIR}/oneTBB-${PV}"

LICENSE="Apache-2.0"
# https://github.com/oneapi-src/oneTBB/blob/master/CMakeLists.txt#L53
# libtbb<SONAME>-libtbbmalloc<SONAME>-libtbbbind<SONAME>
SOVER_TBB="12.19"
SOVER_TBBMALLOC="2.19"
SOVER_TBBBIND="3.19"
SLOT="0/${SOVER_TBB}-${SOVER_TBBMALLOC}-${SOVER_TBBBIND}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE+=" test"
RESTRICT="!test? ( test )"

RDEPEND="!kernel_Darwin? ( sys-apps/hwloc:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2021.9.0-ppc.patch
	"${FILESDIR}"/${PN}-2021.13.0-test-atomics.patch
	"${FILESDIR}"/${PN}-2022.0.0_do-not-fortify-source.patch
	"${FILESDIR}"/${PN}-0e2d2c0-no-clobber-hardened.patch
	"${FILESDIR}"/${PN}-2022.3.0-cmake.patch
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover
	local expected_sover

	# See
	# https://github.com/uxlfoundation/oneTBB/blob/master/include/oneapi/tbb/version.h#L56
	# https://github.com/uxlfoundation/oneTBB/blob/master/src/tbb/CMakeLists.txt#L103
	# https://github.com/uxlfoundation/oneTBB/blob/master/src/tbbbind/CMakeLists.txt#L56
	# https://github.com/uxlfoundation/oneTBB/blob/master/src/tbbmalloc/CMakeLists.txt#L76
	# https://github.com/uxlfoundation/oneTBB/blob/master/CMakeLists.txt#L67

	local tbb_binary_ver=$(grep -E -e "#define __TBB_BINARY_VERSION [0-9]+" "${S}/include/oneapi/tbb/version.h" | cut -f 3 -d " ")
	local tbb_interface_ver=$(grep -E -e "#define TBB_INTERFACE_VERSION [0-9]+" "${S}/include/oneapi/tbb/version.h" | cut -f 3 -d " ")
	local t
	t=$((${tbb_interface_ver} % 1000))
	t=$((${t} / 10))
	tbb_interface_ver=${t}
	local tbbmalloc_binary_ver=$(grep -E -e "TBBMALLOC_BINARY_VERSION [0-9]+" "${S}/CMakeLists.txt" | cut -f 2 -d " " | grep -E -o -e "[0-9]+")
	local tbbbind_binary_ver=$(grep -E -e "TBBBIND_BINARY_VERSION [0-9]+" "${S}/CMakeLists.txt" | cut -f 2 -d " " | grep -E -o -e "[0-9]+")
	actual_sover="${tbb_binary_ver}.${tbb_interface_ver}"
	expected_sover="${SOVER_TBB}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER_TBB in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi

	actual_sover="${tbbmalloc_binary_ver}.${tbb_interface_ver}"
	expected_sover="${SOVER_TBBMALLOC}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER_TBBMALLOC in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi

	actual_sover="${tbbbind_binary_ver}.${tbb_interface_ver}"
	expected_sover="${SOVER_TBBBIND}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER_TBBBIND in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
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

src_test() {
	local CMAKE_SKIP_TESTS=()
	if use elibc_musl; then
		CMAKE_SKIP_TESTS=( conformance_resumable_tasks ) # Bug #864175
	fi
	cmake-multilib_src_test
}
