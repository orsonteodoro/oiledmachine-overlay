# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-compiler-switch flag-o-matic multilib-minimal

SRC_URI="
mirror://sourceforge/hunspell/${P}.tar.gz
"

DESCRIPTION="ALTLinux hyphenation library"
HOMEPAGE="
	http://hunspell.github.io/
	https://sourceforge.net/projects/hunspell/
"
LICENSE="
	GPL-2
	LGPL-2.1
	MPL-1.1
"
KEYWORDS="~amd64"
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

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

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
