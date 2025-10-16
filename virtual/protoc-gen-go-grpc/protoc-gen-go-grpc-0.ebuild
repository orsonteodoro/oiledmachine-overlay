# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	"gcc_slot_11_5" # Support U22, LTS
	"gcc_slot_12_5" # Support D12, LTS
	"gcc_slot_13_4" # Support U24, LTS
	"gcc_slot_14_3" # Support D13, LTS
	"gcc_slot_15_2" # Support F43, Rolling
	${LIBSTDCXX_COMPAT_LTS[@]}
)

DESCRIPTION="A virtual package to manage protoc-gen-go-grpc stability"
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
	gcc_slot_11_5? (
		=dev-go/protoc-gen-go-grpc-0_p6*
	)
	gcc_slot_12_5? (
		=dev-go/protoc-gen-go-grpc-1.3.0*
	)
	gcc_slot_13_4? (
		=dev-go/protoc-gen-go-grpc-1.3.0*
	)
	gcc_slot_14_3? (
		=dev-go/protoc-gen-go-grpc-1.3.0*
	)
	gcc_slot_15_2? (
		=dev-go/protoc-gen-go-grpc-1.3.0*
	)
	dev-go/protoc-gen-go-grpc:=
"
DEPEND+="
"
