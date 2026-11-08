# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD="ignore"
LIBSTDCXX_SLOT_VERIFY=0
ROCM_SLOT=$(ver_cut "1-2" "${PV}")

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_ROCM_9999[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_CXX20_ROCM_9999[@]/llvm_slot_}"
)

inherit libcxx-slot libstdcxx-slot secure-version rocm-r1

#KEYWORDS="~amd64"

DESCRIPTION="ROCm metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="0/${ROCM_SLOT}"
IUSE="
"
REQUIRED_USE="
"
RDEPEND="
	~sci-ml/therock-${PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	~virtual/kfd-${PV}
"
