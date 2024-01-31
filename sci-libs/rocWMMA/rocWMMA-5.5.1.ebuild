# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1100
	gfx1101
	gfx1102
)
LLVM_MAX_SLOT=16
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"
inherit cmake llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocWMMA/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="AMD's C++ library for accelerating mixed-precision matrix \
multiply-accumulate (MMA) operations leveraging AMD GPU hardware"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocWMMA"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="system-llvm"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	!system-llvm? (
		sys-libs/llvm-roc-libomp:=
		~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}
	)
	dev-util/rocm-compiler:${ROCM_SLOT}[system-llvm=]
	~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
	system-llvm? (
		sys-libs/libomp:${LLVM_MAX_SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
RESTRICT="
	test
"
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.4.3-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

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

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
