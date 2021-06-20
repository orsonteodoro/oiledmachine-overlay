# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic libtool multilib-minimal toolchain-funcs

DESCRIPTION="Free and Open Source spell checker designed to replace Ispell"
HOMEPAGE="http://aspell.net/"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390
sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris
~x86-solaris"
IUSE+=" nls unicode"
# All available language app-dicts/aspell-* packages.
LANGUAGES=( af am ar ast az be bg bn br ca cs csb cy da de de-1901 el en eo es
et fa fi fo fr fy ga gd gl grc gu gv he hi hil hr hsb hu hus hy ia id is it kn
ku ky la lt lv mg mi mk ml mn mr ms mt nb nds nl nn no ny or pa pl pt-PT pt-BR
qu ro ru rw sc sk sl sr sv sw ta te tet tk tl tn tr uk uz vi wa yi zu )
for LANG in ${LANGUAGES[@]}; do
	IUSE+=" l10n_${LANG}"
	case ${LANG} in
		de-1901) DICT="de-alt" ;;
		pt-BR) DICT="pt-br" ;;
		pt-PT) DICT="pt" ;;
		*) DICT="${LANG}" ;;
	esac
	PDEPEND+=" l10n_${LANG}? ( app-dicts/aspell-${DICT} )"
done
unset DICT LANG LANGUAGES
RDEPEND+="
	sys-libs/ncurses:0=[${MULTILIB_USEDEP},unicode?]
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	nls? ( sys-devel/gettext[${MULTILIB_USEDEP}] )"
HTML_DOCS=( manual/aspell{,-dev}.html )
MY_P="${P/_/-}"
SRC_URI="mirror://gnu/aspell/${MY_P}.tar.gz"
PATCHES=(
	"${FILESDIR}/${PN}-0.60.5-nls.patch"
	"${FILESDIR}/${PN}-0.60.5-solaris.patch"
	"${FILESDIR}/${PN}-0.60.6-darwin-bundles.patch"
	"${FILESDIR}/${PN}-0.60.6.1-clang.patch"
	"${FILESDIR}/${PN}-0.60.6.1-unicode.patch"
)
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	rm m4/lt* m4/libtool.m4 || die
	eautoreconf
	elibtoolize --reverse-deps
	# Parallel install of libtool libraries doesn't always work.
	# https://lists.gnu.org/archive/html/libtool/2011-03/msg00003.html
	# This has to be after automake has run so that we don't clobber
	# the default target that automake creates for us.
	echo 'install-filterLTLIBRARIES: install-libLTLIBRARIES' \
		>> Makefile.in || die
	# The unicode patch breaks on Darwin as NCURSES_WIDECHAR won't get set
	# any more.
	[[ ${CHOST} == *-darwin* ]] || [[ ${CHOST} == *-musl* ]] \
		&& use unicode && append-cppflags -DNCURSES_WIDECHAR=1
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		--sysconfdir="${EPREFIX}"/etc/aspell
		$(use_enable nls)
		$(use_enable unicode)
	)
	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default
	docinto examples
	dodoc "${S}"/examples/*.c
	# Install Aspell/Ispell compatibility scripts.
	newbin scripts/ispell ispell-aspell
	newbin scripts/spell spell-aspell
	# As static build has been disabled,
	# all .la files can be deleted unconditionally.
	find "${ED}" -type f -name '*.la' -delete || die
}
