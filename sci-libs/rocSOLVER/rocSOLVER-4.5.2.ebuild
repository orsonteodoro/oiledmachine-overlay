# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
LLVM_SLOT=13
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake edo rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocSOLVER/archive/rocm-${PV}.tar.gz
	-> rocSOLVER-${PV}.tar.gz
"

DESCRIPTION="Implementation of a subset of LAPACK functionality on the ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSOLVER"
LICENSE="
	BSD-2
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test benchmark ebuild-revision-7"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	=dev-libs/libfmt-8*
	~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
	~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}[${ROCBLAS_4_5_AMDGPU_USEDEP},rocm]
	benchmark? (
		virtual/blas
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		>=dev-build/cmake-3.13
		dev-cpp/gtest
		virtual/blas
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-add-stdint-header.patch"
	"${FILESDIR}/${PN}-5.0.2-libfmt8.patch"
	"${FILESDIR}/${PN}-5.1.3-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	# Avoiding a sandbox violation
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=NO
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DCMAKE_SKIP_RPATH=ON
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}${EROCM_PATH}/include/rocsolver"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-Wno-dev
	)

	rocm_set_default_hipcc
	rocm_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	LD_LIBRARY_PATH="${BUILD_DIR}/library/src" \
	edob "./rocsolver-test"
}

src_install() {
	cmake_src_install
	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dobin "clients/staging/rocsolver-bench"
	fi
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
