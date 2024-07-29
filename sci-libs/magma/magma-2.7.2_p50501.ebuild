# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit hip-versions

LLVM_SLOT=16
MAGMA_ROCM=1
ROCM_SLOT="5.5"
ROCM_SLOTS=(
	"${HIP_5_5_VERSION}"
)
declare -A ROCM_PV_TO_LLVM_SLOT=(
	["${HIP_5_5_VERSION}"]="16"
)
SLOT="${ROCM_SLOT}/${HIP_5_5_VERSION}"

inherit icl-magma-v2_7
