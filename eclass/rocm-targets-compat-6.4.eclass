# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm-targets-compat-6.4.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: AMDGPU targets for the *USEDEP generator
# @DESCRIPTION:
# AMDGPU targets for the *USEDEP generator for HIP/ROCm 6.3 ebuilds.

# This ebuild is part of the rocm.eclass.

# The current form is a PLACEHOLDER but needs review/changes

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_TARGETS_COMPAT_6_4_ECLASS} ]]; then
_ROCM_TARGETS_COMPAT_6_4_ECLASS=1

RCCL_6_4_AMDGPU_TARGETS_COMPAT=(
# Last updated:  6.4.4
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
RCCL_6_4_AMDGPU_USEDEP=$(gen_x_usedep "RCCL_6_4_AMDGPU_TARGETS_COMPAT")

TENSILE_6_4_AMDGPU_TARGETS_COMPAT=(
# Last updated:  6.4.4
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
	gfx1150
	gfx1151
)
TENSILE_6_4_AMDGPU_USEDEP=$(gen_x_usedep "TENSILE_6_4_AMDGPU_TARGETS_COMPAT")

ROCPROFILER_6_4_AMDGPU_TARGETS_COMPAT=(
# Last updated:  6.4.4
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
ROCPROFILER_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCPROFILER_6_4_AMDGPU_TARGETS_COMPAT")

MIGRAPHX_6_4_AMDGPU_TARGETS_COMPAT=(
# See https://github.com/ROCm/AMDMIGraphX/blob/rocm-6.3.3/Jenkinsfile
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
MIGRAPHX_6_4_AMDGPU_USEDEP=$(gen_x_usedep "MIGRAPHX_6_4_AMDGPU_TARGETS_COMPAT")

COMPOSABLE_KERNEL_6_4_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/composable_kernel/blob/rocm-6.4.4/include/ck/ck.hpp#L48
# Last updated:  6.4.4
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
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
COMPOSABLE_KERNEL_6_4_AMDGPU_USEDEP=$(gen_x_usedep "COMPOSABLE_KERNEL_6_4_AMDGPU_TARGETS_COMPAT")

HIPBLASLT_6_4_AMDGPU_TARGETS_COMPAT=(
# Last update:  6.4.4
	gfx908_xnack_minus
	gfx908_xnack_plus # with or without asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx1100
	gfx1101
	gfx1103
	gfx1150
	gfx1151
	gfx1200
	gfx1201
)
HIPBLASLT_6_4_AMDGPU_USEDEP=$(gen_x_usedep "HIPBLASLT_6_4_AMDGPU_TARGETS_COMPAT")

HIPCUB_6_4_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
HIPCUB_6_4_AMDGPU_USEDEP=$(gen_x_usedep "HIPCUB_6_4_AMDGPU_TARGETS_COMPAT")

HIPFFT_6_4_AMDGPU_TARGETS_COMPAT=(
# Last updated:  6.4.4
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
HIPFFT_6_4_AMDGPU_USEDEP=$(gen_x_usedep "HIPFFT_6_4_AMDGPU_TARGETS_COMPAT")

HIPRT_2_5_6_4_AMDGPU_TARGETS_COMPAT=(
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
HIPRT_2_5_6_4_AMDGPU_USEDEP=$(gen_x_usedep "HIPRT_2_5_6_4_AMDGPU_TARGETS_COMPAT")

HIPRT_3_0_6_4_AMDGPU_TARGETS_COMPAT=(
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
HIPRT_3_0_6_4_AMDGPU_USEDEP=$(gen_x_usedep "HIPRT_3_0_6_4_AMDGPU_TARGETS_COMPAT")

HIPSPARSELT_6_4_AMDGPU_TARGETS_COMPAT=(
# Last updated:  6.4.4
	gfx940
	gfx940_xnack_plus # with asan
	gfx941
	gfx941_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
)
HIPSPARSELT_6_4_AMDGPU_USEDEP=$(gen_x_usedep "HIPSPARSELT_6_4_AMDGPU_TARGETS_COMPAT")

HIPTENSOR_6_4_AMDGPU_TARGETS_COMPAT=(
# Last updated:  6.4.4
	gfx908
	gfx90a
	gfx90a_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
)
HIPTENSOR_6_4_AMDGPU_USEDEP=$(gen_x_usedep "HIPTENSOR_6_4_AMDGPU_TARGETS_COMPAT")

MIOPEN_6_4_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/MIOpen/blob/rocm-6.4.4/test/CMakeLists.txt#L121
# Last checked: 6.4.4
	gfx803
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
	gfx1102
	gfx1200
	gfx1201
)
MIOPEN_6_4_AMDGPU_USEDEP=$(gen_x_usedep "MIOPEN_6_4_AMDGPU_TARGETS_COMPAT")

MIOPENKERNELS_6_4_AMDGPU_TARGETS_COMPAT=(
# Last checked:  6.4.4
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
)
MIOPENKERNELS_6_4_AMDGPU_USEDEP=$(gen_x_usedep "MIOPENKERNELS_6_4_AMDGPU_TARGETS_COMPAT")

ROCALUTION_6_4_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCALUTION_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCALUTION_6_4_AMDGPU_TARGETS_COMPAT")

ROCBLAS_6_4_AMDGPU_TARGETS_COMPAT=(
# Last update:  6.4.4
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a
	gfx942
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
ROCBLAS_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCBLAS_6_4_AMDGPU_TARGETS_COMPAT")

ROCFFT_6_4_AMDGPU_TARGETS_COMPAT=(
# Last update:  6.4.4
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
ROCFFT_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCFFT_6_4_AMDGPU_TARGETS_COMPAT")

ROCPRIM_6_4_AMDGPU_TARGETS_COMPAT=(
# Last update:  6.4.4
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with_asan
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
ROCPRIM_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCPRIM_6_4_AMDGPU_TARGETS_COMPAT")

ROCRAND_6_4_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCRAND_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCRAND_6_4_AMDGPU_TARGETS_COMPAT")

ROCSOLVER_6_4_AMDGPU_TARGETS_COMPAT=(
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
	gfx1010
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCSOLVER_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCSOLVER_6_4_AMDGPU_TARGETS_COMPAT")

ROCSPARSE_6_4_AMDGPU_TARGETS_COMPAT=(
# Last updated:  6.4.4
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
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1120
	gfx1121
)
ROCSPARSE_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCSPARSE_6_4_AMDGPU_TARGETS_COMPAT")

ROCTHRUST_6_4_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCTHRUST_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCTHRUST_6_4_AMDGPU_TARGETS_COMPAT")

ROCWMMA_6_4_AMDGPU_TARGETS_COMPAT=(
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
	gfx1100
	gfx1101
	gfx1102
)
ROCWMMA_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCWMMA_6_4_AMDGPU_TARGETS_COMPAT")

RPP_6_4_AMDGPU_TARGETS_COMPAT=(
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
)
RPP_6_4_AMDGPU_USEDEP=$(gen_x_usedep "RPP_6_4_AMDGPU_TARGETS_COMPAT")

LLVM_ROC_LIBOMP_6_4_AMDGPU_TARGETS_COMPAT=(
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
)
LLVM_ROC_LIBOMP_6_4_AMDGPU_USEDEP=$(gen_x_usedep "LLVM_ROC_LIBOMP_6_4_AMDGPU_TARGETS_COMPAT")

MAGMA_2_9_6_4_AMDGPU_TARGETS_COMPAT=(
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
MAGMA_2_9_6_4_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_9_6_4_AMDGPU_TARGETS_COMPAT")

ROCDECODE_6_4_AMDGPU_TARGETS_COMPAT=(
# Last update:  6.4.4
	gfx908
	gfx90a
	gfx942
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
	gfx1202
	gfx1201
)
ROCDECODE_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCDECODE_6_4_AMDGPU_TARGETS_COMPAT")

ROCSPARSELT_6_4_AMDGPU_TARGETS_COMPAT=(
	gfx940
	gfx941
	gfx942
)
ROCSPARSELT_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCSPARSELT_6_4_AMDGPU_TARGETS_COMPAT")

ROCM_AGENT_ENUMERATOR_6_4_AMDGPU_TARGETS_COMPAT=(
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
)
ROCM_AGENT_ENUMERATOR_6_4_AMDGPU_USEDEP=$(gen_x_usedep "ROCM_AGENT_ENUMERATOR_6_4_AMDGPU_TARGETS_COMPAT")
ROCMINFO_6_4_AMDGPU_USEDEP="${ROCM_AGENT_ENUMERATOR_6_4_AMDGPU_USEDEP}"

fi
