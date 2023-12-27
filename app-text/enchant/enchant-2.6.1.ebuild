# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

SRC_URI="
https://github.com/AbiWord/enchant/releases/download/v${PV}/${P}.tar.gz
"

DESCRIPTION="Generic spell checking library"
HOMEPAGE="https://abiword.github.io/enchant/"
LICENSE="LGPL-2.1+"
SLOT="2/${PV}"
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos
"
# Default enabled is based on CI.
# test is enabled in CI.
IUSE+="
+aspell +hunspell +nuspell test +voikko
"
REQUIRED_USE="
	|| (
		aspell
		hunspell
		nuspell
	)
"
# CI uses U 22.04.2
RDEPEND+="
	!<app-text/enchant-1.6.1-r2:0
	>=dev-libs/glib-2.72.4:2[${MULTILIB_USEDEP}]
	aspell? (
		>=app-text/aspell-0.60.8[${MULTILIB_USEDEP}]
	)
	hunspell? (
		>=app-text/hunspell-1.7.0:0=[${MULTILIB_USEDEP}]
	)
	nuspell? (
		>=app-text/nuspell-5.1.0:0=
	)
	voikko? (
		>=dev-libs/libvoikko-2.4
	)
"
# nuspell needs multilib ?
DEPEND+="
	${RDEPEND}
	test? (
		>=dev-libs/unittest++-2.0.0-r2[${MULTILIB_USEDEP}]
	)
"
BDEPEND+="
	>=dev-util/pkgconf-1.8.0[${MULTILIB_USEDEP},pkg-config(+)]
"
QA_CONFIG_IMPL_DECL_SKIP=(
	alignof
	static_assert
	unreachable
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		$(multilib_native_usex nuspell)
		$(multilib_native_usex voikko)
		$(use_enable test relocatable)
		$(use_with aspell)
		$(use_with hunspell)
		--disable-static
		--with-hunspell-dir="${EPREFIX}"/usr/share/hunspell/
		--without-applespell
		--without-hspell
		--without-zemberek
	)
	econf "${myconf[@]}"
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.5.0 (20230602)
# Both 32-bit and 64-bit tested:
# ============================================================================
# Testsuite summary for enchant 2.5.0
# ============================================================================
# # TOTAL: 2
# # PASS:  2
# # SKIP:  0
# # XFAIL: 0
# # FAIL:  0
# # XPASS: 0
# # ERROR: 0
# ============================================================================
