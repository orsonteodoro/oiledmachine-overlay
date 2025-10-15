# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
	gfx10-1-generic
	gfx10-3-generic
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
LLVM_SLOT=19
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
	BSD
	BSD-2
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${ROCM_SLOT}"
IUSE="
-asan +sparse -test -benchmark
ebuild_revision_7
"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
# libfmt relaxed, upstream uses 7.1.3.  RDEPEND was previously =dev-libs/libfmt-8*.
RDEPEND="
	>=dev-libs/libfmt-7.1.3
	>=dev-util/hip-${PV}:${SLOT}[rocm]
	dev-util/hip:=
	>=sci-libs/rocBLAS-${PV}:${SLOT}[${ROCBLAS_7_0_AMDGPU_USEDEP},rocm]
	sci-libs/rocBLAS:=
	benchmark? (
		virtual/blas
	)
	sparse? (
		>=sci-libs/rocSPARSE-${PV}:${SLOT}[${ROCSPARSE_7_0_AMDGPU_USEDEP},rocm]
		sci-libs/rocSPARSE:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
	test? (
		>=dev-build/cmake-3.13
		dev-cpp/gtest
		virtual/blas
	)
"
PATCHES=(
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

check_asan() {
	local ASAN_GPUS=(
		"gfx908_xnack_plus"
		"gfx90a_xnack_plus"
		"gfx942_xnack_plus"
		"gfx950_xnack_plus"
	)
	local found=0
	local x
	for x in ${ASAN_GPUS[@]} ; do
		if use "amdgpu_targets_${x}" ; then
			found=1
		fi
	done
	if (( ${found} == 0 )) && use asan ; then
ewarn "ASan security mitigations for GPU are disabled."
ewarn "ASan is enabled for CPU HOST side but not GPU side for both older and newer GPUs."
ewarn "Pick one of the following for GPU side ASan:  ${ASAN_GPUS[@]/#/amdgpu_targets_}"
	fi
}

src_configure() {
	# Avoiding a sandbox violation
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	check_asan

	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_ADDRESS_SANITIZER=$(usex asan ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=NO
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_WITH_SPARSE=$(usex sparse ON OFF)
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

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
