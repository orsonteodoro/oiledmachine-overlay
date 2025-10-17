# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild avoids:
# !!! Multiple package instances within a single package slot have been pulled
# !!! into the dependency graph, resulting in a slot conflict:

inherit libstdcxx-compat multilib-build
GCC_COMPAT=(
	"gcc_slot_11_5" # Support U22, LTS
	"gcc_slot_12_5" # Support D12, LTS
	"gcc_slot_13_4" # Support U24, LTS
	"gcc_slot_14_3" # Support D13, LTS
	"gcc_slot_15_2" # Support F43, Rolling
	${LIBSTDCXX_COMPAT_LTS[@]}
)

inherit libstdcxx-slot

DESCRIPTION="A virtual package to manage Protobuf stability"
LICENSE="metapackage"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="
${GCC_COMPAT[@]}
ebuild_revision_1
"
REQUIRED_USE="
	^^ (
		${GCC_COMPAT[@]}
	)
"
RDEPEND+="
	gcc_slot_11_5? (
		=dev-libs/protobuf-3.12*[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	)
	gcc_slot_12_5? (
		=dev-libs/protobuf-3.21*[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	)
	gcc_slot_13_4? (
		=dev-libs/protobuf-3.21*[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	)
	gcc_slot_14_3? (
		=dev-libs/protobuf-3.21*[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	)
	gcc_slot_15_2? (
		=dev-libs/protobuf-3.19*[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	)
	dev-libs/protobuf:=
"
DEPEND+="
"
