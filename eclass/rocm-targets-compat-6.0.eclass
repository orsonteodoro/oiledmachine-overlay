# Copyright 2024 Orson Teodoro
# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm-targets-compat-6.0.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: AMDGPU targets for the *USEDEP generator
# @DESCRIPTION:
# AMDGPU targets for the *USEDEP generator for HIP/ROCm 5.7 ebuilds.

# This ebuild is part of the rocm.eclass.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_TARGETS_COMPAT_6_0_ECLASS} ]]; then
_ROCM_TARGETS_COMPAT_6_0_ECLASS=1

RCCL_6_0_AMDGPU_TARGETS_COMPAT=(
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
RCCL_6_0_AMDGPU_USEDEP=$(gen_x_usedep "RCCL_6_0_AMDGPU_TARGETS_COMPAT")

TENSILE_6_0_AMDGPU_TARGETS_COMPAT=(
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
TENSILE_6_0_AMDGPU_USEDEP=$(gen_x_usedep "TENSILE_6_0_AMDGPU_TARGETS_COMPAT")

ROCPROFILER_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
)
ROCPROFILER_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCPROFILER_6_0_AMDGPU_TARGETS_COMPAT")

MIGRAPHX_6_0_AMDGPU_TARGETS_COMPAT=(
# See https://github.com/ROCm/AMDMIGraphX/blob/rocm-6.0.2/Jenkinsfile
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
MIGRAPHX_6_0_AMDGPU_USEDEP=$(gen_x_usedep "MIGRAPHX_6_0_AMDGPU_TARGETS_COMPAT")

COMPOSABLE_KERNEL_6_0_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/composable_kernel/blob/rocm-6.0.2/include/ck/ck.hpp#L48
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
)
COMPOSABLE_KERNEL_6_0_AMDGPU_USEDEP=$(gen_x_usedep "COMPOSABLE_KERNEL_6_0_AMDGPU_TARGETS_COMPAT")

HIPBLASLT_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
)
HIPBLASLT_6_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPBLASLT_6_0_AMDGPU_TARGETS_COMPAT")

HIPCUB_6_0_AMDGPU_TARGETS_COMPAT=(
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
HIPCUB_6_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPCUB_6_0_AMDGPU_TARGETS_COMPAT")

HIPFFT_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
HIPFFT_6_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPFFT_6_0_AMDGPU_TARGETS_COMPAT")

HIPTENSOR_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
)
HIPTENSOR_6_0_AMDGPU_USEDEP=$(gen_x_usedep "HIPTENSOR_6_0_AMDGPU_TARGETS_COMPAT")

MIOPEN_6_0_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/MIOpen/blob/rocm-6.0.2/test/CMakeLists.txt#L126
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
	gfx1101
	gfx1102
)
MIOPEN_6_0_AMDGPU_USEDEP=$(gen_x_usedep "MIOPEN_6_0_AMDGPU_TARGETS_COMPAT")

MIOPENKERNELS_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
MIOPENKERNELS_6_0_AMDGPU_USEDEP=$(gen_x_usedep "MIOPENKERNELS_6_0_AMDGPU_TARGETS_COMPAT")

ROCALUTION_6_0_AMDGPU_TARGETS_COMPAT=(
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
ROCALUTION_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCALUTION_6_0_AMDGPU_TARGETS_COMPAT")

ROCBLAS_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
	gfx1010
	gfx1012
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCBLAS_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCBLAS_6_0_AMDGPU_TARGETS_COMPAT")

ROCFFT_6_0_AMDGPU_TARGETS_COMPAT=(
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
)
ROCFFT_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCFFT_6_0_AMDGPU_TARGETS_COMPAT")

ROCPRIM_6_0_AMDGPU_TARGETS_COMPAT=(
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
ROCPRIM_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCPRIM_6_0_AMDGPU_TARGETS_COMPAT")

ROCRAND_6_0_AMDGPU_TARGETS_COMPAT=(
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
ROCRAND_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCRAND_6_0_AMDGPU_TARGETS_COMPAT")

ROCSOLVER_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
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
ROCSOLVER_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCSOLVER_6_0_AMDGPU_TARGETS_COMPAT")

ROCSPARSE_6_0_AMDGPU_TARGETS_COMPAT=(
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
ROCSPARSE_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCSPARSE_6_0_AMDGPU_TARGETS_COMPAT")

ROCTHRUST_6_0_AMDGPU_TARGETS_COMPAT=(
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
ROCTHRUST_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCTHRUST_6_0_AMDGPU_TARGETS_COMPAT")

ROCWMMA_6_0_AMDGPU_TARGETS_COMPAT=(
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
ROCWMMA_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCWMMA_6_0_AMDGPU_TARGETS_COMPAT")

RPP_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx1030
	gfx1100
)
RPP_6_0_AMDGPU_USEDEP=$(gen_x_usedep "RPP_6_0_AMDGPU_TARGETS_COMPAT")

LLVM_ROC_LIBOMP_6_0_AMDGPU_TARGETS_COMPAT=(
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
)
LLVM_ROC_LIBOMP_6_0_AMDGPU_USEDEP=$(gen_x_usedep "LLVM_ROC_LIBOMP_6_0_AMDGPU_TARGETS_COMPAT")

MAGMA_2_7_6_0_AMDGPU_TARGETS_COMPAT=(
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
MAGMA_2_7_6_0_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_7_6_0_AMDGPU_TARGETS_COMPAT")

MAGMA_2_8_6_0_AMDGPU_TARGETS_COMPAT=(
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
	gfx940
	gfx941
	gfx942
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1033
)
MAGMA_2_8_6_0_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_8_6_0_AMDGPU_TARGETS_COMPAT")

ROCSPARSELT_6_0_AMDGPU_TARGETS_COMPAT=(
	gfx940
	gfx941
	gfx942
)
ROCSPARSELT_6_0_AMDGPU_USEDEP=$(gen_x_usedep "ROCSPARSELT_6_0_AMDGPU_TARGETS_COMPAT")

fi
