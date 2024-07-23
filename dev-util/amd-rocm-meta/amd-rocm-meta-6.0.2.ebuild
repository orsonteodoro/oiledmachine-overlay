# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/ROCm/rocm-install-on-linux/blob/docs/6.0.2/docs/reference/system-requirements.rst
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

KEYWORDS="~amd64"

DESCRIPTION="ROCm metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	composable-kernel
	flang
	hipfort
	hipsparselt
	migraphx
	mivisionx
	rdc
	rock-dkms
	rocm-bandwidth-test
	rocm-dev
	rocm-gdb
	rocm-libs
	rocm-utils
"
REQUIRED_USE="
	rocm-dev? (
		rocm-utils
	)
"
RDEPEND="
	composable-kernel? (
		~sci-libs/composable_kernel-${PV}:${ROCM_SLOT}$(get_rocm_usedep COMPOSABLE_KERNEL)
	)
	hipfort? (
		~dev-util/hipfort-${PV}:${ROCM_SLOT}
	)
	hipsparselt? (
		amdgpu_targets_gfx942? (
			~sci-libs/hipSPARSELt-${PV}:${ROCM_SLOT}[rocm]
		)
	)
	flang? (
		~dev-lang/rocm-flang-${PV}:${ROCM_SLOT}
	)
	migraphx? (
		~sci-libs/MIGraphX-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIGRAPHX)
	)
	mivisionx? (
		~sci-libs/MIVisionX-${PV}:${ROCM_SLOT}[rocm]
	)
	rdc? (
		~sys-cluster/rdc-${PV}:${ROCM_SLOT}
	)
	rock-dkms? (
		~sys-kernel/rock-dkms-${PV}:${ROCM_SLOT}
	)
	rocm-bandwidth-test? (
		~dev-util/rocm_bandwidth_test-${PV}:${ROCM_SLOT}
	)
	rocm-dev? (
		~dev-libs/ROCdbgapi-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-debug-agent-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-opencl-runtime-${PV}:${ROCM_SLOT}
		~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
		~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}

		~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
		~dev-util/HIPIFY-${PV}:${ROCM_SLOT}
		~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
		~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
		~dev-util/rocprofiler-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCPROFILER)
		~dev-util/roctracer-${PV}:${ROCM_SLOT}

		dev-util/clinfo

		~sys-libs/llvm-roc-${PV}:${ROCM_SLOT}
		~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}$(get_rocm_usedep LLVM_ROC_LIBOMP)
	)
	rocm-gdb? (
		~dev-util/ROCgdb-${PV}:${ROCM_SLOT}
	)
	rocm-libs? (
		~dev-libs/rccl-${PV}:${ROCM_SLOT}$(get_rocm_usedep RCCL)
		~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
		~sci-libs/hipBLAS-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipCUB-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPCUB)
		~sci-libs/hipFFT-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPFFT)
		~sci-libs/hipRAND-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipSOLVER-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipSPARSE-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hiptensor-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/miopen-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIOPEN)
		~sci-libs/rocALUTION-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCALUTION)
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCBLAS)
		~sci-libs/rocFFT-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCFFT)
		~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCPRIM)
		~sci-libs/rocRAND-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCRAND)
		~sci-libs/rocSOLVER-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCSOLVER)
		~sci-libs/rocSPARSE-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCSPARSE)
		~sci-libs/rocThrust-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCTHRUST)
		~sci-libs/rocWMMA-${PV}:${ROCM_SLOT}$(get_rocm_usedep ROCWMMA)
		amdgpu_targets_gfx90a? (
			~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPBLASLT)
		)
		amdgpu_targets_gfx942? (
			~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}$(get_rocm_usedep HIPBLASLT)
		)
	)
	rocm-utils? (
		~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
		~dev-util/rocminfo-${PV}:${ROCM_SLOT}
	)
"

#
# Legend:
#
# #                      :  comment/notes
# -                      :  skipped packaging
# -dev [package suffix]  :  headers, build files
# ;                      :  comment/notes
# x                      :  completely packaged on the distro
#

#
# rocm-dev:
#
# comgr x
# hip-dev ; Included in hip
# hip-doc -
# hip-runtime-amd x ; Alias for hip
# hip-samples -
# hipcc x ; Included in hip
# hipify-clang # Alias for HIPIFY
# hsa-amd-aqlprofile x No repo
# hsa-rocr x Alias for rocr-runtime
# hsa-rocr-dev # Alias for rocr-runtime
# hsakmt-roct-dev # Alias for roct-thunk-interface
# openmp-extras-dev ; omp headers, aompcc from aomp-extras, flang
# openmp-extras-runtime ; libarcher (and static-lib), libomp, flang
# rocm-cmake x
# rocm-core x
# rocm-dbgapi x
# rocm-debug-agent x
# rocm-device-libs x
# rocm-gdb x
# rocm-llvm x
# rocm-ocl-icd - dev-libs/opencl-icd-loader is the drop in replacement
# rocm-opencl x dev-util/clinfo + rocm-opencl-runtime
# rocm-opencl-dev x
# rocm-smi-lib x
# rocm-utils x
# rocprofiler x
# rocprofiler-dev x
# rocprofiler-plugins
# roctracer x
# roctracer-dev x
#

#
# rocm-libs:
#
# composablekernel-dev x
# hipblas x
# hipblas-dev x
# hipblaslt x
# hipblaslt-dev x
# hipcub-dev x
# hipfft x
# hipfft-dev x
# hiprand x
# hiprand-dev x
# hipsolver x
# hipsolver-dev x
# hipsparse x
# hipsparse-dev x
# hiptensor x
# hiptensor-dev x
# miopen-hip x
# miopen-hip-dev x
# rccl x
# rccl-dev x
# rocalution x
# rocalution-dev x
# rocblas x
# rocblas-dev x
# rocfft x
# rocfft-dev x
# rocm-core x
# rocprim-dev x
# rocrand x
# rocrand-dev x
# rocsolver x
# rocsolver-dev x
# rocsparse x
# rocsparse-dev x
# rocthrust-dev x
# rocwmma-dev x
#

#
# rocm-utils:
#
# rocm-clang-ocl # Metapackage for rocm-llvm x, rocm-opencl-dev x, rocm-core x
# rocm-cmake x
# rocm-core x
# rocminfo x
#
