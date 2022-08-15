# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# -r revision notes
# -rabcde
# ab = WEBKITGTK_API_VERSION version (4.1)
# c = reserved
# de = ebuild revision

# See also, https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/Source/WebKit/Configurations/Version.xcconfig
# To make sure that libwebrtc is the same revision

LLVM_MAX_SLOT=14 # This should not be more than Mesa's package LLVM_MAX_SLOT
LLVM_SLOTS=(14 13)

CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{8..11} )
USE_RUBY="ruby26 ruby27 ruby30 ruby31 "
inherit check-reqs cmake desktop flag-o-matic git-r3 gnome2 linux-info llvm \
multilib-minimal pax-utils python-any-r1 ruby-single toolchain-funcs

DESCRIPTION="Open source web browser engine (GTK+3 with libsoup3)"
HOMEPAGE="https://www.webkitgtk.org"
LICENSE_DROMAEO="
	( all-rights-reserved || ( MPL-1.1 GPL-2.0+ LGPL-2.1+ ) )
	( all-rights-reserved MIT )
	( ( all-rights-reserved || ( MIT AFL-2.1 ) ) ( MIT GPL-2 ) || ( AFL-2.1 BSD ) MIT )
	( all-rights-reserved GPL-2+ )
	( MIT GPL-2 )
	( MIT BSD GPL )
	BSD
	BSD-2
	LGPL-2.1
"
# The default webkit license is LGPL-2 BSD-2.
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
	( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
	( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) GIF )
	|| ( AFL-2.0 LGPL-2+ )
	libwebrtc? (
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
		ooura
		openssl
		QU-fft
		sigslot
	)
	pgo? (
		all-rights-reserved
		BSD
		BSD-2
		GPL-2+
		LGPL-2+
		LGPL-2.1+
	)
" # \
# emerge does not understand ^^ when applied to licenses, but you should only \
#   pick one when || is presented

# BSD BSD-2 LGPL-2+ LGPL-2.1+ Tools/Scripts
#   (all-rights-reserved LGPL-2.1+) Tools/Scripts/webkitperl/VCSUtils_unittest/parseDiffWithMockFiles.pl
#   all-rights-reserved Tools/Scripts/libraries/webkitcorepy/webkitcorepy/tests/string_utils_unittest.py
#   GPL-2+ Tools/Scripts/prepare-ChangeLog
#   LGPL-2.1+ Tools/Scripts/run-minibrowser
#   LGPL-2.1+ Tools/Scripts/webkitpy/minibrowser/run_webkit_app.py

