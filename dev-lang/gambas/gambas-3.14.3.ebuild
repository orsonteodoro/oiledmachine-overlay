# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Gambas is a free development environment and a full powerful \
development platform based on a Basic interpreter with object extensions
and form designer."
HOMEPAGE="http://gambas.sourceforge.net/en/main.html"
SRC_URI=\
"https://gitlab.com/gambas/gambas/-/archive/${PV}/gambas-${PV}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
GAMBAS_MODULES="bzip2 cairo crypt curl dbus gmp gnome-keyring gsl gstreamer
gtk2 gtk3 httpd imlib2 jit mime mixer mysql ncurses network odbc openal
opengl openssl pcre pdf pixbuf postgresql qt5 sdl sdl2 sqlite2 sqlite3 v4l
X xml xslt zlib"
IUSE="${GAMBAS_MODULES} doc ide smtp webkit"
RDEPEND="bzip2? ( app-arch/bzip2 )
	cairo? ( >=x11-libs/cairo-1.6 )
	crypt? ( dev-libs/libgcrypt )
	curl? ( >=net-misc/curl-7.13 )
	dbus? ( sys-apps/dbus )
	dev-libs/libffi
	gmp? ( dev-libs/gmp )
	gnome-keyring? ( gnome-base/gnome-keyring )
	gsl? ( sci-libs/gsl )
	gstreamer? ( >=media-libs/gstreamer-1 )
	gtk2? ( >=gnome-base/librsvg-2.14.3
		opengl? ( >=x11-libs/gtkglext-1 )
		>=x11-libs/gtk+-2.16:2
		x11-libs/libICE
		x11-libs/libSM )
	gtk3? ( >=gnome-base/librsvg-2.14.3
		>=x11-libs/gtk+-3.4:3
		x11-libs/libICE
		x11-libs/libSM )
	httpd? ( sys-libs/glibc )
	imlib2? ( >=media-libs/imlib-1.4 )
	jit? ( >=sys-devel/llvm-3.1
		<sys-devel/llvm-3.6 )
	mime? ( >=dev-libs/gmime-2.6 )
	mixer? ( sdl? ( media-libs/sdl-mixer )
		sdl2? ( >=media-libs/sdl2-mixer-2 ) )
	mysql? ( virtual/mysql )
	ncurses? ( sys-libs/ncurses )
	odbc? ( dev-db/unixODBC )
	openal? ( >=media-libs/openal-1.13 )
	opengl? ( media-libs/mesa
		media-libs/glew )
	openssl? ( dev-libs/openssl )
	pcre? ( dev-libs/libpcre )
	pdf? ( >=app-text/poppler-0.5 )
	pixbuf? ( >=x11-libs/gdk-pixbuf-2.4.13 )
	postgresql? ( dev-db/postgresql )
	qt5? ( >=dev-qt/qtcore-5.3:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport
		dev-qt/qtsvg:5
		dev-qt/qtwidgets
		dev-qt/qtx11extras
		opengl? ( dev-qt/qtopengl:5 )
		webkit? ( dev-qt/qtnetwork
			dev-qt/qtwebkit:5
			dev-qt/qtxml ) )
	sdl? ( >=media-libs/libsdl-1.2.8
		media-libs/sdl-ttf )
	sdl2? ( >=media-libs/libsdl2-2.0.2
		>=media-libs/sdl2-image-2.0
		>=media-libs/sdl2-ttf-2.0.12 )
	smtp? ( dev-libs/glib )
	sqlite2? ( dev-db/sqlite:2 )
	sqlite3? ( dev-db/sqlite:3 )
	sys-devel/gcc
	sys-devel/gettext
	v4l? ( media-libs/libpng
		media-libs/libv4l
		virtual/jpeg )
	X? ( x11-libs/libX11
		x11-libs/libXtst )
	x11-misc/xdg-utils
	xml? ( >=dev-libs/libxml2-2 )
	xslt? ( dev-libs/libxslt )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.68
	>=sys-devel/automake-1.11.1
	>=sys-devel/libtool-2.4"
