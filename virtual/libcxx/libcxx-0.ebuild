# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

_CXX_STANDARD=(
	"cxx_standard_cxx98"
	"cxx_standard_cxx03"
	"cxx_standard_cxx11"
	"cxx_standard_cxx14"
	"cxx_standard_cxx17"
	"cxx_standard_cxx20"
	"cxx_standard_cxx23"
	"cxx_standard_cxx26"
)

DESCRIPTION="Manages libc++ versioning"
KEYWORDS="
~alpha ~amd64 ~arm ~hppa ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
"
IUSE="
${_CXX_STANDARD[@]}
"
RDEPEND="
	cxx_standard_cxx98? (
		>=llvm-runtimes/libcxx-18.1.8
	)
	cxx_standard_cxx03? (
		>=llvm-runtimes/libcxx-18.1.8
	)
	cxx_standard_cxx11? (
		>=llvm-runtimes/libcxx-18.1.8
	)
	cxx_standard_cxx14? (
		>=llvm-runtimes/libcxx-18.1.8
	)
	cxx_standard_cxx17? (
		>=llvm-runtimes/libcxx-20.1.8
	)
	cxx_standard_cxx20? (
		>=llvm-runtimes/libcxx-20.1.8
	)
	cxx_standard_cxx23? (
		>=llvm-runtimes/libcxx-21.1.3
	)
	cxx_standard_cxx26? (
		>=llvm-runtimes/libcxx-21.1.3
	)
"
SLOT="0"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
