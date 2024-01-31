# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
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
LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic llvm rocm toolchain-funcs

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipFFT/archive/refs/tags/rocm-${PV}.tar.gz
	-> hipFFT-rocm-${PV}.tar.gz
"

DESCRIPTION="CU / ROCM agnostic hip FFT implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipFFT"
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
cuda +rocm
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
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		~sci-libs/rocFFT-${PV}:${ROCM_SLOT}[rocm]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
RESTRICT="test"
S="${WORKDIR}/hipFFT-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.2-remove-git-dependency.patch"
	"${FILESDIR}/${PN}-4.3.0-add-complex-header.patch"
	"${FILESDIR}/${PN}-5.2.3-path-changes.patch"
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
	local mycmakeargs=(
		-DBUILD_CLIENTS_RIDER=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include/hipfft"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake"
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake/hip"
		-DHIP_ROOT_DIR="${EPREFIX}${EROCM_PATH}"
		-DROCM_PATH="${EPREFIX}${EROCM_PATH}"
	)
	if use cuda ; then
		local s=11
		strip-flags
		filter-flags \
			-pipe \
			-Wl,-O1 \
			-Wl,--as-needed \
			-Wno-unknown-pragmas
		if [[ "${HIP_CXX}" == "nvcc" ]] ; then
			append-cxxflags -ccbin "${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-g++"
		fi
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
	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
