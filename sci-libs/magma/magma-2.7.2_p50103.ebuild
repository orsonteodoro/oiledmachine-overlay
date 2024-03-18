# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=14
MAGMA_ROCM=1
ROCM_SLOT="5.1"
ROCM_SLOTS=(
	"5.1.3"
)
declare -A ROCM_PV_TO_LLVM_SLOT=(
	["5.1.3"]="14"
)
SLOT="${ROCM_SLOT}/${PV}"

inherit icl-magma-v2_7
