# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic toolchain-funcs xdg

SRC_URI="
https://gitlab.com/gambas/gambas/-/archive/${PV}/gambas-${PV}.tar.bz2
"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Gambas is a free development environment and a full powerful \
development platform based on a Basic interpreter with object extensionsand form \
designer."
HOMEPAGE="http://gambas.sourceforge.net/en/main.html"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
RESTRICT="mirror"
SLOT="0"
GAMBAS_MODULES=(
bzip2 cairo crypt curl dbus gmp gnome-keyring gsl gstreamer gtk3 htmlview httpd
imlib2 jit mime mixer mysql ncurses network odbc openal opengl openssl pcre pdf
pixbuf poppler postgresql qt5 sdl sdl2 sqlite v4l wayland X xml xslt zlib zstd
)
LIBSDL_PV="1.2.8"
LIBSDL2_PV="2.0.2"
QT_MIN_PV="5.3"
# On each minor release, re-inspect the code quality.
# Disabled unstable and unfinished code for security and productivity reasons.
# Deprecated is enabled until the component is deleted.
GAMBAS_MODULES_DEFAULTS=(
	${GAMBAS_MODULES[@]/#/+}
	${GAMBAS_MODULES_DEFAULTS[@]/+dbus/-dbus}
	${GAMBAS_MODULES_DEFAULTS[@]/+gsl/-gsl}
	${GAMBAS_MODULES_DEFAULTS[@]/+gtk3/-gtk3}
	${GAMBAS_MODULES_DEFAULTS[@]/+imlib2/-imlib2}
	${GAMBAS_MODULES_DEFAULTS[@]/+mysql/-mysql}
	${GAMBAS_MODULES_DEFAULTS[@]/+ncurses/-ncurses}
	${GAMBAS_MODULES_DEFAULTS[@]/+pdf/-pdf}
	${GAMBAS_MODULES_DEFAULTS[@]/+sdl2/-sdl2}
)
# The remove_stable_not_finished is intentionally kept disabled.
# The remove_deprecated is intentionally kept disabled until upstream removes it.
# The USE flags below have no config options but are removed manually.
IUSE+="
${GAMBAS_MODULES_DEFAULTS[@]}
debug doc +glsl +glu +ide +jit +glsl +sge remove_deprecated +remove_not_finished
remove_stable_not_finished +remove_unstable smtp +webview
"
REQUIRED_USE+="
	glsl? (
		opengl
	)
	gtk3? (
		cairo
		X
	)
	ide (
		curl
		gtk3
		htmlview
		network
		pcre
		X
	)
	mixer? (
		|| (
			sdl
			sdl2
		)
	)
	opengl? (
		gtk3? (
			opengl
			X
		)
		qt5? (
			X
		)
		|| (
			gtk3
			qt5
		)
	)
	remove_deprecated? (
		!gnome-keyring
		!pdf
		!sdl
		!v4l
	)
	remove_not_finished? (
		!dbus
		!gsl
		!gtk3
		!imlib2
		!ncurses
		!poppler
	)
	remove_stable_not_finished? (
		!sdl2
		!xml
	)
	remove_unstable? (
		!jit
		!mysql
		!pdf
	)
	sdl? (
		opengl
		X
	)
	sdl2? (
		|| (
			wayland
			X
		)
	)
	qt5? (
		|| (
			wayland
			X
		)
	)
	sge? (
		opengl
	)
	xml? (
		xslt
	)
	xslt? (
		xml
	)
"
# For depends see also:
# https://gitlab.com/gambas/gambas/-/blob/3.16.3/.gitlab-ci.yml
DEPEND+="
	dev-libs/libffi
	sys-devel/gcc
	sys-devel/gettext
	virtual/libc
	x11-misc/xdg-utils
	bzip2? (
		app-arch/bzip2
	)
	cairo? (
		>=x11-libs/cairo-1.6
	)
	crypt? (
		dev-libs/libgcrypt
	)
	curl? (
		>=net-misc/curl-7.13
	)
	dbus? (
		>=sys-apps/dbus-1
	)
	gmp? (
		dev-libs/gmp
	)
	gnome-keyring? (
		gnome-base/gnome-keyring
	)
	glu? (
		media-libs/glu
	)
	gsl? (
		sci-libs/gsl
	)
	gstreamer? (
		>=media-libs/gstreamer-1
	)
	gtk3? (
		>=gnome-base/librsvg-2.14.3
		>=x11-libs/gtk+-3.4:3[wayland?,X?]
		x11-libs/libICE
		x11-libs/libSM
		webview? (
			|| (
				>=net-libs/webkit-gtk-2.20:4
				>=net-libs/webkit-gtk-2.20:4.1
			)
		)
	)
	httpd? (
		sys-libs/glibc
	)
	imlib2? (
		>=media-libs/imlib-1.4
	)
	jit? (
		|| (
			sys-devel/gcc
			sys-devel/clang
			dev-lang/tcc
		)
	)
	mime? (
		>=dev-libs/gmime-3
	)
	mixer? (
		sdl? (
			media-libs/sdl-mixer
		)
		sdl2? (
			>=media-libs/sdl2-mixer-2
		)
	)
	mysql? (
		virtual/mysql
	)
	ncurses? (
		sys-libs/ncurses
	)
	odbc? (
		dev-db/unixODBC
	)
	openal? (
		>=media-libs/openal-1.13
		media-libs/alure
	)
	opengl? (
		media-libs/glew
		media-libs/mesa
		gtk3? (
			x11-libs/gtkglext
		)
	)
	openssl? (
		>=dev-libs/openssl-1
	)
	pcre? (
		dev-libs/libpcre
	)
	pdf? (
		>=app-text/poppler-0.58
	)
	poppler? (
		>=app-text/poppler-0.20
	)
	pixbuf? (
		>=x11-libs/gdk-pixbuf-2.4.13
	)
	postgresql? (
		dev-db/postgresql
	)
	qt5? (
		>=dev-qt/qtcore-${QT_MIN_PV}:5=
		>=dev-qt/qtgui-${QT_MIN_PV}:5=[wayland?,X?]
		>=dev-qt/qtprintsupport-${QT_MIN_PV}:5=
		>=dev-qt/qtsvg-${QT_MIN_PV}:5=
		>=dev-qt/qtwidgets-${QT_MIN_PV}:5=[X?]
		opengl? (
			>=dev-qt/qtopengl-${QT_MIN_PV}:5=
		)
		webview? (
			>=dev-qt/qtwebengine-5:5=[widgets]
		)
		X? (
			>=dev-qt/qtx11extras-${QT_MIN_PV}:5=
			x11-libs/libX11
		)
	)
	sdl? (
		>=media-libs/libsdl-${LIBSDL_PV}[opengl?,X?]
		media-libs/sdl-ttf
		mixer? (
			>=media-libs/libsdl-${LIBSDL_PV}[opengl?,sound,X?]
		)
		X? (
			x11-libs/libXcursor
		)
	)
	sdl2? (
		>=media-libs/libsdl2-${LIBSDL2_PV}[wayland?,X?]
		>=media-libs/sdl2-image-2.0
		>=media-libs/sdl2-ttf-2.0.12
		mixer? (
			>=media-libs/libsdl2-${LIBSDL2_PV}[wayland?,sound,X?]
		)
	)
	smtp? (
		dev-libs/glib
	)
	sqlite? (
		dev-db/sqlite:3
	)
	v4l? (
		media-libs/libpng
		media-libs/libv4l
		virtual/jpeg
	)
	X? (
		x11-libs/libX11
		x11-libs/libXtst
	)
	xml? (
		>=dev-libs/libxml2-2
	)
	xslt? (
		dev-libs/libxslt
	)
	zlib? (
		sys-libs/zlib
	)
	zstd? (
		>=app-arch/zstd-1.3.3
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-build/autoconf-2.68
	>=dev-build/automake-1.11.1
	>=sys-devel/libtool-2.4
"
DOCS=( AUTHORS ChangeLog README )

declare -Ax USE_FLAG_TO_MODULE_NAME=(
	[bzip2]="bzlib2"
	[cairo]="cairo"
	[crypt]="crypt"
	[curl]="curl"
	[dbus]="dbus"
	[gmp]="gmp"
	[gnome-keyring]="keyring"
	[gsl]="gsl"
	[gstreamer]="media"
	[gtk3]="gtk3"
	[htmlview]="htmlview"
	[httpd]="httpd"
	[imlib2]="imageimlib"
	[mime]="mime"
	[ncurses]="ncurses"
	[network]="net"
	[mixer]="sdlsound"
	[mysql]="mysql"
	[odbc]="odbc"
	[openal]="openal"
	[opengl]="opengl"
	[openssl]="openssl"
	[pcre]="pcre"
	[pdf]="pdf"
	[pixbuf]="imageio"
	[poppler]="poppler"
	[postgresql]="postgresql"
	[qt5]="qt5"
	[sdl]="sdl"
	[sdl2]="sdl2"
	[sqlite]="sqlite3"
	[v4l]="v4l"
	[X]="X"
	[xslt]="xslt"
	[xml]="libxml"
	[zlib]="zlib"
	[zstd]="zstd"
)

check_cxx() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	strip-unsupported-flags
einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo
	test-flags-CXX "-std=c++17" 2>/dev/null 1>/dev/null \
		|| die "Switch to a c++17 compatible compiler."
	if tc-is-gcc ; then
		if ver_test $(gcc-major-version) -lt 11 ; then
			die "${PN} requires GCC >=11 for c++17 support"
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt 11 ; then
			die "${PN} requires Clang >=11 for c++17 support"
		fi
	else
		die "Compiler is not supported for =${CATEGORY}/${P}"
	fi
}

check_qt() {
	einfo "Checking Qt versions"
	local QT_VERSION=$("${EROOT}/usr/$(get_libdir)/libQt5Core.so.5" \
		| head -n 1 \
		| cut -f 8 -d " ")
	if ver_test ${QT_VERSION} -lt ${QT_MIN_PV} ; then
		die "You need >=${QT_MIN_PV} for the Qt system libraries."
	fi

	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	use opengl && \
	QTOPENGL_PV=$(pkg-config --modversion Qt5OpenGL)
	QTPRINTSUPPORT_PV=$(pkg-config --modversion Qt5PrintSupport)
	QTSVG_PV=$(pkg-config --modversion Qt5Svg)
	use webview && \
	QTWEBENGINE_PV=$(pkg-config --modversion Qt5WebEngine)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	use X && \
	QTX11EXTRAS_PV=$(pkg-config --modversion Qt5X11Extras)

	if ver_test ${QT_VERSION} -ne ${QTCORE_PV} ; then
		die "QT_VERSION is not the same version as Qt5Core"
	fi
	if ver_test ${QT_VERSION} -ne ${QTGUI_PV} ; then
		die "QT_VERSION is not the same version as Qt5Gui"
	fi
	if use opengl && ver_test ${QT_VERSION} -ne ${QTOPENGL_PV} ; then
		die "QT_VERSION is not the same version as Qt5OpenGL"
	fi
	if ver_test ${QT_VERSION} -ne ${QTPRINTSUPPORT_PV} ; then
		die "QT_VERSION is not the same version as Qt5PrintSupport"
	fi
	if ver_test ${QT_VERSION} -ne ${QTSVG_PV} ; then
		die "QT_VERSION is not the same version as Qt5Svg"
	fi
	if use webview ; then
		strings "${EROOT}/usr/$(get_libdir)/libQt5WebEngine.so" \
			| grep -q -F -e "Qt_"$(ver_cut 1-2 ${QT_VERSION})
		if [[ "${?}" != "0" ]] ; then
			QT5WEBENGINE_HIGHEST=$(strings \
				"${EROOT}/usr/$(get_libdir)/libQt5WebEngine.so" \
				| grep -F -e "Qt_5." \
				| tail -n 1 \
				| cut -f 2 -d "_")
eerror
eerror "Qt5WebEngine is not compatible.  Highest supported by this library is"
eerror "${QT5WEBENGINE_HIGHEST}.  You have ${QT_VERSION}."
eerror
			die
		fi
	fi
	if ver_test ${QT_VERSION} -ne ${QTWIDGETS_PV} ; then
		die "QT_VERSION is not the same version as Qt5Widgets"
	fi
	if use X && ver_test ${QT_VERSION} -ne ${QTX11EXTRAS_PV} ; then
		die "QT_VERSION is not the same version as Qt5X11Extras"
	fi
}

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
ewarn
ewarn "Gambas does not support clang/clang++ as the primary compiler.  Clang"
ewarn "doesn't support nested functions.  Forcing GCC..."
ewarn
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		strip-unsupported-flags
	fi

	check_cxx
	use qt5 && check_qt
}

