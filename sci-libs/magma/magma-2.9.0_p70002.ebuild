# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit hip-versions

CXX_STANDARD=14
LLVM_SLOT=19
MAGMA_ROCM=1
ROCM_SLOT="7.0"
ROCM_SLOTS=(
	"${HIP_7_0_VERSION}"
)
declare -A ROCM_PV_TO_LLVM_SLOT=(
	["${HIP_7_0_VERSION}"]="19"
)
SLOT="0/${ROCM_SLOT}"

inherit icl-magma-v2_9