# BSD PerformanceTests/Animation
# BSD BSD-2 PerformanceTests/APIBench
# BSD-2 BSD MIT PerformanceTests/ARES-6 plus group below
#   BSD PerformanceTests/ARES-6/Basic/random.js
#   MIT PerformanceTests/ARES-6/ml/index.js
# BSD-2 PerformanceTests/Canvas
# PGL PerformanceTests/Layout/chapter-reflow.html ; For license, see
#  https://www.gutenberg.org/policy/license.html
# BSD-2 PerformanceTests/DecoderTest
# BSD BSD-2 || ( MPL-1.1 GPL-2.0+ LGPL-2.1+ ) PerformanceTests/Dromaeo
#   (all-rights-reserved || (MIT AFL-2.1)) (MIT GPL-2) BSD \
#     PerformanceTests/Dromaeo/resources/dromaeo/web/tests/sunspider-string-unpack-code.html
#   (all-rights-reserved GPL-2+) PerformanceTests/Dromaeo/resources/dromaeo/web/tests/v8-deltablue.html ; \
#     the GPL-2+ does not say all rights reserved in the license template
#   (all-rights-reserved MIT) PerformanceTests/Dromaeo/Octane2/navier-stokes.js
#   (all-rights-reserved MIT) PerformanceTests/Dromaeo/resources/dromaeo/web/tests/v8-crypto.html ; \
#     the MIT license template doesn't contain all rights reserved
#   LGPL-2.1 PerformanceTests/Dromaeo/resources/dromaeo/web/tests/sunspider-date-format-xparb.html
#   (MIT GPL-2) for jquery (MIT BSD GPL-2) for Sizzle.js \
#     PerformanceTests/Dromaeo/resources/dromaeo/web/lib/jquery-1.6.4.js
# BSD PerformanceTests/DOM
# BSD-2 BSD MIT GPL-2 GPL-2+ ZLIB Apache-2.0 || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) UoI-NCSA \
#     PerformanceTests/JetStream
#   ( (all-rights-reserved Apache-2.0) (all-rights-reserved MIT) ) \
#     PerformanceTests/JetStream/simple/gcc-loops.cpp.js
#   (all-rights-reserved Apache-2.0) PerformanceTests/JetStream/Octane2/typescript-input.js ; \
#     the Apache-2.0 template does not contain all-rights-reserved
#   (all-rights-reserved GPL-2+) PerformanceTests/JetStream/Octane2/pdfjs.js ; \
#     the GPL-2+ does not contain all rights reserved in the template
#   (all-rights-reserved MIT) PerformanceTests/JetStream/Octane2/crypto.js ; \
#     the MIT license template does not contain all rights reserved
#   || ( BSD-2 GPL-2+ ) PerformanceTests/JetStream2/SeaMonster/sjlc.js
#   custom (all-rights-reserved Apache-2.0) PerformanceTests/JetStream/simple/hash-map.js
#   LGPL-2.1 PerformanceTests/JetStream/sunspider/date-format-xparb.js
# BSD-2 BSD || ( BSD GPL-2+ ) MIT LGPL-2.1 Apache-2.0 ZLIB PerformanceTests/JetStream2
#   (all-rights-reserved GPL-2+) PerformanceTests/JetStream2/Octane/pdfjs.js
#   (all-rights-reserved MIT) PerformanceTests/JetStream2/Octane/crypto.js
#   (all-rights-reserved Apache-2.0) PerformanceTests/JetStream2/simple/hash-map.js
#   ( MIT BSD || ( MIT GPL-2 ) ^^ ( MIT GPL-2 ) LGPL BSD-2 ) \
#     PerformanceTests/JetStream2/web-tooling-benchmark/cli.js
#   ^^ ( MPL-1.1 GPL-2+ LGPL-2+ ) PerformanceTests/JetStream2/SunSpider/base64.js
#   all-rights-reserved PerformanceTests/JetStream2/wasm/TSF/tsf_sha1.h
#   all-rights-reserved FPL PerformanceTests/JetStream2/wasm/TSF/tsf_sha1.c
#   custom MIT PerformanceTests/JetStream2/WSL/spirv.core.grammar.json
#   GPL-2 PerformanceTests/JetStream2/Octane/gbemu-part2.js
#   LGPL-2+ PerformanceTests/JetStream2/wasm/HashSet.cpp
#   LGPL-2.1 PerformanceTests/JetStream/sunspider/date-format-xparb.js
#   public-domain PerformanceTests/JetStream2/wasm/TSF/tsf_st.c
# BSD-2 MIT PerformanceTests/JSBench
# BSD-2 BSD LGPL-2.1 - Kraken benchmark
#   ( ( all-rights-reserved || ( MIT AFL-2.1 ) ) (MIT GPL) BSD MIT )
#   ( all-rights-reserved ^^ ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
#   ( all-rights-reserved GPL-3+ ) tests/kraken-1.0/audio-beat-detection-data.js
#   || ( BSD GPL-2 ) ; for SJCL
#   MPL-1.1 tests/kraken-1.0/imaging-desaturate.js
#   public-domain hosted/json2.js
# BSD-2 PerformanceTests/LaunchTime
# BSD BSD-2 Apache-2.0 LGPL-2.1 || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) \
#   PerformanceTests/LongSpider
# BSD-2 PerformanceTests/MallocBench
# BSD-2 PerformanceTests/MediaTime
# BSD-2 PerformanceTests/MotionMark
#   all-rights-reserved PerformanceTests/MotionMark/tests/master/resources/compass.svg
#   all-rights-reserved PerformanceTests/MotionMark/tests/master/resources/inspector.svg
#   all-rights-reserved PerformanceTests/MotionMark/tests/master/resources/script.svg
#   all-rights-reserved PerformanceTests/MotionMark/resources/runner/crystal.svg
#   all-rights-reserved PerformanceTests/MotionMark/resources/runner/lines.svg
#   all-rights-reserved PerformanceTests/MotionMark/resources/runner/logo.svg
# BSD PerformanceTests/Octane
# BSD PerformanceTests/Parser
# BSD-2 BSD PerformanceTests/RexBench
# BSD-2 PerformanceTests/resources
#   MIT PerformanceTests/resources/jquery.flot.min.js
# MIT PerformanceTests/SixSpeed
# MIT BSD PerformanceTests/Speedometer/
#   (all-rights-reserved MIT) \
#     PerformanceTests/Speedometer/resources/todomvc/architecture-examples/angular/dist/vendor.9a296bbc1909830a9106.bundle.js
#   (MIT CC0-1.0) \
#     PerformanceTests/Speedometer/resources/todomvc/dependency-examples/flight/flight/node_modules/requirejs-text/LICENSE
#   || (MIT BSD) \
#     PerformanceTests/Speedometer/resources/flightjs-example-app/components/requirejs/require.js
#   Apache-2.0 PerformanceTests/Speedometer/resources/flightjs-example-app/components/bootstrap/css/bootstrap-responsive.css
#   CC-BY-4.0 PerformanceTests/Speedometer/resources/todomvc/vanilla-examples/es2015/node_modules/todomvc-app-css/readme.md
#   public-domain PerformanceTests/Speedometer/resources/flightjs-example-app/components/es5-shim/tests/lib/json2.js
# BSD BSD-2 (MIT GPL-2) MIT || (MIT AFL-2.1) PerformanceTests/SunSpider
#   (all-rights-reserved GPL-2) PerformanceTests/SunSpider/tests/v8-v6/v8-deltablue.js
#   (all-rights-reserved MIT) PerformanceTests/SunSpider/tests/v8-v5/v8-crypto.js ; \
#     no all rights reserved in the plain MIT license template
#   ^^ (MPL-1.1 GPL-2.0+ LGPL-2.1+) \
#     PerformanceTests/SunSpider/tests/sunspider-0.9.1/string-base64.js
#   GPL-2+ PerformanceTests/SunSpider/tests/v8-v5/v8-deltablue.js
#   LGPL-2.1 PerformanceTests/SunSpider/tests/sunspider-0.9.1/date-format-xparb.js
#   public-domain PerformanceTests/SunSpider/hosted/json2.js
# BSD-2 BSD ( all-rights-reserved Apache-2.0 ) ZLIB PerformanceTests/testmem
#   (all-rights-reserved || (MPL-1.1 GPL-2+ LGPL-2+)) PerformanceTests/testmem/base64.js
# PerformanceTests/SVG
#   public-domain PerformanceTests/SVG/resources/AzLizardBenjiPark.svg
#   custom PerformanceTests/SVG/resources/WorldIso.svg
#   custom non commerical PerformanceTests/SVG/resources/France.svg
#   Free-Art-1.3 PerformanceTests/SVG/resources/Samurai.svg
#   GPL-2 PerformanceTests/SVG/resources/DropsOnABlade.svg
#   GPL-2 PerformanceTests/SVG/resources/UnderTheSee.svg
#   GPL-2 PerformanceTests/SVG/resources/FlowerFromMyGarden.svg
#   LGPL-2.1 PerformanceTests/SVG/resources/GearFlowers.svg
#   LGPL GPL-2 public-domain CC-BY-ND-2.5 PerformanceTests/SVG/resources/LICENSES
# No explicit licenses in module but defaults to LGPL-2 BSD-2.  Top level dir has no license.
#   See also https://webkit.org/licensing-webkit/
#   PerformanceTests/CSS
#   PerformanceTests/BigIntBench
#   PerformanceTests/Bindings
#   PerformanceTests/IndexedDB
#   PerformanceTests/Interactive
#   PerformanceTests/Intl
#   PerformanceTests/Media
#   PerformanceTests/Mutation
#   PerformanceTests/StyleBench
#   PerformanceTests/TailBench9000

