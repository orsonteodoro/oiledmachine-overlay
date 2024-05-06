# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {17..14} )
MAGMA_CUDA=1
SLOT="0/${PV}"

inherit icl-magma-v2_8
