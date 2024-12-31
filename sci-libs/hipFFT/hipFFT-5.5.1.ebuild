# Copyright 1999-2025 Gentoo Authors
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
	gfx1100
	gfx1101
	gfx1102
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
LLVM_SLOT=16
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
ebuild_revision_7
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
RESTRICT="test"
SLOT="${ROCM_SLOT}/${PV}"
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		~sci-libs/rocFFT-${PV}:${ROCM_SLOT}[${ROCFFT_5_5_AMDGPU_USEDEP},rocm]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.5
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.2-remove-git-dependency.patch"
	"${FILESDIR}/${PN}-4.3.0-add-complex-header.patch"
	"${FILESDIR}/${PN}-5.4.3-hardcoded-paths.patch"
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

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
