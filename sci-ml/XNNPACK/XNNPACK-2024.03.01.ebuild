# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CommitId="86e00162c213f56a4e70abd3d8f2488bb0ae2eed" # committer-date:2024-03-01

# Requirements:
# https://github.com/google/XNNPACK/blob/86e00162c213f56a4e70abd3d8f2488bb0ae2eed/cmake/DownloadCpuinfo.cmake
# https://github.com/google/XNNPACK/blob/86e00162c213f56a4e70abd3d8f2488bb0ae2eed/cmake/DownloadPThreadPool.cmake
# https://github.com/google/XNNPACK/blob/86e00162c213f56a4e70abd3d8f2488bb0ae2eed/cmake/DownloadFP16.cmake
# https://github.com/google/XNNPACK/blob/86e00162c213f56a4e70abd3d8f2488bb0ae2eed/cmake/DownloadFXdiv.cmake
# https://github.com/google/XNNPACK/blob/86e00162c213f56a4e70abd3d8f2488bb0ae2eed/cmake/DownloadGoogleTest.cmake

inherit check-compiler-switch cmake flag-o-matic

S="${WORKDIR}/${PN}-${CommitId}"
SRC_URI="
https://github.com/google/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="library of floating-point neural network inference operators"
HOMEPAGE="https://github.com/google/XNNPACK/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv"
IUSE="+assembly jit +memopt +sparse static-libs test ebuild_revision_3"
RDEPEND="
	>=dev-libs/cpuinfo-2023.11.03
	>=dev-libs/pthreadpool-2023.08.28
"
DEPEND="
	${RDEPEND}
	>=sci-ml/FP16-2021.03.20
	>=dev-libs/FXdiv-2020.04.17
"
BDEPEND="
	test? (
		>=dev-cpp/gtest-1.12.1
	)
"
RESTRICT="
	!test? (
		test
	)
"
REQUIRED_USE="
	test? (
		static-libs
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2024.03.01-gentoo.patch"
)

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	sed -i \
		-e "/PRIVATE fp16)/d" \
		-e "/PRIVATE fxdiv)/d" \
		-e "/PRIVATE clog)/d" \
		-e "/TARGET_LINK_LIBRARIES/s: fp16::" \
		CMakeLists.txt \
		|| die
	local dropTest=(
		"add-nd-test"
		"subtract-nd-test"
		"f32-velu-test"
		"qc8-dwconv-minmax-fp32-test"
		"qs8-dwconv-minmax-fp32-test"
		"qs8-vadd-minmax-test"
		"qs8-vaddc-minmax-test"
		"qu8-dwconv-minmax-fp32-test"
		"qu8-vadd-minmax-test"
		"qu8-vaddc-minmax-test"
	)
	local id
	for id in ${dropTest[@]}
	do
		sed -i \
			-e "/ADD_TEST(${id}/d" \
			CMakeLists.txt \
			|| die
	done
	cmake_src_prepare
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DXNNPACK_BUILD_BENCHMARKS=OFF
		-DXNNPACK_USE_SYSTEM_LIBS=ON
		-DXNNPACK_BUILD_TESTS=$(usex test ON OFF)
		-DXNNPACK_LIBRARY_TYPE=$(usex static-libs static shared)
		-DXNNPACK_ENABLE_ASSEMBLY=$(usex assembly ON OFF)
		-DXNNPACK_ENABLE_JIT=$(usex jit ON OFF)
		-DXNNPACK_ENABLE_MEMOPT=$(usex memopt ON OFF)
		-DXNNPACK_ENABLE_SPARSE=$(usex sparse ON OFF)
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
	)
	cmake_src_configure
	cd "${BUILD_DIR}" || die
}
