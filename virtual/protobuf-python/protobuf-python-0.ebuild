# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is WIP.  It may accomodate additional rolling pairs.

# This ebuild avoids:
# !!! Multiple package instances within a single package slot have been pulled
# !!! into the dependency graph, resulting in a slot conflict:

# Some ebuilds will use a rolling release of protobuf-python 5.x in their
# Dockerfile, especially AI packages, while a ebuild packager will overlook the
# consequences, but it will conflict with the monoslot LTS protobuf 3.x used by
# LTS distros and possibly binary packages.  To mix the LTS Protobuf and the
# rolling release Protobuf, there are two choices to support both the LTS
# protobuf and rolling protobuf.

# 1. Use Dockerfile (not preferred on this distro)
# 2. Multisloting the following packages
#    - protobuf in /usr/lib/protobuf/{4,5}
#    - gRPC in /usr/lib/grpc/1.75.1
#    - abseil-cpp in /usr/lib/abseil-cpp/20250512.1

inherit libstdcxx-compat
GCC_COMPAT=(
	"gcc_slot_11_5" # Support U22, LTS
	"gcc_slot_12_5" # Support D12, LTS
	"gcc_slot_13_4" # Support U24, LTS
	"gcc_slot_14_3" # Support D13, LTS
	"gcc_slot_15_2" # Support F43, Rolling
	${LIBSTDCXX_COMPAT_LTS[@]}
)
PYTHON_COMPAT=( "python3_"{11..13} )

inherit libstdcxx-slot python-single-r1

DESCRIPTION="A virtual package to manage dev-python/protobuf stability"
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
	$(python_gen_cond_dep '
		gcc_slot_11_5? (
			dev-python/protobuf:0/3.12[${PYTHON_USEDEP}]
		)
		gcc_slot_12_5? (
			dev-python/protobuf:0/4.21[${PYTHON_USEDEP}]
		)
		gcc_slot_13_4? (
			dev-python/protobuf:0/4.21[${PYTHON_USEDEP}]
		)
		gcc_slot_14_3? (
			dev-python/protobuf:0/4.21[${PYTHON_USEDEP}]
		)
		gcc_slot_15_2? (
			dev-python/protobuf:0/3.19[${PYTHON_USEDEP}]
		)
	')
	dev-python/protobuf:=
"
DEPEND+="
"
