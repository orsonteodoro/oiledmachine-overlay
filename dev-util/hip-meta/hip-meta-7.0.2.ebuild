# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/ROCm/rocm-install-on-linux/blob/release/rocm-rel-7.0.2/docs/reference/system-requirements.rst
AMDGPU_TARGETS_COMPAT=(
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1100
	gfx1101
	gfx1200
	gfx1201
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
			dev-libs/rocm-comgr:=
			>=sys-devel/llvm-roc-${PV}:${SLOT}
			sys-devel/llvm-roc:=
		)
	)
	math? (
		>=sci-libs/hipBLAS-${PV}:${SLOT}[cuda?,rocm?]
		sci-libs/hipBLAS:=
		>=sci-libs/hipRAND-${PV}:${SLOT}[cuda?,rocm?]
		sci-libs/hipRAND:=
		>=sci-libs/hipSOLVER-${PV}:${SLOT}[cuda?,rocm?]
		sci-libs/hipSOLVER:=
		>=sci-libs/hipSPARSE-${PV}:${SLOT}[cuda?,rocm?]
		sci-libs/hipSPARSE:=
		cuda? (
			>=sci-libs/hipFFT-${PV}:${SLOT}[cuda]
			sci-libs/hipFFT:=
		)
		fortran? (
			>=dev-util/hipfort-${PV}:${SLOT}
			dev-util/hipfort:=
		)
		rocm? (
			>=sci-libs/hipFFT-${PV}:${SLOT}[$(get_rocm_usedep HIPFFT)]
			sci-libs/hipFFT:=
			amdgpu_targets_gfx90a? (
				>=sci-libs/hipBLASLt-${PV}:${SLOT}[$(get_rocm_usedep HIPBLASLT)]
				sci-libs/hipBLASLt:=
			)
			amdgpu_targets_gfx942? (
				>=sci-libs/hipBLASLt-${PV}:${SLOT}[$(get_rocm_usedep HIPBLASLT)]
				sci-libs/hipBLASLt:=
			)
			amdgpu_targets_gfx942? (
				>=sci-libs/hipSPARSELt-${PV}:${SLOT}[rocm]
				sci-libs/hipSPARSELt:=
			)
		)
	)
	primitives? (
		>=sci-libs/hipTensor-${PV}:${SLOT}[cuda?,rocm?]
		sci-libs/hipTensor:=
		cuda? (
			>=sci-libs/hipCUB-${PV}:${SLOT}[cuda]
			sci-libs/hipCUB:=
		)
		rocm? (
			>=sci-libs/hipCUB-${PV}:${SLOT}[$(get_rocm_usedep HIPCUB)]
			sci-libs/hipCUB:=
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
			dev-util/hip:=
		)
		rocm? (
			>=dev-libs/rocm-device-libs-${PV}:${SLOT}
			dev-libs/rocm-device-libs:=
			>=dev-libs/rocr-runtime-${PV}:${SLOT}
			dev-libs/rocr-runtime:=
		)
	)
	support-libs? (
		cuda? (
			>=dev-build/rocm-cmake-${PV}:${SLOT}
			dev-build/rocm-cmake:=
			>=dev-libs/hipother-${PV}:${SLOT}
			dev-libs/hipother:=
		)
		rocm? (
			>=dev-build/rocm-cmake-${PV}:${SLOT}
			dev-build/rocm-cmake:=
			>=dev-libs/rocm-core-${PV}:${SLOT}
			dev-libs/rocm-core:=
			>=dev-libs/roct-thunk-interface-${PV}:${SLOT}
			dev-libs/roct-thunk-interface:=
		)
	)
"
