# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

inherit eutils toolchain-funcs pax-utils multiprocessing ruby-single git-r3 flag-o-matic

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"

QT_WEBKIT_GIT_COMMIT="e7b74331d695bfa8b77e39cdc50fc2d84a49a22a"
QT_BASE_GIT_COMMIT="b5cc0083a5766e773885e8dd624c51a967c17de0"
THIRD_PARTY_GIT_COMMIT="19051aa97cecdcd3ef8c8862e36a3cb4cd3471fc"

#SRC_URI="https://github.com/ariya/${PN}/archive/${PV}.tar.gz
#         https://github.com/Vitallium/qtwebkit/archive/${QT_WEBKIT_GIT_COMMIT}.zip -> qtwebkit-${QT_WEBKIT_GIT_COMMIT}.zip
#	 https://github.com/Vitallium/qtbase/archive/${QT_BASE_GIT_COMMIT}.zip -> qtbase-${QT_BASE_GIT_COMMIT}.zip
#	 https://github.com/Vitallium/phantomjs-3rdparty-win/archive/${THIRD_PARTY_GIT_COMMIT}.zip -> phantomjs-3rdparty-win-${THIRD_PARTY_GIT_COMMIT}.zip
#"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples libressl -gstreamer -gstreamer010 -debug -alsa -opengl -webkit2 -egl -gles2 webgl"
REQUIRED_USE="?? ( gstreamer gstreamer010 ) webkit2? ( ^^ ( opengl gles2 ) ) egl? ( gles2 ) ?? ( gles2 opengl ) webgl? ( ^^ ( opengl gles2 )  ) alsa? ( ^^ ( gstreamer gstreamer010 ) )"

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

pkg_setup() {
	if use gstreamer || use gstreamer010 || use webkit2 || use opengl || use gles2 || use egl || use webgl || use alsa ; then
		if [ -z "${I_AM_A_PHANTOMJS_DEVELOPER+x}" ]; then
			ewarn "Remove use gstreamer || use gstreamer010 || use webkit2 || use opengl || use gles2 || use egl || use webgl || use alsa ."
			ewarn "These are experimental use flags and not functional.  It is intented only for fixing the html5 video src bug."
			ewarn "To bypass, set I_AM_A_PHANTOMJS_DEVELOPER=1 in your make.conf."
			exit 1
		else
			true
		fi
	fi
}

