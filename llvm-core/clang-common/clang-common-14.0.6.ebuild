# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 llvm.org

KEYWORDS="
amd64 arm arm64 ~ppc ppc64 ~riscv sparc x86 ~amd64-linux ~ppc-macos ~x64-macos
"

DESCRIPTION="Common files shared between multiple slots of clang"
HOMEPAGE="https://llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	UoI-NCSA
"
SLOT="0"
PDEPEND="
	llvm-core/clang:*
"
LLVM_COMPONENTS=(
	"clang/utils"
)
llvm.org_set_globals

src_install() {
	newbashcomp bash-autocomplete.sh clang
}
