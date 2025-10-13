# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/ROCm/rocm-install-on-linux/blob/docs/6.4.4/docs/reference/system-requirements.rst
AMDGPU_TARGETS_COMPAT=(
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1100
	gfx1030
)

ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit rocm

#KEYWORDS="~amd64"

DESCRIPTION="HIP metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="0/${ROCM_SLOT}"
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
	ebuild_revision_1
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
			>=dev-libs/rocm-comgr-${PV}:${SLOT}
			>=sys-devel/llvm-roc-${PV}:${SLOT}
		)
	)
	math? (
		>=sci-libs/hipBLAS-${PV}:${SLOT}[cuda?,rocm?]
		>=sci-libs/hipRAND-${PV}:${SLOT}[cuda?,rocm?]
		>=sci-libs/hipSOLVER-${PV}:${SLOT}[cuda?,rocm?]
		>=sci-libs/hipSPARSE-${PV}:${SLOT}[cuda?,rocm?]
		cuda? (
			>=sci-libs/hipFFT-${PV}:${SLOT}[cuda]
		)
		fortran? (
			>=dev-util/hipfort-${PV}:${SLOT}
		)
		rocm? (
			>=sci-libs/hipFFT-${PV}:${SLOT}$(get_rocm_usedep HIPFFT)
			amdgpu_targets_gfx90a? (
				>=sci-libs/hipBLASLt-${PV}:${SLOT}$(get_rocm_usedep HIPBLASLT)
			)
			amdgpu_targets_gfx942? (
				>=sci-libs/hipBLASLt-${PV}:${SLOT}$(get_rocm_usedep HIPBLASLT)
			)
			amdgpu_targets_gfx942? (
				>=sci-libs/hipSPARSELt-${PV}:${SLOT}[rocm]
			)
		)
	)
	primitives? (
		>=sci-libs/hipTensor-${PV}:${SLOT}[cuda?,rocm?]
		cuda? (
			>=sci-libs/hipCUB-${PV}:${SLOT}[cuda]
		)
		rocm? (
			>=sci-libs/hipCUB-${PV}:${SLOT}$(get_rocm_usedep HIPCUB)
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
			>=dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
		)
		rocm? (
			>=dev-libs/rocm-device-libs-${PV}:${SLOT}
			>=dev-libs/rocr-runtime-${PV}:${SLOT}
		)
	)
	support-libs? (
		cuda? (
			>=dev-build/rocm-cmake-${PV}:${SLOT}
			>=dev-libs/hipother-${PV}:${SLOT}
		)
		rocm? (
			>=dev-build/rocm-cmake-${PV}:${SLOT}
			>=dev-libs/rocm-core-${PV}:${SLOT}
			>=dev-libs/roct-thunk-interface-${PV}:${SLOT}
		)
	)
"
