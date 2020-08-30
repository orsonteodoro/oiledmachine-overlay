# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{6,7,8} )
USE_RUBY="ruby24 ruby25 ruby26 ruby27"
CMAKE_MIN_VERSION=3.10

inherit check-reqs cmake-utils flag-o-matic gnome2 pax-utils python-any-r1 ruby-single toolchain-funcs virtualx
inherit multilib-minimal

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="https://www.webkitgtk.org"
FN="${MY_P}.tar.xz"
SRC_URI="https://www.webkitgtk.org/releases/${FN}"

LICENSE="LGPL-2+ BSD"
LICENSE+=" unicode"
API_VERSION="4.0"
SLOT_MAJOR=$(ver_cut 1 ${API_VERSION})
SLOT="${SLOT_MAJOR}/37" # soname version of libwebkit2gtk-4.0
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~sparc x86"

IUSE="aqua +egl +geolocation gles2-only gnome-keyring +gstreamer gtk-doc +introspection +jpeg2k +jumbo-build libnotify +opengl seccomp spell wayland +X"
IUSE+=" accelerated-2d-canvas bmalloc ftl-jit hardened +jit minibrowser +webgl"

# gstreamer with opengl/gles2 needs egl
REQUIRED_USE="
	gles2-only? ( egl !opengl )
	gstreamer? ( opengl? ( egl ) )
	wayland? ( egl )
	|| ( aqua wayland X )
"
REQUIRED_USE+="
	geolocation? ( introspection )
	hardened? ( !jit )
	webgl? ( gstreamer
		|| ( gles2-only opengl ) )
	!accelerated-2d-canvas
"

# accelerated-2d-canvas disabled because it may be unstable
# cannot use introspection for 32 webkit on 64 bit because it requires 32 bit libs/build for python
# from gobject-introspection pyport.h:686:2: error: #error "LONG_BIT definition appears wrong for platform (bad gcc/glibc config?)."
# this means also you cannot use the geolocation feature

# Tests fail to link for inexplicable reasons
# https://bugs.webkit.org/show_bug.cgi?id=148210
RESTRICT="test"

# Aqua support in gtk3 is untested
# Dependencies found at Source/cmake/OptionsGTK.cmake
# Various compile-time optionals for gtk+-3.22.0 - ensure it
# Missing WebRTC support, but ENABLE_MEDIA_STREAM/ENABLE_WEB_RTC is experimental upstream (PRIVATE OFF) and shouldn't be used yet in 2.26
# >=gst-plugins-opus-1.14.4-r1 for opusparse (required by MSE)
wpe_depend="
	>=gui-libs/libwpe-1.3.0:1.0[${MULTILIB_USEDEP}]
	>=gui-libs/wpebackend-fdo-1.3.1:1.0[${MULTILIB_USEDEP}]