# Some licenses are third party
# ( all-rights-reserved ^^ ( MPL-1.1 GPL-2+ LGPL-2.1+ ) ) Source/WTF/wtf/DateMath.h
# ( all-rights-reserved ^^ ( MPL-1.1 GPL-2+ LGPL-2.1+ ) GIF ) Source/WebCore/platform/image-decoders/gif/GIFImageReader.cpp
# || ( LGPL-2+ AFL-2.0 ) Source/ThirdParty/xdgmime/README
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
# base64 Source/ThirdParty/libwebrtc/Source/webrtc/rtc_base/third_party/base64/LICENSE
# GPL-2+ Source/JavaScriptCore
# GPL-3+ Source/ThirdParty/ANGLE/tools/flex-bison/third_party/m4sugar
# GPL-3+ Source/ThirdParty/ANGLE/tools/flex-bison/third_party/skeletons
# ISC Source/bmalloc/bmalloc/CryptoRandom.cpp
# ISC Source/WTF/wtf/CryptographicallyRandomNumber.cpp
# LGPL-2 (only) Source/WebCore/rendering/AutoTableLayout.cpp
# LGPL-2.1+ for some files in Source/WebCore
# MIT Source/ThirdParty/ANGLE/src/third_party/libXNVCtrl/LICENSE
# MIT Source/WTF/LICENSE-libc++.txt
# MIT Source/ThirdParty/libwebrtc/Source/webrtc/modules/third_party/fft/LICENSE
# MIT Source/ThirdParty/libwebrtc/Source/webrtc/modules/third_party/portaudio/LICENSE
# MPL-2.0 Source/WTF/wtf/text/StringBuilderJSON.cpp
# ooura Source/ThirdParty/libwebrtc/Source/webrtc/common_audio/third_party/ooura/LICENSE
# openssl, ISC, MIT - Source/ThirdParty/libwebrtc/Source/third_party/boringssl/src/LICENSE
# public-domain Source/ThirdParty/libwebrtc/Source/webrtc/rtc_base/third_party/sigslot/LICENSE
# public-domain Source/ThirdParty/libwebrtc/Source/webrtc/common_audio/third_party/spl_sqrt_floor/LICENSE
# public-domain Source/ThirdParty/libwebrtc/Source/webrtc/modules/third_party/g722/LICENSE
# public-domain Source/ThirdParty/libwebrtc/Source/webrtc/modules/third_party/g711/LICENSE
# unicode Source/WTF/icu/LICENSE
# * The public-domain is not presented in LICENSE variable to not give
#   the wrong impression that the entire package is released in the public domain.
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~riscv ~x86"

API_VERSION="4.1"
SLOT_MAJOR=$(ver_cut 1 ${API_VERSION})
# See Source/cmake/OptionsGTK.cmake
# CALCULATE_LIBRARY_VERSIONS_FROM_LIBTOOL_TRIPLE(WEBKIT C R A),
# SOVERSION = C - A
# WEBKITGTK_API_VERSION is 4.1
CURRENT="2"
AGE="2"
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
vi zh_CN
)

# aqua (quartz) is enabled upstream but disabled
# systemd is enabled upstream but gentoo uses openrc by default
# wayland is enabled upstream but disabled because it is not defacto default
#   standard for desktop yet

