# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://abiword.github.io/enchant/"
LICENSE="LGPL-2.1+"
SLOT="2/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64
~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE+=" aspell +hunspell nuspell test voikko"
REQUIRED_USE="|| ( aspell hunspell nuspell )"
RDEPEND+="
	!<app-text/enchant-1.6.1-r2:0
	>=dev-libs/glib-2.6:2[${MULTILIB_USEDEP}]
	aspell? ( app-text/aspell[${MULTILIB_USEDEP}] )
	hunspell? ( >=app-text/hunspell-1.2.1:0=[${MULTILIB_USEDEP}] )
	nuspell? ( >=app-text/nuspell-5.1.0:0= )
	voikko? ( dev-libs/libvoikko )"
# nuspell needs multilib ?
DEPEND+=" ${RDEPEND}
	test? ( >=dev-libs/unittest++-2.0.0-r2[${MULTILIB_USEDEP}] )"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]"
SRC_URI="
https://github.com/AbiWord/enchant/releases/download/v${PV}/${P}.tar.gz"
RESTRICT="!test? ( test )"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		--disable-static
		$(use_enable test relocatable)
		$(use_with aspell)
		$(use_with hunspell)
		$(multilib_native_usex nuspell)
		$(multilib_native_usex voikko)
		--without-hspell
		--without-applespell
		--without-zemberek
		--with-hunspell-dir="${EPREFIX}"/usr/share/hunspell/
	)
	econf "${myconf[@]}"
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
