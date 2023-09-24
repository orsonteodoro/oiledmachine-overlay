# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# SECURITY NOTE(S):
# dev-perl/Alien-caca needs to be patched/bump if vulnerabilities are fixed for
# same version as this one.

EAPI=8

MY_PN="libcaca"
MY_P="libcaca-${PV}"
EGIT_COMMIT="f42aa68fc798db63b7b2a789ae8cf5b90b57b752"
PHP_EXT_NAME="caca"
PHP_EXT_NEEDED_USE="cli,gd,unicode"
PHP_EXT_SKIP_PATCHES="yes"
PHP_EXT_S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
USE_PHP="php7-4 php8-0 php8-1 php8-2"
inherit autotools flag-o-matic php-ext-source-r3-caca

DESCRIPTION="A library that creates colored ASCII-art graphics"
HOMEPAGE="http://libcaca.zoy.org/"
LICENSE="
	ISC
	GPL-2
	LGPL-2.1
	WTFPL-2
"

# Live/snapshots ebuilds do not get KEYWORDed

IUSE="
256-colors-ncurses doc examples imlib ncurses network opengl perl php slang
static-libs test truetype X r5
"
SLOT="0/$(ver_cut 1-2 ${PV})"
REQUIRED_USE+="
	php
	256-colors-ncurses? (
		ncurses
	)
	truetype? (
		opengl
	)
"
# dev-lang/php[unicode] is for examples/figfont.php
RDEPEND+="
	imlib? (
		>=media-libs/imlib2-1.4.6-r2
	)
	ncurses? (
		>=sys-libs/ncurses-5.9-r3:0=
	)
	opengl? (
		>=media-libs/freeglut-2.8.1
		>=virtual/glu-9.0-r1
		>=virtual/opengl-7.0-r1
		truetype? (
			>=media-libs/ftgl-2.1.3_rc5
		)
	)
	slang? (
		>=sys-libs/slang-2.2.4-r1
	)
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXt-1.1.4
	)
	|| (
		~media-libs/libcaca-${PV}:=[256-colors-ncurses=,doc=,examples=,imlib=,ncurses=,network=,opengl=,perl=,php,slang=,static-libs=,test=,truetype=,X=]
		~media-libs/libcaca-$(ver_cut 1-4 ${PV}):=[256-colors-ncurses=,doc=,examples=,imlib=,ncurses=,network=,opengl=,perl=,php,slang=,static-libs=,test=,truetype=,X=]
	)
"
DEPEND+="
	${RDEPEND}
"
# The internal term caca is 0.91 and incomplete but the latest is 3.1.0.
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[pkg-config(+)]
	media-libs/gd
	doc? (
		>=dev-texlive/texlive-fontsrecommended-2012
		>=dev-texlive/texlive-latexextra-2012
		app-doc/doxygen
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-plaingeneric
		virtual/latex-base
	)
	test? (
		app-forensics/zzuf
		dev-util/cppunit
	)
"
# The Term-Caca in this project seems to be not finished compared to Term-Caca-3.1.0.
PDEPEND+="
	perl? (
		dev-perl/Term-Caca
	)
"
SRC_URI="
https://github.com/cacalabs/libcaca/archive/${EGIT_COMMIT}.tar.gz
	-> ${MY_P}.tar.gz
https://github.com/cacalabs/libcaca/commit/afacac2cf7dfad8015c059a96046d9c2fa34632f.patch
	-> libcaca-pr70-afacac2.patch
https://github.com/cacalabs/libcaca/commit/f57b0d65cfaac5f1fbdc75458170e102f57a8dfa.patch
	-> libcaca-pr70-f57b0d6.patch
https://github.com/cacalabs/libcaca/commit/9683d1f7efe316b1e6113b65c6fff40671d35632.patch
	-> libcaca-pr70-9683d1f.patch
