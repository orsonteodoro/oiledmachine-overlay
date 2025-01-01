# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/ROCm/ROCm/blob/rocm-5.5.1/docs/release/gpu_os_support.md
AMDGPU_TARGETS_COMPAT=(
	gfx906
	gfx908
	gfx90a
	gfx1030
)

ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit rocm

KEYWORDS="~amd64"

DESCRIPTION="HIP metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	compilers
	cuda
	fortran
	hip
	math
	primitives
	rocm
	runtimes
	support-libs
"
REQUIRED_USE="
	hip? (
		compilers
		runtimes
		support-libs
	)
	math? (
		support-libs
	)
	primitives? (
		support-libs
	)
	^^ (
		cuda
		rocm
	)
	|| (
		hip
	)
"
RDEPEND="
	compilers? (
		cuda? (
			dev-util/nvidia-cuda-toolkit:=
		)
		rocm? (
			~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
			~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
		)
	)
	math? (
		~sci-libs/hipBLAS-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		~sci-libs/hipRAND-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		~sci-libs/hipSOLVER-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		~sci-libs/hipSPARSE-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		cuda? (
			~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}[cuda]
			~sci-libs/hipFFT-${PV}:${ROCM_SLOT}[cuda]
		)
		fortran? (
			~dev-util/hipfort-${PV}:${ROCM_SLOT}
		)
		rocm? (
			~sci-libs/hipFFT-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPFFT)
			amdgpu_targets_gfx90a? (
				~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPBLASLT)
			)
		)
	)
	primitives? (
		cuda? (
			~sci-libs/hipCUB-${PV}:${ROCM_SLOT}[cuda]
		)
		rocm? (
			~sci-libs/hipCUB-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPCUB)
		)
	)
	runtimes? (
		hip? (
			>=dev-lang/perl-5.0
			sys-apps/file
			sys-libs/glibc
			dev-perl/URI-Encode
			dev-perl/File-BaseDir
			dev-perl/File-Copy-Recursive
			dev-perl/File-Listing
			dev-perl/File-Which
			~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		)
		rocm? (
			~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
			~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
		)
	)
	support-libs? (
		cuda? (
			~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
		)
		rocm? (
			~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
			~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
			~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}
		)
	)
"