"
# TODO: gst-plugins-base[X] is only needed when build configuration ends up with GLX set, but that's a bit automagic too to fix
# Technically, dev-libs/gobject-introspection requires [${MULTILIB_USEDEP}].  It is removed to only allow native abi to use it.
RDEPEND="
	>=x11-libs/cairo-1.16.0:=[X?,${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.13.0:1.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.7.0:0=[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.22.0:3[aqua?,introspection?,wayland?,X?,${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-1.4.2:=[icu(+),${MULTILIB_USEDEP}]
	>=dev-libs/icu-3.8.1-r1:=[${MULTILIB_USEDEP}]
	virtual/jpeg:0=[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.54:2.4[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.8.0:2[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.4:0=[${MULTILIB_USEDEP}]
	dev-db/sqlite:3=[${MULTILIB_USEDEP}]
	sys-libs/zlib:0[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.16.0[${MULTILIB_USEDEP}]
	media-libs/libwebp:=[${MULTILIB_USEDEP}]

	>=dev-libs/glib-2.44.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxslt-1.1.7[${MULTILIB_USEDEP}]
	media-libs/woff2[${MULTILIB_USEDEP}]
	gnome-keyring? ( app-crypt/libsecret[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.32.0:= )
	dev-libs/libtasn1:=[${MULTILIB_USEDEP}]
	spell? ( >=app-text/enchant-0.22:2[${MULTILIB_USEDEP}] )
	gstreamer? (
		>=media-libs/gstreamer-1.14:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-base-1.14:1.0[egl?,opengl?,X?,${MULTILIB_USEDEP}]
		gles2-only? ( media-libs/gst-plugins-base:1.0[gles2,${MULTILIB_USEDEP}] )
		>=media-plugins/gst-plugins-opus-1.14.4-r1:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-1.14:1.0[${MULTILIB_USEDEP}] )

	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		x11-libs/libXrender[${MULTILIB_USEDEP}]
		x11-libs/libXt[${MULTILIB_USEDEP}] )

	libnotify? ( x11-libs/libnotify[${MULTILIB_USEDEP}] )
	dev-libs/hyphen[${MULTILIB_USEDEP}]
	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2=[${MULTILIB_USEDEP}] )

	egl? ( media-libs/mesa[egl,${MULTILIB_USEDEP}] )
	gles2-only? ( media-libs/mesa[gles2,${MULTILIB_USEDEP}] )
	opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.12[${MULTILIB_USEDEP}]
		opengl? ( ${wpe_depend} )
		gles2-only? ( ${wpe_depend} )
	)

	seccomp? (
		>=sys-apps/bubblewrap-0.3.1
		sys-libs/libseccomp[${MULTILIB_USEDEP}]
		sys-apps/xdg-dbus-proxy
	)
"
RDEPEND+="
	accelerated-2d-canvas? ( gles2-only? ( x11-libs/cairo[gles2-only,${MULTILIB_USEDEP}] )
				 opengl? ( x11-libs/cairo[opengl,${MULTILIB_USEDEP}] ) )
	dev-libs/gmp[-pgo(-),${MULTILIB_USEDEP}]"
unset wpe_depend
# paxctl needed for bug #407085
# Need real bison, not yacc
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=app-accessibility/at-spi2-core-2.5.3[${MULTILIB_USEDEP}]
	dev-util/glib-utils
	>=dev-util/gperf-3.0.1
	>=sys-devel/bison-2.4.3
	|| ( >=sys-devel/gcc-7.3 >=sys-devel/clang-5[${MULTILIB_USEDEP}] )
	sys-devel/gettext[${MULTILIB_USEDEP}]
	virtual/pkgconfig[${MULTILIB_USEDEP}]

	>=dev-lang/perl-5.10
	virtual/perl-Data-Dumper
	virtual/perl-Carp
	virtual/perl-JSON-PP

	gtk-doc? ( >=dev-util/gtk-doc-1.32 )
	geolocation? ( dev-util/gdbus-codegen )
"
#	test? (
#		dev-python/pygobject:3[python_targets_python2_7]
#		x11-themes/hicolor-icon-theme
#		jit? ( sys-apps/paxctl ) )
RDEPEND="${RDEPEND}
	geolocation? ( >=app-misc/geoclue-2.1.5:2.0 )
"

S="${WORKDIR}/${MY_P}"

CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

# This is due to Unicode data files contained in Source/JavaScriptCore/ucd/
RESTRICT+=" fetch"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo ""
	einfo "You must also read and agree to the licenses:"
	einfo "  https://www.unicode.org/license.html"
	einfo "  http://www.unicode.org/copyright.html"
	einfo ""
	einfo "Before downloading ${P}"
	einfo ""
	einfo "If you agree, you may download"
	einfo "  - ${FN}"
	einfo "from ${SRC_URI} and place them in ${distdir}"
	einfo ""
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi

		if ! test-flag-CXX -std=c++17 ; then
			die "You need at least GCC 7.3.x or Clang >= 5 for C++17-specific compiler flags"
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
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi

	python-any-r1_pkg_setup
	ewarn "The build may crash randomly when building.  Re-emerge again."
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.24.4-eglmesaext-include.patch" # bug 699054 # https://bugs.webkit.org/show_bug.cgi?id=204108
	eapply "${FILESDIR}"/2.28.2-opengl-without-X-fixes.patch
	eapply "${FILESDIR}"/2.28.2-non-jumbo-fix.patch
	eapply "${FILESDIR}"/2.28.4-non-jumbo-fix2.patch
	cmake-utils_src_prepare
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
		if has_version --host-root "virtual/rubygems[ruby_targets_${rubyimpl}]"; then
			ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ${rubyimpl})"
		fi
	done
	# This will rarely occur. Only a couple of corner cases could lead us to
	# that failure. See bug 513888
	[[ -z $ruby_interpreter ]] && die "No suitable ruby interpreter found"

	# TODO: Check Web Audio support
	# should somehow let user select between them?
	#
	# opengl needs to be explicetly handled, bug #576634

	local use_wpe_renderer=OFF
	local opengl_enabled
	if use opengl || use gles2-only; then
		opengl_enabled=ON
		use wayland && use_wpe_renderer=ON
	else
		opengl_enabled=OFF
	fi

	local mycmakeargs=(
		-DENABLE_UNIFIED_BUILDS=$(usex jumbo-build)
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_API_TESTS=$(usex test)
		-DENABLE_GTKDOC=$(usex gtk-doc)
		-DENABLE_GEOLOCATION=$(multilib_native_usex geolocation "ON" "OFF") # Runtime optional (talks over dbus service)
		$(cmake-utils_use_find_package gles2-only OpenGLES2)
		-DENABLE_GLES2=$(usex gles2-only)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_INTROSPECTION=$(multilib_native_usex introspection "ON" "OFF")
		-DUSE_LIBNOTIFY=$(usex libnotify)
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_WOFF2=ON
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DUSE_WPE_RENDERER=${use_wpe_renderer} # WPE renderer is used to implement accelerated compositing under wayland
		$(cmake-utils_use_find_package egl EGL)
		$(cmake-utils_use_find_package opengl OpenGL)
		-DENABLE_X11_TARGET=$(usex X)
		-DENABLE_OPENGL=${opengl_enabled}
		-DENABLE_WEBGL=$(usex webgl)
		-DENABLE_BUBBLEWRAP_SANDBOX=$(usex seccomp)
		-DBWRAP_EXECUTABLE="${EPREFIX}"/usr/bin/bwrap # If bubblewrap[suid] then portage makes it go-r and cmake find_program fails with that
		-DCMAKE_BUILD_TYPE=Release
		-DPORT=GTK
		${ruby_interpreter}
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
		-DENABLE_MINIBROWSER=$(usex minibrowser "ON" "OFF")
		-DUSE_SYSTEM_MALLOC=$(usex bmalloc "OFF" "ON")
	)

	# Allow it to use GOLD when possible as it has all the magic to
	# detect when to use it and using gold for this concrete package has
	# multiple advantages and is also the upstream default, bug #585788
#	if tc-ld-is-gold ; then
#		mycmakeargs+=( -DUSE_LD_GOLD=ON )
#	else
#		mycmakeargs+=( -DUSE_LD_GOLD=OFF )
#	fi

	if use accelerated-2d-canvas ; then
		ewarn "The accelerated-2d-canvas USE flag is unstable and not recommended."
	fi

	if [[ "${ABI}" == "x86" ]] ; then
		mycmakeargs+=( -DFORCE_32BIT=ON )
	fi

	WK_USE_CCACHE=NO cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_test() {
	# Prevents test failures on PaX systems
	pax-mark m $(list-paxables Programs/*[Tt]ests/*) # Programs/unittests/.libs/test*

	cmake-utils_src_test
}

multilib_src_install() {
	cmake-utils_src_install

	# Prevents crashes on PaX systems, bug #522808
	local d="${ED}usr/$(get_libdir)/misc/webkit2gtk-${API_VERSION}"
	# usr/libexec int not multilib this is why it is changed
	pax-mark m "${d}/WebKitPluginProcess"
	pax-mark m "${d}/WebKitWebProcess"
	pax-mark m "${d}/jsc"
}
