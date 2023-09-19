# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SLOT="$(ver_cut 1-2 ${PV})"

DESCRIPTION="ROCm metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="${ROCM_SLOT}/${PV}"
KEYWORDS="~amd64"
IUSE="
	aqlprofile
	flang
	hipfort
	hiptensor
	migraphx
	mivisionx
	rdc
	rocm-bandwidth-test
	rock-dkms
	rocm-dev
	rocm-gdb
	rocm-libs
	rocm-utils
"
REQUIRED_USE="
	aqlprofile? (
		rocm-dev
	)
	rocm-dev? (
		rocm-utils
	)
"
RDEPEND="
	hipfort? (
		~dev-util/hipfort-${PV}:${ROCM_SLOT}
	)
	flang? (
		~dev-lang/rocm-flang-${PV}:${ROCM_SLOT}
	)
	migraphx? (
		~sci-libs/MIGraphX-${PV}:${ROCM_SLOT}[rocm]
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
		~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
		~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
		~dev-util/rocprofiler-${PV}:${ROCM_SLOT}[aqlprofile?]
		~dev-util/roctracer-${PV}:${ROCM_SLOT}

		dev-util/clinfo

		aqlprofile? (
			~dev-libs/hsa-amd-aqlprofile-${PV}:${ROCM_SLOT}
		)
	)
	rocm-gdb? (
		~dev-util/ROCgdb-${PV}:${ROCM_SLOT}
	)
	rocm-libs? (
		~dev-libs/rccl-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
		~sci-libs/hipBLAS-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipBLASLt-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipCUB-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipFFT-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipSOLVER-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/hipSPARSE-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/miopen-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocALUTION-${PV}:${ROCM_SLOT}
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocFFT-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocRAND-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocSOLVER-${PV}:${ROCM_SLOT}
		~sci-libs/rocSPARSE-${PV}:${ROCM_SLOT}
		~sci-libs/rocThrust-${PV}:${ROCM_SLOT}
		~sci-libs/rocWMMA-${PV}:${ROCM_SLOT}
	)
	rocm-utils? (
		~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
		~dev-util/rocminfo-${PV}:${ROCM_SLOT}
	)
	hiptensor? (
		~sci-libs/hiptensor-${PV}:${ROCM_SLOT}
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
# hip-doc -
# hipcc x ; Included in hip
# hipify-clang # Alias for HIPIFY
# hip-runtime-amd x ; Alias for hip
# hip-samples -
# hsa-rocr x Alias for rocr-runtime
# hsa-amd-aqlprofile x No repo
# rocm-llvm x
# openmp-extras-runtime ; libarcher (and static-lib), libomp, flang
# rocm-cmake x
# rocm-dbgapi x
# rocm-debug-agent x
# rocm-device-libs x
# rocm-gdb x
# rocm-smi-lib x
# rocm-utils x
# rocm-core x
# rocm-opencl x dev-util/clinfo + rocm-opencl-runtime
# rocm-ocl-icd - dev-libs/opencl-icd-loader is the drop in replacement
# rocprofiler x
# roctracer x
# hip-dev ; Included in hip
# hsa-rocr-dev # Alias for rocr-runtime
# hsakmt-roct-dev # Alias for roct-thunk-interface
# rocprofiler-dev x
# roctracer-dev x
# openmp-extras-dev ; omp headers, aompcc from aomp-extras, flang
# rocm-opencl-dev x
#

#
# rocm-libs:
#
# hipblas x
# hipblaslt x
# hipfft x
# hipsolver x
# hipsparse x
# miopen-hip x
# rccl x
# rocalution x
# rocblas x
# rocfft x
# rocrand x
# rocsolver x
# rocsparse x
# rocm-core x
# hipblas-dev x
# hipblaslt-dev x
# hipcub-dev x
# hipfft-dev x
# hipsolver-dev x
# hipsparse-dev x
# miopen-hip-dev x
# rccl-dev x
# rocalution-dev x
# rocblas-dev x
# rocfft-dev x
# rocprim-dev x
# rocrand-dev x
# rocsolver-dev x
# rocsparse-dev x
# rocthrust-dev x
# rocwmma-dev x
#

#
# rocm-utils:
#
# rocminfo x
# rocm-clang-ocl # Metapackage for rocm-llvm x, rocm-opencl-dev x, rocm-core x
# rocm-cmake x
# rocm-core -
#
