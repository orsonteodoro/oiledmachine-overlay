# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The h in the version means hip

inherit hip-versions

CXX_STANDARD=14
EBUILD_REVISION="ebuild_revision_9"
LLVM_SLOT="${HIP_7_2_LLVM_SLOT}"
MAGMA_ROCM=1
ROCM_SLOT="7.2"
ROCM_SLOTS=(
	"${HIP_7_2_VERSION}"
)
declare -A ROCM_PV_TO_LLVM_SLOT=(
	["${HIP_7_2_VERSION}"]="22"
)
SLOT="0/${ROCM_SLOT}"

inherit icl-magma-v2_10
