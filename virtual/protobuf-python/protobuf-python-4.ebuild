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

CXX_STANDARD="ignore"
LIBCXX_SLOT_VERIFY=0
LIBSTDCXX_SLOT_VERIFY=0
PYTHON_COMPAT=( "python3_"{11..13} )

inherit libstdcxx-compat
GCC_COMPAT=(
	gcc_slot_12_5
	gcc_slot_13_4
	gcc_slot_14_3
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_LTS[@]/llvm_slot_}
)

inherit libcxx-slot libstdcxx-slot python-r1

DESCRIPTION="A virtual package to manage dev-python/protobuf stability"
LICENSE="metapackage"
VERSIONS_MONITORED="4.21-4.25"
SLOT="4/${VERSIONS_MONITORED}" # 4/ is the major version of protobuf-python not protobuf-cpp
KEYWORDS="~amd64"
IUSE="
ebuild_revision_3
"
REQUIRED_USE="
	^^ (
		${GCC_COMPAT[@]}
	)
"
RDEPEND+="
	!virtual/protobuf-python:0
	gcc_slot_12_5? (
		dev-python/protobuf:4.21/4.21[${PYTHON_USEDEP}]
		dev-python/protobuf:4.25/4.25[${PYTHON_USEDEP}]
	)
	gcc_slot_13_4? (
		dev-python/protobuf:4.21/4.21[${PYTHON_USEDEP}]
		dev-python/protobuf:4.25/4.25[${PYTHON_USEDEP}]
	)
	gcc_slot_14_3? (
		dev-python/protobuf:4.21/4.21[${PYTHON_USEDEP}]
		dev-python/protobuf:4.25/4.25[${PYTHON_USEDEP}]
	)
	llvm_slot_18? (
		dev-python/protobuf:4.21/4.21[${PYTHON_USEDEP}]
		dev-python/protobuf:4.25/4.25[${PYTHON_USEDEP}]
	)
	llvm_slot_19? (
		dev-python/protobuf:4.21/4.21[${PYTHON_USEDEP}]
		dev-python/protobuf:4.25/4.25[${PYTHON_USEDEP}]
	)
	dev-python/protobuf:=
"
DEPEND+="
"