IUSE+="
${LANGS[@]/#/l10n_}
aqua avif +bmalloc cpu_flags_arm_thumb2 dav1d +dfg-jit +doc +egl -eme
+ftl-jit -gamepad +geolocation gles2 gnome-keyring +gstreamer gstwebrtc hardened
+introspection +javascriptcore +jit +journald +jpeg2k jpegxl +jumbo-build +lcms
+libhyphen +libnotify -libwebrtc lto -mediastream +minibrowser +opengl openmp
pgo +pulseaudio -seccomp -spell test thunder variation-fonts +v4l wayland
+webassembly +webassembly-b3-jit +webcore +webcrypto +webgl webm-eme -webrtc
webvtt -webxr +woff2 +X +yarr-jit
"

# See https://webkit.org/status/#specification-webxr for feature quality status
# of emerging web technologies.  Also found in Source/WebCore/features.json
# gstreamer with opengl/gles2 needs egl
REQUIRED_USE+="
	|| (
		aqua
		wayland
		X
	)
	egl
	cpu_flags_arm_thumb2? (
		!ftl-jit
		bmalloc
	)
	dav1d? ( gstreamer )
	jit? (
		bmalloc
		dfg-jit
	)
	dfg-jit? ( jit )
	ftl-jit? ( jit )
	geolocation? ( introspection )
	gles2? (
		!opengl
		egl
	)
	gstreamer? (
		|| (
			opengl
			gles2
		)
	)
	gstwebrtc? (
		gstreamer
		webrtc
	)
	hardened? ( !jit )
	opengl? (
		!gles2
		egl
	)
	pgo? ( minibrowser )
	pulseaudio? ( gstreamer )
	thunder? ( eme )
	v4l? ( gstreamer mediastream )
	wayland? ( egl )
	webassembly? ( jit )
	webassembly-b3-jit? (
		ftl-jit
		webassembly
	)
	webgl? (
		gstreamer
		|| (
			gles2
			opengl
		)
	)
	webm-eme? (
		eme
		gstreamer
		thunder
	)
	webrtc? (
		^^ ( gstwebrtc libwebrtc )
		mediastream
	)
	webvtt? ( gstreamer )
	webxr? ( webgl )
	yarr-jit? ( jit )
"
# libwebrtc requires git clone or the fix the tarball to contain the libwebrtc folder.

# cannot use introspection for 32 webkit on 64 bit because it requires 32 bit
# libs/build for python from gobject-introspection.  It produces this error:
#
# pyport.h:686:2: error: #error "LONG_BIT definition appears wrong for platform
#   (bad gcc/glibc config?)."
#
# This means also you cannot use the geolocation feature.

# For dependencies, see:
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/CMakeLists.txt
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/Source/cmake/BubblewrapSandboxChecks.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/Source/cmake/FindGStreamer.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/Source/cmake/GStreamerChecks.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/Source/cmake/OptionsGTK.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/Source/cmake/WebKitCommon.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/Tools/gtk/install-dependencies
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
	>=gui-libs/wpebackend-fdo-1.6.0:1.0[${MULTILIB_USEDEP}]
"
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
# xdg-dbus-proxy is using U 20.04 version
OCDM_WV="virtual/libc" # Placeholder
# Dependencies last updated from
# https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1
# Do not use trunk!
# media-libs/gst-plugins-bad should check libkate as a *DEPENDS but does not
RDEPEND+="
	>=dev-db/sqlite-3.22.0:3=[${MULTILIB_USEDEP}]
	>=dev-libs/icu-61.2:=[${MULTILIB_USEDEP}]
	>=dev-libs/glib-${GLIB_V}:2[${MULTILIB_USEDEP}]
	>=dev-libs/gmp-6.1.2[-pgo(-),${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.6.0:0=[${MULTILIB_USEDEP}]
	>=dev-libs/libtasn1-4.13:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.8.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxslt-1.1.7[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.8.0:1.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.4.2:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-0.9.18:=[icu(+),${MULTILIB_USEDEP}]
	>=media-libs/lcms-2.9[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.34:0=[${MULTILIB_USEDEP}]
	>=media-libs/libwebp-0.6.1:=[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.99.9:3.0[introspection?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.11:0[${MULTILIB_USEDEP}]
	  virtual/jpeg:0=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-${CAIRO_V}:=[X?,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.22.0:3[aqua?,introspection?,wayland?,X?,${MULTILIB_USEDEP}]
	avif? ( >=media-libs/libavif-0.9.0[${MULTILIB_USEDEP}] )
	egl? ( >=media-libs/mesa-${MESA_V}[egl(+),${MULTILIB_USEDEP}] )
	gamepad? ( >=dev-libs/libmanette-0.2.4[${MULTILIB_USEDEP}] )
	geolocation? ( >=app-misc/geoclue-0.12.99:2.0 )
	gles2? ( >=media-libs/mesa-${MESA_V}[gles2,${MULTILIB_USEDEP}] )
	gnome-keyring? ( >=app-crypt/libsecret-0.18.6[${MULTILIB_USEDEP}] )
	gstreamer? (
		>=media-libs/gstreamer-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
>=media-libs/gst-plugins-base-${GSTREAMER_V}:1.0[gles2?,egl(+),opengl?,X?,${MULTILIB_USEDEP}]
		media-plugins/gst-plugins-meta:1.0[${MULTILIB_USEDEP},pulseaudio?,v4l?]
		>=media-plugins/gst-plugins-opus-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-transcoder-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		dav1d? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},dav1d]
		)
		gstwebrtc? (
			>=media-plugins/gst-plugins-webrtc-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		)
		webvtt? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},closedcaption]
		)
	)
	introspection? ( >=dev-libs/gobject-introspection-1.56.1:= )
	journald? (
		|| (
			sys-auth/elogind
			>=sys-apps/systemd-245.4[${MULTILIB_USEDEP}]
		)
	)
	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2=[${MULTILIB_USEDEP}] )
	jpegxl? ( media-libs/libjxl[${MULTILIB_USEDEP}] )
	libhyphen? ( >=dev-libs/hyphen-2.8.8[${MULTILIB_USEDEP}] )
	libnotify? ( >=x11-libs/libnotify-0.7.7[${MULTILIB_USEDEP}] )
	opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
	openmp? ( >=sys-libs/libomp-10.0.0[${MULTILIB_USEDEP}] )
	seccomp? (
		>=sys-apps/bubblewrap-0.3.1
		>=sys-apps/xdg-dbus-proxy-0.1.2
		>=sys-libs/libseccomp-0.9.0[${MULTILIB_USEDEP}]
	)
	spell? ( >=app-text/enchant-1.6.0:2[${MULTILIB_USEDEP}] )
	thunder? ( net-libs/thunder )
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
		gles2? ( ${WPE_DEPEND} )
	)
	webcrypto? (
		>=dev-libs/libgcrypt-1.7.0:0=[${MULTILIB_USEDEP}]
	)
	webm-eme? ( ${OCDM_WV} )
	webxr? ( media-libs/openxr )
	webrtc? (
		>=dev-libs/libevent-2.1.8[${MULTILIB_USEDEP}]
		>=media-libs/alsa-lib-1.1.3[${MULTILIB_USEDEP}]
		>=media-libs/libvpx-1.7.0[${MULTILIB_USEDEP}]
		media-libs/openh264[${MULTILIB_USEDEP}]
		>=media-libs/opus-1.1[${MULTILIB_USEDEP}]
	)
	woff2? ( >=media-libs/woff2-1.0.2[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXcomposite-0.4.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXdamage-1.1.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-0.9.10[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.5[${MULTILIB_USEDEP}]
	)
"
# For ${OCDM_WV}, \
#   You need a license, the proprietary SDK, and OCDM plugin.
# see https://github.com/WebKit/WebKit/blob/9467df8e0134156fa95c4e654e956d8166a54a13/Source/WebCore/platform/graphics/gstreamer/eme/WebKitThunderDecryptorGStreamer.cpp#L97
unset WPE_DEPEND
DEPEND+=" ${RDEPEND}"
# paxctl is needed for bug #407085
# It needs real bison, not yacc.
gen_bdepend_clang() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
				>=sys-devel/lld-${s}
			)
		"
	done
}

