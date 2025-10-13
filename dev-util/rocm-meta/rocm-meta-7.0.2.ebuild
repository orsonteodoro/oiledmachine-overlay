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
				~dev-lang/rocm-flang-${PV}:${SLOT}[-aocc]
			)
			non-free? (
				~dev-lang/rocm-flang-${PV}:${SLOT}[aocc]
			)
		)
		hip? (
			~dev-libs/rocm-comgr-${PV}:${SLOT}
			~sys-libs/llvm-roc-${PV}:${SLOT}
		)
		opencl? (
			~llvm-core/clang-ocl-${PV}:${SLOT}
			~sys-libs/llvm-roc-${PV}:${SLOT}
			~sys-libs/llvm-roc-libomp-${PV}:${SLOT}$(get_rocm_usedep LLVM_ROC_LIBOMP)
		)
	)
	communication? (
		~dev-libs/rccl-${PV}:${SLOT}$(get_rocm_usedep RCCL)
		~dev-libs/rccl-rdma-sharp-plugins-${PV}:${SLOT}
	)
	cv? (
		~dev-python/rocPyDecode-${PV}:${SLOT}
		~sci-libs/MIVisionX-${PV}:${SLOT}[rocm]
		~sci-libs/rocAL-${PV}:${SLOT}
		~sci-libs/rocDecode-${PV}:${SLOT}
		~sci-libs/rpp-${PV}:${SLOT}$(get_rocm_usedep RPP)
	)
	kernel-driver? (
		|| (
			virtual/kfd-ub:7.0
			virtual/kfd:6.4
			virtual/kfd-lb:6.3
		)
	)
	math? (
		~dev-util/Tensile-${PV}:${SLOT}$(get_rocm_usedep TENSILE)
		~sci-libs/hipBLAS-${PV}:${SLOT}[rocm]
		~sci-libs/hipFFT-${PV}:${SLOT}$(get_rocm_usedep HIPFFT)
		~sci-libs/hipRAND-${PV}:${SLOT}[rocm]
		~sci-libs/hipSOLVER-${PV}:${SLOT}[rocm]
		~sci-libs/hipSPARSE-${PV}:${SLOT}[rocm]
		~sci-libs/rocALUTION-${PV}:${SLOT}$(get_rocm_usedep ROCALUTION)
		~sci-libs/rocBLAS-${PV}:${SLOT}$(get_rocm_usedep ROCBLAS)
		~sci-libs/rocFFT-${PV}:${SLOT}$(get_rocm_usedep ROCFFT)
		~sci-libs/rocRAND-${PV}:${SLOT}$(get_rocm_usedep ROCRAND)
		~sci-libs/rocSOLVER-${PV}:${SLOT}$(get_rocm_usedep ROCSOLVER)
		~sci-libs/rocSPARSE-${PV}:${SLOT}$(get_rocm_usedep ROCSPARSE)
		~sci-libs/rocWMMA-${PV}:${SLOT}$(get_rocm_usedep ROCWMMA)
		amdgpu_targets_gfx90a? (
			~sci-libs/hipBLASLt-${PV}:${SLOT}$(get_rocm_usedep HIPBLASLT)
		)
		amdgpu_targets_gfx942? (
			~sci-libs/hipBLASLt-${PV}:${SLOT}$(get_rocm_usedep HIPBLASLT)
			~sci-libs/hipSPARSELt-${PV}:${SLOT}[rocm]
		)
		amdgpu_targets_gfx1100? (
			~sci-libs/hipBLASLt-${PV}:${SLOT}$(get_rocm_usedep HIPBLASLT)
		)
		fortran? (
			~dev-util/hipfort-${PV}:${SLOT}
		)
	)
	ml? (
		~sci-libs/composable-kernel-${PV}:${SLOT}$(get_rocm_usedep COMPOSABLE_KERNEL)
		~sci-libs/MIGraphX-${PV}:${SLOT}$(get_rocm_usedep MIGRAPHX)
		~sci-libs/miopen-${PV}:${SLOT}$(get_rocm_usedep MIOPEN)
	)
	primitives? (
		~sci-libs/hipCUB-${PV}:${SLOT}$(get_rocm_usedep HIPCUB)
		~sci-libs/hipTensor-${PV}:${SLOT}[rocm]
		~sci-libs/rocPRIM-${PV}:${SLOT}$(get_rocm_usedep ROCPRIM)
		~sci-libs/rocThrust-${PV}:${SLOT}$(get_rocm_usedep ROCTHRUST)
	)
	runtimes? (
		~dev-libs/rocm-device-libs-${PV}:${SLOT}
		~dev-libs/rocr-runtime-${PV}:${SLOT}
		hip? (
			>=dev-lang/perl-5.0
			sys-apps/file
			sys-libs/glibc
			dev-perl/URI-Encode
			dev-perl/File-BaseDir
			dev-perl/File-Copy-Recursive
			dev-perl/File-Listing
			dev-perl/File-Which
			~dev-util/hip-${PV}:${SLOT}[rocm]
		)
		opencl? (
			~dev-libs/rocm-opencl-runtime-${PV}:${SLOT}
		)
	)
	support-libs? (
		~dev-build/rocm-cmake-${PV}:${SLOT}
		~dev-libs/rocm-core-${PV}:${SLOT}
		~dev-libs/roct-thunk-interface-${PV}:${SLOT}
	)
	tools-deploy? (
		~dev-util/amd-smi-${PV}:${SLOT}
		~dev-util/rocm-smi-${PV}:${SLOT}
		~dev-util/rocm-validation-suite-${PV}:${SLOT}
		~sys-cluster/rdc-${PV}:${SLOT}
	)
	tools-dev? (
		~dev-libs/ROCdbgapi-${PV}:${SLOT}
		~dev-libs/rocm-debug-agent-${PV}:${SLOT}
		~dev-util/HIPIFY-${PV}:${SLOT}
		~dev-util/ROCgdb-${PV}:${SLOT}
	)
	tools-perf? (
		~dev-util/omniperf-${PV}:${SLOT}
		~dev-util/omnitrace-${PV}:${SLOT}
		~dev-util/rocprofiler-sdk-${PV}:${SLOT}
		~dev-util/rocm_bandwidth_test-${PV}:${SLOT}
		non-free? (
			~dev-libs/rocprofiler-register-${PV}:${SLOT}
			~dev-util/rocprofiler-${PV}:${SLOT}$(get_rocm_usedep ROCPROFILER)
			~dev-util/roctracer-${PV}:${SLOT}
		)
	)
	tools-system? (
		~dev-util/rocminfo-${PV}:${SLOT}
		opencl? (
			dev-util/clinfo
		)
	)
"
