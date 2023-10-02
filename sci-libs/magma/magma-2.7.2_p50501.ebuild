# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
MAGMA_ROCM=1
ROCM_SLOT="5.5"
ROCM_SLOTS=(
	"5.5.1"
)
declare -A ROCM_PV_TO_LLVM_MAX_SLOT=(
	["5.5.1"]="16"
)
SLOT="${ROCM_SLOT}/${PV}"

inherit icl-magma-v2_7