BDEPEND+="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	|| (
		|| ( $(gen_bdepend_clang) )
		>=sys-devel/gcc-8.3.0
	)
	>=app-accessibility/at-spi2-core-2.5.3[${MULTILIB_USEDEP}]
	>=dev-util/cmake-3.12
	>=dev-util/glib-utils-${GLIB_V}
	>=dev-lang/perl-5.10.0
	>=dev-lang/python-2.7
	>=dev-lang/ruby-1.9
	>=sys-devel/bison-3.0.4
	>=sys-devel/gettext-0.19.8.1[${MULTILIB_USEDEP}]
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-JSON-PP
	doc? ( dev-util/gi-docgen )
	geolocation? ( >=dev-util/gdbus-codegen-${GLIB_V} )
	lto? (
		|| ( $(gen_bdepend_clang) )
	)
	thunder? ( net-libs/thunder )
	webcore? ( >=dev-util/gperf-3.0.1 )
"
#	test? (
#		>=dev-python/pygobject-3.26.1:3[python_targets_python2_7]
#		>=x11-themes/hicolor-icon-theme-0.17
#		jit? ( >=sys-apps/paxctl-0.9 ) )
#
# Revisions and commit hashes provided since no tags specifically for the
# webkit-gtk project.
# Revisions can be found at:
# https://trac.webkit.org/log/webkit/trunk/Source/WebKit/gtk/NEWS
# https://trac.webkit.org/browser/webkit/releases/WebKitGTK
# Commits can be found at:
# https://github.com/WebKit/WebKit/commits/main/Source/WebKit/gtk/NEWS
# Or https://trac.webkit.org/browser/webkit/releases/WebKitGTK
EGIT_COMMIT="bec7040a3f8d8c18ae65fd9b22f0eced1215b4a4"
SRC_URI="
	!libwebrtc? (
		https://webkitgtk.org/releases/webkitgtk-${PV}.tar.xz
	)
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
einfo
einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
einfo
			check-reqs_pkg_pretend
		fi

		if ! test-flag-CXX -std=c++20 ; then
# See https://github.com/WebKit/WebKit/blob/webkitgtk-2.37.1/Source/cmake/OptionsCommon.cmake
eerror
eerror "You need at least GCC 8.3.x or Clang >= 6 for C++20-specific compiler"
eerror "flags"
eerror
			die
		fi
	fi

	if ! use opengl && ! use gles2; then
ewarn
ewarn "You are disabling OpenGL usage (USE=opengl or USE=gles2) completely."
ewarn "This is an unsupported configuration meant for very specific embedded"
ewarn "use cases, where there truly is no GL possible (and even that use case"
ewarn "is very unlikely to come by). If you have GL (even software-only), you"
ewarn "really really should be enabling OpenGL!"
ewarn
	fi
}

check_geolocation() {
	if use geolocation ; then
		if has_version "~app-misc/geoclue-2.5.7" ; then
			local geoclue_repo=$(cat "${EROOT}/var/db/pkg/app-misc/geoclue-2.5.7"*"/repository")
			if [[ "${geoclue_repo}" == "gentoo" ]] ; then
ewarn
ewarn "The gentoo repo version of geoclue may be broken if you have no GPS"
ewarn "device but rely on Wi-Fi positioning system (WPS) method of converting"
ewarn "the BSSID/SSID to Lat/Long.  Use the app-misc/geoclue from the"
ewarn "oiledmachine-overlay version instead."
ewarn
			fi
		fi
	fi
}

pkg_setup() {
einfo
einfo "This is the unstable branch."
einfo
	if [[ ${MERGE_TYPE} != "binary" ]] \
		&& is-flagq "-g*" \
		&& ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi
	python-any-r1_pkg_setup

	check_geolocation

	if ( use arm || use arm64 ) && ! use gles2 ; then
ewarn
ewarn "gles2 is the default on upstream."
ewarn
	fi

	if use openmp ; then
		tc-check-openmp
	fi

	if use lto ; then
		llvm_pkg_setup
	fi

	if ! use pulseaudio ; then
ewarn
ewarn "Microphone support requires pulseaudio USE flag enabled."
ewarn
	fi

	if use v4l ; then
		local gst_plugins_v4l2_repo=\
$(cat "${EROOT}/var/db/pkg/media-plugins/gst-plugins-v4l2-"*"/repository")
einfo
einfo "gst-plugins-v4l2 repo:  ${gst_plugins_v4l2_repo}"
einfo
		if [[ "${gst_plugins_v4l2_repo}" != "oiledmachine-overlay" ]] ; then
ewarn
ewarn "Please only use the media-plugins/gst-plugins-v4l2::oiledmachine-overlay"
ewarn
ewarn "  or"
ewarn
ewarn "Add \"export GST_V4L2_USE_LIBV4L2=1\" to your .bashrc and relog."
ewarn
		fi
	fi

	if use webrtc ; then
ewarn
ewarn "WebRTC support is currently in development and feature incomplete."
ewarn
	fi

	if ! use webcore ; then
ewarn
ewarn "Disabling webcore disables rendering support."
ewarn "Only disable if you want JavaScript support."
ewarn
	fi

	if ! use javascriptcore ; then
ewarn
ewarn "Disabling webcore disables website scripts completely"
ewarn "or any contemporary websites."
ewarn
	fi
}

