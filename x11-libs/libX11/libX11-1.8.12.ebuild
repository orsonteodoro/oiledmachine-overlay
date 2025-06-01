# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: Please bump this with x11-misc/compose-tables

# HACK: libX11 produces .pc files that depend on xproto.pc. When libX11
#       is installed as a binpkg, DEPEND packages are not pulled in,
#       but to build source packages against libX11, xorg-proto is
#       needed. Until a "build-against-depend" option is available in
#       ebuilds, we RDEPEND on xproto. See bug #903707 and others.

# Add retpoline for end-to-end copy-paste
CFLAGS_HARDENED_LANGS="c-lang"
CFLAGS_HARDENED_USE_CASES="copy-paste-password sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DF DOS IO OOBR OOBW PE"
XORG_DOC=doc
XORG_MULTILIB=yes

inherit cflags-hardened toolchain-funcs xorg-3

KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86
~amd64-linux ~x86-linux ~ppc-macos ~x64-macos
"

DESCRIPTION="X.Org X11 library"
IUSE="
test
ebuild_revision_8
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	>=x11-libs/libxcb-1.11.1[${MULTILIB_USEDEP}]
	x11-misc/compose-tables
	x11-base/xorg-proto
"
DEPEND="
	${RDEPEND}
	x11-libs/xtrans
"
BDEPEND="
	test? (
		dev-lang/perl
	)
"

src_configure() {
	cflags-hardened_append
	local XORG_CONFIGURE_OPTIONS=(
		$(use_with doc xmlto)
		$(use_enable doc specs)
		--enable-ipv6
		--without-fop
		--with-keysymdefdir="${ESYSROOT}/usr/include/X11"
		CPP="$(tc-getPROG CPP cpp)"
	)
	xorg-3_src_configure
}

src_install() {
	xorg-3_src_install
	rm -rf "${ED}/usr/share/X11/locale" || die
}
