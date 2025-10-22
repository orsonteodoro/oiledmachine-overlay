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

DESCRIPTION="A virtual package to manage Protobuf C++ stability"
LICENSE="metapackage"
VERSIONS_MONITORED="6.33"
SLOT="6/${VERSIONS_MONITORED}"
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
	!virtual/protobuf:0
	dev-libs/protobuf:6/6.33[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	dev-libs/protobuf:=
"
DEPEND+="
"
