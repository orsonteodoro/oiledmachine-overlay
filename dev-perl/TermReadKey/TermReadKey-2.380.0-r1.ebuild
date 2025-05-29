# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Add retpoline for kpcli
CFLAGS_HARDENED_FORTIFY_FIX_LEVEL=3
CFLAGS_HARDENED_USE_FLAGS="security-critical sensitive-data"
DIST_AUTHOR="JSTOWE"
DIST_VERSION="2.38"
DIST_EXAMPLES=( "example/*" )

inherit cflags-hardened perl-module

KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86
~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
"

DESCRIPTION="Change terminal modes, and perform non-blocking reads"
SLOT="0"
IUSE="
ebuild_revision_7
"
BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.580.0
"
PATCHES=(
	"${FILESDIR}/${P}-configure-clang16.patch"
)

src_configure() {
	cflags-hardened_append
	perl-module_src_configure
}
