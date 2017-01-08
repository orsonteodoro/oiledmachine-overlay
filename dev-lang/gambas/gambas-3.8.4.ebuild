# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools toolchain-funcs gnome2-utils fdo-mime

DESCRIPTION="Gambas"
HOMEPAGE="http://gambas.sourceforge.net/en/main.html"
SRC_URI="mirror://sourceforge/gambas/gambas3-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ide qt5 qt4 gtk3 gtk2 postgresql sqlite2 sqlite3 mysql opengl X pdf jit dbus sdl sdl2 curl gnome-keyring bzip2 zlib v4l mime gmp imlib2 cairo pcre crypt gstreamer xml httpd network webkit pixbuf xslt gsl smtp mixer ncurses openssl openal odbc"

RDEPEND="bzip2? ( app-arch/bzip2 )
         zlib? ( sys-libs/zlib )
	 postgresql? ( dev-db/postgresql )
	 sqlite2? ( dev-db/sqlite:2 )
	 sqlite3? ( dev-db/sqlite:3 )
	 mysql? ( virtual/mysql )
	 curl? ( >=net-misc/curl-7.13 )
	 mime? ( >=dev-libs/gmime-2.6 )
	 pcre? ( dev-libs/libpcre )
 	 sdl? ( >=media-libs/libsdl-1.2.8 media-libs/sdl-ttf )
	 sdl2? ( >=media-libs/libsdl2-2.0.2 >=media-libs/sdl2-ttf-2.0.12 >=media-libs/sdl2-image-2.0 )
	 mixer? ( sdl? ( media-libs/sdl-mixer )
                      sdl2? ( >=media-libs/sdl2-mixer-2 ) )
	 xml? ( >=dev-libs/libxml2-2 )
	 xslt? ( dev-libs/libxslt )
         v4l? ( media-libs/libv4l virtual/jpeg media-libs/libpng )
	 crypt? ( dev-libs/libgcrypt )
	 qt4? ( >=dev-qt/qtcore-4.5:4[qt3support] dev-qt/qtgui:4 dev-qt/qtwidgets dev-qt/qtprintsupport dev-qt/qtsvg:4 dev-qt/qtx11extras
		 opengl? ( dev-qt/qtopengl:4[qt3support] )
		 webkit? ( dev-qt/qtwebkit:4 )
	 )
         qt5? ( >=dev-qt/qtcore-5.3:5 dev-qt/qtgui:5 dev-qt/qtwidgets dev-qt/qtprintsupport dev-qt/qtsvg:5 dev-qt/qtx11extras
		 opengl? ( dev-qt/qtopengl:5 )
		 webkit? ( dev-qt/qtwebkit:5 dev-qt/qtnetwork dev-qt/qtxml )
	 )
	 gtk2? ( >=x11-libs/gtk+-2.16:2 gnome-base/librsvg
	 	 opengl? ( >=x11-libs/gtkglext-1 )
	 )
         gtk3? ( >=x11-libs/gtk+-3.4:3 >=gnome-base/librsvg-2.14.3
	 	 opengl? ( x11-libs/gtkglext )
	 )
	 X? ( x11-libs/libX11 x11-libs/libXtst )
         ncurses? ( sys-libs/ncurses )
         opengl? ( media-libs/mesa media-libs/glew )
	 gnome-keyring? ( gnome-base/gnome-keyring )
	 pdf? ( >=app-text/poppler-0.5 )
         cairo? ( >=x11-libs/cairo-1.6 )
	 pixbuf? ( >=x11-libs/gdk-pixbuf-2.4.13 )
	 imlib2? ( >=media-libs/imlib-1.4 )
         dbus? ( sys-apps/dbus )
         gsl? ( sci-libs/gsl )
	 gmp? ( dev-libs/gmp )
	 gstreamer? ( >=media-libs/gstreamer-1 )
	 jit? ( >=sys-devel/llvm-3.1 )
	 httpd? ( sys-libs/glibc )
         openssl? ( dev-libs/openssl )
         openal? ( >=media-libs/openal-1.13 )
	 smtp? ( dev-libs/glib )
	 odbc? ( dev-db/unixODBC )
	 dev-libs/libffi
	 x11-misc/xdg-utils
	 sys-devel/gettext
	 sys-devel/gcc"
