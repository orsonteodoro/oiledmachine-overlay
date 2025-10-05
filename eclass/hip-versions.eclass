# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

HIP_3_5_VERSION="3.5.1"
HIP_3_7_VERSION="3.7.0"
HIP_3_8_VERSION="3.8.0"
HIP_3_9_VERSION="3.9.0"
HIP_3_10_VERSION="3.10.0"
HIP_4_0_VERSION="4.0.0"
HIP_4_1_VERSION="4.1.0"
HIP_4_2_VERSION="4.2.0"
HIP_4_3_VERSION="4.3.0"
HIP_4_5_VERSION="4.5.2"
HIP_5_0_VERSION="5.0.2"
# The latest supported for this overlay below
HIP_5_1_VERSION="5.1.3"
HIP_5_2_VERSION="5.2.3"
HIP_5_3_VERSION="5.3.3"
HIP_5_4_VERSION="5.4.3"
HIP_5_5_VERSION="5.5.1"
HIP_5_6_VERSION="5.6.1"
HIP_5_7_VERSION="5.7.1"
HIP_6_0_VERSION="6.0.2"
HIP_6_1_VERSION="6.1.2"
HIP_6_2_VERSION="6.2.4"
HIP_6_3_VERSION="6.3.3"

HIP_3_5_LLVM_SLOT="11"
HIP_3_7_LLVM_SLOT="11"
HIP_3_8_LLVM_SLOT="11"
HIP_3_9_LLVM_SLOT="12"
HIP_3_10_LLVM_SLOT="12"
HIP_4_0_LLVM_SLOT="12"
HIP_4_1_LLVM_SLOT="12"
HIP_4_2_LLVM_SLOT="12"
HIP_4_3_LLVM_SLOT="13"
# The latest supported for this overlay below
HIP_4_5_LLVM_SLOT="13"
HIP_5_0_LLVM_SLOT="14"
HIP_5_1_LLVM_SLOT="14"
HIP_5_2_LLVM_SLOT="14"
HIP_5_3_LLVM_SLOT="15"
HIP_5_4_LLVM_SLOT="15"
HIP_5_5_LLVM_SLOT="16"
HIP_5_6_LLVM_SLOT="16"
HIP_5_7_LLVM_SLOT="17"
HIP_6_0_LLVM_SLOT="17"
HIP_6_1_LLVM_SLOT="17"
HIP_6_2_LLVM_SLOT="18"
HIP_6_3_LLVM_SLOT="18"

# AOCC in this context means rocm-llvm-alt
AOCC_5_1_SLOT="13"
AOCC_5_2_SLOT="14"
AOCC_5_3_SLOT="15"
AOCC_5_4_SLOT="15"
AOCC_5_5_SLOT="16"
AOCC_5_6_SLOT="16"
AOCC_5_7_SLOT="17"
AOCC_6_0_SLOT="17"
AOCC_6_1_SLOT="17"
AOCC_6_2_SLOT="17"

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
HIP_4_1_GLIBCXX_MIN="3.4.22" # GCC 6.1.0
HIP_4_5_GLIBCXX_MIN="3.4.22" # GCC 6.1.0
HIP_5_1_GLIBCXX_MIN="3.4.22" # GCC 6.1.0
HIP_5_2_GLIBCXX_MIN="3.4.22" # GCC 6.1.0
HIP_5_3_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_5_4_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_5_5_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_5_6_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_5_7_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_6_0_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_6_1_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_6_2_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_6_3_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_6_3_GLIBCXX_MIN="3.4.26" # GCC 9.1.0
HIP_6_4_GLIBCXX_MIN="3.4.30" # GCC 12.1.0

# Upstream preference
HIP_4_1_GLIBCXX_MAX="3.4.22" # GCC 6.1.0
HIP_4_5_GLIBCXX_MAX="3.4.22" # GCC 6.1.0
HIP_5_1_GLIBCXX_MAX="3.4.22" # GCC 6.1.0
HIP_5_2_GLIBCXX_MAX="3.4.22" # GCC 6.1.0
HIP_5_3_GLIBCXX_MAX="3.4.30" # GCC 12.1.0
HIP_5_4_GLIBCXX_MAX="3.4.30" # GCC 12.1.0
HIP_5_5_GLIBCXX_MAX="3.4.30" # GCC 12.1.0
HIP_5_6_GLIBCXX_MAX="3.4.30" # GCC 12.1.0
HIP_5_7_GLIBCXX_MAX="3.4.30" # GCC 12.1.0
HIP_6_0_GLIBCXX_MAX="3.4.30" # GCC 12.1.0
HIP_6_1_GLIBCXX_MAX="3.4.30" # GCC 12.1.0
HIP_6_2_GLIBCXX_MAX="3.4.32" # GCC 13.2.0
HIP_6_3_GLIBCXX_MAX="3.4.32" # GCC 13.2.0
HIP_6_4_GLIBCXX_MAX="3.4.32" # GCC 13.2.0

