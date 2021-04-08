# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{7..9} )
USE_RUBY="ruby24 ruby25 ruby26 ruby27"
inherit check-reqs cmake desktop flag-o-matic gnome2 multilib-minimal \
pax-utils python-any-r1 ruby-single toolchain-funcs virtualx

DESCRIPTION="Open source web browser engine"
HOMEPAGE="https://www.webkitgtk.org"
LICENSE="LGPL-2+ Apache-2.0 BSD BSD-2 GPL-2+ GPL-3+ LGPL-2 LGPL-2.1+ MIT unicode"
# Some licenses are third party
# Apache-2.0 Source/ThirdParty/ANGLE/src/tests/test_utils/third_party/LICENSE
# BSD Source/ThirdParty/gtest/LICENSE
# BSD Source/WTF/wtf/dtoa/LICENSE
# BSD-2 Source/ThirdParty/ANGLE/src/third_party/compiler/LICENSE
# MIT Source/ThirdParty/ANGLE/src/third_party/libXNVCtrl/LICENSE
# MIT Source/WTF/LICENSE-libc++.txt
# unicode Source/WTF/icu/LICENSE
# LGPL-2 (only) Source/WebCore/rendering/AutoTableLayout.cpp
# LGPL-2.1+ for some files in Source/WebCore
# Source/WebCore/rendering/AutoTableLayout.cpp
# GPL-2+ Source/JavaScriptCore
# GPL-3+ Source/ThirdParty/ANGLE/tools/flex-bison/third_party/m4sugar
# GPL-3+ Source/ThirdParty/ANGLE/tools/flex-bison/third_party/skeletons
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~x86"

API_VERSION="4.0"
SLOT_MAJOR=$(ver_cut 1 ${API_VERSION})
# See Source/cmake/OptionsGTK.cmake
# CALCULATE_LIBRARY_VERSIONS_FROM_LIBTOOL_TRIPLE(WEBKIT C R A),
# SOVERSION = C - A
# WEBKITGTK_API_VERSION is 4.0
CURRENT="90"
AGE="53"
SOVERSION=$((${CURRENT} - ${AGE}))
SLOT="${SLOT_MAJOR}/${SOVERSION}"

IUSE+=" aqua +egl examples +geolocation gles2-only gnome-keyring +gstreamer \
gtk-doc +introspection +jpeg2k +jumbo-build libnotify +opengl seccomp spell \
wayland +X"
LANGS=( ar as bg ca cs da de el en_CA en_GB eo es et eu fi fr gl gu he hi hu \
id it ja kn ko lt lv ml mr nb nl or pa pl pt_BR pt ro ru sl sr@latin sr sv ta \
te tr uk vi zh_CN )
IUSE+=" ${LANGS[@]/#/l10n_} accelerated-2d-canvas bmalloc ftl-jit gamepad \
hardened +jit systemd +webgl"

# gstreamer with opengl/gles2 needs egl
REQUIRED_USE+="
	|| ( aqua wayland X )
	gles2-only? ( egl !opengl )
	gstreamer? ( opengl? ( egl ) )
	wayland? ( egl )
"
REQUIRED_USE+="
	!accelerated-2d-canvas
	geolocation? ( introspection )
	hardened? ( !jit )
	webgl? ( gstreamer
		|| ( gles2-only opengl ) )
"

# accelerated-2d-canvas disabled because it may be unstable
# cannot use introspection for 32 webkit on 64 bit because it requires 32 bit
# libs/build for python from gobject-introspection.  It produces this error:
#
# pyport.h:686:2: error: #error "LONG_BIT definition appears wrong for platform
#   (bad gcc/glibc config?)."
#
# This means also you cannot use the geolocation feature.

# For dependencies, see:
#   CMakeLists.txt
#   Source/cmake/BubblewrapSandboxChecks.cmake
#   Source/cmake/FindGStreamer.cmake
#   Source/cmake/GStreamerChecks.cmake
#   Source/cmake/OptionsGTK.cmake
#   Source/cmake/WebKitCommon.cmake
#   Tools/gtk/install-dependencies
#   https://trac.webkit.org/wiki/WebKitGTK/DependenciesPolicy
#   https://trac.webkit.org/wiki/WebKitGTK/GCCRequirement

# Target U 20.04.2

# Aqua support in gtk3 is untested.
# Dependencies are found at Source/cmake/OptionsGTK.cmake.
# Various compile-time optionals for gtk+.
# Missing WebRTC support, but ENABLE_MEDIA_STREAM/ENABLE_WEB_RTC is experimental
#   upstream (PRIVATE OFF) and shouldn't be used yet in 2.26
# >=gst-plugins-opus-1.14.4-r1 for opusparse (required by MSE
#  [Media Source Extensions])
WPE_DEPEND="
	>=gui-libs/libwpe-1.6.0:1.0[${MULTILIB_USEDEP}]
	>=gui-libs/wpebackend-fdo-1.6.0:1.0[${MULTILIB_USEDEP}]"
