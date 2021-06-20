# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://abiword.github.io/enchant/"
LICENSE="LGPL-2.1+"
SLOT="2/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86
~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE+=" aspell +hunspell test voikko"
REQUIRED_USE+=" || ( hunspell aspell )"
RDEPEND+="
	>=dev-libs/glib-2.6:2[${MULTILIB_USEDEP}]
	aspell? ( app-text/aspell[${MULTILIB_USEDEP}] )
	hunspell? ( >=app-text/hunspell-1.2.1:0=[${MULTILIB_USEDEP}] )
	voikko? ( dev-libs/libvoikko[${MULTILIB_USEDEP}] )"
DEPEND+=" ${RDEPEND}
	test? ( >=dev-libs/unittest++-2.0.0-r2[${MULTILIB_USEDEP}] )"
BDEPEND+="
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)"
SRC_URI="
https://github.com/AbiWord/enchant/releases/download/v${PV}/${P}.tar.gz"
RESTRICT="test" # Tests fail

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	# TODO: Add app-text/nuspell support
	econf \
		--datadir="${EPREFIX}"/usr/share/enchant-2 \
		--disable-static \
		$(use_enable test relocatable) \
		$(use_with aspell) \
		$(use_with hunspell) \
		$(use_with voikko) \
		--without-nuspell \
		--without-hspell \
		--without-applespell \
		--without-zemberek \
		--with-hunspell-dir="${EPREFIX}"/usr/share/hunspell/
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
