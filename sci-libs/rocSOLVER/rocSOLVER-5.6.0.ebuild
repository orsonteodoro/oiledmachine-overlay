# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1010
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
LLVM_MAX_SLOT=16
ROCM_VERSION="${PV}"

inherit cmake edo llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocSOLVER/archive/rocm-${PV}.tar.gz
	-> rocSOLVER-${PV}.tar.gz
"

DESCRIPTION="Implementation of a subset of LAPACK functionality on the ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSOLVER"
LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="test benchmark r1"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	=dev-libs/libfmt-8*
	~dev-util/hip-${PV}:${SLOT}[rocm]
	~sci-libs/rocBLAS-${PV}:${SLOT}[${ROCM_USEDEP},rocm]
	benchmark? (
		virtual/blas
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	~dev-util/rocm-cmake-${PV}:${SLOT}
	test? (
		>=dev-util/cmake-3.13
		dev-cpp/gtest
		virtual/blas
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
)

RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/${PN}-rocm-${PV}"

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	# Avoiding a sandbox violation
	addpredict /dev/kfd
	addpredict /dev/dri/

	export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=NO
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DCMAKE_SKIP_RPATH=ON
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/usr/include/rocsolver"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-Wno-dev
	)

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	LD_LIBRARY_PATH="${BUILD_DIR}/library/src" \
	edob ./rocsolver-test
}

src_install() {
	cmake_src_install
	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dobin clients/staging/rocsolver-bench
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
