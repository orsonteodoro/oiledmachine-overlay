# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# -r revision notes
# -rabcde
# ab = WEBKITGTK_API_VERSION version (5.0)
# c = reserved
# de = ebuild revision

# Corresponds to
# WebKit 612.1.15 (20210514, main) ; See Source/WebKit/Configurations/Version.xcconfig

LLVM_MAX_SLOT=12 # This should not be more than Mesa's llvm \
# dependency (mesa 20.x (stable): llvm-11, mesa 21.x (testing): llvm-12).

CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{8..10} )
USE_RUBY="ruby26 ruby27 ruby30"
inherit check-reqs cmake desktop flag-o-matic gnome2 linux-info llvm \
multilib-minimal pax-utils python-any-r1 ruby-single subversion \
toolchain-funcs virtualx

DESCRIPTION="Open source web browser engine (GTK 4)"
HOMEPAGE="https://www.webkitgtk.org"
LICENSE="
	all-rights-reserved
	Apache-2.0
	BitstreamVera
	Boost-1.0
	BSD
	BSD-2
	GPL-2+
	GPL-3+
	ISC
	LGPL-2
	LGPL-2+
	LGPL-2.1+
	MIT
	MPL-2.0
	unicode
	|| ( AFL-2.0 LGPL-2+ )
	|| ( MPL-1.1 GPL-2 LGPL-2 )
	|| ( MPL-1.1 GPL-2 LGPL-2.1 ) GIF
	webrtc? (
		Apache-2.0
		BSD
		BSD-2
		base64
		g711
		g722
		ISC
		libvpx-PATENTS
		libwebm-PATENTS
		libwebrtc-PATENTS
		libyuv-PATENTS
		MIT
		openssl
		sigslot
	)"
# Some licenses are third party
# all-rights-reserved Source/WebInspectorUI/UserInterface/Images/CanvasOverview.svg
# all-rights-reserved Source/ThirdParty/gtest/scripts/run_with_path.py
# all-rights-reserved GPL-2+ Source/WTF/wtf/HashCountedSet.h ; * the GPL-2+ license does not contain all rights reserved
# Apache-2.0 Source/ThirdParty/ANGLE/src/tests/test_utils/third_party/LICENSE
# Apache-2.0 Source/ThirdParty/libwebrtc/Source/webrtc/examples/objc/AppRTCMobile/third_party/SocketRocket/LICENSE
# BitstreamVera Source/ThirdParty/ANGLE/src/libANGLE/overlay/DejaVuSansMono-Bold.ttf
# Boost-1.0 Source/WTF/wtf/Optional.h
# BSD Source/ThirdParty/gtest/LICENSE
# BSD Source/WTF/wtf/dtoa/LICENSE
# BSD Source/ThirdParty/libwebrtc/Source/third_party/pffft/LICENSE
# BSD-2 Source/ThirdParty/libwebrtc/Source/third_party/usrsctp/LICENSE
# BSD-2 Source/ThirdParty/ANGLE/src/third_party/compiler/LICENSE
# custom Source/ThirdParty/libwebrtc/Source/webrtc/rtc_base/third_party/base64/LICENSE
# custom Source/ThirdParty/libwebrtc/Source/webrtc/common_audio/third_party/ooura/LICENSE
# GPL-2+ Source/JavaScriptCore
# GPL-3+ Source/ThirdParty/ANGLE/tools/flex-bison/third_party/m4sugar
# GPL-3+ Source/ThirdParty/ANGLE/tools/flex-bison/third_party/skeletons
# ISC Source/bmalloc/bmalloc/CryptoRandom.cpp
# ISC Source/WTF/wtf/CryptographicallyRandomNumber.cpp
# LGPL-2 (only) Source/WebCore/rendering/AutoTableLayout.cpp
# || ( LGPL-2+ AFL-2.0 ) Source/ThirdParty/xdgmime/README
# LGPL-2.1+ for some files in Source/WebCore
# MIT Source/ThirdParty/ANGLE/src/third_party/libXNVCtrl/LICENSE
# MIT Source/WTF/LICENSE-libc++.txt
# MIT Source/ThirdParty/libwebrtc/Source/webrtc/modules/third_party/fft/LICENSE
# MIT Source/ThirdParty/libwebrtc/Source/webrtc/modules/third_party/portaudio/LICENSE
# || ( MPL-1.1 GPL-2 LGPL-2 ) Source/WTF/wtf/DateMath.h
# || ( MPL-1.1 GPL-2 LGPL-2.1 ) GIF Source/WebCore/platform/image-decoders/gif/GIFImageReader.cpp
# MPL-2.0 Source/WTF/wtf/text/StringBuilderJSON.cpp
# openssl, ISC, MIT - Source/ThirdParty/libwebrtc/Source/third_party/boringssl/src/LICENSE
# public-domain Source/ThirdParty/libwebrtc/Source/webrtc/rtc_base/third_party/sigslot/LICENSE
# public-domain Source/ThirdParty/libwebrtc/Source/webrtc/common_audio/third_party/spl_sqrt_floor/LICENSE
# public-domain Source/ThirdParty/libwebrtc/Source/webrtc/modules/third_party/g722/LICENSE
# public-domain Source/ThirdParty/libwebrtc/Source/webrtc/modules/third_party/g711/LICENSE
# unicode Source/WTF/icu/LICENSE
# * The public-domain is not presented in LICENSE variable to not give
#   the wrong impression that the entire package is released in the public domain.
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~x86"

