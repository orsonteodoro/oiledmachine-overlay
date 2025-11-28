# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="AMDMIGraphX"
MY_P="${CATEGORY}/${MY_PN}-${PV}"

CXX_STANDARD=17
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

AMDGPU_TARGETS_COMPAT=(
# See https://github.com/ROCm/AMDMIGraphX/blob/rocm-7.0.2/Jenkinsfile
	"gfx906"
	"gfx908"
	"gfx90a"
	"gfx1030"
	"gfx1100"
	"gfx1101"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_ROCM_7_0[@]}"
)

inherit abseil-cpp cmake flag-o-matic libstdcxx-slot protobuf python-r1 rocm

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
SLOT="0/${ROCM_SLOT}"
IUSE="
+composable-kernel -cpu -fpga -hip-rtc -mlir +rocm test
ebuild_revision_11
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
# The required Protobuf version is relaxed.
RDEPEND="
	>=dev-db/sqlite-3.17
	>=dev-libs/half-1.12.0
	|| (
		dev-libs/protobuf:3/3.12[${LIBSTDCXX_USEDEP}]
		dev-libs/protobuf:3/3.21[${LIBSTDCXX_USEDEP}]
	)
	dev-libs/protobuf:=
	>=dev-python/pybind11-2.6.0[${PYTHON_USEDEP}]
	dev-libs/msgpack
	composable-kernel? (
		>=sci-libs/composable-kernel-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},${COMPOSABLE_KERNEL_7_0_AMDGPU_USEDEP}]
		sci-libs/composable-kernel:=
	)
	cpu? (
		sci-ml/oneDNN
		>=dev-libs/rocm-opencl-runtime-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
		dev-libs/rocm-opencl-runtime:=
		>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},${LLVM_ROC_LIBOMP_7_0_AMDGPU_USEDEP}]
		sys-libs/llvm-roc-libomp:=
	)
	mlir? (
		>=sci-libs/rocMLIR-${ROCM_SLOT}:${SLOT}[${LIBSTDCXX_USEDEP}]
		sci-libs/rocMLIR:=
	)
	rocm? (
		>=sci-libs/miopen-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},${MIOPEN_7_0_AMDGPU_USEDEP}]
		sci-libs/miopen:=
		>=sci-libs/rocBLAS-${PV}:${SLOT}[${LIBSTDCXX_USEDEP},${ROCBLAS_7_0_AMDGPU_USEDEP}]
		sci-libs/rocBLAS:=
	)
	test? (
		>=dev-util/hip-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
		dev-util/hip:=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/blaze-3.4
	dev-cpp/blaze:=
	>=dev-cpp/msgpack-cxx-3.3.0
	dev-cpp/msgpack-cxx:=
	>=dev-cpp/nlohmann_json-3.8.0
	dev-cpp/nlohmann_json:=
"
# It uses hip-clang (--cuda-host-only -x hip) for GPU.
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.15
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
"
PATCHES=(
)

pkg_setup() {
	python_setup
	rocm_pkg_setup
	libstdcxx-slot_verify
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
	if has_version "dev-libs/protobuf:3/3.12" ; then
		ABSEIL_CPP_SLOT="20200225"
		PROTOBUF_SLOT="3"
	elif has_version "dev-libs/protobuf:3/3.21" ; then
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_SLOT="3"
	fi
	abseil-cpp_src_compile
	protobuf_src_compile

	local mycmakeargs=(
		$(abseil-cpp_append_cmake)
		$(protobuf_append_cmake)
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