# TODO: gst-plugins-base[X] is only needed when build configuration ends up with
#   GLX set, but that's a bit automagic too to fix
# Technically, dev-libs/gobject-introspection requires [${MULTILIB_USEDEP}].
#   It is removed to only allow native ABI to use it.
CAIRO_V="1.20"
GLIB_V="2.64.6"
GSTREAMER_V="1.16.2"
MESA_V="20.0.4"
RDEPEND+="
	>=dev-db/sqlite-3.31.1:3=[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.35.1[${MULTILIB_USEDEP}]
	>=dev-libs/icu-66.1:=[${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.8.5:0=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.40.1:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-${GLIB_V}:2[${MULTILIB_USEDEP}]
	>=dev-libs/gmp-6.2.0[-pgo(-),${MULTILIB_USEDEP}]
	>=dev-libs/hyphen-0.9.0[${MULTILIB_USEDEP}]
	>=dev-libs/libxslt-1.1.34[${MULTILIB_USEDEP}]
	>=dev-libs/libtasn1-4.16.0:=[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.13.1:1.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.10.1:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.6.4:=[icu(+),${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.37:0=[${MULTILIB_USEDEP}]
	>=media-libs/libwebp-0.6.1:=[${MULTILIB_USEDEP}]
	>=media-libs/woff2-1.0.2[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.70.0:2.4[introspection?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.11:0[${MULTILIB_USEDEP}]
	  virtual/jpeg:0=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-${CAIRO_V}:=[X?,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.24.18:3[aqua?,introspection?,wayland?,X?,${MULTILIB_USEDEP}]
	accelerated-2d-canvas? (
gles2-only? ( >=x11-libs/cairo-${CAIRO_V}[gles2-only,${MULTILIB_USEDEP}] )
opengl? ( >=x11-libs/cairo-${CAIRO_V}[opengl,${MULTILIB_USEDEP}] )
	)
	egl? ( >=media-libs/mesa-${MESA_V}[egl,${MULTILIB_USEDEP}] )
	gamepad? ( >=dev-libs/libmanette-0.2.3[${MULTILIB_USEDEP}] )
	gnome-keyring? ( >=app-crypt/libsecret-0.20.2[${MULTILIB_USEDEP}] )
	gstreamer? (
		>=media-libs/gstreamer-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
>=media-libs/gst-plugins-base-${GSTREAMER_V}:1.0[egl?,opengl?,X?,${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-opus-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		gles2-only? (
>=media-libs/gst-plugins-base-${GSTREAMER_V}:1.0[gles2,${MULTILIB_USEDEP}] )
		)
	introspection? ( >=dev-libs/gobject-introspection-1.64.0:= )
	jpeg2k? ( >=media-libs/openjpeg-2.4.0:2=[${MULTILIB_USEDEP}] )
	geolocation? ( >=app-misc/geoclue-2.5.6:2.0 )
	gles2-only? ( >=media-libs/mesa-${MESA_V}[gles2,${MULTILIB_USEDEP}] )
	libnotify? ( >=x11-libs/libnotify-0.7.9[${MULTILIB_USEDEP}] )
	opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
	seccomp? (
		>=sys-apps/bubblewrap-0.4.0
		>=sys-apps/xdg-dbus-proxy-0.1.2
		>=sys-libs/libseccomp-2.4.3[${MULTILIB_USEDEP}]
	)
	spell? ( >=app-text/enchant-1.6.0:2[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.18.0[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.20[${MULTILIB_USEDEP}]
		opengl? ( ${WPE_DEPEND} )
		gles2-only? ( ${WPE_DEPEND} )
	)
	X? (	>=x11-libs/libX11-1.6.9[${MULTILIB_USEDEP}]
		>=x11-libs/libXcomposite-0.4.5[${MULTILIB_USEDEP}]
		>=x11-libs/libXdamage-1.1.5[${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-0.9.10[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.5[${MULTILIB_USEDEP}] )"
unset WPE_DEPEND
DEPEND+=" ${RDEPEND}"
# paxctl is needed for bug #407085
# It needs real bison, not yacc.
BDEPEND+="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=app-accessibility/at-spi2-core-2.36.0[${MULTILIB_USEDEP}]
	>=dev-util/cmake-3.16.3
	>=dev-util/glib-utils-${GLIB_V}
	>=dev-util/gperf-3.1
	>=dev-lang/perl-5.30.0
	>=sys-devel/bison-3.5.1
	|| ( >=sys-devel/clang-10.0[${MULTILIB_USEDEP}]
	     >=sys-devel/gcc-9.3.0 )
	>=sys-devel/gettext-0.19.8.1[${MULTILIB_USEDEP}]
	>=virtual/pkgconfig-0.29.1[${MULTILIB_USEDEP}]
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-JSON-PP
	geolocation? ( >=dev-util/gdbus-codegen-${GLIB_V} )
	gtk-doc? ( >=dev-util/gtk-doc-1.32 )"
#	test? (
#		>=dev-python/pygobject-3.36.0:3[python_targets_python2_7]
#		>=x11-themes/hicolor-icon-theme-0.17
#		jit? ( >=sys-apps/paxctl-0.9 ) )
MY_P="webkitgtk-${PV}"
FN="${MY_P}.tar.xz"
SRC_URI="https://www.webkitgtk.org/releases/${FN}"
# Tests fail to link for inexplicable reasons
# https://bugs.webkit.org/show_bug.cgi?id=148210
# Fetch is due to Unicode data files contained in Source/JavaScriptCore/ucd/
RESTRICT="fetch test"
S="${WORKDIR}/${MY_P}"
CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo
	einfo "You must also read and agree to the licenses:"
	einfo "  https://www.unicode.org/license.html"
	einfo "  http://www.unicode.org/copyright.html"
	einfo
	einfo "Before downloading ${P}"
	einfo
	einfo "If you agree, you may download"
	einfo "  - ${FN}"
	einfo "from ${SRC_URI} and place them in ${distdir}"
	einfo
	einfo "The quick one liner to do all that:"
	einfo "wget -O ${distdir}/${FN} ${SRC_URI}"
	einfo
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			einfo \
"Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi

		if ! test-flag-CXX -std=c++17 ; then
			die \
"You need at least GCC 7.3.x or Clang >= 6 for C++17-specific compiler flags"
		fi
	fi

	if ! use opengl && ! use gles2-only; then
ewarn
ewarn "You are disabling OpenGL usage (USE=opengl or USE=gles2-only) completely."
ewarn "This is an unsupported configuration meant for very specific embedded"
ewarn "use cases, where there truly is no GL possible (and even that use case"
ewarn "is very unlikely to come by). If you have GL (even software-only), you"
ewarn "really really should be enabling OpenGL!"
ewarn
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != "binary" ]] \
		&& is-flagq "-g*" \
		&& ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.24.4-eglmesaext-include.patch" # \
	# bug 699054 # https://bugs.webkit.org/show_bug.cgi?id=204108
	eapply "${FILESDIR}"/2.28.2-opengl-without-X-fixes.patch
	eapply "${FILESDIR}"/2.28.2-non-jumbo-fix.patch
	eapply "${FILESDIR}"/2.28.4-non-jumbo-fix2.patch
	eapply "${FILESDIR}"/2.30.3-fix-noGL-build.patch
	cmake_src_prepare
	gnome2_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# Arches without JIT support also need this to really disable it in all places
#	use jit || append-cppflags -DENABLE_JIT=0 -DENABLE_YARR_JIT=0 -DENABLE_ASSEMBLER=0

	# It does not compile on alpha without this in LDFLAGS
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648761
	use alpha && append-ldflags "-Wl,--no-relax"

	# ld segfaults on ia64 with LDFLAGS --as-needed, bug #555504
	use ia64 && append-ldflags "-Wl,--no-as-needed"

	# Sigbuses on SPARC with mcpu and co., bug #???
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	# Try to use less memory, bug #469942 (see Fedora .spec for reference)
	# --no-keep-memory doesn't work on ia64, bug #502492
	if ! use ia64; then
		append-ldflags "-Wl,--no-keep-memory"
	fi

	# We try to use gold when possible for this package
#	if ! tc-ld-is-gold ; then
#		append-ldflags "-Wl,--reduce-memory-overheads"
#	fi

	# Multiple rendering bugs on youtube, github, etc without this, bug #547224
	append-flags $(test-flags -fno-strict-aliasing)

	# Ruby situation is a bit complicated. See bug 513888
	local rubyimpl
	local ruby_interpreter=""
	for rubyimpl in ${USE_RUBY}; do
		if has_version -b "virtual/rubygems[ruby_targets_${rubyimpl}]"; then
			ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ${rubyimpl})"
		fi
	done
	# This will rarely occur. Only a couple of corner cases could lead us to
	# that failure. See bug 513888
	[[ -z $ruby_interpreter ]] && die "No suitable ruby interpreter found"

	# TODO: Check Web Audio support
	# should somehow let user select between them?
	# opengl needs to be explictly handled, bug #576634

	local use_wpe_renderer=OFF
	local opengl_enabled
	if use opengl || use gles2-only; then
		opengl_enabled=ON
		use wayland && use_wpe_renderer=ON
	else
		opengl_enabled=OFF
	fi

	local mycmakeargs=(
		${ruby_interpreter}
		-DBWRAP_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/bwrap # \
# If bubblewrap[suid] then portage makes it go-r and cmake find_program fails \
# with that
		-DDBUS_PROXY_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/xdg-dbus-proxy
		-DENABLE_API_TESTS=$(usex test)
		-DENABLE_BUBBLEWRAP_SANDBOX=$(usex seccomp)
		-DENABLE_GEOLOCATION=$(multilib_native_usex geolocation "ON" "OFF") # \
		-DENABLE_GLES2=$(usex gles2-only)
		-DENABLE_GTKDOC=$(usex gtk-doc)
		-DENABLE_INTROSPECTION=$(multilib_native_usex introspection "ON" "OFF")
		-DENABLE_MINIBROWSER=$(usex examples)
		-DENABLE_OPENGL=${opengl_enabled}
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_UNIFIED_BUILDS=$(usex jumbo-build)
# Runtime optional (talks over dbus service)
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_WEBGL=$(usex webgl)
		-DENABLE_X11_TARGET=$(usex X)
		-DPORT=GTK
		-DUSE_LIBNOTIFY=$(usex libnotify)
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_WOFF2=ON
		-DUSE_WPE_RENDERER=${use_wpe_renderer} # \
# WPE renderer is used to implement accelerated compositing under wayland
		$(cmake_use_find_package gles2-only OpenGLES2)
		$(cmake_use_find_package egl EGL)
		$(cmake_use_find_package opengl OpenGL)
	)

	mycmakeargs+=(
		-DCMAKE_CXX_LIBRARY_ARCHITECTURE=$(get_abi_CHOST ${ABI})
		-DCMAKE_INSTALL_BINDIR=$(get_libdir)/webkit-gtk
		-DCMAKE_INSTALL_LIBEXECDIR=$(get_libdir)/misc
		-DCMAKE_LIBRARY_PATH=/usr/$(get_libdir)
		-DENABLE_ACCELERATED_2D_CANVAS=$(usex accelerated-2d-canvas)
#		-DENABLE_C_LOOP=$(usex jit "OFF" "ON")
#		-DENABLE_DFG_JIT=$(usex jit)
#		-DENABLE_FTL_JIT=$(usex ftl-jit)
#		-DENABLE_JIT=$(usex jit)
		-DUSE_SYSTEM_MALLOC=$(usex bmalloc "OFF" "ON")
		-DUSE_SYSTEMD=$(usex systemd "ON" "OFF")
	)

	# Use GOLD when possible as it has all the magic to
	# detect when to use it and using gold for this concrete package has
	# multiple advantages and is also the upstream default, bug #585788
#	if tc-ld-is-gold ; then
#		mycmakeargs+=( -DUSE_LD_GOLD=ON )
#	else
#		mycmakeargs+=( -DUSE_LD_GOLD=OFF )
#	fi

	# https://bugs.gentoo.org/761238
	append-cppflags -DNDEBUG

	if use accelerated-2d-canvas ; then
		ewarn \
"The accelerated-2d-canvas USE flag is unstable and not recommended."
	fi

	if [[ "${ABI}" == "x86" ]] ; then
		mycmakeargs+=( -DFORCE_32BIT=ON )
	fi

	WK_USE_CCACHE=NO cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_test() {
	# Prevent test failures on PaX systems
	# Programs/unittests/.libs/test*
	pax-mark m $(list-paxables Programs/*[Tt]ests/*)
	cmake_src_test
}

multilib_src_install() {
	cmake_src_install

	# Prevent crashes on PaX systems, bug #522808
	local d="${ED}/usr/$(get_libdir)/misc/webkit2gtk-${API_VERSION}"
	# usr/libexec is not multilib this is why it is changed.
	pax-mark m "${d}/WebKitPluginProcess"
	pax-mark m "${d}/WebKitWebProcess"
	pax-mark m "${d}/jsc"

	if use examples ; then
		exeinto /usr/bin
		newexe "${FILESDIR}/minibrowser" minibrowser-${ABI}
		sed -i -e "s|\$(get_libdir)|$(get_libdir)|g" \
			"${ED}/usr/bin/minibrowser-${ABI}" || die
		dosym /usr/bin/minibrowser-${ABI} /usr/bin/minibrowser
		make_desktop_entry minibrowser-${ABI} "MiniBrowser (${ABI})" \
			"" "Network;WebBrowser"
	fi
	mkdir -p "${T}/langs" || die
	cp -a "${ED}/usr/share/locale/"* "${T}/langs" || die
	rm -rf "${ED}/usr/share/locale" || die
	insinto /usr/share/locale
	for l in ${L10N} ; do
		doins -r "${T}/langs/${l}"
	done
}
