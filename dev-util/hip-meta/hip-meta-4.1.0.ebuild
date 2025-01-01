# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

#KEYWORDS="~amd64"

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
		~sci-libs/hipSPARSE-${PV}:${ROCM_SLOT}[cuda?,rocm?]
		cuda? (
			~sci-libs/hipFFT-${PV}:${ROCM_SLOT}[cuda]
		)
		fortran? (
			~dev-util/hipfort-${PV}:${ROCM_SLOT}
		)
		rocm? (
			~sci-libs/hipFFT-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPFFT)
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
			~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}
		)
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