API_VERSION="5.0"
SLOT_MAJOR=$(ver_cut 1 ${API_VERSION})
# See Source/cmake/OptionsGTK.cmake
# CALCULATE_LIBRARY_VERSIONS_FROM_LIBTOOL_TRIPLE(WEBKIT C R A),
# SOVERSION = C - A
# WEBKITGTK_API_VERSION is 5.0
CURRENT="0"
AGE="0"
SOVERSION=$((${CURRENT} - ${AGE}))
SLOT="${SLOT_MAJOR}/${SOVERSION}-${API_VERSION}"
# SLOT=5.0/0  GTK4 SOUP*
# SLOT=4.1/0  GTK3 SOUP3
# SLOT=4.0/37 GTK3 SOUP2

# LANGS=(
# find ${S}/Source/WebCore/platform/gtk/po/ -name "*.po" \
# | cut -f 14 -d "/" \
# | sort \
# | sed -e "s|.po||g" \
# | tr "\n" " " \
# | fold -w 80 -s )

LANGS=(
ar as bg ca cs da de el en_CA en_GB eo es et eu fi fr gl gu he hi hu id it ja
kn ko lt lv ml mr nb nl or pa pl pt_BR pt ro ru sl sr@latin sr sv ta te tr uk
vi zh_CN )

# aqua (quartz) is enabled upstream but disabled
# systemd is enabled upstream but gentoo uses openrc by default
# wayland is enabled upstream but disabled because it is not defacto default
#   standard for desktop yet

IUSE+=" ${LANGS[@]/#/l10n_} 64k-pages aqua avif +bmalloc cpu_flags_arm_thumb2
dav1d +dfg-jit +egl +ftl-jit -gamepad +geolocation gles2-only gnome-keyring
+gstreamer -gtk-doc hardened +introspection +jit +jpeg2k +jumbo-build +lcms
+libhyphen +libnotify lto -mediastream -minibrowser +opengl openmp -seccomp
-libsoup3 -spell -systemd test variation-fonts wayland +webassembly
+webassembly-b3-jit +webcrypto +webgl webvtt -webrtc -webxr +X +yarr-jit"

# See https://webkit.org/status/#specification-webxr for feature quality status
# of emerging web technologies.  Also found in Source/WebCore/features.json
# gstreamer with opengl/gles2 needs egl
REQUIRED_USE+="
	|| ( aqua wayland X )
	64k-pages? ( !bmalloc !dfg-jit !ftl-jit !jit !webassembly !webassembly-b3-jit )
	cpu_flags_arm_thumb2? ( bmalloc !ftl-jit )
	dav1d? ( gstreamer )
	jit? ( bmalloc )
	dfg-jit? ( jit )
	ftl-jit? ( jit )
	geolocation? ( introspection )
	gles2-only? ( egl !opengl )
	gstreamer? ( opengl? ( egl ) )
	hardened? ( !jit )
	wayland? ( egl )
	webassembly? ( jit )
	webassembly-b3-jit? ( ftl-jit webassembly )
	webgl? ( gstreamer
		|| ( gles2-only opengl ) )
	webrtc? ( mediastream )
	webvtt? ( gstreamer )
	webxr? ( webgl )
	yarr-jit? ( jit )"

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

