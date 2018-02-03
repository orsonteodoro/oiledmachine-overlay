# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby20 ruby21 ruby22"

inherit eutils toolchain-funcs pax-utils multiprocessing ruby-single git-r3 flag-o-matic

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"

QT_WEBKIT_GIT_COMMIT="e7b74331d695bfa8b77e39cdc50fc2d84a49a22a"
QT_BASE_GIT_COMMIT="b5cc0083a5766e773885e8dd624c51a967c17de0"
THIRD_PARTY_GIT_COMMIT="19051aa97cecdcd3ef8c8862e36a3cb4cd3471fc"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="html5-video examples libressl -gstreamer -gstreamer010 -debug -alsa -opengl -egl -gles2 webgl"
REQUIRED_USE="?? ( gstreamer gstreamer010 ) egl? ( gles2 ) ?? ( gles2 opengl ) webgl? ( ^^ ( opengl gles2 )  ) alsa? ( ^^ ( gstreamer gstreamer010 ) )"

RDEPEND="dev-libs/icu:=
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/libpng:0=
	virtual/jpeg:0
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	gstreamer010? (
		dev-libs/glib:2
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
	)
	alsa? ( media-libs/alsa-lib )
        virtual/opengl
	opengl? ( dev-qt/qtopengl:5 )
	gles2? ( media-libs/mesa[gles2] )
	egl? ( media-libs/mesa[egl] )
	debug? ( dev-qt/qtcore[debug] )
"


DEPEND="${RDEPEND}
	${RUBY_DEPS}
	net-misc/openssh[-bindist]
	app-arch/unzip
	virtual/pkgconfig"

src_unpack() {
	EGIT_REPO_URI="https://github.com/ariya/phantomjs.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="${PV}"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.1.1-python3-udis86-itab.patch"
	eapply "${FILESDIR}/${PN}-2.1.1-addMessageToConsole-override.patch"
	eapply "${FILESDIR}/${PN}-2.1.1-fix-emoji-crash.patch"
	eapply "${FILESDIR}/${PN}-2.1.1-int-fix.patch"
	if use html5-video ; then
		eapply "${FILESDIR}/${PN}-2.1.1-audio-video-support.patch" #testing
	fi

	if use debug ; then
		append-cflags -g3
		append-cxxflags -g3
	fi

	# Respect CC, CXX, {C,CXX,LD}FLAGS in .qmake.cache
	sed -i \
		-e "/^SYSTEM_VARIABLES=/i \
		CC='$(tc-getCC)'\n\
		CXX='$(tc-getCXX)'\n\
		CFLAGS='${CFLAGS}'\n\
		CXXFLAGS='${CXXFLAGS}'\n\
		LDFLAGS='${LDFLAGS}'\n\
		QMakeVar set QMAKE_CFLAGS_RELEASE\n\
		QMakeVar set QMAKE_CFLAGS_DEBUG\n\
		QMakeVar set QMAKE_CXXFLAGS_RELEASE\n\
		QMakeVar set QMAKE_CXXFLAGS_DEBUG\n\
		QMakeVar set QMAKE_LFLAGS_RELEASE\n\
		QMakeVar set QMAKE_LFLAGS_DEBUG\n"\
		src/qt/qtbase/configure \
		|| die

	# Respect CC, CXX, LINK and *FLAGS in config.tests
	find src/qt/qtbase/config.tests/unix -name '*.test' -type f -exec \
		sed -i -e "/bin\/qmake/ s: \"\$SRCDIR/: \
			'QMAKE_CC=$(tc-getCC)'    'QMAKE_CXX=$(tc-getCXX)'      'QMAKE_LINK=$(tc-getCXX)' \
			'QMAKE_CFLAGS+=${CFLAGS}' 'QMAKE_CXXFLAGS+=${CXXFLAGS}' 'QMAKE_LFLAGS+=${LDFLAGS}'&:" \
		{} + || die

	sed -i -r -e 's|"-no-c++11"|"-c++11"|g' build.py || die p12
	sed -i -r -e 's|-no-compile-examples|-no-compile-examples -c++11|g' ./src/qt/preconfig.sh || die p12z1
	sed -i -r -e 's|-no-compile-examples|-no-compile-examples -c++11|g' ./tools/preconfig.sh || die p12z1

	if use debug ; then
		sed -i -r -e 's|-release|-debug|g' ./tools/preconfig.sh
		sed -i -r -e 's|-static|-static -debug|g' ./src/qt/preconfig.sh
	fi

	eapply_user
}

src_compile() {
	local mydebug="--release"
	if use debug ; then
		mydebug="--debug"
	fi
	./build.py \
		${mydebug} \
		--confirm \
		--jobs $(makeopts_jobs) \
		|| die
}

src_test() {
	./bin/phantomjs test/run-tests.js || die
}

src_install() {
	pax-mark m bin/phantomjs || die
	dobin bin/phantomjs
	dodoc ChangeLog README.md
	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}