https://github.com/cacalabs/libcaca/commit/d33a9ca2b7e9f32483c1aee4c3944c56206d456b.patch
	-> libcaca-pr66-d33a9ca.patch
"
# Fix undefined reference to _caca_alloc2d #70
# From https://github.com/cacalabs/libcaca/pull/70/commits
# afacac2 - common-image: avoid implicit function declaration
# f57b0d6 - caca: avoid nested externs
# 9683d1f - caca_internals: export _caca_alloc2d
# d33a9ca - Prevent a divide-by-zero by checking for a zero width or height.
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
RESTRICT="
	mirror
	!test? (
		test
	)
"
PATCHES=(
	"${DISTDIR}/libcaca-pr70-afacac2.patch"
	"${DISTDIR}/libcaca-pr70-f57b0d6.patch"
	"${DISTDIR}/libcaca-pr70-9683d1f.patch"
	"${FILESDIR}/libcaca-0.99_beta20_p20211207-php7-fixes.patch"
	"${FILESDIR}/libcaca-0.99_beta20_p20211207-php8-fixes.patch"
	"${DISTDIR}/libcaca-pr66-d33a9ca.patch"
)
# Applied already upstream:
# 84bd155 : CVE-2018-20544.patch
# 3e52dab : CVE-2018-20545+20547+20549.patch
# 1022d97 : CVE-2018-20546+20547.patch
# 46b4ea7 : canvas-fix-an-integer-overflow-in-caca_resize.patch
# e4968ba : Fix-a-problem-in-the-caca_resize-overflow-detection-.patch

pkg_setup() {
ewarn
ewarn "A random configure time failure may be encountered.  Try:"
ewarn
ewarn "  emerge -C dev-php/libcaca media-libs/libcaca"
ewarn "  emerge -1vuDN media-libs/libcaca"
ewarn "  emerge -1vuDN dev-php/libcaca"
ewarn
}

src_prepare() {
	default
	# Fixes:
	# FAIL: check-source \
	sed -i \
		-e "s|\t|    |g" \
		"src/img2txt.c" \
		|| die
	sed -i \
		-e '/doxygen_tests = check-doxygen/d' \
		caca/t/Makefile.am \
		|| die #339962
	sed -i \
		-e 's:-O0::' \
		-e 's:-g -O2 -fno-strength-reduce -fomit-frame-pointer::' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		configure.ac \
		|| die
	sed -i \
		-e 's:-O0::' \
			"build/build-kernel" \
		|| die
	if ! use truetype; then
		sed -i -e '/PKG_CHECK_MODULES/s:ftgl:dIsAbLe&:' \
			configure.ac \
			|| die
	fi
	if use imlib && ! use X; then
		append-cflags -DX_DISPLAY_MISSING
	fi
	append-cxxflags -std=c++11 # Bug 653400
	if use 256-colors-ncurses ; then
		eapply "${FILESDIR}/${MY_PN}-0.99.beta20-256-colors-ncurses.patch"
	fi
	eautoreconf
	php-ext-source-r3-caca_src_prepare
	local slot
	for slot in $(php_get_slots); do
		if [[ "${slot}" =~ ("php8."[0-9]) ]] ; then
			einfo "Patching for ${slot}"
			php_init_slot_env "${slot}"
			pushd .. || die
				eapply "${FILESDIR}/libcaca-0.99_beta20_p20211207-php8-gdimage-fixes.patch"
			popd
		fi
	done
}

