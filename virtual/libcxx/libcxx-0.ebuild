# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Manages libc++ versioning"
KEYWORDS="
~alpha ~amd64 ~arm ~hppa ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
"
IUSE=" cxx98 cxx03 cxx11 cxx14 cxx17 cxx20 cxx23 cxx26"
RDEPEND="
	cxx98? (
		>=llvm-runtimes/libcxx-18.1.8
	)
	cxx03? (
		>=llvm-runtimes/libcxx-18.1.8
	)
	cxx11? (
		>=llvm-runtimes/libcxx-18.1.8
	)
	cxx14? (
		>=llvm-runtimes/libcxx-18.1.8
	)
	cxx17? (
		>=llvm-runtimes/libcxx-20.1.8
	)
	cxx20? (
		>=llvm-runtimes/libcxx-20.1.8
	)
	cxx23? (
		>=llvm-runtimes/libcxx-21.1.3
	)
	cxx26? (
		>=llvm-runtimes/libcxx-21.1.3
	)
"
SLOT="0"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