DEPEND="${RDEPEND}
        >=sys-devel/libtool-2.4
	>=sys-devel/autoconf-2.68
	>=sys-devel/automake-1.11.1"
REQUIRED_USE="mixer? ( || ( sdl sdl2 ) ) qt4? ( X ) qt5? ( X ) gtk2? ( X cairo ) gtk3? ( X cairo ) xslt? ( xml ) ide ( X network curl qt4 webkit )"

FEATURES=""

S="${WORKDIR}/gambas3-${PV}"

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
		ewarn "Gambas does not support clang/clang++ as the primary compiler.  Clang doesn't support nested functions."
		ewarn "Forcing GCC..."
		export CC="gcc"
		export CXX="g++"
	fi
}

src_prepare() {
	! use bzip2 && sed -i -e 's|GB_CONFIG_SUBDIRS(bzlib2, gb.compress.bzlib2)||' configure.ac
	! use zlib && sed -i -e 's|GB_CONFIG_SUBDIRS(zlib, gb.compress.zlib)||' configure.ac
	! use mysql && sed -i -e 's|GB_CONFIG_SUBDIRS(mysql, gb.db.mysql)||' configure.ac
	! use odbc && sed -i -e 's|GB_CONFIG_SUBDIRS(odbc, gb.db.odbc)||' configure.ac
	! use postgresql && sed -i -e 's|GB_CONFIG_SUBDIRS(postgresql, gb.db.postgresql)||' configure.ac
	! use sqlite2 && sed -i -e 's|GB_CONFIG_SUBDIRS(sqlite2, gb.db.sqlite2)||' configure.ac
	! use sqlite3 && sed -i -e 's|GB_CONFIG_SUBDIRS(sqlite3, gb.db.sqlite3)||' configure.ac
	! use network && sed -i -e 's|GB_CONFIG_SUBDIRS(net, gb.net)||' configure.ac
	! use curl && sed -i -e 's|GB_CONFIG_SUBDIRS(curl, gb.net.curl)||' configure.ac
	! use mime && sed -i -e 's|GB_CONFIG_SUBDIRS(mime, gb.mime)||' configure.ac
	! use pcre && sed -i -e 's|GB_CONFIG_SUBDIRS(pcre, gb.pcre)||' configure.ac
	! use sdl && sed -i -e 's|GB_CONFIG_SUBDIRS(sdl, gb.sdl)||' configure.ac
	! use mixer && sed -i -e 's|GB_CONFIG_SUBDIRS(sdlsound, gb.sdl.sound)||' configure.ac
	! use sdl2 && sed -i -e 's|GB_CONFIG_SUBDIRS(sdl2, gb.sdl2)||' configure.ac
	! use xml && sed -i -e 's|GB_CONFIG_SUBDIRS(libxml, gb.libxml)||' configure.ac
	! use xslt && sed -i -e 's|GB_CONFIG_SUBDIRS(xml, gb.xml)||' configure.ac
	! use v4l && sed -i -e 's|GB_CONFIG_SUBDIRS(v4l, gb.v4l)||' configure.ac
	! use crypt && sed -i -e 's|GB_CONFIG_SUBDIRS(crypt, gb.crypt)||' configure.ac
	! use qt4 && sed -i -e 's|GB_CONFIG_SUBDIRS(qt4, gb.qt4)||' configure.ac
	! use qt5 && sed -i -e 's|GB_CONFIG_SUBDIRS(qt5, gb.qt5)||' configure.ac
	! use gtk2 && sed -i -e 's|GB_CONFIG_SUBDIRS(gtk, gb.gtk)||' configure.ac
	! use gtk3 && sed -i -e 's|GB_CONFIG_SUBDIRS(gtk3, gb.gtk3)||' configure.ac
	! use opengl && sed -i -e 's|GB_CONFIG_SUBDIRS(opengl, gb.opengl)||' configure.ac
	! use X && sed -i -e 's|GB_CONFIG_SUBDIRS(x11, gb.desktop.x11)||' configure.ac
	! use gnome-keyring && sed -i -e 's|GB_CONFIG_SUBDIRS(keyring, gb.desktop.gnome.keyring)||' configure.ac
	! use pdf && sed -i -e 's|GB_CONFIG_SUBDIRS(pdf, gb.pdf)||' configure.ac
	! use cairo && sed -i -e 's|GB_CONFIG_SUBDIRS(cairo, gb.cairo)||' configure.ac
	! use pixbuf && sed -i -e 's|GB_CONFIG_SUBDIRS(imageio, gb.image.io)||' configure.ac
	! use imlib2 && sed -i -e 's|GB_CONFIG_SUBDIRS(imageimlib, gb.image.imlib)||' configure.ac
	! use dbus && sed -i -e 's|GB_CONFIG_SUBDIRS(dbus, gb.dbus)||' configure.ac
	! use gsl && sed -i -e 's|GB_CONFIG_SUBDIRS(gsl, gb.gsl)||' configure.ac
	! use gmp && sed -i -e 's|GB_CONFIG_SUBDIRS(gmp, gb.gmp)||' configure.ac
	! use ncurses && sed -i -e 's|GB_CONFIG_SUBDIRS(ncurses, gb.ncurses)||' configure.ac
	! use gstreamer && sed -i -e 's|GB_CONFIG_SUBDIRS(media, gb.media)||' configure.ac
	! use jit && sed -i -e 's|GB_CONFIG_SUBDIRS(jit, gb.jit)||' configure.ac
	! use httpd && sed -i -e 's|GB_CONFIG_SUBDIRS(httpd, gb.httpd)||' configure.ac
	! use openssl && sed -i -e 's|GB_CONFIG_SUBDIRS(openssl, gb.openssl)||' configure.ac
	! use openal && sed -i -e 's|GB_CONFIG_SUBDIRS(openal, gb.openal)||' configure.ac

	! use bzip2 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @bzlib2_dir@ [\]\n||g' Makefile.am
	! use zlib && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @zlib_dir@ [\]\n||g' Makefile.am
	! use mysql && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @mysql_dir@ [\]\n||g' Makefile.am
	! use odbc && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @odbc_dir@ [\]\n||g' Makefile.am
	! use postgresql && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @postgresql_dir@ [\]\n||g' Makefile.am
	! use sqlite2 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @sqlite2_dir@ [\]\n||g' Makefile.am
	! use sqlite3 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @sqlite3_dir@ [\]\n||g' Makefile.am
	! use network && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @net_dir@ [\]\n||g' Makefile.am
	! use curl && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @curl_dir@ [\]\n||g' Makefile.am
	! use mime && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @mime_dir@ [\]\n||g' Makefile.am
	! use pcre && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @pcre_dir@ [\]\n||g' Makefile.am
	! use sdl && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @sdl_dir@ [\]\n||g' Makefile.am
	! use mixer && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @sdlsound_dir@ [\]\n||g' Makefile.am
	! use sdl2 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @sdl2_dir@ [\]\n||g' Makefile.am
	! use xml && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @libxml_dir@ [\]\n||g' Makefile.am
	! use xslt && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @xml_dir@ [\]\n||g' Makefile.am
	! use v4l && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @v4l_dir@ [\]\n||g' Makefile.am
	! use crypt && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @crypt_dir@ [\]\n||g' Makefile.am
	! use qt4 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @qt4_dir@ [\]\n||g' Makefile.am
	! use qt5 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @qt5_dir@ [\]\n||g' Makefile.am
	! use gtk2 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @gtk_dir@ [\]\n||g' Makefile.am
	! use gtk3 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @gtk3_dir@ [\]\n||g' Makefile.am
	! use opengl && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @opengl_dir@ [\]\n||g' Makefile.am
	! use X && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @x11_dir@ [\]\n||g' Makefile.am
	! use gnome-keyring && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @keyring_dir@ [\]\n||g' Makefile.am
	! use pdf && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @pdf_dir@ [\]\n||g' Makefile.am
	! use cairo && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @cairo_dir@ [\]\n||g' Makefile.am
	! use pixbuf && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @imageio_dir@ [\]\n||g' Makefile.am
	! use imlib2 && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @imageimlib_dir@ [\]\n||g' Makefile.am
	! use dbus && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @dbus_dir@ [\]\n||g' Makefile.am
	! use gsl && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @gsl_dir@ [\]\n||g' Makefile.am
	! use gmp && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @gmp_dir@ [\]\n||g' Makefile.am
	! use ncurses && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @ncurses_dir@ [\]\n||g' Makefile.am
	! use gstreamer && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @media_dir@ [\]\n||g' Makefile.am
	! use jit && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @jit_dir@ [\]\n||g' Makefile.am
	! use httpd && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @httpd_dir@ [\]\n||g' Makefile.am
	! use openssl && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @openssl_dir@ [\]\n||g' Makefile.am
	! use openal && sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's| @openal_dir@ [\]\n||g' Makefile.am

	sed -i -e ':a' -e 'N' -e '$!ba' -e 's|dist_gblib_DATA = $(COMPONENT).component\ngblib_DATA = $(COMPONENT).component|gblib_DATA = $(COMPONENT).component|g' component.am

	eapply_user

	eautoreconf || die
}