EXPECTED_BUILD_FINGERPRINT="\
701d81992160af88a320e27226915531da0c17d221b16fff370beb7dc75615b9\
ece9dff979ab427e8fca45f7c598524383c077d235c5645224d0a0e2c87553af"
EXPECTED_BUILD_FINGERPRINT_WEBRTC="\
ce7a0164ea0da74de32de8eeac7e541c29355542710f270c2fc6125309315194\
2c3acd8d773264875d99304da31c28ec05e5c97ee9af6a352504fb37fa59d8c3"
src_unpack() {
	if use libwebrtc ; then
		EGIT_CLONE_TYPE="single"
		EGIT_COMMIT="webkitgtk-$(ver_cut 1-3 ${PV})"
		EGIT_REPO_URI="https://github.com/WebKit/WebKit.git"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi

	local actual_build_fingerprint_webrtc
	if use libwebrtc ; then
		actual_build_fingerprint_webrtc=$(cat \
		$(find "${S}/Source/ThirdParty/libwebrtc" \
			\( \
				   -name "*.cmake" \
				-o -name "*CMakeLists.txt" \
			\) \
			| sort \
		) \
				| sha512sum \
				| cut -f 1 -d " " \
						)
	fi

	local actual_build_fingerprint=$(cat \
		$(find "${S}" \
			\( \
				\( \
					   -name "*.cmake" \
					-o -name "*CMakeLists.txt" \
				\) \
				-not -path "*Source/ThirdParty/libwebrtc/*" \
			\) \
			| sort \
		) \
				| sha512sum \
				| cut -f 1 -d " " \
					)
	if [[ "${actual_build_fingerprint}" != "${EXPECTED_BUILD_FINGERPRINT}" ]] ; then
eerror
eerror "Detected build files update"
eerror
eerror "Actual build files fingerprint=${actual_build_fingerprint}"
eerror "Expected build files fingerprint=${EXPECTED_BUILD_FINGERPRINT}"
eerror
eerror "QA:  Update IUSE, *DEPENDS, options, KEYWORDS, patches"
eerror
		die
	fi

	if use libwebrtc && [[ "${actual_build_fingerprint_webrtc}" != "${EXPECTED_BUILD_FINGERPRINT_WEBRTC}" ]] ; then
eerror
eerror "Detected build files update for WebRTC"
eerror
eerror "Actual build files fingerprint=${actual_build_fingerprint_webrtc}"
eerror "Expected build files fingerprint=${EXPECTED_BUILD_FINGERPRINT_WEBRTC}"
eerror
eerror "QA:  Update IUSE, *DEPENDS, options, KEYWORDS, patches"
eerror
#		die
	fi
	if use pgo ; then
ewarn
ewarn "The PGO use flag is a Work In Progress (WIP) and is not production"
ewarn "ready."
ewarn
	fi
}

_prepare_pgo() {
	local pgo_data_dir="${EPREFIX}/var/lib/pgo-profiles/${CATEGORY}/${PN}/$(ver_cut 1-2 ${pv})/${API_VERSION}/${MULTILIB_ABI_FLAG}.${ABI}"
	local pgo_data_dir2="${T}/pgo-${MULTILIB_ABI_FLAG}.${ABI}"
	mkdir -p "${pgo_data_dir2}" || die
	if [[ -e "${pgo_data_dir}" ]] ; then
		cp -aT "${pgo_data_dir}" "${pgo_data_dir2}" || die
	fi
	touch "${pgo_data_dir2}/compiler_fingerprint" || die
}

src_prepare() {
#	use webrtc && eapply "${FILESDIR}/2.33.2-add-openh264-headers.patch"
	cmake_src_prepare
	gnome2_src_prepare

	prepare_abi() {
		_prepare_pgo
	}
	multilib_foreach_abi prepare_abi
}

meets_pgo_requirements() {
	if use pgo ; then
		local pgo_data_dir="${EPREFIX}/var/lib/pgo-profiles/${CATEGORY}/${PN}/$(ver_cut 1-2 ${pv})/${API_VERSION}/${MULTILIB_ABI_FLAG}.${ABI}"
		local pgo_data_dir2="${T}/pgo-${MULTILIB_ABI_FLAG}.${ABI}"

		# Has same compiler?
		if tc-is-gcc ; then
			local actual=$("${CC}" -dumpmachine | sha512sum | cut -f 1 -d " ")
			local expected=$(cat "${pgo_data_dir2}/compiler_fingerprint")
			if [[ "${actual}" != "${expected}" ]] ; then
				return 1
			fi
		elif tc-is-clang ; then
			local actual=$("${CC}" -dumpmachine | sha512sum | cut -f 1 -d " ")
			local expected=$(cat "${pgo_data_dir2}/compiler_fingerprint")
			if [[ "${actual}" != "${expected}" ]] ; then
				return 1
			fi
		else
			return 1
			ewarn "Compiler is not supported."
		fi

		# Has profile?
		if tc-is-gcc && find "${pgo_data_dir2}" -name "*.gcda" \
			2>/dev/null 1>/dev/null ; then
			:; # pass
		elif tc-is-clang && find "${pgo_data_dir2}" -name "*.profraw" \
			2>/dev/null 1>/dev/null ; then
			:; # pass
		else
			return 1
		fi

		return 0
	fi
	return 1
}

get_pgo_phase() {
	local result="NO_PGO"
	if ! use pgo ; then
		result="NO_PGO"
	elif use pgo && meets_pgo_requirements ; then
		result="PGO"
	elif use pgo && ! meets_pgo_requirements ; then
		result="PGI"
	fi
	echo "${result}"
}

_config_pgx() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	if [[ -e "${BUILD_DIR}" ]] ; then
		# For 3 step PGO only
		cd "${BUILD_DIR}" || die
		[[ -f build.ninja ]] && eninja clean
		find "${BUILD_DIR}" -name "CMakeCache.txt" -delete
	fi
	cd "${CMAKE_USE_DIR}" || die

	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	filter-flags -DENABLE_JIT=* -DENABLE_YARR_JIT=* -DENABLE_ASSEMBLER=*
	filter-flags '-fprofile*'

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
	if [[ -z $ruby_interpreter ]] ; then
