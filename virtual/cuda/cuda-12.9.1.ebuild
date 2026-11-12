# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is more strict.

GCC_COMPAT=(
	"gcc_slot_14_3"
)

LLVM_COMPAT=(
	"llvm_slot_19"
)

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
	>=x11-drivers/nvidia-drivers-575.57
	|| (
		=x11-drivers/nvidia-drivers-580*[kernel-open]
		=x11-drivers/nvidia-drivers-595
		=x11-drivers/nvidia-drivers-615*
		=x11-drivers/nvidia-drivers-620*
	)
	cudnn? (
		dev-libs/cudnn
		|| (
			=dev-libs/cudnn-9.17*
			=dev-libs/cudnn-9.14*
			=dev-libs/cudnn-9.8*
			=dev-libs/cudnn-8.9*
			=dev-libs/cudnn-8.8*
		)
	)
	gcc_slot_14_3? (
		=sys-devel/gcc-14.3*
	)
	llvm_slot_19? (
		=llvm-core/clang-19*
		=llvm-core/lld-19*
		=llvm-core/llvm-19*
	)
"
DEPEND+="
"
