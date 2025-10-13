# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/ROCm/rocm-install-on-linux/blob/docs/6.2.4/docs/reference/system-requirements.rst
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

DESCRIPTION="ROCm metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="0/${ROCM_SLOT}"
IUSE="
	ai
	+compilers
	communication
	cv
	fortran
	+hip
	+kernel-driver
	+math
	+ml
	non-free
	+opencl
	+primitives
	+runtimes
	+support-libs
	tools-deploy
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
	math? (
		support-libs
	)
	ml? (
		support-libs
	)
	opencl? (
		compilers
		runtimes
		support-libs
	)
	primitives? (
		support-libs
	)
	support-libs? (
		kernel-driver
	)
	tools-deploy? (
		kernel-driver
	)
	tools-dev? (
		kernel-driver
		support-libs
	)
	tools-system? (
		kernel-driver
	)
	|| (
		fortran
		hip
		opencl
		tools-deploy
	)
"
RDEPEND="
	!dev-util/amd-rocm-meta
	compilers? (
		fortran? (
			hip? (
				~dev-lang/rocm-flang-${PV}:${ROCM_SLOT}[-aocc]
			)
			non-free? (
				~dev-lang/rocm-flang-${PV}:${ROCM_SLOT}[aocc]
			)
		)
		hip? (
			~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
			~sys-libs/llvm-roc-${PV}:${ROCM_SLOT}
		)
		opencl? (
			~llvm-core/clang-ocl-${PV}:${ROCM_SLOT}
			~sys-libs/llvm-roc-${PV}:${ROCM_SLOT}
			~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}$(get_rocm_usedep LLVM_ROC_LIBOMP)
		)
	)
	communication? (
		~dev-libs/rccl-${PV}:${ROCM_SLOT}$(get_rocm_usedep RCCL)
		~dev-libs/rccl-rdma-sharp-plugins-${PV}:${ROCM_SLOT}
	)
	cv? (
		~dev-python/rocPyDecode-${PV}:${ROCM_SLOT}
		~sci-libs/MIVisionX-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocAL-${PV}:${ROCM_SLOT}
		~sci-libs/rocDecode-${PV}:${ROCM_SLOT}
		~sci-libs/rpp-${PV}:${ROCM_SLOT}$(get_rocm_usedep RPP)
	)
	kernel-driver? (
		|| (
			virtual/kfd-ub:6.2
			virtual/kfd:6.1
			virtual/kfd-lb:6.0
		)
	)
	math? (
		~dev-util/Tensile-${PV}:${ROCM_SLOT}$(get_rocm_usedep TENSILE)
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
		amdgpu_targets_gfx942? (
			~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPBLASLT)
			~sci-libs/hipSPARSELt-${PV}:${ROCM_SLOT}[rocm]
		)
		amdgpu_targets_gfx1100? (
			~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPBLASLT)
		)
		fortran? (
			~dev-util/hipfort-${PV}:${ROCM_SLOT}
		)
	)
	ml? (
		~sci-libs/composable-kernel-${PV}:${ROCM_SLOT}$(get_rocm_usedep COMPOSABLE_KERNEL)
		~sci-libs/MIGraphX-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIGRAPHX)
		~sci-libs/miopen-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIOPEN)
	)
	primitives? (
		~sci-libs/hipCUB-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPCUB)
		~sci-libs/hipTensor-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCPRIM)
		~sci-libs/rocThrust-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCTHRUST)
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
	tools-deploy? (
		~dev-util/amd-smi-${PV}:${ROCM_SLOT}
		~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
		~dev-util/rocm-validation-suite-${PV}:${ROCM_SLOT}
		~sys-cluster/rdc-${PV}:${ROCM_SLOT}
	)
	tools-dev? (
		~dev-libs/ROCdbgapi-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-debug-agent-${PV}:${ROCM_SLOT}
		~dev-util/HIPIFY-${PV}:${ROCM_SLOT}
		~dev-util/ROCgdb-${PV}:${ROCM_SLOT}
	)
	tools-perf? (
		~dev-util/omniperf-${PV}:${ROCM_SLOT}
		~dev-util/omnitrace-${PV}:${ROCM_SLOT}
		~dev-util/rocprofiler-sdk-${PV}:${ROCM_SLOT}
		~dev-util/rocm_bandwidth_test-${PV}:${ROCM_SLOT}
		non-free? (
			~dev-libs/rocprofiler-register-${PV}:${ROCM_SLOT}
			~dev-util/rocprofiler-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCPROFILER)
			~dev-util/roctracer-${PV}:${ROCM_SLOT}
		)
	)
	tools-system? (
		~dev-util/rocminfo-${PV}:${ROCM_SLOT}
		opencl? (
			dev-util/clinfo
		)
	)
"
