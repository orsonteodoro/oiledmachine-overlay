# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"
TEST_TARBALL="aspell6-en-2018.04.16-0.tar.bz2"

inherit autotools flag-o-matic libtool multilib-minimal toolchain-funcs

SRC_URI="
mirror://gnu/aspell/${MY_P}.tar.gz
test? (
	ftp://ftp.gnu.org/gnu/aspell/dict/en/${TEST_TARBALL}
)
"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Free and Open Source spell checker designed to replace Ispell"
HOMEPAGE="
http://aspell.net/
https://github.com/GNUAspell/aspell
"
LICENSE="
	LGPL-2+
	LGPL-2.1
	LGPL-2.1+
	BSD
	FDL-1.1+
	FDL-1.2
	GPL-2+
	GPL-3+
	MIT
	myspell-en_CA-KevinAtkinson
"
# BSD - myspell/munch.c
# BSD LGPL-2.1 - modules/speller/default/affix.cpp
# GPL-2+ - m4/libtool.m4
#	 - misc/po-filter.c
# GPL-3+ - config.guess
#	 - manual/texinfo.tex
# FDL-1.1+ - manual/aspell-dev.info
# FDL-1.2 - manual/fdl.texi
# LGPL-2+ - common/gettext.h
# LGPL-2.1+ - modules/filter/nroff.cpp
# MIT - install-sh
# myspell-en_CA-KevinAtkinson - common/lsort.hpp
#			      - common/clone_ptr-t.hpp
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv
~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos
"
IUSE+=" nls regex test unicode"
# All available language app-dicts/aspell-* packages.
LANGUAGES=(
af am ar ast az be bg bn br ca cs csb cy da de de-1901 el en eo es et fa fi fo
fr fy ga gd gl grc gu gv he hi hil hr hsb hu hus hy ia id is it kn ku ky la lt
lv mg mi mk ml mn mr ms mt nb nds nl nn no ny or pa pl pt-PT pt-BR qu ro ru rw
sc sk sl sr sv sw ta te tet tk tl tn tr uk uz vi wa yi zu
)
for LANG in ${LANGUAGES[@]}; do
	IUSE+="
		l10n_${LANG}
	"
	case ${LANG} in
		de-1901) DICT="de-alt" ;;
		pt-BR) DICT="pt-br" ;;
		pt-PT) DICT="pt" ;;
		*) DICT="${LANG}" ;;
	esac
	PDEPEND+="
		l10n_${LANG}? (
			app-dicts/aspell-${DICT}
		)
	"
done
unset DICT LANG LANGUAGES
RDEPEND+="
	sys-libs/ncurses:0=[${MULTILIB_USEDEP},unicode(+)]
	nls? (
		>=virtual/libintl-0-r1[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	nls? (
		sys-devel/gettext[${MULTILIB_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.60.5-nls.patch"
	"${FILESDIR}/${PN}-0.60.5-solaris.patch"
	"${FILESDIR}/${PN}-0.60.6-darwin-bundles.patch"
	"${FILESDIR}/${PN}-0.60.6.1-clang.patch"
	"${FILESDIR}/${PN}-0.60.6.1-unicode.patch"
	"${FILESDIR}/${PN}-0.60.8.1-gcc.patch" # For the test USE flag, oiledmachine-overlay added
)

get_build_type() {
	echo "production"
	use test && echo "test"
}

src_prepare() {
	default
	rm \
		m4/lt* \
		m4/libtool.m4 \
		|| die
	eautoreconf
	elibtoolize --reverse-deps
	# Parallel install of libtool libraries doesn't always work.
	# https://lists.gnu.org/archive/html/libtool/2011-03/msg00003.html
	# This has to be after automake has run so that we don't clobber
	# the default target that automake creates for us.
	echo 'install-filterLTLIBRARIES: install-libLTLIBRARIES' \
		>> Makefile.in \
		|| die
	# The unicode patch breaks on Darwin as NCURSES_WIDECHAR won't get set
	# any more.
	if \
		   [[ ${CHOST} == *-darwin* ]] \
		|| [[ ${CHOST} == *-musl* ]] \
		&& use unicode
	then
		append-cppflags -DNCURSES_WIDECHAR=1
	fi
	if use test ; then
		sed -i -e "s|curl|true|g" \
			test/Makefile || die
		cat "${DISTDIR}/${TEST_TARBALL}" \
			> "test/${TEST_TARBALL}" \
			|| die
	fi
	prepare_abi() {
		local build_type
		for build_type in $(get_build_type) ; do
			cp -a "${S}" "${S}-${MULTIBUILD_VARIANT}_${build_type}" || die
		done
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		local build_type
		for build_type in $(get_build_type) ; do
			cd "${S}-${MULTIBUILD_VARIANT}_${build_type}" || die
			local myeconfargs=(
				$(use_enable nls)
				$(use_enable regex)
				$(use_enable unicode)
				--disable-static
				--sysconfdir="${EPREFIX}/etc/aspell"
			)
			econf "${myeconfargs[@]}"
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		local build_type
		for build_type in $(get_build_type) ; do
			cd "${S}-${MULTIBUILD_VARIANT}_${build_type}" || die
			emake all || die
			if use test && [[ "${build_type}" == "test" ]] ; then
				emake distclean || die
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local build_type
		for build_type in $(get_build_type) ; do
			[[ "${build_type}" == "production" ]] && continue
			cd "${S}-${MULTIBUILD_VARIANT}_${build_type}" || die
			emake -C test
			rm test/build/Makefile || die
			emake SLOPPY=1 -C test
			local actual_result=$(sha1sum test/test-res | cut -f 1 -d " ")
			local expected_results=(
				"9520b5ad11a9f109196218a0bf45dd99db980096"
				"7efcc5386fafb59130450ed7956e96e3c178480f"
			)
			local found=0
			local expected_result
			for expected_result in ${expected_results[@]} ; do
				if [[ "${actual_result}" != "${expected_result}" ]] ; then
					found=1
				fi
			done
			if [[ "${found}" != "1" ]] ; then
eerror
eerror "Results does not match expected (test/test-res):"
eerror
cat "test/test-res"
eerror
				die
			fi
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local build_type
		for build_type in $(get_build_type) ; do
			[[ "${build_type}" == "test" ]] && continue
			cd "${S}-${MULTIBUILD_VARIANT}_${build_type}" || die
			default
			docinto examples
			dodoc "${S}"/examples/*.c
			# Install Aspell/Ispell compatibility scripts.
			newbin scripts/ispell ispell-aspell
			newbin scripts/spell spell-aspell
			# As static build has been disabled,
			# all .la files can be deleted unconditionally.
			find "${ED}" -type f -name '*.la' -delete || die
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	HTML_DOCS=( manual/aspell{,-dev}.html )
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib-support
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.60.8 (20230623)
# Both 32-bit and 64-bit tested
# USE="test -nls -regex -unicode"
# L10N="-af -am -ar -ast -az -be -bg -bn -br -ca -cs -csb -cy -da -de -de-1901
# -el -en -eo -es -et -fa -fi -fo -fr -fy -ga -gd -gl -grc -gu -gv -he -hi -hil
# -hr -hsb -hu -hus -hy -ia -id -is -it -kn -ku -ky -la -lt -lv -mg -mi -mk -ml
# -mn -mr -ms -mt -nb -nds -nl -nn -no -ny -or -pa -pl -pt-BR -pt-PT -qu -ro -ru
# -rw -sc -sk -sl -sr -sv -sw -ta -te -tet -tk -tl -tn -tr -uk -uz -vi -wa -yi
# -zu"
