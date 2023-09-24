# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# SECURITY NOTE(S):
# dev-perl/Alien-caca needs to be patched/bump if vulnerabilities are fixed for
# same version as this one.

EGIT_COMMIT="f42aa68fc798db63b7b2a789ae8cf5b90b57b752"
PYTHON_COMPAT=( python3_{8..11} )
inherit autotools flag-o-matic mono-env java-pkg-opt-2 multilib-minimal
inherit python-r1 virtualx

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
256-colors-ncurses cxx doc examples imlib java mono ncurses network opengl perl
php python ruby slang static-libs test truetype X r3
"
JAVA_SLOT="1.8"
SLOT="0/$(ver_cut 1-2 ${PV})"
REQUIRED_USE+="
	256-colors-ncurses? (
		ncurses
	)
	examples? (
		cxx? (
			|| (
				X
				opengl
			)
		)
		java? (
			|| (
				X
				opengl
			)
		)
		mono? (
			|| (
				X
				opengl
			)
		)
		python? (
			|| (
				X
				opengl
			)
		)
	)
	python? (
		|| (
			${PYTHON_REQUIRED_USE}
		)
	)
	truetype? (
		opengl
	)
"
RDEPEND+="
	imlib? (
		>=media-libs/imlib2-1.4.6-r2[${MULTILIB_USEDEP}]
	)
	java? (
		virtual/jre:${JAVA_SLOT}
	)
	mono? (
		dev-lang/mono
	)
	ncurses? (
		>=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=media-libs/freeglut-2.8.1[${MULTILIB_USEDEP}]
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		truetype? (
			>=media-libs/ftgl-2.1.3_rc5
		)
	)
	python? (
		${PYTHON_DEPS}
		examples? (
			$(python_gen_cond_dep '
				dev-python/pillow[${PYTHON_USEDEP}]
			')
		)
	)
	slang? (
		>=sys-libs/slang-2.2.4-r1[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
	java? (
		virtual/jdk:${JAVA_SLOT}
	)
"
# The internal term caca is 0.91 and incomplete but the latest is 3.1.0.
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	doc? (
		>=dev-texlive/texlive-fontsrecommended-2012
		>=dev-texlive/texlive-latexextra-2012
		app-doc/doxygen
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-plaingeneric
		virtual/latex-base
	)
	python? (
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
	test? (
		app-forensics/zzuf[${MULTILIB_USEDEP}]
		dev-util/cppunit[${MULTILIB_USEDEP}]
		python? (
			${PYTHON_DEPS}
		)
	)
"
# The Term-Caca in this project seems to be not finished compared to Term-Caca-3.1.0.
PDEPEND+="
	perl? (
		dev-perl/Term-Caca
	)
	php? (
		|| (
			~dev-php/libcaca-${PV}[256-colors-ncurses=,examples=,imlib=,ncurses=,network=,opengl=,slang=,static-libs=,test=,truetype=,X=]
			~dev-php/libcaca-$(ver_cut 1-4 ${PV})[256-colors-ncurses=,examples=,imlib=,ncurses=,network=,opengl=,slang=,static-libs=,test=,truetype=,X=]
		)
	)
	ruby? (
		|| (
			~dev-ruby/libcaca-${PV}[256-colors-ncurses=,examples=,imlib=,ncurses=,network=,opengl=,slang=,static-libs=,test=,truetype=,X=]
			~dev-ruby/libcaca-$(ver_cut 1-4 ${PV})[256-colors-ncurses=,examples=,imlib=,ncurses=,network=,opengl=,slang=,static-libs=,test=,truetype=,X=]
		)
	)
"
SRC_URI="
https://github.com/cacalabs/libcaca/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
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
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
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
	"${FILESDIR}/libcaca-0.99_beta20_p20211207-img2txt-python3-compat.patch"
	"${DISTDIR}/libcaca-pr66-d33a9ca.patch"
)
# Applied already upstream:
# 84bd155 : CVE-2018-20544.patch
# 3e52dab : CVE-2018-20545+20547+20549.patch
# 1022d97 : CVE-2018-20546+20547.patch
# 46b4ea7 : canvas-fix-an-integer-overflow-in-caca_resize.patch
# e4968ba : Fix-a-problem-in-the-caca_resize-overflow-detection-.patch

pkg_setup() {
	use python && python_setup
	java-pkg-opt-2_pkg_setup
	use java && java-pkg_ensure-vm-version-eq ${JAVA_SLOT}
	use mono && mono-env_pkg_setup
}

src_unpack() {
	default
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
		-e 's:$(JAVAC):$(JAVAC) $(JAVACFLAGS):' \
		-e 's:libcaca_java_la_CPPFLAGS =:libcaca_java_la_CPPFLAGS = -I$(top_srcdir)/caca:' \
		java/Makefile.am \
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
		eapply "${FILESDIR}/${PN}-0.99.beta20-256-colors-ncurses.patch"
	fi
	eautoreconf
	multilib_copy_sources
	prepare_abi() {
		if multilib_is_native_abi ; then
			if use java ; then
				java-pkg-opt-2_src_prepare
			fi
		fi
	}
	multilib_foreach_abi prepare_abi
}

multilib_src_configure() {
	replace-flags '-O*' '-O2'
	if use 256-colors-ncurses ; then
		append-cppflags -DUSE_NCURSES_256_COLORS=1
	fi
	if multilib_is_native_abi; then
		if use java; then
			export JAVACFLAGS="$(java-pkg_javac-args)"
			export JAVA_CFLAGS="$(java-pkg_get-jni-cflags)"
einfo "JAVACFLAGS=${JAVACFLAGS}"
einfo "JAVA_CFLAGS=${JAVA_CFLAGS}"
		fi
		if use mono ; then
			export CSC="$(type -P gmcs)" #329651
		fi
		export VARTEXFONTS="${T}/fonts" #44128
	fi
	local myeconfargs=(
		$(multilib_native_use_enable doc)
		$(multilib_native_use_enable java)
		$(multilib_native_use_enable mono csharp)
		$(multilib_native_use_enable python)
		$(use_enable slang)
		$(use_enable static-libs static)
		$(use_enable ncurses)
		$(use_enable network)
		$(use_enable cxx)
		$(use_enable imlib imlib2)
		$(use_enable opengl gl)
		$(use_enable test cppunit)
		$(use_enable test zzuf)
		$(use_enable X x11)
		$(use_with X x)
		--disable-ruby
		--x-libraries="/usr/$(get_libdir)"
	)
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

src_configure() {
	# Broken inherit, do not remove.
	multilib-minimal_src_configure
}

multilib_src_compile() {
	local _java_makeopts
	use java && _java_makeopts="-j1" #480864
	emake V=1 ${_java_makeopts}
}

src_compile() {
	# Broken inherit, do not remove.
	multilib-minimal_src_compile
}

_test_native_lib() {
	make V=1 -j1 check
	return $?
}

multilib_src_test() {
	virtx _test_native_lib
	if multilib_is_native_abi ; then
		if use python ; then
			pushd python || die
				${EPYTHON} -m unittest test/canvas.py || die
			popd
		fi
	fi
}

src_test() {
	# Broken inherit, do not remove.
	multilib-minimal_src_test
}

multilib_src_install() {
	emake V=1 DESTDIR="${D}" install
	if multilib_is_native_abi ; then
		if use java; then
			java-pkg_newjar java/libjava.jar
		fi
		if use python ; then
			_python_install() {
				python_domodule python/caca
				python_optimize
			}
			python_foreach_impl _python_install
		fi

		if use examples ; then
			# if use c ; then
				insinto "/usr/share/${PN}/examples/c"
				doins -r examples/*
				rm -rf "${ED}/usr/share/${PN}/examples/c/"*.o
			# fi
			if use cxx ; then
				insinto "/usr/share/${PN}/examples/cxx"
				doins cxx/cxxtest.cpp
			fi
			if use java ; then
				insinto "/usr/share/${PN}/examples/java"
				doins -r java/examples/*
			fi
			if use python ; then
				local L=(
					blit.py
					cacainfo.py
					colors.py
					drawing.py
					driver.py
					event.py
					figfont.py
					font.py
					frames.py
					gol.py
					img2txt.py
					text.py
				)
				exeinto "/usr/share/${PN}/examples/python"
				local f
				for f in ${L[@]} ; do
					doexe python/examples/${f}
				done
			fi
		fi
	fi
}

src_install() {
einfo "PYTHON_SITEDIR=${PYTHON_SITEDIR}"
	rm -rf "${ED}/${PYTHON_SITEDIR}" || die
	# Broken inherit, do not remove.
	multilib-minimal_src_install
}

multilib_src_install_all() {
	DOCS=( AUTHORS NEWS NOTES README THANKS )
	use doc && einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  256-color-patch
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.99_beta20_p20211207 (f42aa68) (20230618)
# USE="256-colors-ncurses X cxx doc imlib java ncurses opengl python -ruby
# static-libs test truetype -mono -network -slang"
# PYTHON_SINGLE_TARGET="python3_10 -python3_11"
# RUBY_TARGETS="ruby30 -ruby31"

# comment on test:  Both 32-bit and 64-bit tested with same results below

# Testing the native libcaca C library:
# PASS: simple
# PASS: check-copyright
# PASS: check-source
# PASS: check-win32
# PASS: caca-test
# ============================================================================
# Testsuite summary for libcaca 0.99.beta20
# ============================================================================
# # TOTAL: 5
# # PASS:  5
# # SKIP:  0
# # # XFAIL: 0
# # FAIL:  0
# # XPASS: 0
# # ERROR: 0
# ============================================================================

# Testing the C++ bindings:  passed (interactive) 0.99_beta20_p20211207 (f42aa68) (20230621)
# USE="-* X imlib cxx opengl test"
# cd ${BUILD_DIR}/cxx
# ./cxxtest

# Testing java bindings:  passed (interactive) 0.99_beta20_p20211207 (f42aa68) (20230621)
# USE="-* X imlib java test"
# cd ${BUILD_DIR}/java/examples
# ./TrueColor

# Testing mono bindings:  passed (interactive) 0.99_beta20_p20211207 (f42aa68) (20230621)
# USE="-* X imlib mono test"
# cd ${BUILD_DIR}/caca-sharp
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs/" mono test.exe

# Testing python bindings:  passed (test suite) 0.99_beta20_p20211207 (f42aa68) (20230621)
# USE="-* X imlib python opengl test"
# PYTHON_SINGLE_TARGET="python3_10 -python3_11"
# Ran 36 tests in 0.012s
#
# OK

# Testing python bindings:  passed (examples) 0.99_beta20_p20211207 (f42aa68) (20230621)
# cd ${BUILD_DIR}/python
# EPYTHON="python3.10"
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/blit.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/cacainfo.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/colors.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/drawing.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/driver.py : pass, but stuck on gl after 5 secs
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/event.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/figfont.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/font.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/frames.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/gol.py : pass
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/img2txt.py : pass, but bugs out with --charset=shades
# LD_LIBRARY_PATH="$(pwd)/../caca/.libs" PYTHONPATH="$(pwd)/caca:${PYTHONPATH}" ${EPYTHON} examples/text.py : pass
