# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://abiword.github.io/enchant/"
LICENSE="LGPL-2.1+"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 \
~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
SLOT="2"
IUSE="aspell +hunspell"
REQUIRED_USE="|| ( hunspell aspell )"
inherit multilib-minimal
RDEPEND="
	>=dev-libs/glib-2.6:2[${MULTILIB_USEDEP}]
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
SRC_URI=\
"https://github.com/AbiWord/enchant/releases/download/v${PV}/${P}.tar.gz"
RESTRICT="test"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	# TODO: Add app-text/nuspell support
	econf \
		--datadir="${EPREFIX}"/usr/share/enchant-2 \
		--disable-static \
		$(use_with aspell) \
		$(use_with hunspell) \
		--without-nuspell \
		--without-hspell \
		--without-voikko \
		--without-applespell \
		--without-zemberek \
		--with-hunspell-dir="${EPREFIX}"/usr/share/hunspell/
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