# Upstream tests with U 18.04 LTS and U 20.04
# Ebuild target is 18.04 based on the lowest LTS builder-bot

# *DEPENDs versions based on placing find_package as a higher priority
# than U toolchain image unless general major is only provided
# which is converted to full versioning.

# Aqua support in gtk3 is untested.
# Dependencies are found at Source/cmake/OptionsGTK.cmake.
# Various compile-time optionals for gtk+.
#
# >=gst-plugins-opus-1.14.4-r1 for opusparse (required by MSE
#  [Media Source Extensions])
# gstreamer requires >=libwpe-1.9.0 but gtk wpe renderer requires >=1.3.0
WPE_DEPEND="
	>=gui-libs/libwpe-1.9.0:1.0[${MULTILIB_USEDEP}]
	>=gui-libs/wpebackend-fdo-1.6.0:1.0[${MULTILIB_USEDEP}]"
# TODO: gst-plugins-base[X] is only needed when build configuration ends up with
#   GLX set, but that's a bit automagic too to fix
# Technically, dev-libs/gobject-introspection requires [${MULTILIB_USEDEP}].
#   It is removed to only allow native ABI to use it.
# Manette 0.2.4 is required by webkit-gtk but LTS version is 0.2.3
CAIRO_V="1.14.0"
CLANG_V="6.0"
GLIB_V="2.44.0"
GSTREAMER_V="1.14.0"
MESA_V="18.0.0_rc5"
# The openmp? ( sys-libs/libomp ) depends is relevant to only clang.
# xdg-dbus-proxy is using U 20.04 version
RDEPEND+="
	>=dev-db/sqlite-3.22.0:3=[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.16.0[${MULTILIB_USEDEP}]
	>=dev-libs/icu-60.2:=[${MULTILIB_USEDEP}]
	>=dev-libs/glib-${GLIB_V}:2[${MULTILIB_USEDEP}]
	>=dev-libs/gmp-6.1.2[-pgo(-),${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.6.0:0=[${MULTILIB_USEDEP}]
	>=dev-libs/libtasn1-4.13:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.8.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxslt-1.1.7[${MULTILIB_USEDEP}]
	>=gui-libs/gtk-3.98.5:4[aqua?,introspection?,wayland?,X?,${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.8.0:1.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.4.2:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-0.9.18:=[icu(+),${MULTILIB_USEDEP}]
	>=media-libs/lcms-2.9[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.34:0=[${MULTILIB_USEDEP}]
	>=media-libs/libwebp-0.6.1:=[${MULTILIB_USEDEP}]
	>=media-libs/woff2-1.0.2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.11:0[${MULTILIB_USEDEP}]
	  virtual/jpeg:0=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-${CAIRO_V}:=[X?,${MULTILIB_USEDEP}]
	avif? ( >=media-libs/libavif-0.9.0[${MULTILIB_USEDEP}] )
	egl? ( >=media-libs/mesa-${MESA_V}[egl,${MULTILIB_USEDEP}] )
	gamepad? ( >=dev-libs/libmanette-0.2.4[${MULTILIB_USEDEP}] )
	geolocation? ( >=app-misc/geoclue-0.12.99:2.0 )
	gles2-only? ( >=media-libs/mesa-${MESA_V}[gles2,${MULTILIB_USEDEP}] )
	gnome-keyring? ( >=app-crypt/libsecret-0.18.6[${MULTILIB_USEDEP}] )
	gstreamer? (
		>=media-libs/gstreamer-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
>=media-libs/gst-plugins-base-${GSTREAMER_V}:1.0[egl?,opengl?,X?,${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-opus-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		dav1d? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},dav1d]
		)
		webvtt? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},closedcaption]
		)
		gles2-only? (
>=media-libs/gst-plugins-base-${GSTREAMER_V}:1.0[gles2,${MULTILIB_USEDEP}]
		)
	)
	introspection? ( >=dev-libs/gobject-introspection-1.56.1:= )
	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2=[${MULTILIB_USEDEP}] )
	libhyphen? ( >=dev-libs/hyphen-2.8.8[${MULTILIB_USEDEP}] )
	libnotify? ( >=x11-libs/libnotify-0.7.7[${MULTILIB_USEDEP}] )
	!libsoup3? (
		>=net-libs/libsoup-2.54.0:2.4[introspection?,${MULTILIB_USEDEP}]
	)
	libsoup3? (
		>=net-libs/libsoup-2.99.5:3[introspection?,${MULTILIB_USEDEP}]
	)
	opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
	openmp? ( >=sys-libs/libomp-10.0.0[${MULTILIB_USEDEP}] )
	seccomp? (
		>=sys-apps/bubblewrap-0.3.1
		>=sys-apps/xdg-dbus-proxy-0.1.2
		>=sys-libs/libseccomp-0.9.0[${MULTILIB_USEDEP}]
	)
	spell? ( >=app-text/enchant-1.6.0:2[${MULTILIB_USEDEP}] )
	variation-fonts? (
		>=x11-libs/cairo-1.16:=[X?,${MULTILIB_USEDEP}]
		>=media-libs/fontconfig-2.13.0:1.0[${MULTILIB_USEDEP}]
		>=media-libs/freetype-2.9.0[${MULTILIB_USEDEP}]
		>=media-libs/harfbuzz-0.9.18:=[icu(+),${MULTILIB_USEDEP}]
	)
	wayland? (
		>=dev-libs/wayland-1.14.0[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.12[${MULTILIB_USEDEP}]
		opengl? ( ${WPE_DEPEND} )
		gles2-only? ( ${WPE_DEPEND} )
	)
	webcrypto? (
		>=dev-libs/libgcrypt-1.7.0:0=[${MULTILIB_USEDEP}]
	)
	webxr? ( media-libs/openxr )
	webrtc? (
		>=dev-libs/libevent-2.1.8[${MULTILIB_USEDEP}]
		>=media-libs/alsa-lib-1.1.3[${MULTILIB_USEDEP}]
		>=media-libs/libvpx-1.7.0[${MULTILIB_USEDEP}]
		media-libs/openh264[${MULTILIB_USEDEP}]
		>=media-libs/opus-1.1[${MULTILIB_USEDEP}]
	)
	X? (	>=x11-libs/libX11-1.6.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXcomposite-0.4.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXdamage-1.1.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-0.9.10[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.5[${MULTILIB_USEDEP}] )"
unset WPE_DEPEND
DEPEND+=" ${RDEPEND}"
# paxctl is needed for bug #407085
# It needs real bison, not yacc.
BDEPEND+="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	lto? (
		>=sys-devel/clang-${CLANG_V}[${MULTILIB_USEDEP}]
		>=sys-devel/lld-${CLANG_V}
	)
	|| ( >=sys-devel/clang-${CLANG_V}[${MULTILIB_USEDEP}]
	     >=sys-devel/gcc-7.3.0 )
	>=app-accessibility/at-spi2-core-2.5.3[${MULTILIB_USEDEP}]
	>=dev-util/cmake-3.10.2
	>=dev-util/glib-utils-${GLIB_V}
	>=dev-util/gperf-3.0.1
	>=dev-lang/perl-5.10.0
	>=dev-lang/python-2.7
	>=dev-lang/ruby-1.9
	>=sys-devel/bison-3.0.4
	>=sys-devel/gettext-0.19.8.1[${MULTILIB_USEDEP}]
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-JSON-PP
	geolocation? ( >=dev-util/gdbus-codegen-${GLIB_V} )
	gtk-doc? ( >=dev-util/gtk-doc-1.27 )
	webrtc? ( dev-vcs/subversion )"
#	test? (
#		>=dev-python/pygobject-3.26.1:3[python_targets_python2_7]
#		>=x11-themes/hicolor-icon-theme-0.17
#		jit? ( >=sys-apps/paxctl-0.9 ) )
#
# Revisions and commit hashes provided since no tags specifically for the
# webkit-gtk project.
# Revisions can be found at:
# https://trac.webkit.org/log/webkit/trunk/Source/WebKit/gtk/NEWS
# Commits can be found at:
# https://github.com/WebKit/WebKit/commits/main/Source/WebKit/gtk/NEWS
EGIT_COMMIT="d5e91638838f10c735a266c40d22c16eb0056b60"
ESVN_REVISION="277486"
SRC_URI="
https://webkitgtk.org/releases/webkitgtk-${PV}.tar.xz
"
#
# Tests fail to link for inexplicable reasons
# https://bugs.webkit.org/show_bug.cgi?id=148210
#
# Fetch restrict was due to Unicode data files contained in
# Source/JavaScriptCore/ucd/ but it is relaxed because Gentoo distributes
# firefox and webkit's tarball with unicode data.  Most distros
# distributes these browsers with unicode licensed data without
# restrictions.
RESTRICT="test"
S="${WORKDIR}/webkitgtk-${PV}"
CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

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
	ewarn "GTK 4 is default OFF upstream, but forced ON this ebuild."
	ewarn "It is currently not recommended due to rendering bug(s)."
	einfo "This is the stable branch."
	if [[ ${MERGE_TYPE} != "binary" ]] \
		&& is-flagq "-g*" \
		&& ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi
	python-any-r1_pkg_setup

	if use 64k-pages ; then
		if [[ "${ABI}" == "arm64" \
			|| "${ABI}" == "n32" \
			|| "${ABI}" == "n64" \
			|| "${ABI}" == "n64" \
			|| "${ABI}" == "ppc64" \
			|| "${ABI}" == "sparc32" \
			|| "${ABI}" == "sparc64" \
			]] ; then
			local pagesize=$(getconf PAGESIZE)
			if [[ "${pagesize}" != "16384" ]] ; then
				ewarn \
"Page size is not 16k but currently ${pagesize}.  Disable 64k-pages USE flag."
			fi
		else
			die \
"64k pages is not supported.  Remove the 64k-pages USE flag."
		fi

		if ! linux_config_exists ; then
			die \
"Missing .config for kernel."
		fi

		if [[ "${ABI}" == "arm64" ]] ; then
			if ! linux_chkconfig_present "ARM64_64K_PAGES" ; then
				die \
"CONFIG_ARM64_64K_PAGES is unset in the kernel config.  Remove the 64k-pages \
USE flag or change the kernel config."
			fi
		elif [[ "${ABI}" == "n32" ]] ; then
			if ! linux_chkconfig_present "PAGE_SIZE_64KB" ; then
				die \
"CONFIG_PAGE_SIZE_64KB is unset in the kernel config.  Remove the 64k-pages \
USE flag or change the kernel config."
			fi
		elif [[ "${ABI}" == "n64" ]] ; then
			if ! linux_chkconfig_present "PAGE_SIZE_64KB" ; then
				die \
"CONFIG_PAGE_SIZE_64KB is unset in the kernel config.  Remove the 64k-pages \
USE flag or change the kernel config."
			fi
		elif [[ "${ABI}" == "n64" ]] ; then
			if ! linux_chkconfig_present "PAGE_SIZE_64KB" ; then
				die \
"CONFIG_PAGE_SIZE_64KB is unset in the kernel config.  Remove the 64k-pages \
USE flag or change the kernel config."
			fi
		elif [[ "${ABI}" == "ppc64" ]] ; then
			if ! linux_chkconfig_present "PPC_64K_PAGES" ; then
				die \
"CONFIG_PPC_64K_PAGES is unset in the kernel config.  Remove the 64k-pages \
USE flag or change the kernel config."
			fi
		elif [[ "${ABI}" == "sparc32" ]] ; then
			if linux_chkconfig_present "HUGETLB_PAGE" ; then
				:;
			elif linux_chkconfig_present "TRANSPARENT_HUGEPAGE" ; then
				:;
			else
				die \
"CONFIG_HUGETLB_PAGE or CONFIG_TRANSPARENT_HUGEPAGE is unset in the kernel \
config.  Remove the 64k-pages USE flag or change the kernel config."
			fi
		elif [[ "${ABI}" == "sparc64" ]] ; then
			if linux_chkconfig_present "HUGETLB_PAGE" ; then
				:;
			elif linux_chkconfig_present "TRANSPARENT_HUGEPAGE" ; then
				:;
			else
				die \
"CONFIG_HUGETLB_PAGE or CONFIG_TRANSPARENT_HUGEPAGE is unset in the kernel \
config.  Remove the 64k-pages USE flag or change the kernel config."
			fi
		fi
	fi

	if use openmp ; then
		tc-check-openmp
		llvm_pkg_setup
	fi

	if use webrtc ; then
		einfo "The webrtc USE flag is in testing."
		if has network-sandbox $FEATURES ; then
			die \
"${PN} requires network-sandbox to be disabled in FEATURES to be able to use\n\
webrtc."
		fi
	fi
}

src_unpack() {
	unpack ${A}
	if use webrtc ; then
		subversion_fetch \
https://svn.webkit.org/repository/webkit/trunk/Source/ThirdParty/libwebrtc/ \
Source/ThirdParty/libwebrtc
	fi
}

src_prepare() {
	eapply "${FILESDIR}/2.33.1-opengl-without-X-fixes.patch"
	if use webrtc ; then
		eapply "${FILESDIR}/2.33.2-add-ImplementationLacksVTable-to-RTCRtpReceiver.patch"
		eapply "${FILESDIR}/2.33.2-add-ImplementationLacksVTable-to-RTCRtpSender.patch"
		eapply "${FILESDIR}/2.33.2-add-openh264-headers.patch"
	fi
	cmake_src_prepare
	gnome2_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	filter-flags -DENABLE_JIT=* -DENABLE_YARR_JIT=* -DENABLE_ASSEMBLER=*

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
	local opengl_enabled=OFF
	if use opengl || use gles2-only; then
		opengl_enabled=ON
		use wayland && use_wpe_renderer=ON
	fi

	# For more custom options, see
	# S="<sources dir>" grep -r -e "WEBKIT_OPTION_DEFINE" \
	#	${S}/Source/cmake/GStreamerDefinitions.cmake \
	#	${S}/Source/cmake/OptionsGTK.cmake \
	#	${S}/Source/cmake/OptionsJSCOnly.cmake \
	#	${S}/Source/cmake/WebKitFeatures.cmake
	local mycmakeargs=(
		${ruby_interpreter}
		-DBWRAP_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/bwrap # \
# If bubblewrap[suid] then portage makes it go-r and cmake find_program fails \
# with that
		-DCMAKE_CXX_LIBRARY_ARCHITECTURE=$(get_abi_CHOST ${ABI})
		-DCMAKE_INSTALL_BINDIR=$(get_libdir)/webkit-gtk-${API_VERSION}
		-DCMAKE_INSTALL_LIBEXECDIR=$(get_libdir)/misc
		-DCMAKE_LIBRARY_PATH=/usr/$(get_libdir)
		-DDBUS_PROXY_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/xdg-dbus-proxy
		-DENABLE_API_TESTS=$(usex test)
		-DENABLE_BUBBLEWRAP_SANDBOX=$(usex seccomp)
		-DENABLE_GEOLOCATION=$(multilib_native_usex geolocation) # \
# Runtime optional (talks over dbus service)
		-DENABLE_GLES2=$(usex gles2-only)
		-DENABLE_GTKDOC=$(usex gtk-doc)
		-DENABLE_GAMEPAD=$(usex gamepad)
		-DENABLE_INTROSPECTION=$(multilib_native_usex introspection)
		-DENABLE_MEDIA_STREAM=$(usex mediastream)
		-DENABLE_MINIBROWSER=$(usex minibrowser)
		-DENABLE_OPENGL=${opengl_enabled}
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_UNIFIED_BUILDS=$(usex jumbo-build)
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_WEB_CRYPTO=$(usex webcrypto)
		-DENABLE_WEB_RTC=$(usex webrtc)
		-DENABLE_WEBASSEMBLY=$(usex webassembly)
		-DENABLE_WEBGL=$(usex webgl)
		-DENABLE_X11_TARGET=$(usex X)
		-DPORT=GTK
		-DUSE_AVIF=$(usex avif)
		-DUSE_GTK4=ON
		-DUSE_LIBHYPHEN=$(usex libhyphen)
		-DUSE_LCMS=$(usex lcms)
		-DUSE_LIBNOTIFY=$(usex libnotify)
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_SOUP2=$(usex libsoup3 OFF ON)
		-DUSE_SYSTEMD=$(usex systemd) # Whether to enable journald logging
		-DUSE_WOFF2=ON
		-DUSE_WPE_RENDERER=${use_wpe_renderer} # \
# WPE renderer is used to implement accelerated compositing under wayland
		$(cmake_use_find_package gles2-only OpenGLES2)
		$(cmake_use_find_package egl EGL)
		$(cmake_use_find_package opengl OpenGL)
	)

	# See Source/cmake/WebKitFeatures.cmake
	local jit_enabled=$(usex jit "1" "0")
	if use 64k-pages ; then
		einfo "Disabling JIT for ${ABI} with 64kb pages"
		mycmakeargs+=(
			-DENABLE_JIT=OFF
			-DENABLE_DFG_JIT=OFF
			-DENABLE_FTL_JIT=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=OFF
			-DUSE_64KB_PAGE_BLOCK=ON
			-DUSE_SYSTEM_MALLOC=ON
		)
		if [[ "${ABI}" == "arm64" ]] ; then
			mycmakeargs+=(
				-DENABLE_C_LOOP=OFF
				-DENABLE_SAMPLING_PROFILER=ON
			)
		else
			mycmakeargs+=(
				-DENABLE_C_LOOP=ON
				-DENABLE_SAMPLING_PROFILER=OFF
			)
		fi
		jit_enabled="0"
	elif [[ "${ABI}" == "amd64" || "${ABI}" == "arm64" ]] && use jit ; then
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex dfg-jit)
			-DENABLE_FTL_JIT=$(usex ftl-jit)
			-DENABLE_SAMPLING_PROFILER=$(usex jit)
			-DENABLE_WEBASSEMBLY_B3JIT=$(usex webassembly-b3-jit)
			-DUSE_SYSTEM_MALLOC=$(usex !bmalloc)
		)
	elif [[ "${ABI}" == "arm" ]] && use cpu_flags_arm_thumb2 && use jit ; then
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex dfg-jit)
			-DENABLE_FTL_JIT=OFF
			-DENABLE_SAMPLING_PROFILER=$(usex jit)
			-DENABLE_WEBASSEMBLY_B3JIT=$(usex webassembly-b3-jit)
			-DUSE_SYSTEM_MALLOC=$(usex !bmalloc)
		)
	elif [[ "${ABI}" == "n32" ]] && use jit ; then
		# mips32
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex dfg-jit)
			-DENABLE_FTL_JIT=OFF
			-DENABLE_SAMPLING_PROFILER=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=$(usex webassembly-b3-jit)
			-DUSE_SYSTEM_MALLOC=$(usex jit OFF $(usex !bmalloc))
		)
	else
		einfo "Disabling JIT for ${ABI}"
		mycmakeargs+=(
			-DENABLE_C_LOOP=ON
			-DENABLE_JIT=OFF
			-DENABLE_DFG_JIT=OFF
			-DENABLE_FTL_JIT=OFF
			-DENABLE_SAMPLING_PROFILER=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=OFF
			-DUSE_SYSTEM_MALLOC=$(usex !bmalloc)
		)
		jit_enabled="0"
	fi

	# Arches without JIT support also need this to really disable it in all
	# places
	if [[ "${jit_enabled}" == "0" ]] ; then
		einfo "Disabled YARR (regex) JIT"
		append-cppflags -DENABLE_JIT=0 -DENABLE_YARR_JIT=0 \
			-DENABLE_ASSEMBLER=0
	else
		if use yarr-jit ; then
			einfo "Enabled YARR (regex) JIT" # default
		else
			einfo "Disabled YARR (regex) JIT"
			append-cppflags -DENABLE_YARR_JIT=0
		fi
	fi
	einfo "CPPFLAGS=${CPPFLAGS}"

	if use lto ; then
		MESA_LLVM_V=$(bzcat "${ESYSROOT}/var/db/pkg/media-libs/mesa-"*"/environment.bz2" \
			| grep "LLVM_MAX_SLOT" \
			| head -n 1 \
			| cut -f 2 -d "\"")
		einfo "MESA LLVM: ${MESA_LLVM_V}"
		local llvmp=$(get_llvm_prefix ${MESA_LLVM_V})
		einfo "LLVM path: ${llvmp}"
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="${llvmp}/bin/${ctarget}-clang"
			-DCMAKE_CXX_COMPILER="${llvmp}/bin/${ctarget}-clang++"
			-DLTO_MODE=thin
			-DUSE_LD_LLD=ON
		)
	fi

	if use mediastream ; then
		sed -i -e "s|ENABLE_MEDIA_STREAM PRIVATE|ENABLE_MEDIA_STREAM PUBLIC|g" \
			"${S}/Source/cmake/OptionsGTK.cmake" || die
	fi

	if use openmp ; then
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-fopenmp"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="libomp"
		)
	fi

	if use webrtc ; then
		sed -i -e "s|ENABLE_WEB_RTC PRIVATE|ENABLE_WEB_RTC PUBLIC|g" \
			"${S}/Source/cmake/OptionsGTK.cmake" || die
	fi

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

