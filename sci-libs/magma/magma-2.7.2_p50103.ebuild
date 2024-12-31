# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit hip-versions

LLVM_SLOT=14
MAGMA_ROCM=1
ROCM_SLOT="5.1"
ROCM_SLOTS=(
	"${HIP_5_1_VERSION}"
)
declare -A ROCM_PV_TO_LLVM_SLOT=(
	["${HIP_5_1_VERSION}"]="14"
)
SLOT="${ROCM_SLOT}/${HIP_5_1_VERSION}"

inherit icl-magma-v2_7