mod_off() {
	local module_name="${1}"
einfo "Disabling ${module_name}"
	sed -i -e "/GB_CONFIG_SUBDIRS[(]${module_name},/d" \
		configure.ac || die
	sed -i -r -e ":a;N;\$!ba s| @${module_name}_dir@ [\]\n||g" \
		Makefile.am || die
}

src_prepare() {
	default
	cd "${S}" || die
einfo "${GAMBAS_MODULES[@]}"
	local m
	for m in ${GAMBAS_MODULES[@]} ; do
		[[ "${m}" == "jit" ]] && continue
		if [[ -z "${USE_FLAG_TO_MODULE_NAME[${m}]}" ]] ; then
ewarn "QA:  Missing ${m} in USE_FLAG_TO_MODULE_NAME."
		fi
		use "${m}" || mod_off ${USE_FLAG_TO_MODULE_NAME[${m}]}
		use "${m}" && einfo "Enabling ${m}"
	done
	mod_off gtk
	mod_off qt4
	mod_off sqlite2

	# eautoreconf is slower
	./reconf-all
}

CODE_QUALITY_REPORT=

_use_enable_lto() {
	if is-flagq '-flto*' ; then
		echo "--enable-lto"
	else
		echo "--disable-lto"
	fi
}

src_configure() {
	econf \
		$(use_enable bzip2) \
		$(use_enable bzip2 bzlib2) \
		$(use_enable cairo) \
		$(use_enable crypt) \
		$(use_enable curl) \
		$(use_enable debug) \
		$(usex debug \
			--disable-optimization \
			--enable-optimization \
		) \
		$(use_enable dbus) \
		$(use_enable gmp) \
		$(use_enable gnome-keyring keyring) \
		$(use_enable gnome-keyring gb_desktop_gnome_keyring) \
		$(use_enable gstreamer media) \
		$(use_enable gtk3 \
			$(echo \
				" \
				$(use_enable opengl gtk3opengl) \
				$(use_enable wayland gtk3wayland) \
				$(use_enable webview gtk3webview) \
				$(use_enable X gtk3x11) \
				" \
			) \
		) \
		$(use_enable htmlview) \
		$(use_enable httpd) \
		$(use_enable imlib2 image_imlib) \
		$(use_enable imlib2 imageimlib) \
		$(use_enable mime) \
		$(use_enable mysql) \
		$(use_enable network net) \
		$(use_enable odbc) \
		$(use_enable openal) \
		$(use_enable opengl) \
		$(usex opengl \
			$(echo \
				" \
				$(use_enable glsl) \
				$(use_enable glu) \
				$(use_enable sge) \
				" \
			) \
			\
		) \
		$(use_enable openssl) \
		$(use_enable pcre) \
		$(use_enable pdf) \
		$(use_enable poppler) \
		$(use_enable pixbuf image_io) \
		$(use_enable pixbuf imageio) \
		$(use_enable postgresql) \
		$(use_enable qt5) \
		$(usex qt5 \
			$(echo \
				" \
				$(use_enable opengl qt5opengl) \
				$(use_enable wayland qt5wayland) \
				$(use_enable webview qt5webview) \
				$(use_enable X qt5ext) \
				$(use_enable X qt5x11) \
				" \
			) \
			\
		) \
		$(use_enable sdl) \
		$(usex sdl \
			$(use_enable mixer sdlsound) \
		) \
		$(use_enable sdl2) \
		$(usex sdl2 \
			$(use_enable mixer sdl2audio) \
		) \
		$(use_enable sqlite sqlite3) \
		$(use_enable v4l) \
		$(use_enable v4l v4lconvert) \
		$(use_enable X desktop_x11) \
		$(use_enable X x) \
		$(use_enable X x11) \
		$(use_enable xml) \
		$(usex xml \
			$(usex xslt \
				$(echo \
					" \
					$(use_enable xslt xmlxslt) \
					--enable-xmlhtml \
					" \
				) \
				\
			) \
			\
		) \
		$(use_enable zlib) \
		$(use_enable zstd) \
		$(_use_enable_lto) \
		--disable-jitllvm \
		--disable-gtk2 \
		--disable-qt4 \
		--disable-qt5webkit \
		--disable-sqlite2

	# Upstream will supply -O flags.
	filter-flags '-O*' '-flto*'

	local p
	for p in $(grep -l -F -e "State" $(find . -name "*.component")) ; do
		if echo "${p}" | grep -q -E -e "gb.xml/.component$" ; then
			# Makefile traversal doesn't go in this folder
			continue
		fi
		local state=$(grep -F -e "State" "${p}" | cut -f 2 -d "=")
		local component=$(
			echo "${p}" \
			| sed \
				-r \
				-e "s|comp/src/||g" \
				-e "s|main/lib/[^/]+/||g" \
				-e "s|[^/]+/src/[^/]+/||g" \
			| cut -f 2 -d "/"
		)
		# See app/src/gambas3/.src/Component/CComponent.class
		local m=""
		if [[ "${state}" =~ (0|Stable) ]] ; then
			m=" \e[92m*\e[39m ${component}: stable"
		elif [[ "${state}" =~ Finished ]] ; then
			m=" \e[92m*\e[39m ${component}: finished"
		elif [[ "${state}" =~ NotFinished ]] ; then
			m=" \e[93m*\e[39m ${component}: is not finished"
		elif [[ "${state}" =~ 1 ]] ; then
			m=" \e[93m*\e[39m ${component}: is stable but not finished"
		elif [[ "${state}" =~ 2 ]] ; then
			m=" \e[93m*\e[39m ${component}: is unstable"
		elif [[ "${state}" =~ (3|Deprecated) ]] ; then
			m=" \e[93m*\e[39m ${component}: is deprecated and may be removed soon"
		elif [[ "${state}" =~ 4 ]] ; then
			m=" \e[93m*\e[39m ${component}: is of unknown code quality"
		fi
		CODE_QUALITY_REPORT+="${m}\n"
	done
	CODE_QUALITY_REPORT=$(echo -e "${CODE_QUALITY_REPORT}" | sort)
einfo "Code quality:"
	echo -e "${CODE_QUALITY_REPORT}"
}

