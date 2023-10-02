# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
MAGMA_ROCM=1
ROCM_SLOT="5.3"
ROCM_SLOTS=(
	"5.3.3"
)
declare -A ROCM_PV_TO_LLVM_MAX_SLOT=(
	["5.3.3"]="15"
)
SLOT="${ROCM_SLOT}/${PV}"

inherit icl-magma-v2_7
