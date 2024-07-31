# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/ROCm/ROCm/blob/rocm-5.7.1/docs/release/gpu_os_support.md
AMDGPU_TARGETS_COMPAT=(
	gfx906
	gfx908
	gfx90a
	gfx1030
)

ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit rocm

KEYWORDS="~amd64"

DESCRIPTION="ROCm metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	ai
	+compilers
	communication
	cv
	+cxx-primitives
	fortran
	+hip
	+kernel-driver
	+math-libs
	+ml
	non-free
	+opencl
	+runtimes
	+support-libs
	tools-dev
	tools-perf
	tools-system
"
REQUIRED_USE="
	ai? (
		cv
		ml
	)
	fortran? (
		compilers
		|| (
			hip
			non-free
		)
	)
	hip? (
		compilers
		runtimes
		support-libs
	)
	opencl? (
		compilers
		runtimes
		support-libs
	)
	support-libs? (
		kernel-driver
	)
	tools-dev? (
		kernel-driver
	)
	tools-system? (
		kernel-driver
	)
	|| (
		fortran
		hip
		opencl
	)
"
RDEPEND="
	!dev-util/amd-rocm-meta
	compilers? (
		hip? (
			~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
			~sys-libs/llvm-roc-${PV}:${ROCM_SLOT}
		)
		fortran? (
			hip? (
				~dev-lang/rocm-flang-${PV}:${ROCM_SLOT}[-aocc]
			)
			non-free? (
				~dev-lang/rocm-flang-${PV}:${ROCM_SLOT}[aocc]
			)
		)
		non-free? (
			~sys-devel/llvm-roc-alt-${PV}:${ROCM_SLOT}
		)
		opencl? (
			~sys-libs/llvm-roc-${PV}:${ROCM_SLOT}
			~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}$(get_rocm_usedep LLVM_ROC_LIBOMP)
		)
	)
	communication? (
		~dev-libs/rccl-${PV}:${ROCM_SLOT}$(get_rocm_usedep RCCL)
	)
	cv? (
		~sci-libs/MIVisionX-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rpp-${PV}:${ROCM_SLOT}$(get_rocm_usedep RPP)
	)
	cxx-primitives? (
		~sci-libs/hipCUB-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPCUB)
		~sci-libs/hipTensor-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCPRIM)
		~sci-libs/rocThrust-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCTHRUST)
	)
	kernel-driver? (
		~virtual/amdgpu-${PV}:${PV%.*}
	)
	math-libs? (
		~sci-libs/hipBLAS-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipFFT-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPFFT)
		~sci-libs/hipRAND-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipSOLVER-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipSPARSE-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocALUTION-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCALUTION)
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCBLAS)
		~sci-libs/rocFFT-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCFFT)
		~sci-libs/rocRAND-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCRAND)
		~sci-libs/rocSOLVER-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCSOLVER)
		~sci-libs/rocSPARSE-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCSPARSE)
		~sci-libs/rocWMMA-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCWMMA)
		amdgpu_targets_gfx90a? (
			~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPBLASLT)
		)
		fortran? (
			~dev-util/hipfort-${PV}:${ROCM_SLOT}
		)
	)
	ml? (
		~sci-libs/composable_kernel-${PV}:${ROCM_SLOT}$(get_rocm_usedep COMPOSABLE_KERNEL)
		~sci-libs/MIGraphX-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIGRAPHX)
		~sci-libs/miopen-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIOPEN)
	)
	runtimes? (
		~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
		~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
		hip? (
			>=dev-lang/perl-5.0
			sys-apps/file
			sys-libs/glibc
			dev-perl/URI-Encode
			dev-perl/File-BaseDir
			dev-perl/File-Copy-Recursive
			dev-perl/File-Listing
			dev-perl/File-Which
			~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
		)
		opencl? (
			~dev-libs/rocm-opencl-runtime-${PV}:${ROCM_SLOT}
		)
	)
	support-libs? (
		~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
		~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}
	)
	tools-dev? (
		~dev-libs/ROCdbgapi-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-debug-agent-${PV}:${ROCM_SLOT}
		~dev-util/HIPIFY-${PV}:${ROCM_SLOT}
		~dev-util/ROCgdb-${PV}:${ROCM_SLOT}
	)
	tools-perf? (
		~dev-util/rocm_bandwidth_test-${PV}:${ROCM_SLOT}
		non-free? (
			~dev-util/rocprofiler-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCPROFILER)
			~dev-util/roctracer-${PV}:${ROCM_SLOT}
		)
	)
	tools-system? (
		dev-util/clinfo
		~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
		~dev-util/rocminfo-${PV}:${ROCM_SLOT}
		~sys-cluster/rdc-${PV}:${ROCM_SLOT}
	)
"