REQUIRED_USE="
	gtk2? ( X cairo )
	gtk3? ( X cairo )
	ide ( X network curl ^^ ( qt5 ) webkit )
	mixer? ( || ( sdl sdl2 ) )
	qt5? ( X )
	xml? ( xslt )
	xslt? ( xml )"
inherit autotools desktop eutils fdo-mime toolchain-funcs xdg-utils
S="${WORKDIR}/${PN}-${PV}"
DOCS=( AUTHORS ChangeLog COPYING README )
RESTRICT="mirror"

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
		ewarn \
"Gambas does not support clang/clang++ as the primary compiler.  Clang\n\
doesn't support nested functions.  Forcing GCC..."
		export CC="gcc"
		export CXX="g++"
	fi
}

mod_off() {
	local module_name="${1}"
	sed -i -e "s|\
GB_CONFIG_SUBDIRS\(${module_name}, gb[.a-z]*.${module_name}\)||" \
		configure.ac || die
	sed -i -r -e ":a;N;\$!ba s| @${module_name}_dir@ [\]\n||g" \
		Makefile.am || die
}

src_prepare() {
	default
	cd "${S}" || die
	for m in ${GAMBAS_MODULES} ; do
		echo "$USE" | grep -F -q -o "${m}" \
			|| mod_off $(remap_use ${m})
	done

	L=$(find . -name "configure.ac")
	for c in ${L} ; do
		[[ "${c}" =~ TEMPLATE ]] && continue
		pushd $(dirname "${c}") || die
			eautoreconf || die
		popd
	done
}

src_configure() {
	econf \
		$(use_enable bzip2) \
		$(use_enable bzip2 bzlib2) \
		$(use_enable cairo) \
		$(use_enable crypt) \
		$(use_enable curl) \
		$(use_enable dbus) \
		$(use_enable gmp) \
		$(use_enable gnome-keyring keyring) \
		$(use_enable gnome-keyring gb_desktop_gnome_keyring) \
		$(use_enable gstreamer media) \
		$(use_enable gtk2) \
		$(usex gtk2 \
			$(use_enable opengl gtkopengl) ) \
		$(use_enable gtk3) \
		$(use_enable httpd) \
		$(use_enable imlib2 image_imlib) \
		$(use_enable imlib2 imageimlib) \
		$(use_enable jit) \
		$(use_enable mime) \
		$(use_enable mysql) \
		$(use_enable network net) \
		$(use_enable odbc) \
		$(use_enable openal) \
		$(use_enable openssl) \
		$(use_enable pcre) \
		$(use_enable pdf) \
		$(use_enable pdf poppler) \
		$(use_enable pixbuf image_io) \
		$(use_enable pixbuf imageio) \
		$(use_enable postgresql) \
		$(use_enable qt5) \
		$(usex qt5 \
			$(use_enable opengl qt5opengl) \
			$(use_enable webkit qt5webkit) ) \
		$(use_enable sdl) \
		$(usex sdl \
			$(use_enable mixer sdlsound) ) \
		$(use_enable sdl2) \
		$(usex sdl2 \
			$(use_enable mixer sdl2audio) ) \
		$(use_enable sqlite2) \
		$(use_enable sqlite3) \
		$(use_enable v4l) \
		$(use_enable v4l v4lconvert) \
		$(use_enable X x11) \
		$(use_enable X desktop_x11) \
		$(usex xslt $($(use_enable xslt xmlxslt) \
				--enable-xmlhtml) ) \
		$(use_enable xml) \
		$(use_enable zlib) \
		|| die
}

src_compile() {
	emake || die
}

src_install() {
	dodir "/usr/share/icons/hicolor/"
	dodir "/usr/share/mime/packages/"
	XDG_DATA_DIRS="${D}/usr/share/" \
	emake DESTDIR="${D}" install
	! use ide && rm "${D}/usr/bin/gambas3"
	if use ide; then
		insinto "/usr/share/gambas"
		doins "app/desktop/gambas3.png"
		make_desktop_entry "/usr/bin/gambas3.gambas" "Gambas" \
			"/usr/share/gambas/gambas3.png" "Development;IDE"
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