src_configure() {
	econf 	$(use_enable qt5) \
		$(use_enable qt4) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable postgresql) \
		$(use_enable sqlite2) \
		$(use_enable sqlite3) \
		$(use_enable mysql) \
		$(use_enable X x11) \
		$(use_enable pdf) \
		$(use_enable openssl) \
                $(use_enable openal) \
		$(use_enable jit) \
		$(use_enable dbus) \
		$(use_enable sdl) \
		$(use_enable sdl2) \
		$(use_enable curl) \
		$(use_enable gnome-keyring keyring) \
		$(use_enable bzip2) \
		$(use_enable zlib) \
		$(use_enable v4l) \
		$(use_enable mime) \
		$(use_enable gmp) \
		$(use_enable imlib2 imageimlib) \
		$(use_enable cairo) \
		$(use_enable pcre) \
		$(use_enable crypt) \
		$(use_enable gstreamer media) \
		$(use_enable xml) \
		$(use_enable odbc) \
		$(use_enable httpd) \
		$(use_enable network net) \
		$(use_enable pixbuf imageio) \
		|| die

	if use qt5; then
		cd "gb.qt5"
		econf  $(use_enable qt5) \
		       $(use_enable webkit qt5webkit) \
		       $(use_enable opengl qt5opengl) || die
		cd ..
	fi

	if use qt4; then
		cd "gb.qt4"
		econf  $(use_enable qt4 qt) \
		       $(use_enable webkit qtwebkit) \
		       $(use_enable opengl qtopengl) \
		       --enable-qtext || die
		cd ..
	fi

	if use gtk2; then
		cd "gb.gtk"
		econf   $(use_enable gtk2 gtk) \
			$(use_enable opengl gtkopengl) || die
		cd ..
	fi

	if use gtk3; then
		cd "gb.gtk3"
		econf  $(use_enable gtk3) || die
		cd ..
	fi

	if use cairo; then
		cd "gb.cairo"
		econf  $(use_enable cairo) || die
		cd ..
	fi

	if use bzip2; then
		cd "gb.compress.bzlib2"
		econf  $(use_enable bzip2 bzlib2) || die
		cd ..
	fi

	if use zlib; then
		cd "gb.compress.zlib"
		econf  $(use_enable zlib) || die
		cd ..
	fi

	if use crypt; then
		cd "gb.crypt"
		econf  $(use_enable crypt) || die
		cd ..
	fi

	if use mysql; then
		cd "gb.db.mysql"
		econf  $(use_enable mysql) || die
		cd ..
	fi

	if use odbc; then
		cd "gb.db.odbc"
		econf $(use_enable odbc) || die
		cd ..
	fi

	if use postgresql; then
		cd "gb.db.postgresql"
		econf  $(use_enable postgresql) || die
		cd ..
	fi

	if use sqlite2; then
		cd "gb.db.sqlite2"
		econf  $(use_enable sqlite2) || die
		cd ..
	fi

	if use sqlite3; then
		cd "gb.db.sqlite3"
		econf  $(use_enable sqlite3) || die
		cd ..
	fi

	if use gnome-keyring; then
		cd "gb.desktop.gnome.keyring"
		econf  $(use_enable gnome-keyring gb_desktop_gnome_keyring) || die
		cd ..
	fi

	if use X; then
		cd "gb.desktop.x11"
		econf  $(use_enable X desktop_x11) || die
		cd ..
	fi

	if use gmp; then
		cd "gb.gmp"
		econf  $(use_enable gmp) || die
		cd ..
	fi

	if use gsl; then
		cd "gb.gsl"
		econf  $(use_enable gsl) || die
		cd ..
	fi

	if use imlib2; then
		cd "gb.image.imlib"
		econf  $(use_enable imlib2 image_imlib) || die
		cd ..
	fi

	if use pixbuf; then
		cd "gb.image.io"
		econf  $(use_enable pixbuf image_io) || die
		cd ..
	fi

	if use xml; then
		cd "gb.libxml"
		econf  $(use_enable xml) || die
		cd ..
	fi

	if use gstreamer; then
		cd "gb.media"
		econf  $(use_enable gstreamer media) || die
		cd ..
	fi

	if use mime; then
		cd "gb.mime"
		econf  $(use_enable mime) || die
		cd ..
	fi

	if use ncurses; then
		cd "gb.ncurses"
		econf  $(use_enable ncurses) || die
		cd ..
	fi

	if use network; then
		cd "gb.net"
		econf  $(use_enable network net) || die
		cd ..
	fi

	if use curl; then
		cd "gb.net.curl"
		econf  $(use_enable curl) || die
		cd ..
	fi

	if use openal; then
		cd "gb.openal"
		econf  $(use_enable openal) || die
		cd ..
	fi

	if use openssl; then
		cd "gb.openssl"
		econf  $(use_enable openssl) || die
		cd ..
	fi

	if use pcre; then
		cd "gb.pcre"
		econf  $(use_enable pcre) || die
		cd ..
	fi

	if use pdf; then
		cd "gb.pdf"
		econf  $(use_enable pdf poppler) || die
		cd ..
	fi

	if use pdf; then
		cd "gb.pdf"
		econf  $(use_enable pdf poppler) || die
		cd ..
	fi

	if use sdl; then
		cd "gb.sdl"
		econf  $(use_enable sdl) || die
		cd ..
		if use mixer; then
			cd "gb.sdl.sound"
			econf $(use_enable mixer sdlsound) || die
			cd ..
		fi
	fi

	if use sdl2; then
		cd "gb.sdl2"
		econf  $(use_enable sdl2) \
		       $(use_enable mixer sdl2audio) || die
		cd ..
	fi

	if use v4l; then
		cd "gb.v4l"
		econf  $(use_enable v4l v4lconvert) \
		       $(use_enable v4l) die
		cd ..
	fi

	if use xslt; then
		cd "gb.xml"
		econf  $(use_enable xml) \
		       $(use_enable xslt xmlxslt) \
		       --enable-xmlhtml || die
		cd ..
	fi
}

src_compile() {
	emake || die
}

src_install() {
	mkdir -p "${D}/usr/share/icons/hicolor/"
	mkdir -p "${D}/usr/share/mime/packages/"
	XDG_DATA_DIRS="${D}/usr/share/" \
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog README COPYING

	! use ide && rm "${D}/usr/bin/gambas3"

	if use ide; then
		mkdir -p "${D}/usr/share/gambas"
		cp "${S}/app/desktop/gambas3.png" "${D}/usr/share/gambas"/
		make_desktop_entry "/usr/bin/gambas3.gambas" "Gambas" "/usr/share/gambas/gambas3.png" "Development;IDE"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}
pkg_postinst() {
        fdo-mime_desktop_database_update
        fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
pkg_postrm() {
        fdo-mime_desktop_database_update
        fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

