# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
USE_RUBY="ruby26 ruby27 ruby30"
inherit autotools eutils flag-o-matic mono-env java-pkg-opt-2 \
multilib-minimal python-single-r1 ruby-ng

DESCRIPTION="A library that creates colored ASCII-art graphics"
HOMEPAGE="http://libcaca.zoy.org/"
LICENSE="ISC GPL-2 LGPL-2.1 WTFPL-2"

# Live/snapshots ebuilds do not get KEYWORDed

IUSE="cxx doc imlib java mono ncurses network opengl python ruby slang
 static-libs test truetype X"
IUSE+=" 256-colors-ncurses"
SLOT="0/${PV}"
REQUIRED_USE+=" 256-colors-ncurses? ( ncurses )
	      python? ( ${PYTHON_REQUIRED_USE} )
	      ruby? ( ^^ ( $(ruby_get_use_targets) ) )
	      truetype? ( opengl )"
RDEPEND+=" imlib? ( >=media-libs/imlib2-1.4.6-r2[${MULTILIB_USEDEP}] )
	java? ( >=virtual/jre-1.5 )
	mono? ( dev-lang/mono )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	opengl? (  >=media-libs/freeglut-2.8.1[${MULTILIB_USEDEP}]
		     truetype? ( >=media-libs/ftgl-2.1.3_rc5 )
		   >=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		   >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	slang? ( >=sys-libs/slang-2.2.4-r1[${MULTILIB_USEDEP}] )
	X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	     >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	doc? (    app-doc/doxygen
		>=dev-texlive/texlive-fontsrecommended-2012
		>=dev-texlive/texlive-latexextra-2012
		  dev-texlive/texlive-latexrecommended
		  virtual/latex-base )
	java? ( >=virtual/jdk-1.5 )
	test? ( dev-util/cppunit
		app-forensics/zzuf
		python? ( ${PYTHON_DEPS} ) )"
RUBY_OPTIONAL=yes
EGIT_COMMIT="e4968ba6e93e9fd35429eb16895c785c51072015"
SRC_URI="
https://github.com/cacalabs/libcaca/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror !test? ( test )"
DOCS=( AUTHORS NEWS NOTES README THANKS )

pkg_setup() {
	use python && python-single-r1_pkg_setup
	java-pkg-opt-2_pkg_setup
	use mono && mono-env_pkg_setup
	ruby-ng_pkg_setup
}

src_unpack() {
	default
}

src_prepare() {
	default
	sed -i -e '/doxygen_tests = check-doxygen/d' caca/t/Makefile.am \
		|| die #339962
	sed -i  -e 's:-g -O2 -fno-strength-reduce -fomit-frame-pointer::' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		configure.ac || die
	sed -i  -e 's:$(JAVAC):$(JAVAC) $(JAVACFLAGS):' \
		-e 's:libcaca_java_la_CPPFLAGS =:libcaca_java_la_CPPFLAGS = -I$(top_srcdir)/caca:' \
		java/Makefile.am || die
	if ! use truetype; then
		sed -i -e '/PKG_CHECK_MODULES/s:ftgl:dIsAbLe&:' configure.ac \
			|| die
	fi
	if use imlib && ! use X; then
		append-cflags -DX_DISPLAY_MISSING
	fi
	# bug 653400
	append-cxxflags -std=c++11
	# Removed 'has_version '>=dev-texlive/texlive-latex-2013' &&' that
	# prefixed this patch before wrt #517474
	eapply "${FILESDIR}"/${PN}-0.99_beta20_p20190101-latex_hacks.patch
	if use 256-colors-ncurses ; then
		eapply "${FILESDIR}"/${PN}-0.99.beta20-256-colors-ncurses.patch
	fi
	eautoreconf
	java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	if use 256-colors-ncurses ; then
		append-cppflags -DUSE_NCURSES_256_COLORS=1
	fi
	if multilib_is_native_abi; then
		if use java; then
			export JAVACFLAGS="$(java-pkg_javac-args)"
			export JAVA_CFLAGS="$(java-pkg_get-jni-cflags)"
		fi
		use mono && export CSC="$(type -P gmcs)" #329651
		export VARTEXFONTS="${T}/fonts" #44128
		use ruby && use ruby_targets_${USE_RUBY} && \
			export RUBY=$(ruby_implementation_command ${USE_RUBY})
	fi
	ECONF_SOURCE="${S}" \
	econf   $(use_enable static-libs static) \
		$(use_enable slang) \
		$(use_enable ncurses) \
		$(use_enable network) \
		$(use_enable X x11) \
		$(use_with X x) \
		--x-libraries=/usr/$(get_libdir) \
		$(use_enable opengl gl) \
		$(use_enable cxx) \
		$(use_enable imlib imlib2) \
		$(use_enable test cppunit) \
		$(use_enable test zzuf) \
		$(multilib_native_use_enable java) \
		$(multilib_native_use_enable ruby) \
		$(multilib_native_use_enable python) \
		$(multilib_native_use_enable mono csharp) \
		$(multilib_native_use_enable doc)
}

multilib_src_compile() {
	local _java_makeopts
	use java && _java_makeopts="-j1" #480864
	emake V=1 ${_java_makeopts}
}

multilib_src_test() {
	emake V=1 -j1 check
}

multilib_src_install() {
	emake V=1 DESTDIR="${D}" install
	if multilib_is_native_abi && use java; then
		java-pkg_newjar java/libjava.jar
	fi
}

multilib_src_install_all() {
	einstalldocs
	rm -rf "${D}"/usr/share/java
	find "${D}" -name '*.la' -type f -delete || die
}
