# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic toolchain-funcs xdg

DESCRIPTION="Gambas is a free development environment and a full powerful \
development platform based on a Basic interpreter with object extensionsand form \
designer."
HOMEPAGE="http://gambas.sourceforge.net/en/main.html"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
GAMBAS_MODULES=(
bzip2 cairo crypt curl dbus gmp gnome-keyring gsl gstreamer gtk3 httpd imlib2
jit mime mixer mysql ncurses network odbc openal opengl openssl pcre pdf pixbuf
postgresql qt5 sdl sdl2 sqlite v4l X xml xslt zlib zstd
)
QT_MIN_PV="5.3"
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES[@]/#/+})
# On each minor release, re-inspect the code quality.
# Disabled unstable and unfinished code for security and productivity reasons.
# Deprecated is enabled until component deleted
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES_DEFAULTS[@]/+dbus/-dbus})
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES_DEFAULTS[@]/+gsl/-gsl})
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES_DEFAULTS[@]/+gtk3/-gtk3})
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES_DEFAULTS[@]/+imlib2/-imlib2})
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES_DEFAULTS[@]/+ncurses/-ncurses})
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES_DEFAULTS[@]/+mysql/-mysql})
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES_DEFAULTS[@]/+pdf/-pdf})
GAMBAS_MODULES_DEFAULTS=(${GAMBAS_MODULES_DEFAULTS[@]/+sdl2/-sdl2})
# The remove_stable_not_finished is intentionally kept disabled.
# The remove_deprecated is intentionally kept disabled until upstream removes it.
# The USE flags below have no config options but are removed manually.
IUSE+="
${GAMBAS_MODULES_DEFAULTS[@]}
debug doc +glsl +glu +ide +jit +glsl +sge smtp +webkit

