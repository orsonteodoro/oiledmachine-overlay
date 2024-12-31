# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

KEYWORDS="
amd64 arm arm64 ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos
"
SRC_URI=""

DESCRIPTION="A meta-ebuild for the Clang runtime libraries"
HOMEPAGE="https://clang.llvm.org/"
LICENSE="metapackage"
SLOT="$(ver_cut 1-3)"
IUSE+=" +compiler-rt libcxx openmp pstl +sanitize"
REQUIRED_USE="
	sanitize? (
		compiler-rt
	)
"
RDEPEND="
	compiler-rt? (
		~llvm-runtimes/compiler-rt-${PV}:${SLOT}
		sanitize? (
			~llvm-runtimes/compiler-rt-sanitizers-${PV}:${SLOT}
		)
	)
	libcxx? (
		>=llvm-runtimes/libcxx-${PV}[${MULTILIB_USEDEP}]
	)
	openmp? (
		llvm-runtimes/openmp:${PV%%.*}[${MULTILIB_USEDEP}]
	)
	pstl? (
		llvm-core/pstl:${PV%%.*}
	)
"
