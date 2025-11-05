# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

HIP_6_4_VERSION="6.4.4"
HIP_7_0_VERSION="7.0.2"

HIP_6_4_LLVM_SLOT="19"
HIP_7_0_LLVM_SLOT="19"

# rocBLAS_PV  GCC_VER  U_VER
# 4.1.0       6.1.0
# 4.5.2       6.1.0
# 5.1.3       6.1.0
# 5.2.3       6.1.0
# 5.3.3       12.1.0   22.04
# 5.5.3       9.1.0    20.04
# 6.1.0       12.1.0   22.04
# 6.2.2       9.1.0    20.04
# 6.2.2       12.1.0   22.04
# 6.2.2       13.2.0   24.04

# Upstream preference
HIP_6_4_GLIBCXX_MIN="3.4.30" # GCC 12.1.0
HIP_7_0_GLIBCXX_MIN="3.4.30" # GCC 12.1.0

# Upstream preference
HIP_6_4_GLIBCXX_MAX="3.4.32" # GCC 13.2.0
HIP_7_0_GLIBCXX_MAX="3.4.32" # GCC 13.2.0

# oiledmachine-overlay preference
# The choice of GLIBCXX and GCC_SLOT maximum currently is based on rebuild mood.
# You can fork this eclass and change it, but it should not be more than upstream's GLIBCXX_MAX.
# The limits can change based on...
# 1. The highest upstream preference (GLIBCXX_MAX).
# 2. HIPIFY CUDA requirement.
# 3. Testing between HIP and CUDA.
HIP_6_4_GLIBCXX="3.4.32" # GCC 13.2.0
HIP_7_0_GLIBCXX="3.4.32" # GCC 13.2.0

_hip_set_globals() {
	local hip_platform="${HIP_PLATFORM:-amd}"
	if [[ "${hip_platform}" == "amd" ]] ; then
	# Based on GLIBCXX version correspondance in rocBLAS linking to libstdc++
	# For HIP_PLATFORM == amd.
	#		  This distro # Upstream
		HIP_6_4_GCC_SLOT="13" # GCC 12.1 U22, GCC 13.2 U24
		HIP_7_0_GCC_SLOT="13" # GCC 12.1 U22, GCC 13.2 U24
	else
	# The GCC slots listed is based on the max GCC allowed in the dev-util/nvidia-cuda-toolkit ebuild.
	# For HIP_PLATFORM == nvidia.
		HIP_6_4_GCC_SLOT="13" # CUDA 12.6
		HIP_7_0_GCC_SLOT="14" # CUDA 12.9
	fi
}

_hip_set_globals
unset -f _hip_set_globals

#
# The table for corresponding llvm-roc and CUDA versions.
#
# Key:
# c       - consistent CUDA version with HIPIFY documentation with the same
#           ROCM_SLOT.  This means that it has the same LLVM major version
#           but not necessarily the same stable non-git versus the unstable
#           git suffix.
# s       - stable config
# u       - not marked stable config (implied unstable or not CI tested)
# match   - The versions are matching.  (e.g. The git version in HIPIFY
#           documentation with the same ROCM_SLOT is the same as version in
#           llvm-roc with the git suffix.)  The suffix for git or non-git
#           are the same.
# missing - The corresponding llvm-roc major version is not found in HIPIFY
#           documentation for the same ROCM_SLOT.  Upstream may have forgotten
#           to update the documentation, which is a common bad habit in
#           programming.
#
# For the "missing" tag in brackets, we fill the missing details using the
# documentation from the next minor version of HIPIFY.
#
# CUDA:DRIVER_VERSION pairs
HIPIFY_6_4_CUDA_SLOTS=( "11.8:520.61" "12.3:545.23" "12.4:550.54" "12.5:555.42" "12.6:560.35" )
HIPIFY_7_0_CUDA_SLOTS=( "11.8:520.61" "12.3:545.23" "12.4:550.54" "12.5:555.42" "12.6:560.35" "12.8:570.124" )

HIP_6_4_LIBSTDCXX_SLOTS=( "12.5" "13.4" )
HIP_7_0_LIBSTDCXX_SLOTS=( "12.5" "13.4" )
