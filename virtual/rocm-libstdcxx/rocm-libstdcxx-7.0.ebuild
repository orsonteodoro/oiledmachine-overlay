# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# There is a situation where the rocm eclass has a contradiction for has_version
# where the ebuild doesn't exist yet.  Force the initial libstdc++ version
# choice before building ROCm the stack.  This ebuild is to increase the build
# configuration stable state.  Users can be eager to do compiler switches due
# to new package versions or distro version bumps but should not do it.

GCC_COMPAT=(
	"gcc_slot_12_5"
	"gcc_slot_13_4"
)

DESCRIPTION="A virtual package to manage the underlying ROCm libstdc++ dependency choice"
LICENSE="metapackage"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="
${GCC_COMPAT[@]}
"
REQUIRED_USE="
	^^ (
		${GCC_COMPAT[@]}
	)
"

RDEPEND+="
"
DEPEND+="
"
