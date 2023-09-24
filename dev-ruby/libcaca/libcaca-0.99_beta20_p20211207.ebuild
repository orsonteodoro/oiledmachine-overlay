# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# SECURITY NOTE(S):
# dev-perl/Alien-caca needs to be patched/bump if vulnerabilities are fixed for
# same version as this one.

EAPI=8

EGIT_COMMIT="f42aa68fc798db63b7b2a789ae8cf5b90b57b752"
USE_RUBY="ruby30 ruby31"
inherit autotools flag-o-matic ruby-ng virtualx

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
256-colors-ncurses examples imlib ncurses network opengl slang static-libs
test truetype X r1
"
SLOT="0/$(ver_cut 1-2 ${PV})"
REQUIRED_USE+="
	X
	256-colors-ncurses? (
		ncurses
	)
	truetype? (
		opengl
	)
	|| (
		$(ruby_get_use_targets)
	)
"
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
		~media-libs/libcaca-${PV}[256-colors-ncurses=,examples=,imlib=,ncurses=,network=,opengl=,slang=,static-libs=,test=,truetype=,X=]
		~media-libs/libcaca-$(ver_cut 1-4 ${PV})[256-colors-ncurses=,examples=,imlib=,ncurses=,network=,opengl=,slang=,static-libs=,test=,truetype=,X=]
	)
"
DEPEND+="
	${RDEPEND}
"
# The internal term caca is 0.91 and incomplete but the latest is 3.1.0.
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[pkg-config(+)]
	test? (
		app-forensics/zzuf
		dev-util/cppunit
	)
"
# The Term-Caca in this project seems to be not finished compared to Term-Caca-3.1.0.
ruby_add_bdepend "
	test? (
		dev-ruby/minitest
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
S="${WORKDIR}/all/${PN}-${EGIT_COMMIT}"
RUBY_S="${PN}-${EGIT_COMMIT}"
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
	"${FILESDIR}/libcaca-0.99_beta20_p20211207-ruby-3.0-compat.patch"
	"${DISTDIR}/libcaca-pr66-d33a9ca.patch"
)
# Applied already upstream:
# 84bd155 : CVE-2018-20544.patch
# 3e52dab : CVE-2018-20545+20547+20549.patch
# 1022d97 : CVE-2018-20546+20547.patch
# 46b4ea7 : canvas-fix-an-integer-overflow-in-caca_resize.patch
# e4968ba : Fix-a-problem-in-the-caca_resize-overflow-detection-.patch

pkg_setup() {
# Some indeterministic or random failures may still exist, but
# the below may fix it.
ewarn
ewarn "Reinstall media-libs/libcaca if the test USE flag fails."
ewarn
	ruby-ng_pkg_setup
}

each_ruby_prepare() {
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
		eapply "${FILESDIR}/${PN}-0.99.beta20-256-colors-ncurses.patch"
	fi
	eautoreconf
}

check_ruby() {
	einfo "RUBY_VERSION="$(ruby_get_version)
	if ver_test $(ruby_get_version) -lt 3 ; then
eerror
eerror "<dev-lang/ruby-3 must be uninstalled."
eerror
	fi
	if has_version "<dev-lang/ruby-3" ; then
eerror
eerror "<dev-lang/ruby-3 must be uninstalled."
eerror
		die
	fi
}

each_ruby_configure() {
	check_ruby
	replace-flags '-O*' '-O2'
	if use 256-colors-ncurses ; then
		append-cppflags -DUSE_NCURSES_256_COLORS=1
	fi
	export VARTEXFONTS="${T}/fonts" #44128
	if use ruby_targets_${USE_RUBY} ; then
		export RUBY=$(ruby_implementation_command ${USE_RUBY})
	fi
	local myeconfargs=(
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
		--disable-csharp
		--disable-cxx
		--disable-doc
		--disable-java
		--disable-python
		--enable-ruby
		--x-libraries="/usr/$(get_libdir)"
	)
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

each_ruby_compile() {
	emake V=1
}

_test_ruby() {
	./test
	return $?
}

each_ruby_test() {
	pushd ruby || die
		virtx _test_ruby
	popd
}

each_ruby_install() {
	emake V=1 DESTDIR="${D}" install
}

all_ruby_install() {
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

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  256-color-patch
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.99_beta20_p20211207 (f42aa68) (20230618)

# Testing ruby bindings:  passed (test suite) 0.99_beta20_p20211207 (f42aa68) (20230622)
# USE="-* X imlib ruby test" : pass
# USE="-* -X imlib opengl ruby test" : fail
# RUBY_TARGETS="ruby30 -ruby31"
# PASS: test
# ============================================================================
# Testsuite summary for libcaca 0.99.beta20
# ============================================================================
# # TOTAL: 1
# # PASS:  1
# # SKIP:  0
# # XFAIL: 0
# # FAIL:  0
# # XPASS: 0
# # ERROR: 0
# ============================================================================

# Testing ruby bindings via ${BUILD_DIR}/test:  passed [${BUILD_DIR}/test is the same as above.]
# Finished in 0.999457s, 29.0158 runs/s, 39.0212 assertions/s.
#
# 29 runs, 39 assertions, 0 failures, 0 errors, 0 skips