eerror
eerror "No suitable ruby interpreter found"
eerror
		die
	fi

	# TODO: Check Web Audio support
	# should somehow let user select between them?
	# opengl needs to be explictly handled, bug #576634

	local use_wpe_renderer=OFF
	if use opengl || use gles2; then
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
		-DBWRAP_EXECUTABLE:FILEPATH="${EPREFIX}/usr/bin/bwrap" # \
# If bubblewrap[suid] then portage makes it go-r and cmake find_program fails \
# with that
		-DCMAKE_CXX_LIBRARY_ARCHITECTURE=$(get_abi_CHOST ${ABI})
		-DCMAKE_INSTALL_BINDIR=$(get_libdir)/webkit-gtk-${API_VERSION}
		-DCMAKE_INSTALL_LIBEXECDIR=$(get_libdir)/misc
		-DCMAKE_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)"
		-DDBUS_PROXY_EXECUTABLE:FILEPATH="${EPREFIX}/usr/bin/xdg-dbus-proxy"
		-DENABLE_API_TESTS=$(usex test)
		-DENABLE_BUBBLEWRAP_SANDBOX=$(usex seccomp)
		-DENABLE_DOCUMENTATION=$(usex doc)
		-DENABLE_ENCRYPTED_MEDIA=$(usex eme)
		-DENABLE_GAMEPAD=$(usex gamepad)
		-DENABLE_GEOLOCATION=$(multilib_native_usex geolocation) # \
# Runtime optional (talks over dbus service)
		-DENABLE_GLES2=$(usex gles2)
		-DENABLE_INTROSPECTION=$(multilib_native_usex introspection)
		-DENABLE_JAVASCRIPTCORE=$(usex javascriptcore)
		-DENABLE_JOURNALD_LOG=$(usex journald)
		-DENABLE_MEDIA_STREAM=$(usex mediastream)
		-DENABLE_MINIBROWSER=$(usex minibrowser)
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_UNIFIED_BUILDS=$(usex jumbo-build)
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_THUNDER=$(usex thunder)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_WEB_CRYPTO=$(usex webcrypto)
		-DENABLE_WEB_RTC=$(usex webrtc)
		-DENABLE_WEBASSEMBLY=$(usex webassembly)
		-DENABLE_WEBCORE=$(usex webcore)
		-DENABLE_WEBGL=$(usex webgl)
		-DENABLE_X11_TARGET=$(usex X)
		-DPORT=GTK
		-DUSE_AVIF=$(usex avif)
		-DUSE_GTK4=OFF
		-DUSE_JPEGXL=$(usex jpegxl)
		-DUSE_LIBHYPHEN=$(usex libhyphen)
		-DUSE_LCMS=$(usex lcms)
		-DUSE_LIBNOTIFY=$(usex libnotify)
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_SOUP2=OFF
		-DUSE_WOFF2=$(usex woff2)
		-DUSE_WPE_RENDERER=${use_wpe_renderer} # \
# WPE renderer is used to implement accelerated compositing under wayland
		$(cmake_use_find_package gles2 OpenGLES2)
		$(cmake_use_find_package egl EGL)
		$(cmake_use_find_package opengl OpenGL)
	)

	if use opengl || use gles2 ; then
		mycmakeargs+=(
			-DUSE_OPENGL_OR_ES=ON
		)
	else
		mycmakeargs+=(
			-DUSE_OPENGL_OR_ES=OFF
		)
	fi

	# See Source/cmake/WebKitFeatures.cmake
	local jit_enabled=$(usex jit "1" "0")
	if [[ "${ABI}" == "amd64" || "${ABI}" == "arm64" ]] && use jit ; then
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
einfo
einfo "Disabling JIT for ${ABI}"
einfo
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
einfo
einfo "Disabled YARR (regex) JIT"
einfo
		append-cppflags -DENABLE_JIT=0 -DENABLE_YARR_JIT=0 \
			-DENABLE_ASSEMBLER=0
	else
		if use yarr-jit ; then
einfo
einfo "Enabled YARR (regex) JIT" # default
einfo
		else
einfo
einfo "Disabled YARR (regex) JIT"
einfo
			append-cppflags -DENABLE_YARR_JIT=0
		fi
	fi
einfo
einfo "CPPFLAGS=${CPPFLAGS}"
einfo

	if use eme ; then
		sed -i -e "s|ENABLE_ENCRYPTED_MEDIA PRIVATE|ENABLE_ENCRYPTED_MEDIA PUBLIC|g" \
			"${S}/Source/cmake/OptionsGTK.cmake" || die
	fi

	if use lto ; then
		local mesa_llvm_v=$(bzcat \
			"${EPREFIX}/var/db/pkg/media-libs/mesa-"*"/environment.bz2" \
			| grep "LLVM_MAX_SLOT" \
			| head -n 1 \
			| cut -f 2 -d "\"")
		local llvm_prefix=$(get_llvm_prefix -d ${mesa_llvm_v})
einfo
einfo "MESA LLVM: ${mesa_llvm_v}"
einfo "LLVM path: ${llvm_prefix}"
einfo
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="${llvm_prefix}/bin/${ctarget}-clang"
			-DCMAKE_CXX_COMPILER="${llvm_prefix}/bin/${ctarget}-clang++"
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

	if use thunder ; then
		sed -i -e "s|ENABLE_THUNDER PRIVATE|ENABLE_THUNDER PUBLIC|g" \
			"${S}/Source/cmake/OptionsGTK.cmake" || die
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

#	local pgo_data_dir="${T}/pgo-${ABI}"
	local pgo_data_dir="${EPREFIX}/var/lib/pgo-profiles/${CATEGORY}/${PN}/$(ver_cut 1-2 ${pv})/${API_VERSION}/${MULTILIB_ABI_FLAG}.${ABI}"
	local pgo_data_dir2="${T}/pgo-${MULTILIB_ABI_FLAG}.${ABI}"
	mkdir -p "${ED}/${pgo_data_dir}" || die
	if [[ "${PGO_PHASE}" == "PGI" ]] ; then
		if tc-is-clang ; then
			append-flags -fprofile-generate="${pgo_data_dir}"
		elif tc-is-gcc ; then
			append-flags -fprofile-generate -fprofile-dir="${pgo_data_dir}"
		else