# oiledmachine-overlay preference
# The choice of GLIBCXX and GCC_SLOT maximum currently is based on rebuild mood.
# You can fork this eclass and change it, but it should not be more than upstream's GLIBCXX_MAX.
# The limits can change based on...
# 1. The highest upstream preference (GLIBCXX_MAX).
# 2. HIPIFY CUDA requirement.
# 3. Testing between HIP and CUDA.
HIP_4_1_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_4_5_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_5_1_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_5_2_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_5_3_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_5_4_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_5_5_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_5_6_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_5_7_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_6_0_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_6_1_GLIBCXX="3.4.30" # GCC 12.1.0
HIP_6_2_GLIBCXX="3.4.32" # GCC 13.2.0
HIP_6_3_GLIBCXX="3.4.32" # GCC 13.2.0

_hip_set_globals() {
	local hip_platform="${HIP_PLATFORM:-amd}"
	if [[ "${hip_platform}" == "amd" ]] ; then
	# Based on GLIBCXX version correspondance in rocBLAS linking to libstdc++
	# For HIP_PLATFORM == amd.
	#		  This distro # Upstream
		HIP_4_1_GCC_SLOT="12" # GCC 6.1 U18 and U20, which GCC 6.1 is EOL
		HIP_4_5_GCC_SLOT="12" # GCC 6.1 U18 and U20, which GCC 6.1 is EOL
		HIP_5_1_GCC_SLOT="12" # GCC 6.1 U18 and U20, which GCC 6.1 is EOL
		HIP_5_2_GCC_SLOT="12" # GCC 6.1 U18 and U20, which GCC 6.1 is EOL
		HIP_5_3_GCC_SLOT="12" # GCC 9.1 U20, GCC 12.1 U22
		HIP_5_4_GCC_SLOT="12" # GCC 9.1 U20, GCC 12.1 U22
		HIP_5_5_GCC_SLOT="12" # GCC 9.1 U20, GCC 12.1 U22
		HIP_5_6_GCC_SLOT="12" # GCC 9.1 U20, GCC 12.1 U22
		HIP_5_7_GCC_SLOT="12" # GCC 9.1 U20, GCC 12.1 U22
		HIP_6_0_GCC_SLOT="12" # GCC 9.1 U20, GCC 12.1 U22
		HIP_6_1_GCC_SLOT="12" # GCC 9.1 U20, GCC 12.1 U22
		HIP_6_2_GCC_SLOT="13" # GCC 9.1 U20, GCC 12.1 U22, GCC 13.2 U24
		HIP_6_3_GCC_SLOT="13" # GCC 9.1 U20, GCC 12.1 U22, GCC 13.2 U24
	else
	# The GCC slots listed is based on the max GCC allowed in the dev-util/nvidia-cuda-toolkit ebuild.
	# For HIP_PLATFORM == nvidia.
		HIP_4_1_GCC_SLOT="10" # CUDA 11.3
		HIP_4_5_GCC_SLOT="11" # CUDA 11.5
		HIP_5_1_GCC_SLOT="11" # CUDA 11.5
		HIP_5_2_GCC_SLOT="11" # CUDA 11.6
		HIP_5_3_GCC_SLOT="11" # CUDA 11.8
		HIP_5_4_GCC_SLOT="11" # CUDA 11.8
		HIP_5_5_GCC_SLOT="12" # CUDA 12.1
		HIP_5_6_GCC_SLOT="12" # CUDA 12.1
		HIP_5_7_GCC_SLOT="12" # CUDA 12.2
		HIP_6_0_GCC_SLOT="12" # CUDA 12.2
		HIP_6_1_GCC_SLOT="12" # CUDA 12.3
		HIP_6_2_GCC_SLOT="13" # CUDA 12.5
		HIP_6_3_GCC_SLOT="13" # CUDA 12.6
	fi
}

