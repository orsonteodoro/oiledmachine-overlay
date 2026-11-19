# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is more strict.

GCC_COMPAT=(
	"gcc_slot_14_3"
	"gcc_slot_15_3"
	"gcc_slot_16_3"
)

LLVM_COMPAT=(
	"llvm_slot_22"
)

inherit secure-version

DESCRIPTION="CUDA requirements"
LICENSE="metapackage"
SLOT="0/"$(ver_cut "1-2" "${PV}")
KEYWORDS="~amd64"
IUSE="
${GCC_COMPAT[@]}
${LLVM_COMPAT[@]}
cudnn kernel-open profiler rdma
"
REQUIRED_USE="
	^^ (
		${GCC_COMPAT[@]}
	)
	^^ (
		${LLVM_COMPAT[@]}
	)
"

RDEPEND+="
	!virtual/cuda:12
	!virtual/cuda:13
	=dev-util/nvidia-cuda-toolkit-13.4*[profiler?,rdma?]
	$(secure-version_gen_nvidia_drivers_depends '590-')
	cudnn? (
		dev-libs/cudnn
		|| (
			=dev-libs/cudnn-9.25*
		)
	)
	gcc_slot_14_3? (
		=sys-devel/gcc-14.3*
	)
	gcc_slot_15_3? (
		=sys-devel/gcc-15.3*
	)
	gcc_slot_16_3? (
		=sys-devel/gcc-16.3*
	)
	llvm_slot_22? (
		=llvm-core/clang-22*
		=llvm-core/lld-22*
		=llvm-core/llvm-22*
	)
"
DEPEND+="
"
