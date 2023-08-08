# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ROCm metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64"
IUSE="
	aqlprofile
	migraphx
	mivisionx
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
	migraphx? (
		~sci-libs/MIGraphX-${PV}:${SLOT}[rocm]
	)
	mivisionx? (
		~sci-libs/MIVisionX-${PV}:${SLOT}[rocm]
	)
	rock-dkms? (
		~sys-kernel/rock-dkms-${PV}:${SLOT}
	)
	rocm-bandwidth-test? (
		~dev-util/rocm_bandwidth_test-${PV}:${SLOT}
	)
	rocm-dev? (
		~dev-libs/ROCdbgapi-${PV}:${SLOT}
		~dev-libs/rocm-comgr-${PV}:${SLOT}
		~dev-libs/rocm-core-${PV}:${SLOT}
		~dev-libs/rocm-device-libs-${PV}:${SLOT}
		~dev-libs/rocm-opencl-runtime-${PV}:${SLOT}
		~dev-libs/rocr-runtime-${PV}:${SLOT}
		~dev-libs/roct-thunk-interface-${PV}:${SLOT}

		~dev-util/hip-${PV}:${SLOT}[rocm]
		~dev-util/HIPIFY-${PV}:${SLOT}
		~dev-util/rocm-cmake-${PV}:${SLOT}
		~dev-util/rocm-smi-${PV}:${SLOT}
		~dev-util/rocprofiler-${PV}:${SLOT}[aqlprofile?]
		~dev-util/roctracer-${PV}:${SLOT}

		dev-util/clinfo

		aqlprofile? (
			~dev-libs/hsa-amd-aqlprofile-${PV}:${SLOT}
		)
	)
	rocm-gdb? (
		~dev-util/ROCgdb-${PV}:${SLOT}
	)
	rocm-libs? (
		~dev-libs/rccl-${PV}:${SLOT}
		~dev-libs/rocm-core-${PV}:${SLOT}
		~sci-libs/hipBLAS-${PV}:${SLOT}[rocm]
		~sci-libs/hipBLASLt-${PV}:${SLOT}[rocm]
		~sci-libs/hipCUB-${PV}:${SLOT}[rocm]
		~sci-libs/hipFFT-${PV}:${SLOT}[rocm]
		~sci-libs/hipSOLVER-${PV}:${SLOT}[rocm]
		~sci-libs/hipSPARSE-${PV}:${SLOT}[rocm]
		~sci-libs/miopen-${PV}:${SLOT}[rocm]
		~sci-libs/rocALUTION-${PV}:${SLOT}
		~sci-libs/rocBLAS-${PV}:${SLOT}[rocm]
		~sci-libs/rocFFT-${PV}:${SLOT}[rocm]
		~sci-libs/rocPRIM-${PV}:${SLOT}[rocm]
		~sci-libs/rocRAND-${PV}:${SLOT}[rocm]
		~sci-libs/rocSOLVER-${PV}:${SLOT}
		~sci-libs/rocSPARSE-${PV}:${SLOT}
		~sci-libs/rocThrust-${PV}:${SLOT}
		~sci-libs/rocWMMA-${PV}:${SLOT}
	)
	rocm-utils? (
		~dev-util/rocm-cmake-${PV}:${SLOT}
		~dev-libs/rocm-core-${PV}:${SLOT}
		~dev-util/rocminfo-${PV}:${SLOT}
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
# rocm-llvm -
# openmp-extras-runtime ; libomp + flang
# rocm-cmake x
# rocm-dbgapi x
# rocm-debug-agent
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
# openmp-extras-dev
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
# rocm-clang-ocl # Metapackage for rocm-llvm, rocm-opencl-dev x, rocm-core x
# rocm-cmake x
# rocm-core -
#
