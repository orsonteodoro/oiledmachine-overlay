# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit hip-versions

LLVM_SLOT=15
MAGMA_ROCM=1
ROCM_SLOT="5.4"
ROCM_SLOTS=(
	"${HIP_5_4_VERSION}"
)
declare -A ROCM_PV_TO_LLVM_SLOT=(
	["${HIP_5_4_VERSION}"]="15"
)
SLOT="${ROCM_SLOT}/${HIP_5_4_VERSION}"

inherit icl-magma-v2_7
