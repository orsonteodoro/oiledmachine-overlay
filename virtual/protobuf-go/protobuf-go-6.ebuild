# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A virtual package to manage protobuf-go stability"
LICENSE="metapackage"
PROTOBUF_SLOT="6"
VERSIONS_MONITORED="1.36.10"
SLOT="${PROTOBUF_SLOT}/${VERSIONS_MONITORED}"
KEYWORDS="~amd64"
IUSE="
${GCC_COMPAT[@]}
ebuild_revision_1
"
REQUIRED_USE="
"
RDEPEND+="
	dev-go/protobuf-go:${PROTOBUF_SLOT}
	dev-go/protobuf-go:=
"
DEPEND+="
"