_hip_set_globals
unset -f _hip_set_globals

#
# The table for corresponding llvm-roc and CUDA versions.
#
# Key:
# c       - consistent CUDA version with HIPIFY documentation with the same
#           ROCM_SLOT.
# s       - stable config
# u       - not marked stable config (implied unstable or not CI tested)
# match   - The versions are matching.  (e.g. The git version in HIPIFY
#           documentation with the same ROCM_SLOT is the same as version in
#           llvm-roc with the git suffix.)
# missing - The corresponding llvm-roc major version is not found in HIPIFY
#           documentation for the same ROCM_SLOT.  Upstream may have forgotten
#           to update the documentation, which is a common bad habit in
#           programming.
#
# For the "missing" tag in brackets, we fill the missing details using the
# documentation from the next minor version of HIPIFY.
#
HIPIFY_4_1_CUDA_SLOT="11.3" # LLVM 12, [missing]
HIPIFY_4_5_CUDA_SLOT="11.5" # LLVM 13, [missing]
HIPIFY_5_0_CUDA_SLOT="11.6" # LLVM 14, [missing]
HIPIFY_5_1_CUDA_SLOT="11.6" # LLVM 14, [missing]
HIPIFY_5_2_CUDA_SLOT="11.6" # LLVM 14, [c,s]
HIPIFY_5_3_CUDA_SLOT="11.8" # LLVM 15, [missing]
HIPIFY_5_4_CUDA_SLOT="11.8" # LLVM 15, [c,s]
HIPIFY_5_5_CUDA_SLOT="12.1" # LLVM 16, [missing]
HIPIFY_5_6_CUDA_SLOT="12.1" # LLVM 16, [c,s]
HIPIFY_5_7_CUDA_SLOT="12.2" # LLVM 17, [c,u,match]
HIPIFY_6_0_CUDA_SLOT="12.2" # LLVM 17, [c,s]
HIPIFY_6_1_CUDA_SLOT="12.3" # LLVM 17, [c,s]
HIPIFY_6_2_CUDA_SLOT="12.5" # LLVM 19, [u]
HIPIFY_6_3_CUDA_SLOT="12.6" # LLVM 19, [missing]

HIPIFY_4_1_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.3.1.ebuild?id=38b155fa1bf907617067c98eb4ba3a5d0790eb1a"
HIPIFY_4_5_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.5.0-r1.ebuild?id=3e598a395f06403e05d63b15458d90a56cb1a3ec"
HIPIFY_5_0_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.6.2.ebuild?id=e51ca099bec28c5a27a7eb070e7c77a06790a30d"
HIPIFY_5_1_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.6.2.ebuild?id=e51ca099bec28c5a27a7eb070e7c77a06790a30d"
HIPIFY_5_2_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.6.2.ebuild?id=e51ca099bec28c5a27a7eb070e7c77a06790a30d"
# If cuda_11_7 USE flag is enabled for the sys-devel/llvm-roc ebuild, it may be
# possible to use the dev-util/nvidia-cuda-toolkit 11.7.0 ebuild.
# https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.7.0-r4.ebuild?id=5165cc0405cc638a674b1ba7576c4df496012fe0"
HIPIFY_5_3_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.8.0-r4.ebuild?id=3e598a395f06403e05d63b15458d90a56cb1a3ec"
HIPIFY_5_4_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-11.8.0-r4.ebuild?id=3e598a395f06403e05d63b15458d90a56cb1a3ec"
HIPIFY_5_5_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.1.1-r1.ebuild?id=56bf30db3c55f0bf7786e5e057a5546932aa99ca"
HIPIFY_5_6_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.1.1-r1.ebuild?id=56bf30db3c55f0bf7786e5e057a5546932aa99ca"
HIPIFY_5_7_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.2.2-r1.ebuild?id=6d5c521d947b4ccc81b2031f1b51b5ce06fdb880"
HIPIFY_6_0_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.2.2-r1.ebuild?id=6d5c521d947b4ccc81b2031f1b51b5ce06fdb880"
HIPIFY_6_1_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.3.2.ebuild?id=c6a96e9169b96c35d91263b113b334655f752e60"
HIPIFY_6_2_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.5.1.ebuild?id=d071cb72002d9422a4d1d94160012d222196173c"
HIPIFY_6_3_CUDA_URI="https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-12.6.1.ebuild?id=91e6a514e9d7c73279ab9bd40a796c9c389b931e"