src_compile() {
	emake
}

find_remove_module() {
	local name="${1}"
	find "${ED}" \
		-name "${name}" \
		-type d \
		-print0 \
		-exec rm -rf {} +
	find "${ED}" \
		-regextype 'posix-egrep' \
		-regex ".*/${name}.(gambas|component|info|list|so|so.0|so\.0\.0\.0)" \
		-print0 \
		-exec rm -rf {} +
}

gen_env() {
cat <<-EOF > "${T}"/50${PN}-jit
# Details can be found at http://gambaswiki.org/wiki/doc/jit
GB_NO_JIT=${EGAMBAS_GB_NO_JIT:=0}
GB_JIT_DEBUG=${EGAMBAS_GB_JIT_DEBUG:=0}
GB_JIT_CC="${EGAMBAS_GB_JIT_CC:=gcc}"
GB_JIT_CFLAGS="${EGAMBAS_GB_JIT_CFLAGS:=-O3}"
EOF
}

src_install() {
	dodir "/usr/share/icons/hicolor/"
	dodir "/usr/share/mime/packages/"
	XDG_DATA_DIRS="${D}/usr/share/" \
	emake DESTDIR="${D}" install
	! use ide && rm "${D}/usr/bin/gambas3"
	if use ide; then
		doicon -s 48 "app/desktop/gambas3.png"
		doicon -s 256 "app/desktop/gambas3.svg"
		doicon -s scalable "app/desktop/gambas3.svg"
		make_desktop_entry \
			"/usr/bin/gambas3.gambas" \
			"Gambas" \
			"/usr/share/gambas/gambas3.png" \
			"Development;IDE"
	fi

	# Quality control sections:
	if use remove_deprecated ; then
		find_remove_module "gb.libxml"
		find_remove_module "gb.option.component"
		find_remove_module "gb.pdf"
		find_remove_module "gb.report"
		find_remove_module "gb.web.form"
	fi

	if use remove_stable_not_finished ; then
		if ! use ide ; then
			find_remove_module "gb.desktop"
			find_remove_module "gb.form.htmlview"
			find_remove_module "gb.form.terminal"
			find_remove_module "gb.util"
			find_remove_module "gb.util.web"

	# Causes runtime failure
			find_remove_module "gb.test"
		fi
		find_remove_module "gb.desktop.x11"
		find_remove_module "gb.map"
		find_remove_module "gb.memcached"
		find_remove_module "gb.poppler"
		find_remove_module "gb.test.component"
		find_remove_module "gb.web.feed"
		find_remove_module "gb.web.gui"
	fi

	if use remove_unstable ; then
		find_remove_module "gb.chart"
		find_remove_module "gb.dbus.trayicon"
		find_remove_module "gb.term.form"
	fi

	find "${D}" -name '*.la' -delete || die

	use doc && einstalldocs

	docinto licenses
	dodoc COPYING

	if use ide ; then
		if [[ ! -f "${ED}/usr/bin/gambas3.gambas" ]] ; then
eerror
eerror "The IDE was not built.  Fix the USE flags."
eerror
			die
		fi
	fi

	if use jit ; then
		gen_env
einfo "Systemwide JIT settings:"
		cat "${T}"/50${PN}-jit || die
		doenvd "${T}"/50${PN}-jit
einfo "To change them see \`epkginfo -x gambas\` or metadata.xml"
	fi
}

