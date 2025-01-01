# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm-targets-compat-5.2.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: AMDGPU targets for the *USEDEP generator
# @DESCRIPTION:
# AMDGPU targets for the *USEDEP generator for HIP/ROCm 5.2 ebuilds.

# This ebuild is part of the rocm.eclass.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_TARGETS_COMPAT_5_2_ECLASS} ]]; then
_ROCM_TARGETS_COMPAT_5_2_ECLASS=1

ATMI_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx600
	gfx601
	gfx602
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
	gfx90a
	gfx90c
	gfx940
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
	gfx1036
)
ATMI_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ATMI_5_2_AMDGPU_TARGETS_COMPAT")

RCCL_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
RCCL_5_2_AMDGPU_USEDEP=$(gen_x_usedep "RCCL_5_2_AMDGPU_TARGETS_COMPAT")

TENSILE_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
TENSILE_5_2_AMDGPU_USEDEP=$(gen_x_usedep "TENSILE_5_2_AMDGPU_TARGETS_COMPAT")

ROCPROFILER_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
)
ROCPROFILER_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCPROFILER_5_2_AMDGPU_TARGETS_COMPAT")

MIGRAPHX_5_2_AMDGPU_TARGETS_COMPAT=(
# See https://github.com/ROCm/AMDMIGraphX/blob/rocm-5.2.3/Jenkinsfile
	gfx900
	gfx906
)
MIGRAPHX_5_2_AMDGPU_USEDEP=$(gen_x_usedep "MIGRAPHX_5_2_AMDGPU_TARGETS_COMPAT")

HIPCUB_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
HIPCUB_5_2_AMDGPU_USEDEP=$(gen_x_usedep "HIPCUB_5_2_AMDGPU_TARGETS_COMPAT")

HIPFFT_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
)
HIPFFT_5_2_AMDGPU_USEDEP=$(gen_x_usedep "HIPFFT_5_2_AMDGPU_TARGETS_COMPAT")

MIOPEN_5_2_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/MIOpen/blob/rocm-5.2.3/test/CMakeLists.txt#L99
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
MIOPEN_5_2_AMDGPU_USEDEP=$(gen_x_usedep "MIOPEN_5_2_AMDGPU_TARGETS_COMPAT")

MIOPENKERNELS_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
MIOPENKERNELS_5_2_AMDGPU_USEDEP=$(gen_x_usedep "MIOPENKERNELS_5_2_AMDGPU_TARGETS_COMPAT")

ROCALUTION_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCALUTION_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCALUTION_5_2_AMDGPU_TARGETS_COMPAT")

ROCBLAS_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1010
	gfx1012
	gfx1030
)
ROCBLAS_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCBLAS_5_2_AMDGPU_TARGETS_COMPAT")

ROCFFT_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCFFT_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCFFT_5_2_AMDGPU_TARGETS_COMPAT")

ROCPRIM_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCPRIM_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCPRIM_5_2_AMDGPU_TARGETS_COMPAT")

ROCRAND_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCRAND_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCRAND_5_2_AMDGPU_TARGETS_COMPAT")

ROCSOLVER_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1010
	gfx1030
)
ROCSOLVER_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCSOLVER_5_2_AMDGPU_TARGETS_COMPAT")

ROCSPARSE_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCSPARSE_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCSPARSE_5_2_AMDGPU_TARGETS_COMPAT")

ROCTHRUST_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCTHRUST_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCTHRUST_5_2_AMDGPU_TARGETS_COMPAT")

ROCWMMA_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
)
ROCWMMA_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCWMMA_5_2_AMDGPU_TARGETS_COMPAT")

LLVM_ROC_LIBOMP_5_2_AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx801
	gfx803
	gfx900
	gfx902
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1031
	gfx1036
)
LLVM_ROC_LIBOMP_5_2_AMDGPU_USEDEP=$(gen_x_usedep "LLVM_ROC_LIBOMP_5_2_AMDGPU_TARGETS_COMPAT")

RPP_5_2_AMDGPU_TARGETS_COMPAT=(
# Based on commit 189c648
	gfx803
	gfx900
	gfx906
# See https://github.com/ROCm/rpp/blob/0.96/.jenkins/precheckin.groovy
	gfx908
)
RPP_5_2_AMDGPU_USEDEP=$(gen_x_usedep "RPP_5_2_AMDGPU_TARGETS_COMPAT")

MAGMA_2_7_5_2_AMDGPU_TARGETS_COMPAT=(
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
MAGMA_2_7_5_2_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_7_5_2_AMDGPU_TARGETS_COMPAT")

MAGMA_2_8_5_2_AMDGPU_TARGETS_COMPAT=(
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
MAGMA_2_8_5_2_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_8_5_2_AMDGPU_TARGETS_COMPAT")

ROCM_AGENT_ENUMERATOR_5_2_AMDGPU_TARGETS_COMPAT=(
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
ROCM_AGENT_ENUMERATOR_5_2_AMDGPU_USEDEP=$(gen_x_usedep "ROCM_AGENT_ENUMERATOR_5_2_AMDGPU_TARGETS_COMPAT")
ROCMINFO_5_2_AMDGPU_USEDEP="${ROCM_AGENT_ENUMERATOR_5_2_AMDGPU_USEDEP}"

fi