src_unpack() {
	EGIT_REPO_URI="https://github.com/ariya/phantomjs.git"
	EGIT_BRANCH="2.1"
	EGIT_COMMIT="d9cda3dcd26b0e463533c5cc96e39c0f39fc32c1"
	git-r3_fetch
	git-r3_checkout

	if use opengl || use gles2 ; then
		cd "${S}/src/qt/qtwebkit/Source/ThirdParty/"
		svn checkout -r 1442 https://github.com/qt/qtwebkit/trunk/Source/ThirdParty/ANGLE/ || die "failed grabbing ANGLE"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.1.1-python3-udis86-itab.patch"
	epatch "${FILESDIR}/${PN}-2.1.1-addMessageToConsole-override.patch"
	epatch "${FILESDIR}/${PN}-2.1.1-angle-includes.patch"
	#epatch "${FILESDIR}/${PN}-2.1.1-fix-video-src-1.patch"
	#epatch "${FILESDIR}/${PN}-2.1.1-fix-video-src-2.patch"
	#epatch "${FILESDIR}/${PN}-2.1.1-video-src.patch"
	epatch "${FILESDIR}/${PN}-2.1.1-fix-emoji-crash.patch"
	if use gstreamer010 ; then
		epatch "${FILESDIR}/${PN}-2.1.1-enabled-gstreamer-010.patch" || die p1
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

	sed -i -e 's|!enable?(video):qtHaveModule(multimediawidgets)|!enable?(video):false|g' ./src/qt/qtwebkit/Tools/qmake/mkspecs/features/features.prf || die p11 #from qtwebkit default multimedia disabled

	sed -i -r -e 's|"-no-c++11"|"-c++11"|g' build.py || die p12
	sed -i -r -e 's|-no-compile-examples|-no-compile-examples -c++11|g' ./src/qt/preconfig.sh || die p12z1
	sed -i -r -e 's|-no-compile-examples|-no-compile-examples -c++11|g' ./tools/preconfig.sh || die p12z1

	if use webkit2 ; then
		#sed -i -r -e 's|"WEBKIT_CONFIG-=build_webkit2"|"WEBKIT_CONFIG+=build_webkit2","WEBKIT_CONFIG+=build_webkit"|g' build.py || die p4a
		sed -i -r -e 's|"WEBKIT_CONFIG-=build_webkit2"|"WEBKIT_CONFIG+=build_webkit2"|g' build.py || die p4a
		sed -i -r -e 's|"-D", "QT_NO_PRINTPREVIEWDIALOG"|"-D", "QT_NO_PRINTPREVIEWDIALOG",\n"-D", "WTF_USE_COORDINATED_GRAPHICS=1"|g' build.py || die p4f
		sed -i -r -e 's|#include <WebCore/CoordinatedGraphicsScene.h>|#include <CoordinatedGraphicsScene.h>|g' ./src/qt/qtwebkit/Source/WebKit2/UIProcess/API/qt/raw/qrawwebview.cpp || die p4g
	fi

	sed -i -r -e 's|"-D", "QT_NO_PRINTPREVIEWDIALOG"|"-D", "PHANTOMJS_VIDEO_SRC=1","-D", "QT_NO_PRINTPREVIEWDIALOG"|g' build.py || die p4f1

	if ! use webgl ; then
		sed -i -e 's|use?(3d_graphics): WEBKIT_CONFIG += webgl||' ./src/qt/qtwebkit/Tools/qmake/mkspecs/features/features.prf || die p4z2
	fi

	if use opengl ; then
		sed -i -e '/contains(QT_CONFIG, opengl): WEBKIT_CONFIG += use_3d_graphics/d' \
                	./src/qt/qtwebkit/Tools/qmake/mkspecs/features/features.prf || die p4z1
		sed -i -r -e 's|"-no-opengl"|"-opengl"|g' build.py || die p4a
		sed -i -r -e 's|-no-opengl|-opengl|g' ./src/qt/preconfig.sh || die p4b
		sed -i -r -e 's|-no-opengl|-opengl|g' ./tools/preconfig.sh || die p4c
	fi
	if use egl ; then
		sed -i -r -e 's|-no-egl|-egl|g' ./src/qt/preconfig.sh || die p4d
		sed -i -r -e 's|-opengl|-opengl -egl|g' ./tools/preconfig.sh || die p4e
		sed -i -r -e 's|"-no-egl"|"-egl"|g' build.py || die p4f
	fi
	if use gles2 ; then
		sed -i -r -e 's|-egl|-egl -gles2|g' ./src/qt/preconfig.sh || die p8b1
		sed -i -r -e 's|-egl|-egl -gles2|g' ./tools/preconfig.sh || die p8b2
		sed -i -r -e 's|"-egl"|"-egl -gles2"|g' build.py || die p8bc
	fi

	if use gstreamer010 ; then
		sed -i -r -e 's|"WEBKIT_CONFIG-=use_gstreamer010"|"WEBKIT_CONFIG+=use_gstreamer010"|g' build.py || die p1
		sed -i -r -e 's|"WEBKIT_CONFIG-=use_gstreamer"|"WEBKIT_CONFIG+=use_gstreamer"|g' build.py || die p1
		sed -i -r -e 's|"WEBKIT_CONFIG-=use_native_fullscreen_video"|"WEBKIT_CONFIG+=use_native_fullscreen_video"|g' build.py || die p3
		sed -i -r -e 's|"WEBKIT_CONFIG-=video"|"WEBKIT_CONFIG+=video"|g' build.py || die p4
		sed -i -r -e 's|"-no-glib"|"-glib"|g' build.py || die p4a

		sed -i -r -e 's|-no-glib|-glib|g' ./src/qt/preconfig.sh || die p4b
		sed -i -r -e 's|-no-glib|-glib|g' ./tools/preconfig.sh || die p4c
		sed -i -r -e 's|-no-gstreamer|-gstreamer|g' ./tools/preconfig.sh || die p4d
		sed -i -r -e 's|-glib|-glib -gstreamer|g' ./src/qt/preconfig.sh || die p4e

	elif use gstreamer ; then
		sed -i -r -e 's|"WEBKIT_CONFIG-=use_gstreamer010"|"WEBKIT_CONFIG-=use_gstreamer010"|g' build.py || die p5
		sed -i -r -e 's|"WEBKIT_CONFIG-=use_gstreamer"|"WEBKIT_CONFIG+=use_gstreamer"|g' build.py || die p6
		sed -i -r -e 's|"WEBKIT_CONFIG-=use_native_fullscreen_video"|"WEBKIT_CONFIG+=use_native_fullscreen_video"|g' build.py || die p7
		sed -i -r -e 's|"WEBKIT_CONFIG-=video"|"WEBKIT_CONFIG+=video"|g' build.py || die p8
		sed -i -r -e 's|"-no-glib"|"-glib"|g' build.py || die p8a

		sed -i -r -e 's|-no-glib|-glib|g' ./src/qt/preconfig.sh || die p8b
		sed -i -r -e 's|-no-glib|-glib|g' ./tools/preconfig.sh || die p8c
		sed -i -r -e 's|-no-gstreamer|-gstreamer|g' ./tools/preconfig.sh || die p8d
	fi

	if use alsa ; then
		sed -i -r -e 's|"-no-alsa"|"-alsa"|g' build.py || die p9
		sed -i -r -e 's|"WEBKIT_CONFIG-=web_audio"|"WEBKIT_CONFIG+=web_audio"|g' build.py || die p10

		sed -i -r -e 's|-no-alsa|-alsa|g' ./src/qt/preconfig.sh || die p10a
		sed -i -r -e 's|-no-cups|-alsa -no-cups|g' ./tools/preconfig.sh || die p10b
	fi

	if use debug ; then
		sed -i -r -e 's|-release|-debug|g' ./tools/preconfig.sh
		sed -i -r -e 's|-static|-static -debug|g' ./src/qt/preconfig.sh
	fi
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
		--qt-config "$($(tc-getPKG_CONFIG) --cflags-only-I freetype2)" \
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
