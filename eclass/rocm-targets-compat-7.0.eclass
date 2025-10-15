# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm-targets-compat-7.0.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: AMDGPU targets for the *USEDEP generator
# @DESCRIPTION:
# AMDGPU targets for the *USEDEP generator for HIP/ROCm 7.0 ebuilds.

# This ebuild is part of the rocm.eclass.

# The current form is a PLACEHOLDER but needs review/changes

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_TARGETS_COMPAT_7_0_ECLASS} ]]; then
_ROCM_TARGETS_COMPAT_7_0_ECLASS=1

RCCL_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
RCCL_7_0_AMDGPU_USEDEP=$(gen_x_usedep "RCCL_7_0_AMDGPU_TARGETS_COMPAT")

TENSILE_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.0
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1034
	gfx1035
	gfx1100
	gfx1101
	gfx1102
)
TENSILE_7_0_AMDGPU_USEDEP=$(gen_x_usedep "TENSILE_7_0_AMDGPU_TARGETS_COMPAT")

ROCPROFILER_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
# From README.md
	gfx803
# From build.sh
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1031
	gfx1100
	gfx1101
	gfx1102
	gfx1150
	gfx1151
	gfx1200
	gfx1201
)
ROCPROFILER_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCPROFILER_7_0_AMDGPU_TARGETS_COMPAT")

MIGRAPHX_7_0_AMDGPU_TARGETS_COMPAT=(
# See https://github.com/ROCm/AMDMIGraphX/blob/rocm-7.0.2/Jenkinsfile
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1100
	gfx1101
)
MIGRAPHX_7_0_AMDGPU_USEDEP=$(gen_x_usedep "MIGRAPHX_7_0_AMDGPU_TARGETS_COMPAT")

COMPOSABLE_KERNEL_7_0_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/composable_kernel/blob/rocm-7.0.2/include/ck/ck.hpp#L48
# Last updated:  7.0.2
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
	gfx1152
	gfx1200
	gfx1201
)
COMPOSABLE_KERNEL_7_0_AMDGPU_USEDEP=$(gen_x_usedep "COMPOSABLE_KERNEL_7_0_AMDGPU_TARGETS_COMPAT")

HIPBLASLT_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx908_xnack_minus
	gfx908_xnack_plus # with or without asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
	gfx1100
	gfx1101
	gfx1103
	gfx1150
	gfx1151
	gfx1200
	gfx1201
)
HIPBLASLT_7_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPBLASLT_7_0_AMDGPU_TARGETS_COMPAT")

HIPCUB_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
HIPCUB_7_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPCUB_7_0_AMDGPU_TARGETS_COMPAT")

HIPFFT_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
HIPFFT_7_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPFFT_7_0_AMDGPU_TARGETS_COMPAT")

HIPRAND_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
HIPRAND_7_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPRAND_7_0_AMDGPU_TARGETS_COMPAT")

HIPRT_2_5_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  HIPRT 2.5.a21e075.3
	"gfx900"
	"gfx902"
	"gfx904"
	"gfx906"
	"gfx908"
	"gfx909"
	"gfx90a"
	"gfx90c"
	"gfx940"
	"gfx941"
	"gfx942"
	"gfx1010"
	"gfx1011"
	"gfx1012"
	"gfx1013"
	"gfx1030"
	"gfx1031"
	"gfx1032"
	"gfx1033"
	"gfx1034"
	"gfx1035"
	"gfx1036"
	"gfx1100"
	"gfx1101"
	"gfx1102"
	"gfx1103"
	"gfx1150"
	"gfx1151"
	"gfx1152"
	"gfx1200"
	"gfx1201"
)
HIPRT_2_5_7_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPRT_2_5_7_0_AMDGPU_TARGETS_COMPAT")

HIPRT_3_0_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  HIPRT 3.0.4fea77f
	"gfx900"
	"gfx902"
	"gfx904"
	"gfx906"
	"gfx908"
	"gfx909"
	"gfx90a"
	"gfx90c"
	"gfx942"
	"gfx1010"
	"gfx1011"
	"gfx1012"
	"gfx1013"
	"gfx1030"
	"gfx1031"
	"gfx1032"
	"gfx1033"
	"gfx1034"
	"gfx1035"
	"gfx1036"
	"gfx1100"
	"gfx1101"
	"gfx1102"
	"gfx1103"
	"gfx1150"
	"gfx1151"
	"gfx1152"
	"gfx1153"
	"gfx1200"
	"gfx1201"
)
HIPRT_3_0_7_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPRT_3_0_7_0_AMDGPU_TARGETS_COMPAT")

HIPSPARSELT_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
)
HIPSPARSELT_7_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPSPARSELT_7_0_AMDGPU_TARGETS_COMPAT")

HIPTENSOR_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
	gfx908
	gfx90a
	gfx90a_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
)
HIPTENSOR_7_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPTENSOR_7_0_AMDGPU_TARGETS_COMPAT")

