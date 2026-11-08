# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The h in the version means hip

inherit rocm-r1

CXX_STANDARD=14
EBUILD_REVISION="ebuild_revision_9"
LLVM_SLOT="${ROCM_LLVM_SLOT}"
MAGMA_ROCM=1
SLOT="0/${ROCM_SLOT}"

inherit icl-magma-v2_10
