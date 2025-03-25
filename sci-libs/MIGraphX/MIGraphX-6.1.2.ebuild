# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="AMDMIGraphX"
MY_P="${CATEGORY}/${MY_PN}-${PV}"

AMDGPU_TARGETS_COMPAT=(
# See https://github.com/ROCm/AMDMIGraphX/blob/rocm-6.1.2/Jenkinsfile
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
LLVM_SLOT=17
PYTHON_COMPAT=( "python3_"{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/AMDMIGraphX/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/AMDMIGraphX/archive/rocm-${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
	"
fi

DESCRIPTION="AMD's graph optimization engine"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/AMDMIGraphX"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain All rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
+composable-kernel -cpu -fpga -hip-rtc -mlir +rocm test
ebuild_revision_6
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		rocm
		cpu
		fpga
	)
	mlir? (
		rocm
	)
"
# protobuf is relaxed
RDEPEND="
	>=dev-db/sqlite-3.17
	>=dev-cpp/msgpack-cxx-3.3.0
	>=dev-cpp/nlohmann_json-3.8.0
	>=dev-libs/half-1.12.0
	>=dev-libs/protobuf-3.11:0/3.21
	dev-libs/protobuf:=
	>=dev-python/pybind11-2.6.0[${PYTHON_USEDEP}]
	dev-libs/msgpack
	composable-kernel? (
		~sci-libs/composable-kernel-${PV}:${ROCM_SLOT}[${COMPOSABLE_KERNEL_6_1_AMDGPU_USEDEP}]
	)
	cpu? (
		sci-ml/oneDNN
		~dev-libs/rocm-opencl-runtime-${PV}:${ROCM_SLOT}
		~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_6_1_AMDGPU_USEDEP}]
	)
	rocm? (
		~sci-libs/miopen-${PV}:${ROCM_SLOT}[${MIOPEN_6_1_AMDGPU_USEDEP}]
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}[${ROCBLAS_6_1_AMDGPU_USEDEP}]
	)
	test? (
		~dev-util/hip-${PV}:${ROCM_SLOT}
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/blaze-3.4:=
"
# It uses hip-clang (--cuda-host-only -x hip) for GPU.
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.15
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	mlir? (
		|| (
			~sci-libs/rocMLIR-${PV}:${ROCM_SLOT}
			=sci-libs/rocMLIR-${ROCM_SLOT}*:${ROCM_SLOT}
		)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-6.1.2-hardcoded-paths.patch"
)

pkg_setup() {
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed \
		-i \
		-e "s|msgpackc-cxx|msgpack-cxx|g" \
		"src/CMakeLists.txt" \
		|| die
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DMIGRAPHX_ENABLE_CPU=$(usex cpu ON OFF)
		-DMIGRAPHX_ENABLE_FPGA=$(usex fpga ON OFF)
		-DMIGRAPHX_ENABLE_GPU=$(usex rocm ON OFF)
		-DMIGRAPHX_ENABLE_MLIR=$(usex mlir ON OFF)
		-DMIGRAPHX_USE_COMPOSABLEKERNEL=$(usex composable-kernel ON OFF)
		-DMIGRAPHX_USE_HIPRTC=$(usex hip-rtc ON OFF)
	)

	if use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DGPU_TARGETS="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

	rocm_set_default_hipcc
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
