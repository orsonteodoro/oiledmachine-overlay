# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HSA_CODE_OBJECT_VERSION=(
	"+hsa-code-object-v4"
	"hsa-code-object-v5"
)

DESCRIPTION="HSA code object Version consistency"
KEYWORDS="~amd64 ~arm64"
LICENSE="metapackage"
SLOT="0"
IUSE="
${HSA_CODE_OBJECT_VERSION[@]}
"
REQUIRED_USE="
	^^ (
		${HSA_CODE_OBJECT_VERSION[@]/+}
	)
"
