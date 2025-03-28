# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit llvm.org

KEYWORDS="
amd64 arm arm64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos
"

DESCRIPTION="Common files shared between multiple slots of LLVM"
HOMEPAGE="https://llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	UoI-NCSA
"
SLOT="0"
IUSE=""
RDEPEND="
	!llvm-core/llvm:0
"
LLVM_COMPONENTS=(
	"llvm/utils/vim"
)
llvm.org_set_globals

src_install() {
	insinto "/usr/share/vim/vimfiles"
	doins -r *"/"
	# some users may find it useful
	newdoc "README" "README.vim"
	dodoc "vimrc"
}
