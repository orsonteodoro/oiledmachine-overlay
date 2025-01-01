# Copyright 2024 Orson Teodoro
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm-targets-compat-4.1.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: AMDGPU targets for the *USEDEP generator
# @DESCRIPTION:
# AMDGPU targets for the *USEDEP generator for HIP/ROCm 4.1 ebuilds.

# This ebuild is part of the rocm.eclass.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_TARGETS_COMPAT_4_1_ECLASS} ]]; then
_ROCM_TARGETS_COMPAT_4_1_ECLASS=1

ATMI_4_1_AMDGPU_TARGETS_COMPAT=(
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
ATMI_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ATMI_4_1_AMDGPU_TARGETS_COMPAT")

RCCL_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
)
RCCL_4_1_AMDGPU_USEDEP=$(gen_x_usedep "RCCL_4_1_AMDGPU_TARGETS_COMPAT")

TENSILE_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx1010
	gfx1011
	gfx1012
	gfx1030
#	gfx1031
)
TENSILE_4_1_AMDGPU_USEDEP=$(gen_x_usedep "TENSILE_4_1_AMDGPU_TARGETS_COMPAT")

ROCPROFILER_4_1_AMDGPU_TARGETS_COMPAT=(
# From Readme.txt
	gfx803
	gfx900
# From:  grep -o -E -r -e "gfx[0-9a]+" ./ | cut -f 2 -d ":" | sort | uniq | grep -E -e "gfx[0-9a]{3,4}"
	gfx906
	gfx908
	gfx90a
)
ROCPROFILER_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCPROFILER_4_1_AMDGPU_TARGETS_COMPAT")

MIGRAPHX_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx900
)
MIGRAPHX_4_1_AMDGPU_USEDEP=$(gen_x_usedep "MIGRAPHX_4_1_AMDGPU_TARGETS_COMPAT")

HIPCUB_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
HIPCUB_4_1_AMDGPU_USEDEP=$(gen_x_usedep "HIPCUB_4_1_AMDGPU_TARGETS_COMPAT")

HIPFFT_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
)
HIPFFT_4_1_AMDGPU_USEDEP=$(gen_x_usedep "HIPFFT_4_1_AMDGPU_TARGETS_COMPAT")

MIOPEN_4_1_AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/MIOpen/blob/rocm-4.1.0/test/CMakeLists.txt#L99
	gfx900
	gfx906
	gfx908
)
MIOPEN_4_1_AMDGPU_USEDEP=$(gen_x_usedep "MIOPEN_4_1_AMDGPU_TARGETS_COMPAT")

MIOPENKERNELS_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
)
MIOPENKERNELS_4_1_AMDGPU_USEDEP=$(gen_x_usedep "MIOPENKERNELS_4_1_AMDGPU_TARGETS_COMPAT")

ROCALUTION_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCALUTION_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCALUTION_4_1_AMDGPU_TARGETS_COMPAT")

ROCBLAS_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
)
ROCBLAS_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCBLAS_4_1_AMDGPU_TARGETS_COMPAT")

ROCFFT_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCFFT_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCFFT_4_1_AMDGPU_TARGETS_COMPAT")

ROCPRIM_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCPRIM_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCPRIM_4_1_AMDGPU_TARGETS_COMPAT")

ROCRAND_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCRAND_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCRAND_4_1_AMDGPU_TARGETS_COMPAT")

ROCSOLVER_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCSOLVER_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCSOLVER_4_1_AMDGPU_TARGETS_COMPAT")

ROCSPARSE_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCSPARSE_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCSPARSE_4_1_AMDGPU_TARGETS_COMPAT")

ROCTHRUST_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
ROCTHRUST_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCTHRUST_4_1_AMDGPU_TARGETS_COMPAT")

LLVM_ROC_LIBOMP_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx902
	gfx906
	gfx908
)
LLVM_ROC_LIBOMP_4_1_AMDGPU_USEDEP=$(gen_x_usedep "LLVM_ROC_LIBOMP_4_1_AMDGPU_TARGETS_COMPAT")

RPP_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
)
RPP_4_1_AMDGPU_USEDEP=$(gen_x_usedep "RPP_4_1_AMDGPU_TARGETS_COMPAT")

MAGMA_2_7_4_1_AMDGPU_TARGETS_COMPAT=(
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
MAGMA_2_7_4_1_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_7_4_1_AMDGPU_TARGETS_COMPAT")

MAGMA_2_8_4_1_AMDGPU_TARGETS_COMPAT=(
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
MAGMA_2_8_4_1_AMDGPU_USEDEP=$(gen_x_usedep "MAGMA_2_8_4_1_AMDGPU_TARGETS_COMPAT")

ROCM_AGENT_ENUMERATOR_4_1_AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
)
ROCM_AGENT_ENUMERATOR_4_1_AMDGPU_USEDEP=$(gen_x_usedep "ROCM_AGENT_ENUMERATOR_4_1_AMDGPU_TARGETS_COMPAT")
ROCMINFO_4_1_AMDGPU_USEDEP="${ROCM_AGENT_ENUMERATOR_4_1_AMDGPU_USEDEP}"

fi
