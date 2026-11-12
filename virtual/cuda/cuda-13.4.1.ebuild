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
	"llvm_slot_19"
	"llvm_slot_20"
	"llvm_slot_21"
	"llvm_slot_22"
)

DESCRIPTION="CUDA requirements"
LICENSE="metapackage"
SLOT=$(ver_cut "1" "${PV}")"/"$(ver_cut "1-2" "${PV}")
KEYWORDS="~amd64"
IUSE="
${GCC_COMPAT[@]}
${LLVM_COMPAT[@]}
cudnn profiler
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
	=dev-util/nvidia-cuda-toolkit-13.4*[profiler?]
	>=x11-drivers/nvidia-drivers-590
	cudnn? (
		dev-libs/cudnn:=
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
	llvm_slot_19? (
		=llvm-core/clang-19*
		=llvm-core/lld-19*
		=llvm-core/llvm-19*
	)
	llvm_slot_19? (
		=llvm-core/clang-20*
		=llvm-core/lld-20*
		=llvm-core/llvm-20*
	)
	llvm_slot_19? (
		=llvm-core/clang-21*
		=llvm-core/lld-21*
		=llvm-core/llvm-21*
	)
	llvm_slot_19? (
		=llvm-core/clang-22*
		=llvm-core/lld-22*
		=llvm-core/llvm-22*
	)
"
DEPEND+="
"
