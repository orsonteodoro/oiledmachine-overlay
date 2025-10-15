# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# On the distro, the build system stable state is not actually stable
# due to lack of robust ebuilds and user ignorance.
# This ebuild tries to increase the stability of the configuration.

# Users are able to change the build system configuration contract due to
# pressures from distro version bumps from CI images and new ebuilds that are
# pressured to bump dependencies to newer compilers.  This ebuild tries to
# enforce a version contract so that to avoid ABI version symbol issues or
# linker issues.  A change in this contract (i.e. changing USE flags in this
# virtual package) requires all CUDA based packages to be rebuilt.

GCC_COMPAT=(
	"gcc_slot_11_5"
	"gcc_slot_12_5"
)

LLVM_COMPAT=(
	"llvm_slot_15"
	"llvm_slot_16"
	"llvm_slot_17"
)

DESCRIPTION="A virtual package to manage the underlying CUDA compiler dependency choices"
LICENSE="metapackage"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="
${GCC_COMPAT[@]}
${LLVM_COMPAT[@]}
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
"
DEPEND+="
"