_php-ext-source-r3-caca_src_configure() {
	replace-flags '-O*' '-O2'
	if use 256-colors-ncurses ; then
		append-cppflags -DUSE_NCURSES_256_COLORS=1
	fi
	export VARTEXFONTS="${T}/fonts" #44128
	local myeconf=(
		$(use_enable slang)
		$(use_enable static-libs static)
		$(use_enable ncurses)
		$(use_enable network)
		$(use_enable imlib imlib2)
		$(use_enable opengl gl)
		$(use_enable test cppunit)
		$(use_enable test zzuf)
		$(use_enable X x11)
		$(use_with X x)
		--disable-cxx
		--disable-csharp
		--disable-doc
		--disable-java
		--disable-python
		--disable-ruby
		--x-libraries="/usr/$(get_libdir)"
	)
	# libcaca (native c lib)
	pushd .. || die
		econf \
			"${myeconf[@]}"
	popd

	# In caca-php dir
	econf \
		--with-php-config="${PHPCONFIG}" \
		"${econf_args[@]}"
}

src_configure() {
	php-ext-source-r3-caca_src_configure
}

_php-ext-source-r3-caca_src_compile() {
	pushd .. || die
		emake V=1 # Generate libs for tools/*
	popd
	pushd ../tools || die
		emake V=1
	popd
	emake V=1
}

src_compile() {
	php-ext-source-r3-caca_src_compile
}

src_test() {
	:;
}

_php-ext-source-r3-caca_src_install() {
	# libcaca (native c lib)
	pushd .. || die
		emake V=1 DESTDIR="${D}" install
	popd

	INSTALL_ROOT="${D}" emake install-headers

	# php bindings follow

	exeinto "${EXT_DIR#$EPREFIX}"
	doexe "modules/${PHP_EXT_NAME}.so"
}

_php-ext-source-r3-caca_src_install_all() {
	cd .. || die

	DOCS=( AUTHORS NEWS NOTES README THANKS )
	use doc && einstalldocs

	php-ext-source-r3-caca_createinifiles

	if use examples ; then
		insinto "/usr/share/${MY_PN}/examples/php"
		doins -r caca-php/examples/*
	fi
	local L=(
		"/usr/$(get_libdir)/libcaca.so"
		"/usr/$(get_libdir)/libcaca.so.0"
		"/usr/$(get_libdir)/libcaca.so.0.99.20"
		"/usr/$(get_libdir)/pkgconfig"
		"/usr/bin"
		"/usr/include"
		"/usr/share/libcaca/caca.txt"
		"/usr/share/man"
	)
	local p
	for p in ${L[@]} ; do
		rm -rf "${ED}/${p}"
	done
	find "${D}" -name '*.la' -type f -delete || die
}

src_install() {
	php-ext-source-r3-caca_src_install
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  256-color-patch
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.99_beta20_p20211207 (f42aa68) (20230618)

# comment on test:  Only 64-bit tested with same results below.  Both php 7.4 and 8.2 have the same results.

# Testing php bindings:  fail (interactive).  The tester segfaults during Render()
# USE="-* X imlib php opengl test"
# emerge -1vuDN dev-php/libcaca
# ebuild libcaca-0.99_beta20_p20211207.ebuild clean unpack prepare compile test
# cd ${BUILD_DIR}/caca-php/examples
# /usr/bin/php7.4 cacainfo.php : pass
# /usr/bin/php7.4 cacapig.php : pass
# /usr/bin/php7.4 colors.php : pass
# /usr/bin/php7.4 demo.php : pass
# /usr/bin/php7.4 dithering.php : pass
# /usr/bin/php7.4 export.php : pass with html, ansi works decent outside x11
# /usr/bin/php7.4 fullwidth.php : maybe, tiny render
# /usr/bin/php7.4 img2txt.php : pass
# /usr/bin/php7.4 import.php t.out : pass, use results of "/usr/bin/php7.4 export.php caca > t.out"
# /usr/bin/php7.4 polyline.php : pass
# /usr/bin/php7.4 render.php : pass
# /usr/bin/php7.4 test.php : pass
# /usr/bin/php7.4 text.php : pass
# /usr/bin/php7.4 transform.php : pass
# /usr/bin/php7.4 truecolor.php : pass
# /usr/bin/php7.4 unicode : pass, but the unicode output is messed up
# /usr/bin/php7.4 figfont.php : pass
