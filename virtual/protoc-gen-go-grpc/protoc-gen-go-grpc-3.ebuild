# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD="ignore"
LIBCXX_SLOT_VERIFY="0"
LIBSTDCXX_SLOT_VERIFY="0"

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_LTS[@]}
)

DESCRIPTION="A virtual package to manage protoc-gen-go-grpc stability"
LICENSE="metapackage"
VERSIONS_MONITORED="1.3.0"
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
	dev-go/protoc-gen-go-grpc:3/1.3
	dev-go/protoc-gen-go-grpc:=
"
DEPEND+="
"
