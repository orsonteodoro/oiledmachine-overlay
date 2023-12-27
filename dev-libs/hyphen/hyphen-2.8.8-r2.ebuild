# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

SRC_URI="
mirror://sourceforge/hunspell/${P}.tar.gz
"

DESCRIPTION="ALTLinux hyphenation library"
HOMEPAGE="http://hunspell.github.io/"
LICENSE="
	GPL-2
	LGPL-2.1
	MPL-1.1
"
KEYWORDS="
~alpha amd64 ~amd64-linux arm ~arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-linux
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="static-libs"
RDEPEND="
	app-text/hunspell[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
"
DOCS=(
	AUTHORS
	ChangeLog
	NEWS
	README{,.nonstandard,.hyphen,.compound}
	THANKS
	TODO
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	econf $(use_enable static-libs static)
}

multilib_src_install() {
	default
	docinto pdf
	dodoc doc/*.pdf
	rm -r "${ED}"/usr/share/hyphen || die
	rm "${ED}"/usr/lib*/libhyphen.la || die
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
