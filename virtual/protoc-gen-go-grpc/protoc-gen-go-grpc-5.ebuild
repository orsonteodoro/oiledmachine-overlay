# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_LTS[@]}
)

DESCRIPTION="A virtual package to manage protoc-gen-go-grpc stability"
LICENSE="metapackage"
VERSIONS_MONITORED="1.5.1"
SLOT="3/${VERSIONS_MONITORED}"
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
	!virtual/protoc-gen-go-grpc:0
	dev-go/protoc-gen-go-grpc:5/1.5
	dev-go/protoc-gen-go-grpc:=
"
DEPEND+="
"