_install_header_license() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local length="${3}"
	d="${dir_path}"
	dl="licenses/${d}"
	docinto "${dl}"
	mkdir -p "${T}/${dl}" || die
	head -n ${length} "${S}/${d}/${file_name}" > \
		"${T}/${dl}/${license_name}" || die
	dodoc "${T}/${dl}/${license_name}"
}

_install_header_license_mid() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local start="${3}"
	local length="${4}"
	d="${dir_path}"
	dl="licenses/${d}"
	docinto "${dl}"
	mkdir -p "${T}/${dl}" || die
	tail -n +${start} "${S}/${d}/${file_name}" \
		| head -n ${length} > \
		"${T}/${dl}/${license_name}" || die
	dodoc "${T}/${dl}/${license_name}"
}

# @FUNCTION: _install_licenses
# @DESCRIPTION:
# Installs licenses and copyright notices from third party rust cargo
# packages and other internal packages.
_install_licenses() {
	[[ -f "${T}/.copied_licenses" ]] && return

	einfo "Copying third party licenses and copyright notices"
	export IFS=$'\n'
	for f in $(find "${S}" \
	  -iname "*licens*" -type f \
	  -o -iname "*licenc*" \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  ) $(grep -i -G -l \
		-e "copyright" \
		-e "licens" \
		-e "licenc" \
		-e "warrant" \
		$(find "${S}" -iname "*readme*")) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${S}||")
		else
			d=$(echo "${f}" | sed -e "s|^${S}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS=$' \t\n'

	touch "${T}/.copied_licenses"
}

multilib_src_install() {
	cmake_src_install

	# Prevent crashes on PaX systems, bug #522808
	local d="${ED}/usr/$(get_libdir)/misc/webkit2gtk-${API_VERSION}"
	# usr/libexec is not multilib this is why it is changed.
	pax-mark m "${d}/WebKitPluginProcess"
	pax-mark m "${d}/WebKitWebProcess"
	pax-mark m "${d}/jsc"

	if use minibrowser ; then
		make_desktop_entry \
			/usr/$(get_libdir)/misc/webkit2gtk-4.0/MiniBrowser \
			"MiniBrowser (${ABI}, API: ${API_VERSION})" \
			"" "Network;WebBrowser"
	fi
	mkdir -p "${T}/langs" || die
	cp -a "${ED}/usr/share/locale/"* "${T}/langs" || die
	rm -rf "${ED}/usr/share/locale" || die
	insinto /usr/share/locale
	for l in ${L10N} ; do
		doins -r "${T}/langs/${l}"
	done

	_install_licenses
}

pkg_postinst() {
	if use minibrowser ; then
		create_minibrowser_symlink_abi() {
			pushd "${ESYSROOT}/usr/bin" || die
				ln -sf \
../../usr/$(get_abi_LIBDIR ${ABI})/misc/webkit2gtk-${API_VERSION}/MiniBrowser \
					minibrowser || die
			popd
		}
		multilib_foreach_abi create_minibrowser_symlink_abi
		einfo \
"The symlink for the minibrowser may need to change manually to select the\n\
preferred ABI and/or API version which can be 4.0, 4.1, 5.0.  Examples,\n\
\n\
\`ln -sf /usr/lib64/misc/webkit2gtk-${API_VERSION}/MiniBrowser /usr/bin/minibrowser \`
\`ln -sf /usr/lib/misc/webkit2gtk-${API_VERSION}/MiniBrowser /usr/bin/minibrowser \`
\n"
	fi
}
