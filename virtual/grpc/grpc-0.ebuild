# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild avoids:
# !!! Multiple package instances within a single package slot have been pulled
# !!! into the dependency graph, resulting in a slot conflict:

CXX_STANDARD="ignore"

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_LTS[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_LTS[@]/llvm_slot_}
)

inherit libcxx-slot libstdcxx-slot multilib-build

DESCRIPTION="A virtual package to manage gRPC stability"
LICENSE="metapackage"
VERSIONS_MONITORED="1.30-1.51"
SLOT="0/${VERSIONS_MONITORED}"
KEYWORDS="~amd64"
IUSE="
ebuild_revision_1
"
REQUIRED_USE="
	^^ (
		${GCC_COMPAT[@]}
	)
"
RDEPEND+="
	gcc_slot_11_5? (
		net-libs/grpc:3/1.30[${MULTILIB_USEDEP},gcc_slot_11_5]
	)
	gcc_slot_12_5? (
		net-libs/grpc:3/1.51[${MULTILIB_USEDEP},gcc_slot_12_5]
	)
	gcc_slot_13_4? (
		net-libs/grpc:3/1.51[${MULTILIB_USEDEP},gcc_slot_13_4]
	)
	gcc_slot_14_3? (
		net-libs/grpc:3/1.51[${MULTILIB_USEDEP},gcc_slot_14_3]
	)
	llvm_slot_18? (
		net-libs/grpc:3/1.51[${MULTILIB_USEDEP},llvm_slot_18]
	)
	llvm_slot_19? (
		net-libs/grpc:3/1.51[${MULTILIB_USEDEP},llvm_slot_19]
	)
	net-libs/grpc:=
	virtual/protobuf:3[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	virtual/protobuf:=
"
DEPEND+="
"
