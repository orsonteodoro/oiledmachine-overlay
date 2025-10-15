# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
)

HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/hipSPARSELt/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${PN}-rocm-${PV}.tar.gz
"

DESCRIPTION="hipSPARSELt is a SPARSE marshalling library, with multiple supported backends."
HOMEPAGE="https://github.com/ROCm/hipSPARSELt"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - cmake/os-detection.cmake
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="test"
SLOT="0/${ROCM_SLOT}"
IUSE="
-asan -cuda rocm -samples -test
ebuild_revision_1
"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	dev-util/hip:${SLOT}[cuda?,rocm?]
	dev-util/hip:=
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		>=dev-util/Tensile-${PV}:${SLOT}
		dev-util/Tensile:=
		>=sci-libs/hipSPARSE-${PV}:${SLOT}
		sci-libs/hipSPARSE:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.10.2
	test? (
		dev-cpp/gtest
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
	check_asan
	local mycmakeargs=(
		-DBUILD_ADDRESS_SANITIZER=$(usex asan)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark)
		-DBUILD_CLIENTS_SAMPLES=$(usex samples)
		-DBUILD_CLIENTS_TESTS=$(usex test)
		-DBUILD_CUDA=$(usex cuda)
		-DBUILD_GTEST=OFF
	)
	if use cuda ; then
		mycmakeargs+=(
			-DBUILD_WITH_TENSILE=OFF
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
			-DBUILD_WITH_TENSILE=ON
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCM_SYMLINK_LIBS=OFF
		)
	fi
	rocm_set_default_hipcc
	rocm_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
