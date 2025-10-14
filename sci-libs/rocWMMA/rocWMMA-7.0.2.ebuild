# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx908
	gfx90a
	gfx90a_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocWMMA/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="AMD's C++ library for accelerating mixed-precision matrix \
multiply-accumulate (MMA) operations leveraging AMD GPU hardware"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocWMMA"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not have All rights reserved.
RESTRICT="
	test
"
SLOT="0/${ROCM_SLOT}"
IUSE="ebuild_revision_4"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	>=dev-util/hip-${PV}:${SLOT}[rocm]
	dev-util/hip:=
	>=dev-util/rocm-smi-${PV}:${SLOT}
	dev-util/rocm-smi:=
	>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[${LLVM_ROC_LIBOMP_7_0_AMDGPU_USEDEP}]
	sys-libs/llvm-roc-libomp:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.5
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
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

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DOpenMP_CXX_FLAGS="-I${ESYSROOT}/${EROCM_LLVM_PATH}/include -fopenmp=libomp"
		-DOpenMP_CXX_LIB_NAMES="libomp"
		-DOpenMP_libomp_LIBRARY="$(rocm_get_libomp_path)"
		-DROCWMMA_BUILD_TESTS=OFF
	)

	rocm_set_default_hipcc
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
