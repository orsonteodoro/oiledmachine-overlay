# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:  nccl

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
	cuda
	hip-dev
	hip-libs
	hipfort
	hiprand
	migraphx
	mivisionx
	rocm
"
REQUIRED_USE="
"
RDEPEND="
	hip-dev? (
		>=dev-lang/perl-5.0
		sys-apps/file
		sys-libs/glibc
		dev-perl/URI-Encode
		dev-perl/File-BaseDir
		dev-perl/File-Copy-Recursive
		dev-perl/File-Listing
		dev-perl/File-Which
		~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
		~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	)
	hip-libs? (
		~sci-libs/hipBLAS-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		~sci-libs/hipSOLVER-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		~sci-libs/hipSPARSE-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		cuda? (
			~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}[cuda]
			~sci-libs/hipCUB-${PV}:${ROCM_SLOT}[cuda]
			~sci-libs/hipFFT-${PV}:${ROCM_SLOT}[cuda]
			~sci-libs/miopen-${PV}:${ROCM_SLOT}[opencl]
		)
		rocm? (
			~sci-libs/hipCUB-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPCUB)
			~sci-libs/hipFFT-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPFFT)
			~sci-libs/miopen-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIOPEN)
			~dev-libs/rccl-${PV}:${ROCM_SLOT}$(get_rocm_usedep RCCL)
			amdgpu_targets_gfx90a? (
				~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPBLASLT)
			)
		)
	)
	hipfort? (
		~dev-util/hipfort-${PV}:${ROCM_SLOT}
	)
	hiprand? (
		~sci-libs/hipRAND-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	)
	migraphx? (
		cuda? (
			~sci-libs/MIGraphX-${PV}:${ROCM_SLOT}[cpu]
		)
		rocm? (
			~sci-libs/MIGraphX-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIGRAPHX)
		)
	)
	mivisionx? (
		cuda? (
			~sci-libs/MIVisionX-${PV}:${ROCM_SLOT}[opencl]
		)
		rocm? (
			~sci-libs/MIVisionX-${PV}:${ROCM_SLOT}[rocm]
		)
	)

"
