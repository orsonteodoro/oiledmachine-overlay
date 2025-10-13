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
				>=dev-lang/rocm-flang-${PV}:${SLOT}[-aocc]
				dev-lang/rocm-flang:=
			)
			non-free? (
				>=dev-lang/rocm-flang-${PV}:${SLOT}[aocc]
				dev-lang/rocm-flang:=
			)
		)
		hip? (
			>=dev-libs/rocm-comgr-${PV}:${SLOT}
			dev-libs/rocm-comgr:=
			>=sys-libs/llvm-roc-${PV}:${SLOT}
			sys-libs/llvm-roc:=
		)
		opencl? (
			>=llvm-core/clang-ocl-${PV}:${SLOT}
			llvm-core/clang-ocl:=
			>=sys-libs/llvm-roc-${PV}:${SLOT}
			sys-libs/llvm-roc:=
			>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[$(get_rocm_usedep LLVM_ROC_LIBOMP)]
			sys-libs/llvm-roc-libomp:=
		)
	)
	communication? (
		>=dev-libs/rccl-${PV}:${SLOT}[$(get_rocm_usedep RCCL)]
		dev-libs/rccl:=
		>=dev-libs/rccl-rdma-sharp-plugins-${PV}:${SLOT}
		dev-libs/rccl-rdma-sharp-plugins:=
	)
	cv? (
		>=dev-python/rocPyDecode-${PV}:${SLOT}
		dev-python/rocPyDecode:=
		>=sci-libs/MIVisionX-${PV}:${SLOT}[rocm]
		sci-libs/MIVisionX:=
		>=sci-libs/rocAL-${PV}:${SLOT}
		sci-libs/rocAL:=
		>=sci-libs/rocDecode-${PV}:${SLOT}
		sci-libs/rocDecode:=
		>=sci-libs/rpp-${PV}:${SLOT}[$(get_rocm_usedep RPP)]
		sci-libs/rpp:=
	)
	kernel-driver? (
		|| (
			>=virtual/kfd-7.0:0/7.0
			>=virtual/kfd-6.4:0/6.4
			>=virtual/kfd-6.3:0/6.3
		)
		virtual/kfd:=
	)
	math? (
		>=dev-util/Tensile-${PV}:${SLOT}[$(get_rocm_usedep TENSILE)]
		dev-util/Tensile:=
		>=sci-libs/hipBLAS-${PV}:${SLOT}[rocm]
		sci-libs/hipBLAS:=
		>=sci-libs/hipFFT-${PV}:${SLOT}[$(get_rocm_usedep HIPFFT)]
		sci-libs/hipFFT:=
		>=sci-libs/hipRAND-${PV}:${SLOT}[rocm]
		sci-libs/hipRAND:=
		>=sci-libs/hipSOLVER-${PV}:${SLOT}[rocm]
		sci-libs/hipSOLVER:=
		>=sci-libs/hipSPARSE-${PV}:${SLOT}[rocm]
		sci-libs/hipSPARSE:=
		>=sci-libs/rocALUTION-${PV}:${SLOT}[$(get_rocm_usedep ROCALUTION)]
		sci-libs/rocALUTION:=
		>=sci-libs/rocBLAS-${PV}:${SLOT}[$(get_rocm_usedep ROCBLAS)]
		sci-libs/rocBLAS:=
		>=sci-libs/rocFFT-${PV}:${SLOT}[$(get_rocm_usedep ROCFFT)]
		sci-libs/rocFFT:=
		>=sci-libs/rocRAND-${PV}:${SLOT}[$(get_rocm_usedep ROCRAND)]
		sci-libs/rocRAND:=
		>=sci-libs/rocSOLVER-${PV}:${SLOT}[$(get_rocm_usedep ROCSOLVER)]
		sci-libs/rocSOLVER:=
		>=sci-libs/rocSPARSE-${PV}:${SLOT}[$(get_rocm_usedep ROCSPARSE)]
		sci-libs/rocSPARSE:=
		>=sci-libs/rocWMMA-${PV}:${SLOT}[$(get_rocm_usedep ROCWMMA)]
		sci-libs/rocWMMA:=
		amdgpu_targets_gfx90a? (
			>=sci-libs/hipBLASLt-${PV}:${SLOT}[$(get_rocm_usedep HIPBLASLT)]
			sci-libs/hipBLASLt:=
		)
		amdgpu_targets_gfx942? (
			>=sci-libs/hipBLASLt-${PV}:${SLOT}[$(get_rocm_usedep HIPBLASLT)]
			sci-libs/hipBLASLt:=
			>=sci-libs/hipSPARSELt-${PV}:${SLOT}[rocm]
			sci-libs/hipSPARSELt:=
		)
		amdgpu_targets_gfx1100? (
			>=sci-libs/hipBLASLt-${PV}:${SLOT}[$(get_rocm_usedep HIPBLASLT)]
			sci-libs/hipBLASLt:=
		)
		fortran? (
			>=dev-util/hipfort-${PV}:${SLOT}
			dev-util/hipfort:=
		)
	)
	ml? (
		>=sci-libs/composable-kernel-${PV}:${SLOT}[$(get_rocm_usedep COMPOSABLE_KERNEL)]
		sci-libs/composable-kernel:=
		>=sci-libs/MIGraphX-${PV}:${SLOT}[$(get_rocm_usedep MIGRAPHX)]
		sci-libs/MIGraphX:=
		>=sci-libs/miopen-${PV}:${SLOT}[$(get_rocm_usedep MIOPEN)]
		sci-libs/miopen:=
	)
	primitives? (
		>=sci-libs/hipCUB-${PV}:${SLOT}[$(get_rocm_usedep HIPCUB)]
		sci-libs/hipCUB:=
		>=sci-libs/hipTensor-${PV}:${SLOT}[rocm]
		sci-libs/hipTensor:=
		>=sci-libs/rocPRIM-${PV}:${SLOT}[$(get_rocm_usedep ROCPRIM)]
		sci-libs/rocPRIM:=
		>=sci-libs/rocThrust-${PV}:${SLOT}[$(get_rocm_usedep ROCTHRUST)]
		sci-libs/rocThrust:=
	)
	runtimes? (
		>=dev-libs/rocm-device-libs-${PV}:${SLOT}
		dev-libs/rocm-device-libs:=
		>=dev-libs/rocr-runtime-${PV}:${SLOT}
		dev-libs/rocr-runtime:=
		hip? (
			>=dev-lang/perl-5.0
			sys-apps/file
			sys-libs/glibc
			dev-perl/URI-Encode
			dev-perl/File-BaseDir
			dev-perl/File-Copy-Recursive
			dev-perl/File-Listing
			dev-perl/File-Which
			>=dev-util/hip-${PV}:${SLOT}[rocm]
			dev-util/hip:=
		)
		opencl? (
			>=dev-libs/rocm-opencl-runtime-${PV}:${SLOT}
			dev-libs/rocm-opencl-runtime:=
		)
	)
	support-libs? (
		>=dev-build/rocm-cmake-${PV}:${SLOT}
		dev-build/rocm-cmake:=
		>=dev-libs/rocm-core-${PV}:${SLOT}
		dev-libs/rocm-core:=
		>=dev-libs/roct-thunk-interface-${PV}:${SLOT}
		dev-libs/roct-thunk-interface:=
	)
	tools-deploy? (
		>=dev-util/amd-smi-${PV}:${SLOT}
		dev-util/amd-smi:=
		>=dev-util/rocm-smi-${PV}:${SLOT}
		dev-util/rocm-smi:=
		>=dev-util/rocm-validation-suite-${PV}:${SLOT}
		dev-util/rocm-validation-suite:=
		>=sys-cluster/rdc-${PV}:${SLOT}
		sys-cluster/rdc:=
	)
	tools-dev? (
		>=dev-libs/ROCdbgapi-${PV}:${SLOT}
		dev-libs/ROCdbgapi:=
		>=dev-libs/rocm-debug-agent-${PV}:${SLOT}
		dev-libs/rocm-debug-agent:=
		>=dev-util/HIPIFY-${PV}:${SLOT}
		dev-util/HIPIFY:=
		>=dev-util/ROCgdb-${PV}:${SLOT}
		dev-util/ROCgdb:=
	)
	tools-perf? (
		>=dev-util/omniperf-${PV}:${SLOT}
		dev-util/omniperf:=
		>=dev-util/omnitrace-${PV}:${SLOT}
		dev-util/omnitrace:=
		>=dev-util/rocprofiler-sdk-${PV}:${SLOT}
		dev-util/rocprofiler-sdk:=
		>=dev-util/rocm_bandwidth_test-${PV}:${SLOT}
		dev-util/rocm_bandwidth_test:=
		non-free? (
			>=dev-libs/rocprofiler-register-${PV}:${SLOT}
			dev-libs/rocprofiler-register:=
			>=dev-util/rocprofiler-${PV}:${SLOT}[$(get_rocm_usedep ROCPROFILER)]
			dev-util/rocprofiler:=
			>=dev-util/roctracer-${PV}:${SLOT}
			dev-util/roctracer:=
		)
	)
	tools-system? (
		>=dev-util/rocminfo-${PV}:${SLOT}
		dev-util/rocminfo:=
		opencl? (
			dev-util/clinfo
		)
	)
"
