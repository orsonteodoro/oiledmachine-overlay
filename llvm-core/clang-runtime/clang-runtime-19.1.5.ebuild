# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Last update:  2024-03-18

inherit multilib-build toolchain-funcs

KEYWORDS="
~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux
~arm64-macos ~ppc-macos ~x64-macos
"

DESCRIPTION="A meta-ebuild for the Clang runtime libraries"
HOMEPAGE="https://clang.llvm.org/"
LICENSE="metapackage"
SLOT="${PV%%.*}"
IUSE="+compiler-rt libcxx openmp pstl +sanitize"
REQUIRED_USE="
	sanitize? (
		compiler-rt
	)
"
RDEPEND="
	compiler-rt? (
		~llvm-runtimes/compiler-rt-${PV}:${SLOT}[abi_x86_32(+)?,abi_x86_64(+)?]
		sanitize? (
			~llvm-runtimes/compiler-rt-sanitizers-${PV}:${SLOT}[abi_x86_32(+)?,abi_x86_64(+)?]
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

pkg_pretend() {
	if tc-is-clang; then
ewarn
ewarn "You seem to be using clang as a system compiler.  As of clang-16,"
ewarn "upstream has turned a few warnings that commonly occur during configure"
ewarn "script runs into errors by default.  This causes some configure tests to"
ewarn "start failing, sometimes resulting in silent breakage, missing"
ewarn "functionality or runtime misbehavior.  It is not yet clear whether the"
ewarn "change will remain or be reverted."
ewarn
ewarn "For more information, please see:"
ewarn
ewarn "  https://discourse.llvm.org/t/configure-script-breakage-with-the-new-werror-implicit-function-declaration/65213"
ewarn
	fi
}
