# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit hip-versions

CXX_STANDARD=11
LLVM_SLOT=17
MAGMA_ROCM=1
ROCM_SLOT="5.7"
ROCM_SLOTS=(
	"${HIP_5_7_VERSION}"
)
declare -A ROCM_PV_TO_LLVM_SLOT=(
	["${HIP_5_7_VERSION}"]="17"
)
SLOT="${ROCM_SLOT}/${PV}"

inherit icl-magma-v2_8