eerror
eerror "Only GCC and Clang are supported for PGO."
eerror
			die
		fi
	elif [[ "${PGO_PHASE}" == "PGO" ]] ; then
		if tc-is-clang ; then
einfo
einfo "Merging PGO data to generate a PGO profile"
einfo
			if ! ls "${BUILD_DIR}/"*.profraw 2>/dev/null 1>/dev/null ; then
eerror
eerror "Missing *.profraw files"
eerror
				die
			fi
			llvm-profdata merge -output="${pgo_data_dir}/custom-pgo.profdata" \
				"${pgo_data_dir}" || die
			append-flags -fprofile-use="${pgo_data_dir}/custom-pgo.profdata"
		elif tc-is-gcc ; then
			append-flags -fprofile-use -fprofile-dir="${pgo_data_dir}"
		fi
	fi

	if is-flag -O0 ; then
ewarn
ewarn "Upstream doesn't like it when -O0 is used, but we allow it."
ewarn
		append-cppflags -DRELEASE_WITHOUT_OPTIMIZATIONS=1
	fi

	WK_USE_CCACHE=NO cmake_src_configure
}

_compile_pgx() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	cd "${BUILD_DIR}" || die
	cmake_src_compile
}

multilib_src_compile() {
	export CC=$(tc-getCC ${CTARGET:-${CHOST}})
	export CXX=$(tc-getCXX ${CTARGET:-${CHOST}})

	einfo "CC=${CC}"
	einfo "CXX=${CXX}"

	export PGO_PHASE=$(get_pgo_phase)
	_config_pgx
	_compile_pgx
}

multilib_src_test() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	cd "${BUILD_DIR}"
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

einfo
einfo "Copying third party licenses and copyright notices"
einfo
	export IFS=$'\n'
	for f in $(find "${S}" \
	  -iname "*licens*" -type f \
	  -o -iname "*licenc*" \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  -o -iname "*author*" \
	  -o -iname "*CONTRIBUTORS*" \
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
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	cd "${BUILD_DIR}"
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
			"" \
			"Network;WebBrowser"
	fi
	mkdir -p "${T}/langs" || die
	cp -a "${ED}/usr/share/locale/"* "${T}/langs" || die
	rm -rf "${ED}/usr/share/locale" || die
	insinto /usr/share/locale
	for l in ${L10N} ; do
		doins -r "${T}/langs/${l}"
	done

	_install_licenses

	if use pgo ; then
		local pgo_data_dir="${ED}/var/lib/pgo-profiles/${CATEGORY}/${PN}/$(ver_cut 1-2 ${pv})/${API_VERSION}/${MULTILIB_ABI_FLAG}.${ABI}"
		dodir "${pgo_data_dir}"
		if tc-is-gcc ; then
			"${CC}" -dumpmachine > "${pgo_data_dir}/compiler" || die
			"${CC}" -dumpmachine | sha512sum | cut -f 1 -d " " \
				> "${pgo_data_dir}/compiler_fingerprint" || die
		elif tc-is-clang ; then
			"${CC}" -dumpmachine > "${pgo_data_dir}/compiler" || die
			"${CC}" -dumpmachine | sha512sum | cut -f 1 -d " " \
				> "${pgo_data_dir}/compiler_fingerprint" || die
		fi
	fi
}

wipe_pgo_profile() {
	if [[ "${PGO_PHASE}" =~ "PGI" ]] ; then
einfo
einfo "Wiping previous PGO profile"
einfo
		local pgo_data_dir="${EROOT}/var/lib/pgo-profiles/${CATEGORY}/${PN}/$(ver_cut 1-2 ${pv})/${API_VERSION}"
		find "${pgo_data_dir}" -type f -delete
	fi
}

delete_old_pgo_profiles() {
	if [[ -n "${REPLACING_VERSIONS}" ]] ; then
		local pv
		for pv in ${REPLACING_VERSIONS} ; do
			if ver_test $(ver_cut 1-2 "${pv}") -eq $(ver_cut 1-2 "${PV}") ; then
				# Don't delete permissions
				continue
			fi
			local pgo_data_dir="${EROOT}/var/lib/pgo-profiles/${CATEGORY}/${PN}/$(ver_cut 1-2 ${pv})/${API_VERSION}"
			if [[ -e "${pgo_data_dir}" ]] ; then
				rm -rf "${pgo_data_dir}" || true
			fi
		done
	fi
}

pkg_postinst() {
	if use minibrowser ; then
		create_minibrowser_symlink_abi() {
			ln -sf \
"${EPREFIX}/usr/$(get_abi_LIBDIR ${ABI})/misc/webkit2gtk-${API_VERSION}/MiniBrowser" \
				"${EROOT}/usr/bin/minibrowser" || die
		}
		multilib_foreach_abi create_minibrowser_symlink_abi
einfo
einfo "The symlink for the minibrowser may need to change manually to select"
einfo "the preferred ABI and/or API version which can be 4.0, 4.1, 5.0."
einfo "Examples,"
einfo
einfo "\`ln -sf /usr/lib64/misc/webkit2gtk-${API_VERSION}/MiniBrowser /usr/bin/minibrowser \`"
einfo "\`ln -sf /usr/lib/misc/webkit2gtk-${API_VERSION}/MiniBrowser /usr/bin/minibrowser \`"
einfo
	fi
	check_geolocation

	use pgo && wipe_pgo_profile
	delete_old_pgo_profiles
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  license-transparency, webvtt, avif
# OILEDMACHINE-OVERLAY-META-WIP:  pgo, webrtc
