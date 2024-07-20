# Copyright 2024 Orson Teodoro
# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm-targets-compat-5.6.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: AMDGPU targets for the *USEDEP generator
# @DESCRIPTION:
# AMDGPU targets for the *USEDEP generator for HIP/ROCm 5.6 ebuilds.

# This ebuild is part of the rocm.eclass.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_TARGETS_COMPAT_5_4_ECLASS} ]]; then
_ROCM_TARGETS_COMPAT_5_4_ECLASS=1

RCCL_5_6_AMDGPU_TARGETS_COMPAT=(
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
RCCL_5_6_AMDGPU_USEDEP=$(gen_x_usedep "RCCL_5_6_AMDGPU_TARGETS_COMPAT")

TENSILE_5_6_AMDGPU_TARGETS_COMPAT=(
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
TENSILE_5_6_AMDGPU_USEDEP=$(gen_x_usedep "TENSILE_5_6_AMDGPU_TARGETS_COMPAT")

ROCPROFILER_5_6_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1031
	gfx1032
)
ROCPROFILER_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCPROFILER_5_6_AMDGPU_TARGETS_COMPAT")

MIGRAPHX_5_6_AMDGPU_TARGETS_COMPAT=(
# See https://github.com/ROCm/AMDMIGraphX/blob/rocm-5.6.1/Jenkinsfile
	gfx900
	gfx906
)
MIGRAPHX_5_6_AMDGPU_USEDEP=$(gen_x_usedep "MIGRAPHX_5_6_AMDGPU_TARGETS_COMPAT")

HIPBLASLT_5_6_AMDGPU_TARGETS_COMPAT=(
	gfx90a_xnack_minus
	gfx90a_xnack_plus
)
HIPBLASLT_5_6_AMDGPU_USEDEP=$(gen_x_usedep "HIPBLASLT_5_6_AMDGPU_TARGETS_COMPAT")

HIPCUB_5_6_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
HIPCUB_5_6_AMDGPU_USEDEP=$(gen_x_usedep "HIPCUB_5_6_AMDGPU_TARGETS_COMPAT")

HIPFFT_5_6_AMDGPU_TARGETS_COMPAT=(
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
HIPFFT_5_6_AMDGPU_USEDEP=$(gen_x_usedep "HIPFFT_5_6_AMDGPU_TARGETS_COMPAT")

MIOPEN_5_6_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/MIOpen/blob/rocm-5.6.1/test/CMakeLists.txt#L118
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1031
	gfx1100
	gfx1101
	gfx1102
)
MIOPEN_5_6_AMDGPU_USEDEP=$(gen_x_usedep "MIOPEN_5_6_AMDGPU_TARGETS_COMPAT")

MIOPENKERNELS_5_6_AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
MIOPENKERNELS_5_6_AMDGPU_USEDEP=$(gen_x_usedep "MIOPENKERNELS_5_6_AMDGPU_TARGETS_COMPAT")

ROCALUTION_5_6_AMDGPU_TARGETS_COMPAT=(
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
ROCALUTION_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCALUTION_5_6_AMDGPU_TARGETS_COMPAT")

ROCBLAS_5_6_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1010
	gfx1012
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCBLAS_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCBLAS_5_6_AMDGPU_TARGETS_COMPAT")

ROCFFT_5_6_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCFFT_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCFFT_5_6_AMDGPU_TARGETS_COMPAT")

ROCPRIM_5_6_AMDGPU_TARGETS_COMPAT=(
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
ROCPRIM_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCPRIM_5_6_AMDGPU_TARGETS_COMPAT")

ROCRAND_5_6_AMDGPU_TARGETS_COMPAT=(
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
ROCRAND_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCRAND_5_6_AMDGPU_TARGETS_COMPAT")

ROCSOLVER_5_6_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1010
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
ROCSOLVER_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCSOLVER_5_6_AMDGPU_TARGETS_COMPAT")

ROCSPARSE_5_6_AMDGPU_TARGETS_COMPAT=(
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
ROCSPARSE_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCSPARSE_5_6_AMDGPU_TARGETS_COMPAT")

ROCTHRUST_5_6_AMDGPU_TARGETS_COMPAT=(
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
ROCTHRUST_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCTHRUST_5_6_AMDGPU_TARGETS_COMPAT")

ROCWMMA_5_6_AMDGPU_TARGETS_COMPAT=(
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1100
	gfx1101
	gfx1102
)
ROCWMMA_5_6_AMDGPU_USEDEP=$(gen_x_usedep "ROCWMMA_5_6_AMDGPU_TARGETS_COMPAT")

LLVM_ROC_LIBOMP_5_6_AMDGPU_TARGETS_COMPAT=(
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
LLVM_ROC_LIBOMP_5_6_AMDGPU_USEDEP=$(gen_x_usedep "LLVM_ROC_LIBOMP_5_6_AMDGPU_TARGETS_COMPAT")

RPP_5_6_AMDGPU_TARGETS_COMPAT=(
# Based on commit 189c648
	gfx803
	gfx900
	gfx906
# See https://github.com/ROCm/rpp/blob/1.1.0/.jenkins/precheckin.groovy
	gfx908
)
RPP_5_6_AMDGPU_USEDEP=$(gen_x_usedep "RPP_5_6_AMDGPU_TARGETS_COMPAT")

COMPOSABLE_KERNEL_5_6_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/composable_kernel/blob/0a8dac4ef1a232abd8f6896a5b016f9e76192ddd/include/ck/ck.hpp#L31
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
COMPOSABLE_KERNEL_5_6_AMDGPU_USEDEP=$(gen_x_usedep "COMPOSABLE_KERNEL_5_6_AMDGPU_TARGETS_COMPAT")

MAGMA_2_7_5_6_AMDGPU_TARGETS_COMPAT=(
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
MAGMA_2_7_5_6_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_7_5_6_AMDGPU_TARGETS_COMPAT")

MAGMA_2_8_5_6_AMDGPU_TARGETS_COMPAT=(
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
MAGMA_2_8_5_6_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_8_5_6_AMDGPU_TARGETS_COMPAT")

fi
