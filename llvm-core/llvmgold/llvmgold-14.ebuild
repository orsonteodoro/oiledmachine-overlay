# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S="${WORKDIR}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv sparc x86 ~amd64-linux"

DESCRIPTION="LLVMgold plugin symlink for autoloading"
HOMEPAGE="https://llvm.org/"
LICENSE="public-domain"
SLOT="0"
RDEPEND="
	!llvm-core/llvm:0
	llvm-core/llvm:${PV}[binutils-plugin]
"

src_install() {
	dodir "/usr/${CHOST}/binutils-bin/lib/bfd-plugins"
	dosym \
		"../../../../lib/llvm/${PV}/$(get_libdir)/LLVMgold.so" \
		"/usr/${CHOST}/binutils-bin/lib/bfd-plugins/LLVMgold.so"
}