MIOPEN_7_0_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/MIOpen/blob/rocm-7.0.2/test/CMakeLists.txt#L121
# Last checked: 7.0.2
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1031
	gfx1100
	gfx1102
	gfx1200
	gfx1201
)
MIOPEN_7_0_AMDGPU_USEDEP=$(gen_x_usedep "MIOPEN_7_0_AMDGPU_TARGETS_COMPAT")

MIOPENKERNELS_7_0_AMDGPU_TARGETS_COMPAT=(
# Last checked:  7.0.2
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
)
MIOPENKERNELS_7_0_AMDGPU_USEDEP=$(gen_x_usedep "MIOPENKERNELS_7_0_AMDGPU_TARGETS_COMPAT")

ROCAL_7_0_AMDGPU_TARGETS_COMPAT=(
# Last checked:  7.0.2
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
ROCAL_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCAL_7_0_AMDGPU_TARGETS_COMPAT")

ROCALUTION_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1120
	gfx1121
)
ROCALUTION_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCALUTION_7_0_AMDGPU_TARGETS_COMPAT")

ROCBLAS_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a
	gfx90a_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
	gfx1010
	gfx1012
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1150
	gfx1151
	gfx1200
	gfx1201
)
ROCBLAS_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCBLAS_7_0_AMDGPU_TARGETS_COMPAT")

ROCFFT_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx803
	gfx900
	gfx906
	gfx908
	gfx908_xnack_plus # with asan
	gfx90a
	gfx90a_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
ROCFFT_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCFFT_7_0_AMDGPU_TARGETS_COMPAT")

ROCPRIM_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with_asan
	gfx950
	gfx950_xnack_plus # with_asan
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
ROCPRIM_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCPRIM_7_0_AMDGPU_TARGETS_COMPAT")

ROCRAND_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
ROCRAND_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCRAND_7_0_AMDGPU_TARGETS_COMPAT")

ROCSOLVER_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx942
	gfx942_xnack_plus
	gfx950
	gfx950_xnack_plus
	gfx10-1-generic
	gfx10-3-generic
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
ROCSOLVER_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCSOLVER_7_0_AMDGPU_TARGETS_COMPAT")

ROCSPARSE_7_0_AMDGPU_TARGETS_COMPAT=(
# Last updated:  7.0.2
	gfx803
	gfx900
	gfx900_xnack_minus
	gfx906
	gfx906_xnack_minus
	gfx908
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan build
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan build
	gfx942
	gfx942_xnack_plus # with asan build
	gfx950
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1120
	gfx1121

)
ROCSPARSE_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCSPARSE_7_0_AMDGPU_TARGETS_COMPAT")

ROCTHRUST_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
ROCTHRUST_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCTHRUST_7_0_AMDGPU_TARGETS_COMPAT")

ROCWMMA_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx908
	gfx90a
	gfx90a_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
ROCWMMA_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCWMMA_7_0_AMDGPU_TARGETS_COMPAT")

RPP_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
RPP_7_0_AMDGPU_USEDEP=$(gen_x_usedep "RPP_7_0_AMDGPU_TARGETS_COMPAT")

LLVM_ROC_LIBOMP_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx700
	gfx701
	gfx801
	gfx803
	gfx900
	gfx902
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx940
	gfx941
	gfx942
	gfx950
	gfx1010
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
	gfx1152
	gfx1153
	gfx1200
	gfx1201
)
LLVM_ROC_LIBOMP_7_0_AMDGPU_USEDEP=$(gen_x_usedep "LLVM_ROC_LIBOMP_7_0_AMDGPU_TARGETS_COMPAT")

MAGMA_2_9_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  MAGMA 2.9.0
	gfx700
	gfx701
	gfx702
	gfx703
	gfx704
	gfx705
	gfx801
	gfx802
	gfx803
	gfx805
	gfx810
	gfx900
	gfx902
	gfx904
	gfx906
	gfx908
	gfx909
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1033
)
MAGMA_2_9_7_0_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_9_7_0_AMDGPU_TARGETS_COMPAT")

MIVISIONX_6_4_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
MIVISIONX_6_4_AMDGPU_USEDEP=$(gen_x_usedep "MIVISIONX_6_4_AMDGPU_TARGETS_COMPAT")

ROCDECODE_7_0_AMDGPU_TARGETS_COMPAT=(
# Last update:  7.0.2
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
	gfx1202
	gfx1201
)
ROCDECODE_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCDECODE_7_0_AMDGPU_TARGETS_COMPAT")

ROCM_AGENT_ENUMERATOR_7_0_AMDGPU_TARGETS_COMPAT=(
# See also https://github.com/ROCm/rocminfo/blob/rocm-7.0.2/rocm_agent_enumerator
# Last update:  7.0.2
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx942
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1100
	gfx1101
	gfx1102
)
ROCM_AGENT_ENUMERATOR_7_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCM_AGENT_ENUMERATOR_7_0_AMDGPU_TARGETS_COMPAT")
ROCMINFO_7_0_AMDGPU_USEDEP="${ROCM_AGENT_ENUMERATOR_7_0_AMDGPU_USEDEP}"

fi
