# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
CUDA_TARGETS_COMPAT=(
# Based on 5.6.0
	sm_53
	sm_75
	sm_80
	sm_86
	compute_53
	compute_75
	compute_80
	compute_86
)
HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic rocm toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/hipFFT-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipFFT/archive/refs/tags/rocm-${PV}.tar.gz
	-> hipFFT-rocm-${PV}.tar.gz
"

DESCRIPTION="CU / ROCM agnostic hip FFT implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipFFT"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - CMakeLists.txt
# MIT - LICENSE.md
# The distro's MIT license template does not contain all rights reserved.
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
cuda +rocm
ebuild_revision_8
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
		cuda
	)
"
LICENSE="MIT"
RESTRICT="test mirror" # The distro mirrored copy is wrong
SLOT="0/${ROCM_SLOT}"
RDEPEND="
	>=dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	dev-util/hip:=
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		>=sci-libs/rocFFT-${PV}:${SLOT}[${ROCFFT_7_0_AMDGPU_USEDEP},rocm]
		sci-libs/rocFFT:=
		>=sci-libs/rocRAND-${PV}:${SLOT}[${ROCRAND_7_0_AMDGPU_USEDEP},rocm]
		sci-libs/rocRAND:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.16
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
	local mycmakeargs=(
		-DBUILD_CLIENTS_RIDER=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake/hip"
		-DHIP_ROOT_DIR="${EPREFIX}${EROCM_PATH}"
		-DROCM_PATH="${EPREFIX}${EROCM_PATH}"
	)
	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DBUILD_WITH_LIB="CUDA"
			-DCMAKE_CXX_COMPILER="${ESYSROOT}/opt/cuda/bin/nvcc"
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DBUILD_WITH_LIB="ROCM"
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
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
