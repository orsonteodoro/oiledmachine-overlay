# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit hip-versions

LLVM_SLOT=16
MAGMA_ROCM=1
ROCM_SLOT="5.6"
ROCM_SLOTS=(
	"${HIP_5_6_VERSION}"
)
declare -A ROCM_PV_TO_LLVM_SLOT=(
	["${HIP_5_6_VERSION}"]="16"
)
SLOT="${ROCM_SLOT}/${PV}"

inherit icl-magma-v2_8
