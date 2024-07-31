# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:  nccl

# See https://github.com/ROCm/ROCm/blob/roc-4.5.x/README.md
AMDGPU_TARGETS_COMPAT=(
# For names see, https://github.com/ROCm/rocminfo/blob/rocm-6.1.2/rocm_agent_enumerator
	gfx701 # Hawaii
	gfx803 # Polaris 10, Polaris 11, Fiji
	gfx900 # MI25, Vega 10
	gfx906 # MI60, Vega 20
	gfx908 # MI100, CDNA
)

# Partially supported
AMDGPU_UNOFFICIAL_TARGETS=(
	gfx701
	gfx803
)

ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit rocm

KEYWORDS="~amd64"

DESCRIPTION="ROCm metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	cuda
	hip-dev
	hip-libs
	hipfort
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
			~sci-libs/hipCUB-${PV}:${ROCM_SLOT}[cuda]
			~sci-libs/hipFFT-${PV}:${ROCM_SLOT}[cuda]
		)
		rocm? (
			~dev-libs/rccl-${PV}:${ROCM_SLOT}$(get_rocm_usedep RCCL)
			~sci-libs/hipCUB-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPCUB)
			~sci-libs/hipFFT-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPFFT)
		)
	)
	hipfort? (
		~dev-util/hipfort-${PV}:${ROCM_SLOT}
	)
"

warn_unsupported_gpu() {
	local gpu
	for gpu in ${AMDGPU_UNOFFICIAL_TARGETS[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not fully supported upstream but may still be available."
		fi
	done
}

pkg_setup() {
	warn_unsupported_gpu
}