remove_deprecated +remove_not_finished remove_stable_not_finished
+remove_unstable
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
		>=x11-libs/gtk+-3.4:3[X,wayland]
		x11-libs/libICE
		x11-libs/libSM
		|| (
			>=net-libs/webkit-gtk-2.20:4
			>=net-libs/webkit-gtk-2.20:4.1
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
		>=dev-libs/gmime-2.6
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
	)
	opengl? (
		media-libs/glew
		media-libs/mesa
	)
	openssl? (
		>=dev-libs/openssl-1
	)
	pcre? (
		dev-libs/libpcre
	)
	pdf? (
		>=app-text/poppler-0.58
		<app-text/poppler-23
	)
	pixbuf? (
		>=x11-libs/gdk-pixbuf-2.4.13
	)
	postgresql? (
		dev-db/postgresql
	)
	qt5? (
		>=dev-qt/qtcore-${QT_MIN_PV}:5=
		>=dev-qt/qtgui-${QT_MIN_PV}:5=
		>=dev-qt/qtprintsupport-${QT_MIN_PV}:5=
		>=dev-qt/qtsvg-${QT_MIN_PV}:5=
		>=dev-qt/qtwidgets-${QT_MIN_PV}:5=
		>=dev-qt/qtx11extras-${QT_MIN_PV}:5=
		opengl? (
			>=dev-qt/qtopengl-${QT_MIN_PV}:5=
		)
		webkit? (
			>=dev-qt/qtnetwork-${QT_MIN_PV}:5=
			>=dev-qt/qtwebkit-5:5=
			>=dev-qt/qtxml-${QT_MIN_PV}:5=
		)
	)
	sdl? (
		>=media-libs/libsdl-1.2.8
		media-libs/sdl-ttf
	)
	sdl2? (
		>=media-libs/libsdl2-2.0.2
		>=media-libs/sdl2-image-2.0
		>=media-libs/sdl2-ttf-2.0.12
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
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=sys-devel/autoconf-2.68
	>=sys-devel/automake-1.11.1
	>=sys-devel/libtool-2.4
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
		network
		gsl
		webkit
		X
		|| (
			gtk3
			qt5
		)
	)
	mixer? (
		|| (
			sdl
			sdl2
		)
	)
	opengl? (
		|| (
			qt5
		)
	)
	remove_deprecated? (
		!gnome-keyring
		!sdl
		!v4l
	)
	remove_not_finished? (
		!dbus
		!gsl
		!gtk3
		!imlib2
		!ncurses
	)
	remove_stable_not_finished? (
		!sdl2
	)
	remove_unstable? (
		!mysql
		!pdf
	)
	qt5? (
		X
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
SRC_URI="
https://gitlab.com/gambas/gambas/-/archive/${PV}/gambas-${PV}.tar.bz2
"
S="${WORKDIR}/${PN}-${PV}"
DOCS=( AUTHORS ChangeLog README )
RESTRICT="mirror"

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
	CC=$(tc-getCC)
	CXX=$(tc-getCXX)
	einfo "CC=${CC} CXX=${CXX}"
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

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
ewarn
ewarn "Gambas does not support clang/clang++ as the primary compiler.  Clang"
ewarn "doesn't support nested functions.  Forcing GCC..."
ewarn
		export CC="gcc"
		export CXX="g++"
	fi

	check_cxx

	if use qt5 ; then
		einfo "Checking Qt versions"
		local QT_VERSION=$("${EROOT}/usr/$(get_libdir)/libQt5Core.so.5" \
					| head -n 1 | cut -f 8 -d " ")
		if ver_test ${QT_VERSION} -lt ${QT_MIN_PV} ; then
			die "You need >=${QT_MIN_PV} for the Qt system libraries."
		fi

		QTCORE_PV=$(pkg-config --modversion Qt5Core)
		QTGUI_PV=$(pkg-config --modversion Qt5Gui)
		use webkit && \
		QTNETWORK_PV=$(pkg-config --modversion Qt5Network)
		use opengl && \
		QTOPENGL_PV=$(pkg-config --modversion Qt5OpenGL)
		QTPRINTSUPPORT_PV=$(pkg-config --modversion Qt5PrintSupport)
		QTSVG_PV=$(pkg-config --modversion Qt5Svg)
		#use webkit && \
		#QTWEBKIT_PV=$(pkg-config --modversion Qt5WebKit)
		QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
		QTX11EXTRAS_PV=$(pkg-config --modversion Qt5X11Extras)
		use webkit && \
		QTXML_PV=$(pkg-config --modversion Qt5Xml)

		if ver_test ${QT_VERSION} -ne ${QTCORE_PV} ; then
			die "QT_VERSION is not the same version as Qt5Core"
		fi
		if ver_test ${QT_VERSION} -ne ${QTGUI_PV} ; then
			die "QT_VERSION is not the same version as Qt5Gui"
		fi
		if use webkit && ( ver_test ${QT_VERSION} -ne ${QTNETWORK_PV} ) ; then
			die "QT_VERSION is not the same version as Qt5Network"
		fi
		if use opengl ; then
			if ver_test ${QT_VERSION} -ne ${QTOPENGL_PV} ; then
				die "QT_VERSION is not the same version as Qt5OpenGL"
			fi
		fi
		if ver_test ${QT_VERSION} -ne ${QTPRINTSUPPORT_PV} ; then
			die "QT_VERSION is not the same version as Qt5PrintSupport"
		fi
		if ver_test ${QT_VERSION} -ne ${QTSVG_PV} ; then
			die "QT_VERSION is not the same version as Qt5Svg"
		fi
		strings "${EROOT}/usr/$(get_libdir)/libQt5WebKit.so" \
			| grep -q -F -e "Qt_"$(ver_cut 1-2 ${QT_VERSION})
		if [[ "${?}" != "0" ]] ; then
			QT5WEBKIT_HIGHEST=$(strings \
				"${EROOT}/usr/$(get_libdir)/libQt5WebKit.so" \
				| grep -F -e "Qt_5." | tail -n 1 \
				| cut -f 2 -d "_")
			die \
"Qt5WebKit is not compatible.  Highest supported by this library is \
${QT5WEBKIT_HIGHEST}.  You have ${QT_VERSION}."
		fi
		if ver_test ${QT_VERSION} -ne ${QTWIDGETS_PV} ; then
			die "QT_VERSION is not the same version as Qt5Widgets"
		fi
		if ver_test ${QT_VERSION} -ne ${QTX11EXTRAS_PV} ; then
			die "QT_VERSION is not the same version as Qt5X11Extras"
		fi
		if use webkit && ( ver_test ${QT_VERSION} -ne ${QTXML_PV} ) ; then
			die "QT_VERSION is not the same version as Qt5Xml"
		fi
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
	for m in ${GAMBAS_MODULES[@]} ; do
		[[ "${m}" == "jit" ]] && continue
		echo "$USE" | grep -F -q -o "${m}" \
			|| mod_off ${USE_FLAG_TO_MODULE_NAME[${m}]}
	done
	mod_off gtk
	mod_off qt4
	mod_off sqlite2
	# prevent duplicate install failure
	sed -i -e "/dist_gblib_DATA/d" component.am || die
	L=$(find . -name "configure.ac")
	for c in ${L} ; do
		[[ "${c}" =~ TEMPLATE ]] && continue
		pushd $(dirname "${c}") || die
			eautoreconf
		popd
	done
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
		--disable-jitllvm \
		--disable-qt4 \
		--disable-gtk2 \
		--disable-gtkopengl \
		--disable-sqlite2 \
		$(_use_enable_lto) \
		$(use_enable bzip2) \
		$(use_enable bzip2 bzlib2) \
		$(use_enable cairo) \
		$(use_enable crypt) \
		$(use_enable curl) \
		$(use_enable debug) \
		$(usex debug --disable-optimization --enable-optimization) \
		$(use_enable dbus) \
		$(use_enable gmp) \
		$(use_enable gnome-keyring keyring) \
		$(use_enable gnome-keyring gb_desktop_gnome_keyring) \
		$(use_enable gstreamer media) \
		$(use_enable gtk3) \
		$(use_enable httpd) \
		$(use_enable imlib2 image_imlib) \
		$(use_enable imlib2 imageimlib) \
		$(use_enable mime) \
		$(use_enable mysql) \
		$(use_enable network net) \
		$(use_enable odbc) \
		$(use_enable openal) \
		$(use_enable opengl) \
		$(usex opengl $(use_enable glsl)) \
		$(usex opengl $(use_enable glu)) \
		$(usex opengl $(use_enable sge)) \
		$(use_enable openssl) \
		$(use_enable pcre) \
		$(use_enable pdf) \
		$(use_enable pdf poppler) \
		$(use_enable pixbuf image_io) \
		$(use_enable pixbuf imageio) \
		$(use_enable postgresql) \
		$(use_enable qt5) \
		$(usex qt5 \
			$(use_enable opengl qt5opengl) ) \
		$(usex qt5 \
			$(use_enable webkit qt5webkit) ) \
		$(use_enable sdl) \
		$(usex sdl \
			$(use_enable mixer sdlsound) ) \
		$(use_enable sdl2) \
		$(usex sdl2 \
			$(use_enable mixer sdl2audio) ) \
		$(use_enable sqlite sqlite3) \
		$(use_enable v4l) \
		$(use_enable v4l v4lconvert) \
		$(use_enable X desktop_x11) \
		$(use_enable X x) \
		$(use_enable X x11) \
		$(use_enable xml) \
		$(usex xml $(usex xslt $(echo $(use_enable xslt xmlxslt) \
				--enable-xmlhtml) ) ) \
		$(use_enable zlib) \
		$(use_enable zstd)

	# Upstream will supply -O flags.
	filter-flags '-O*' '-flto*'

	for p in $(grep -l -F -e "State" $(find . -name "*.component")) ; do
		if echo "${p}" | grep -q -E -e "gb.xml/.component$" ; then
			# Makefile traversal doesn't go in this folder
			continue
		fi
		local state=$(grep -F -e "State" "${p}" | cut -f 2 -d "=")
		local component=$(
			echo "${p}" | sed -r \
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
	if find "${ED}" -name "${name}" -type d 2>/dev/null 1>/dev/null ; then
		find "${ED}" -name "${name}" -type d -delete
	fi
	if find "${ED}" -regextype 'posix-egrep' \
	   -regex ".*/${name}.(gambas|component|info|list|so|so.0|so\.0\.0\.0)" \
	   2>/dev/null 1>/dev/null ; then
		find "${ED}" -regextype 'posix-egrep' \
		-regex ".*/${name}.(gambas|component|info|list|so|so.0|so\.0\.0\.0)" -delete
	fi
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
		make_desktop_entry "/usr/bin/gambas3.gambas" "Gambas" \
			"/usr/share/gambas/gambas3.png" "Development;IDE"
	fi

	# Quality control sections:
	if use remove_deprecated ; then
		find_remove_module "gb.libxml"
		find_remove_module "gb.option.component"
		find_remove_module "gb.pdf"
		find_remove_module "gb.report"
	fi

	if use remove_stable_not_finished ; then
		find_remove_module "gb.desktop"
		find_remove_module "gb.desktop.x11"
		find_remove_module "gb.form.terminal"
		find_remove_module "gb.map"
		find_remove_module "gb.memcached"
		find_remove_module "gb.test"
		find_remove_module "gb.test.component"
		find_remove_module "gb.util"
		find_remove_module "gb.util.web"
		find_remove_module "gb.web.feed"
		find_remove_module "gb.web.form"
		find_remove_module "gb.web.gui"
	fi

	if use remove_unstable ; then
		find_remove_module "gb.chart"
		find_remove_module "gb.dbus.trayicon"
		find_remove_module "gb.term.form"
	fi
	find "${D}" -name '*.la' -delete || die

	use doc && \
	einstalldocs

	docinto licenses
	dodoc COPYING

	if use ide ; then
		if [[ ! -f "${ED}/usr/bin/gambas3.gambas" ]] ; then
			die "The IDE was not built.  Fix the USE flags."
		fi
	fi

	if use jit ; then
		cat <<-EOF > "${T}"/50${PN}-jit
# Details can be found at http://gambaswiki.org/wiki/doc/jit
GB_NO_JIT=${EGAMBAS_GB_NO_JIT:=0}
GB_JIT_DEBUG=${EGAMBAS_GB_JIT_DEBUG:=0}
GB_JIT_CC="${EGAMBAS_GB_JIT_CC:=gcc}"
GB_JIT_CFLAGS="${EGAMBAS_GB_JIT_CFLAGS:=-O3}"
EOF
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