pkg_postinst() {
	einfo "Upstream code quality report:"
	echo -e "${CODE_QUALITY_REPORT}"
	xdg_pkg_postinst

	if use ide && use gtk3 ; then
einfo "To run the IDE with gtk3 from command line do \`GB_GUI=gb.gtk3 gambas3\`"
	fi

	if use ide && use qt5 ; then
einfo "To run the IDE with Qt5 from command line do \`GB_GUI=gb.qt5 gambas3\`"
	fi

	if use jit ; then
einfo "Relog or do \`source /etc/profile\` for changes to take affect."
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  jit, code-quality-selection
# OILEDMACHINE-OVERLAY-TEST:  passed (INTERACTIVE) 3.18.2 (20230527)
# OILEDMACHINE-OVERLAY-TEST:  passed (INTERACTIVE) 3.18.3 (20230625)
# USE="X cairo curl gtk3 htmlview ide network pcre wayland -bzip2 -crypt -dbus
# (-debug) -doc -glsl -glu -gmp -gnome-keyring -gsl -gstreamer -httpd -imlib2
# -jit -mime -mixer -mysql -ncurses -odbc -openal -opengl -openssl -pdf -pixbuf
# -poppler -postgresql -qt5 -remove_deprecated -remove_not_finished
# -remove_stable_not_finished -remove_unstable -sdl -sdl2 -sge -smtp -sqlite
# -v4l -webview -xml -xslt -zlib -zstd"
# tests under X:
#   designer:  passed
#   hello world (multiform):  passed
#   hello world (message box):  passed
#
# USE+=" remove_deprecated remove_stable_not_finished remove_unstable" (PASSED)
