# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U22, U24

# -r revision notes
# -rabcde
# ab = WEBKITGTK_API_VERSION version (4.0)
# c = reserved
# de = ebuild revision

# See also, https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Source/WebKit/Configurations/Version.xcconfig
# To make sure that libwebrtc is the same revision

# libwebrtc requires git clone or the fix the tarball to contain the libwebrtc folder.

# Introspection for 32 webkit on 64 bit cannot be used because it requires 32 bit
# libs/build for python from gobject-introspection.  It produces this error:
#
# pyport.h:686:2: error: #error "LONG_BIT definition appears wrong for platform
#   (bad gcc/glibc config?)."
#
# This means also you cannot use the geolocation feature.

# For dependencies, see:
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/CMakeLists.txt
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Source/cmake/BubblewrapSandboxChecks.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Source/cmake/FindGStreamer.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Source/cmake/GStreamerChecks.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Source/cmake/OptionsGTK.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Source/cmake/WebKitCommon.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Tools/buildstream/elements/sdk-platform.bst
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Tools/buildstream/elements/sdk/gst-plugin-dav1d.bst
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Tools/gtk/install-dependencies
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Tools/gtk/dependencies
#   https://github.com/WebKit/WebKit/tree/webkitgtk-2.48.1/Tools/glib/dependencies
#   https://docs.webkit.org/Ports/WebKitGTK%20and%20WPE%20WebKit/DependenciesPolicy.html
#   https://docs.webkit.org/Ports/WebKitGTK%20and%20WPE%20WebKit/GCCRequirement.html

#
# To compare changes, Use:
#
# C="Source/cmake/WebKitCommon.cmake" D1="${S_OLD}" ; D2="${S_NEW}" ; diff  -urp "${D1}/${C}" "${D2}/${C}" # For individual comparisons
# D1="${S_OLD}" ; D2="${S_NEW}" ; diff  -urp "${D1}" "${D2}" # For tree comparisons
#

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
# TODO: gst-plugins-base[X] is only needed when build configuration ends up with
#   GLX set, but that's a bit automagic too to fix
# Technically, dev-libs/gobject-introspection requires [${MULTILIB_USEDEP}].
#   It is removed to only allow native ABI to use it.
# Manette 0.2.4 is required by webkit-gtk but LTS version is 0.2.3
# xdg-dbus-proxy is using U 20.04 version
# Dependencies last updated from
# https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1
# Do not use trunk!
# media-libs/gst-plugins-bad should check libkate as a *DEPENDS but does not

API_VERSION="4.0"
CAIRO_PV="1.16.0"
# One of the major sources of lag comes from dependencies
# These are strict to match performance to competition or normal builds.
declare -A CFLAGS_RDEPEND=(
	["media-libs/dav1d"]=">=;-O2" # -O0 skippy, -O1 faster but blurry, -Os blurry still, -O2 not blurry
	["media-libs/libvpx"]=">=;-O1" # -O0 causes FPS to lag below 25 FPS.
)
CFLAGS_HARDENED_SSP_LEVEL=1
CFLAGS_HARDENED_TRAPV=0 # Apply per component using custom patch
CFLAGS_HARDENED_USE_CASES="copy-paste-password jit network sensitive-data untrusted-data web-browser"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE HO IO UAF TC"
CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307
CLANG_PV="18"
CMAKE_MAKEFILE_GENERATOR="ninja"
CXX_STD="20"
FFMPEG_COMPAT=(
	"0/58.60.60" # 6.1
	"0/57.59.59" # 5.1
	"0/56.58.58" # 4.3
)
FONTCONFIG_PV="2.13.0"
FREETYPE_PV="2.9.0"
GCC_PV="11.2.0"
GLIB_VERSIONS=(
	"2.82.5"
)
GOBJECT_INTROSPECTION_VERSIONS=(
	"1.82"
)
GSTREAMER_PV="1.20.0" # Upstream min is 1.16.2, but distro only offers 1.20
HARFBUZZ_PV="2.7.4"
LANGS=(
ar as bg ca cs da de el en_CA en_GB eo es et eu fi fr gl gu he hi hr hu id it
ja ka kn ko lt lv ml mr nb nl or pa pl pt pt_BR ro ru sl sr sr@latin sv ta te
tr uk vi zh_CN
)
LLVM_COMPAT=( 18 14 )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
MESA_PV="18.0.0_rc5"
MITIGATION_DATE="Apr 7, 2025"
MITIGATION_LAST_UPDATE=1743585600 # From `date +%s -d "2025-04-02 2:20 AM PDT"` from tag in GH for this version
MITIGATION_URI="https://webkitgtk.org/security/WSA-2025-0003.html"
VULNERABILITIES_FIXED=(
	"CVE-2024-54551;ZC, DoS;High"
	"CVE-2025-24208;XSS, DT, ID;Medium"
	"CVE-2025-24209;BO, ZC, DoS, DT, ID;High"
	"CVE-2025-24213;MC, DoS, DT, ID;High"
	"CVE-2025-24216;DoS;Medium"
	"CVE-2025-24264;ZC, DoS, DT, ID;Critical"
	"CVE-2025-30427;DoS;Medium"
)
OCDM_WV="virtual/libc" # Placeholder
PYTHON_COMPAT=( "python3_"{10..12} )
SELECTED_LTO="" # global var not const
SLOT_MAJOR=$(ver_cut 1 "${API_VERSION}")
# See Source/cmake/OptionsGTK.cmake
# CALCULATE_LIBRARY_VERSIONS_FROM_LIBTOOL_TRIPLE(WEBKIT C R A),
# SO_VERSION = C - A
# WEBKITGTK_API_VERSION is 4.0
SO_CURRENT="109"
#SO_REVISION=""
SO_AGE="72"
SO_VERSION=$(( ${SO_CURRENT} - ${SO_AGE} ))
USE_RUBY=" ruby32 ruby33"
WK_PAGE_SIZE=64 # global var not const

inherit cflags-depends cflags-hardened check-linker check-reqs cmake desktop dhms flag-o-matic
inherit git-r3 gnome2 lcnr linux-info llvm multilib-minimal multiprocessing
inherit pax-utils python-single-r1 ruby-single toolchain-funcs vf

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~riscv ~x86"
#
# Revisions and commit hashes provided since no tags specifically for the
# webkit-gtk project.
# Revisions can be found at:
# https://trac.webkit.org/log/webkit/trunk/Source/WebKit/gtk/NEWS
# https://trac.webkit.org/browser/webkit/releases/WebKitGTK
# Commits can be found at:
# https://github.com/WebKit/WebKit/commits/main/Source/WebKit/gtk/NEWS
# Or https://trac.webkit.org/browser/webkit/releases/WebKitGTK
#
SRC_URI="
	!libwebrtc? (
		https://webkitgtk.org/releases/webkitgtk-${PV}.tar.xz
	)
"
S="${WORKDIR}/webkitgtk-${PV}"

DESCRIPTION="Open source web browser engine (GTK+3 with HTTP/1.1 support)"
HOMEPAGE="https://www.webkitgtk.org"
LICENSE_DROMAEO="
	(
		all-rights-reserved
		MIT
	)
	(
		(
			all-rights-reserved
			|| (
				AFL-2.1
				MIT
			)
		)
		(
			GPL-2
			MIT
		)
		MIT
		|| (
			AFL-2.1
			BSD
		)
	)
	(
		all-rights-reserved
		GPL-2+
	)
	(
		GPL-2
		MIT
	)
	(
		BSD
		GPL
		MIT
	)
	BSD
	BSD-2
	LGPL-2.1
	|| (
		MPL-1.1
		GPL-2.0+
		LGPL-2.1+
	)
"
# The default webkit license is LGPL-2 BSD-2.
LICENSE="
	all-rights-reserved
	(
		GIF
		|| (
			MPL-1.1
			LGPL-2.1+
			GPL-2+
		)
	)
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
	Unicode-DFS-2016
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
	|| (
		MPL-1.1
		LGPL-2.1+
		GPL-2+
	)
	|| (
		AFL-2.0
		LGPL-2+
	)
" # \
# emerge does not understand ^^ when applied to licenses, but you should only \
#   pick one when || is presented

# BSD BSD-2 LGPL-2+ LGPL-2.1+ Tools/Scripts
#   ( all-rights-reserved LGPL-2.1+ ) Tools/Scripts/webkitperl/VCSUtils_unittest/parseDiffWithMockFiles.pl
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
#   ( all-rights-reserved || ( MIT AFL-2.1 ) ) ( MIT GPL-2 ) BSD \
#     PerformanceTests/Dromaeo/resources/dromaeo/web/tests/sunspider-string-unpack-code.html
#   ( all-rights-reserved GPL-2+ ) PerformanceTests/Dromaeo/resources/dromaeo/web/tests/v8-deltablue.html ; \
#     the GPL-2+ does not say all rights reserved in the license template
#   ( all-rights-reserved MIT ) PerformanceTests/Dromaeo/Octane2/navier-stokes.js
#   ( all-rights-reserved MIT ) PerformanceTests/Dromaeo/resources/dromaeo/web/tests/v8-crypto.html ; \
#     the MIT license template doesn't contain all rights reserved
#   LGPL-2.1 PerformanceTests/Dromaeo/resources/dromaeo/web/tests/sunspider-date-format-xparb.html
#   ( MIT GPL-2 ) for jquery ( MIT BSD GPL-2 ) for Sizzle.js \
#     PerformanceTests/Dromaeo/resources/dromaeo/web/lib/jquery-1.6.4.js
# BSD PerformanceTests/DOM
# BSD-2 BSD MIT GPL-2 GPL-2+ ZLIB Apache-2.0 || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) UoI-NCSA \
#     PerformanceTests/JetStream
#   ( ( all-rights-reserved Apache-2.0 ) ( all-rights-reserved MIT ) ) \
#     PerformanceTests/JetStream/simple/gcc-loops.cpp.js
#   ( all-rights-reserved Apache-2.0 ) PerformanceTests/JetStream/Octane2/typescript-input.js ; \
#     the Apache-2.0 template does not contain all-rights-reserved
#   ( all-rights-reserved GPL-2+ ) PerformanceTests/JetStream/Octane2/pdfjs.js ; \
#     the GPL-2+ does not contain all rights reserved in the template
#   ( all-rights-reserved MIT ) PerformanceTests/JetStream/Octane2/crypto.js ; \
#     the MIT license template does not contain all rights reserved
#   || ( BSD-2 GPL-2+ ) PerformanceTests/JetStream2/SeaMonster/sjlc.js
#   custom ( all-rights-reserved Apache-2.0 ) PerformanceTests/JetStream/simple/hash-map.js
#   LGPL-2.1 PerformanceTests/JetStream/sunspider/date-format-xparb.js
# BSD-2 BSD || ( BSD GPL-2+ ) MIT LGPL-2.1 Apache-2.0 ZLIB PerformanceTests/JetStream2
#   ( all-rights-reserved GPL-2+ ) PerformanceTests/JetStream2/Octane/pdfjs.js
#   ( all-rights-reserved MIT ) PerformanceTests/JetStream2/Octane/crypto.js
#   ( all-rights-reserved Apache-2.0 ) PerformanceTests/JetStream2/simple/hash-map.js
#   ( MIT BSD || ( MIT GPL-2 ) ^^ ( MIT GPL-2 ) LGPL BSD-2 ) \
#     PerformanceTests/JetStream2/web-tooling-benchmark/cli.js
#   || ( MPL-1.1 GPL-2+ LGPL-2+ ) PerformanceTests/JetStream2/SunSpider/base64.js
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
#   ( all-rights-reserved GPL-3+ ) tests/kraken-1.0/audio-beat-detection-data.js
#   MPL-1.1 tests/kraken-1.0/imaging-desaturate.js
#   public-domain hosted/json2.js
#   || ( BSD GPL-2 ) ; for SJCL
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ )
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
#   ( all-rights-reserved MIT ) \
#     PerformanceTests/Speedometer/resources/todomvc/architecture-examples/angular/dist/vendor.9a296bbc1909830a9106.bundle.js
#   ( MIT CC0-1.0 ) \
#     PerformanceTests/Speedometer/resources/todomvc/dependency-examples/flight/flight/node_modules/requirejs-text/LICENSE
#   || ( MIT BSD ) \
#     PerformanceTests/Speedometer/resources/flightjs-example-app/components/requirejs/require.js
#   Apache-2.0 PerformanceTests/Speedometer/resources/flightjs-example-app/components/bootstrap/css/bootstrap-responsive.css
#   CC-BY-4.0 PerformanceTests/Speedometer/resources/todomvc/vanilla-examples/es2015/node_modules/todomvc-app-css/readme.md
#   public-domain PerformanceTests/Speedometer/resources/flightjs-example-app/components/es5-shim/tests/lib/json2.js
# BSD BSD-2 ( MIT GPL-2 ) MIT || ( MIT AFL-2.1 ) PerformanceTests/SunSpider
#   ( all-rights-reserved GPL-2 ) PerformanceTests/SunSpider/tests/v8-v6/v8-deltablue.js
#   ( all-rights-reserved MIT ) PerformanceTests/SunSpider/tests/v8-v5/v8-crypto.js ; \
#     no all rights reserved in the plain MIT license template
#   || ( MPL-1.1 GPL-2.0+ LGPL-2.1+ ) \
#     PerformanceTests/SunSpider/tests/sunspider-0.9.1/string-base64.js
#   GPL-2+ PerformanceTests/SunSpider/tests/v8-v5/v8-deltablue.js
#   LGPL-2.1 PerformanceTests/SunSpider/tests/sunspider-0.9.1/date-format-xparb.js
#   public-domain PerformanceTests/SunSpider/hosted/json2.js
# BSD-2 BSD ( all-rights-reserved Apache-2.0 ) ZLIB PerformanceTests/testmem
#   ( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2+ ) ) PerformanceTests/testmem/base64.js
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
# ( || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) GIF ) Source/WebCore/platform/image-decoders/gif/GIFImageReader.cpp
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
# Unicode-DFS-2016 Source/WTF/icu/LICENSE
# || ( LGPL-2+ AFL-2.0 ) Source/ThirdParty/xdgmime/README
# || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) Source/WTF/wtf/DateMath.h
# * The public-domain is not presented in LICENSE variable to not give
#   the wrong impression that the entire package is released in the public domain.

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
SLOT="${API_VERSION%.*}/${SO_VERSION}"
# SLOT=6/4    GTK4 SOUP3
# SLOT=4.1/0  GTK3 SOUP3
# SLOT=4/37   GTK3 SOUP2

# aqua (quartz) is enabled upstream but disabled
# systemd is enabled upstream but gentoo uses openrc by default
# wayland is enabled upstream but disabled because it is not defacto default
#   standard for desktop yet

# For codecs, see
# https://github.com/WebKit/WebKit/blob/main/Source/WebCore/platform/graphics/gstreamer/eme/WebKitThunderDecryptorGStreamer.cpp#L49
# https://github.com/WebKit/WebKit/blob/main/Source/WebCore/platform/graphics/gstreamer/GStreamerRegistryScanner.cpp#L280
# https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Source/WebCore/platform/mediastream/gstreamer/RealtimeOutgoingAudioSourceGStreamer.cpp#L52

GST_ACODECS_IUSE="
aac
g722
mp3
opus
speex
vorbis
"

GST_VCODECS_IUSE="
aom
dav1d
libde265
openh264
theora
vpx
x264
"

GST_CONTAINERS_IUSE="
ogg
"

MSE_ACODECS_IUSE="
a52
flac
"

MSE_VCODECS_IUSE="
"

# Based on patent status
# Compare https://github.com/WebKit/WebKit/blob/webkitgtk-2.48.1/Tools/glib/dependencies
DEFAULT_GST_PLUGINS="
+a52
-aac
+alsa
+aom
+dav1d
+flac
+g722
-hls
-libde265
+mp3
+ogg
-openh264
+pulseaudio
+opus
+speex
+theora
-v4l
-vaapi
+vorbis
+vpx
-x264
-x265
"
# alsa is disabled on D11, enabled on A/L, enabled in F/L
# D11, A/L, F/L are currently not distributing stateless vaapi decoding.
# Using dav1d because aom is slow for decoding.
# libbacktrace is enabled upstream but disabled for security reasons.

PATENT_STATUS=(
	patent_status_nonfree
)
CPU_FLAGS_ARM=(
	cpu_flags_arm_thumb2
)
IUSE+="
${CPU_FLAGS_ARM[@]}
${DEFAULT_GST_PLUGINS}
${GST_ACODECS_IUSE}
${GST_CONTAINERS_IUSE}
${GST_VCODECS_IUSE}
${LANGS[@]/#/l10n_}
${MSE_ACODECS_IUSE}
${MSE_VCODECS_IUSE}
${PATENT_STATUS[@]}

aqua +avif -bmalloc -cache-partitioning clang dash debug +doc -eme +flite
-gamepad +gbm +geolocation gles2 gnome-keyring +gstreamer gstwebrtc
+introspection +javascript +jit +journald +jpegxl +libpas +lcms -libbacktrace
+libhyphen -libwebrtc -mediarecorder -mediastream +microphone +minibrowser mold
+opengl openmp -seccomp +speech-synthesis -spell -system-malloc test thunder
+variation-fonts wayland +webassembly -webdriver +webgl webm-eme -webrtc webvtt
-webxr +woff2 +X
ebuild_revision_11
"

gen_gst_plugins_duse() {
	local U=(
		${GST_ACODECS_IUSE}
		${GST_CONTAINERS_IUSE}
		${GST_VCODECS_IUSE}
		${MSE_ACODECS_IUSE}
		${MSE_VCODECS_IUSE}
	)
	U=( ${U[@]/aom/} )
	U=( ${U[@]/dav1d/} )
	U=( ${U[@]/g722/} )
	U=( ${U[@]/libde265/} )
	U=( ${U[@]/openh264/} )
	U=( ${U[@]/speex/} )
	local out=""
	local u
	for u in ${U[@]} ; do
		out+="${u}?,"
	done
	out="${out%,*}"
	echo -n "${out}"
}

GST_PLUGINS_DUSE=$(gen_gst_plugins_duse)

gen_gst_plugins_required_use() {
	local U=(
		${GST_ACODECS_IUSE}
		${GST_CONTAINERS_IUSE}
		${GST_VCODECS_IUSE}
		${MSE_ACODECS_IUSE}
		${MSE_VCODECS_IUSE}
	)
	local u
	for u in ${U[@]} ; do
		echo "
			${u}? (
				gstreamer
			)
		"
	done
}

REQUIRED_USE+=" "$(gen_gst_plugins_required_use)

# See https://webkit.org/status/#specification-webxr for feature quality status
# of emerging web technologies.  Also found in Source/WebCore/features.json

# The gstreamer va plugin doesn't allow selective codec disablement
# between free and nonfree so it is restricted.

PATENT_REQUIRED_USE="
	!patent_status_nonfree? (
		!aac
		!dash
		!hls
		!libde265
		!openh264
		!vaapi
		!x264
		!x265
	)
	aac? (
		patent_status_nonfree
	)
	dash? (
		patent_status_nonfree
	)
	hls? (
		patent_status_nonfree
	)
	libde265? (
		patent_status_nonfree
	)
	openh264? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	x264? (
		patent_status_nonfree
	)
	x265? (
		patent_status_nonfree
	)
"

_TRASH="
	^^ (
		bmalloc
		libpas
		system-malloc
	)
"

REQUIRED_USE+="
	${PATENT_REQUIRED_USE}
	alsa? (
		gstreamer
	)
	dash? (
		gstreamer
	)
	gbm? (
		|| (
			gles2
			opengl
		)
	)
	geolocation? (
		introspection
	)
	gles2? (
		!opengl
	)
	gstreamer? (
		|| (
			gles2
			opengl
		)
	)
	gstwebrtc? (
		gstreamer
		webrtc
	)
	hls? (
		gstreamer
	)
	microphone? (
		gstreamer
		mediastream
		pulseaudio
	)
	opengl? (
		!gles2
	)
	pulseaudio? (
		gstreamer
	)
	speech-synthesis? (
		|| (
			flite
		)
	)
	thunder? (
		eme
	)
	v4l? (
		gstreamer
		mediastream
	)
	vaapi? (
		gstreamer
	)
	webassembly? (
		jit
	)
	webgl? (
		gbm
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
		^^ (
			gstwebrtc
			libwebrtc
		)
		mediastream
	)
	webvtt? (
		gstreamer
	)
	webxr? (
		webgl
	)
	|| (
		aqua
		wayland
		X
	)
"

RDEPEND_PATENTS="
	>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},patent_status_nonfree=]
	!patent_status_nonfree? (
		gstreamer? (
			media-plugins/gst-plugins-meta[-nvcodec,-qsv,-vaapi,-vulkan]
			media-libs/gst-plugins-bad[-nvcodec,-qsv,-vaapi,-vulkan-video]
		)
	)
"

gen_depend_llvm() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			(
				llvm-core/clang:${s}
				llvm-core/llvm:${s}
				llvm-core/lld:${s}
				openmp? (
					llvm-runtimes/openmp:${s}[${MULTILIB_USEDEP}]
				)
			)
		"
	done
}

gen_glib_rdepend() {
	local pv
	for pv in ${GLIB_VERSIONS[@]} ; do
		local minor="${pv#*.}"
		minor="${minor%.*}"
		echo "
			(
				~dev-util/glib-utils-${pv}
				~dev-libs/glib-${pv}:2[${MULTILIB_USEDEP}]
				introspection? (
					=dev-libs/gobject-introspection-1.${minor}*[${PYTHON_SINGLE_USEDEP}]
					=dev-libs/gobject-introspection-common-1.${minor}*
				)
				geolocation? (
					~dev-util/gdbus-codegen-${pv}
				)
			)
		"
	done
}

gen_gobject_introspection_rdepend() {
	local pv
	for pv in ${GOBJECT_INTROSPECTION_VERSIONS[@]} ; do
		echo "
			(
				introspection? (
					=dev-libs/gobject-introspection-${pv}*[${PYTHON_SINGLE_USEDEP}]
					=dev-libs/gobject-introspection-common-${pv}*
				)
			)
		"
	done
}

RDEPEND+="
	${RDEPEND_PATENTS}
	>=dev-db/sqlite-3.22.0:3=[${MULTILIB_USEDEP}]
	>=dev-libs/icu-70.1:=[${MULTILIB_USEDEP}]
	>=dev-libs/gmp-6.1.2[-pgo(-),${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.7.0:0=[${MULTILIB_USEDEP}]
	>=dev-libs/libtasn1-4.13:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.13:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxslt-1.1.13[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-${FONTCONFIG_PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-${FREETYPE_PV}:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-${HARFBUZZ_PV}:=[${MULTILIB_USEDEP},icu(+)]
	>=media-libs/lcms-2.9[${MULTILIB_USEDEP}]
	>=media-libs/libepoxy-1.5.4[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.34:0=[${MULTILIB_USEDEP}]
	>=media-libs/libwebp-0.6.1:=[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.54.0:2.4[${MULTILIB_USEDEP},introspection?]
	>=sys-libs/zlib-1.2.11:0[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-${CAIRO_PV}:=[${MULTILIB_USEDEP},X?]
	>=x11-libs/gtk+-3.22.0:3[${MULTILIB_USEDEP},aqua?,introspection?,wayland?,X?]
	sys-kernel/mitigate-id
	virtual/jpeg:0=[${MULTILIB_USEDEP}]
	virtual/patent-status[patent_status_nonfree=]
	avif? (
		>=media-libs/libavif-0.9.0[${MULTILIB_USEDEP}]
	)
	flite? (
		>=app-accessibility/flite-2.2[${MULTILIB_USEDEP}]
	)
	gamepad? (
		>=dev-libs/libmanette-0.2.4[${MULTILIB_USEDEP}]
	)
	gbm? (
		>=x11-libs/libdrm-2.4.99[${MULTILIB_USEDEP}]
	)
	geolocation? (
		>=app-misc/geoclue-2.6.0:2.0
	)
	gles2? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},egl(+),gles2(+),opengl]
	)
	gnome-keyring? (
		>=app-crypt/libsecret-0.18.6[${MULTILIB_USEDEP}]
	)
	gstreamer? (
		>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-base-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},egl(+),gles2?,opengl?,X?]
		>=media-libs/gstreamer-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},${GST_PLUGINS_DUSE},alsa?,pulseaudio?,v4l?]
		>=media-plugins/gst-plugins-opus-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		aom? (
			>=media-plugins/gst-plugins-aom-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		)
		dash? (
			>=media-plugins/gst-plugins-dash-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		)
		dav1d? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},dav1d]
			media-libs/dav1d[${MULTILIB_USEDEP},8bit]
		)
		g722? (
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},ffmpeg]
		)
		gstwebrtc? (
			>=dev-libs/openssl-3[${MULTILIB_USEDEP}]
			>=media-plugins/gst-plugins-webrtc-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		)
		hls? (
			>=media-plugins/gst-plugins-hls-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		)
		libde265? (
			>=media-plugins/gst-plugins-libde265-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		)
		speex? (
			>=media-plugins/gst-plugins-speex-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		)
		vaapi? (
			>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},vaapi]
			media-libs/vaapi-drivers[${MULTILIB_USEDEP},patent_status_nonfree=]
		)
		webvtt? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},closedcaption]
		)
	)
	introspection? (
		>=dev-libs/gobject-introspection-1.56.1[${PYTHON_SINGLE_USEDEP}]
		|| (
			$(gen_gobject_introspection_rdepend)
		)
		dev-libs/gobject-introspection:=
	)
	journald? (
		|| (
			>=sys-apps/systemd-245.4[${MULTILIB_USEDEP}]
			sys-auth/elogind
		)
	)
	jpegxl? (
		>=media-libs/libjxl-0.7.0[${MULTILIB_USEDEP}]
	)
	libbacktrace? (
		sys-libs/libbacktrace[${MULTILIB_USEDEP}]
	)
	libhyphen? (
		>=dev-libs/hyphen-2.8.8[${MULTILIB_USEDEP}]
	)
	libwebrtc? (
		>=dev-libs/libevent-2.1.8[${MULTILIB_USEDEP}]
		>=media-libs/alsa-lib-1.1.3[${MULTILIB_USEDEP}]
		>=media-libs/libvpx-1.10.0[${MULTILIB_USEDEP}]
		>=media-libs/opus-1.1[${MULTILIB_USEDEP}]
		media-libs/openh264[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},egl(+)]
		virtual/opengl[${MULTILIB_USEDEP}]
	)
	openmp? (
		|| (
			$(gen_depend_llvm)
		)
	)
	seccomp? (
		>=sys-apps/bubblewrap-0.3.1
		>=sys-apps/xdg-dbus-proxy-0.1.2
		>=sys-libs/libseccomp-0.9.0[${MULTILIB_USEDEP}]
	)
	speech-synthesis? (
		>=app-accessibility/flite-2.2[${MULTILIB_USEDEP}]
	)
	spell? (
		>=app-text/enchant-1.6.0:2[${MULTILIB_USEDEP}]
	)
	thunder? (
		net-libs/Thunder
	)
	variation-fonts? (
		>=media-libs/fontconfig-${FONTCONFIG_PV}:1.0[${MULTILIB_USEDEP}]
		>=media-libs/freetype-${FREETYPE_PV}[${MULTILIB_USEDEP}]
		>=media-libs/harfbuzz-${HARFBUZZ_PV}:=[${MULTILIB_USEDEP},icu(+)]
		>=x11-libs/cairo-1.16:=[${MULTILIB_USEDEP},X?]
	)
	wayland? (
		>=dev-libs/wayland-1.15.0[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.15[${MULTILIB_USEDEP}]
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},egl(+)]
	)
	webm-eme? (
		${OCDM_WV}
	)
	webxr? (
		media-libs/openxr
	)
	woff2? (
		>=media-libs/woff2-1.0.2[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.4[${MULTILIB_USEDEP}]
	)
	|| (
		$(gen_glib_rdepend)
	)
"
# For ${OCDM_WV}, \
#   You need a license, the proprietary SDK, and OCDM plugin.
# see https://github.com/WebKit/WebKit/blob/9467df8e0134156fa95c4e654e956d8166a54a13/Source/WebCore/platform/graphics/gstreamer/eme/WebKitThunderDecryptorGStreamer.cpp#L97
DEPEND+="
	${RDEPEND}
"
# paxctl is needed for bug #407085
# The >= 2.0 version of mold is used for legal reasons.
BDEPEND+="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=app-accessibility/at-spi2-core-2.5.3[${MULTILIB_USEDEP}]
	>=dev-lang/perl-5.10.0
	>=dev-lang/python-2.7
	>=dev-lang/ruby-1.9
	>=dev-build/cmake-3.20
	>=dev-util/gperf-3.0.1
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/gettext-0.19.8.1[${MULTILIB_USEDEP}]
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-JSON-PP
	clang? (
		|| (
			$(gen_depend_llvm)
		)
		llvm-core/clang:=
		llvm-core/llvm:=
	)
	doc? (
		dev-util/gi-docgen
	)
	mold? (
		>=sys-devel/mold-2.0
	)
	thunder? (
		net-libs/Thunder
	)
	openmp? (
		llvm-runtimes/openmp:=
	)
	|| (
		>=sys-devel/gcc-13.2.0:13
		>=sys-devel/gcc-12.2.0:12
		>=sys-devel/gcc-11.2:11
	)
	sys-devel/gcc:=
"
#	test? (
#		>=dev-python/pygobject-3.26.1:3[python_targets_python2_7]
#		>=x11-themes/hicolor-icon-theme-0.17
#		jit? (
#			>=sys-apps/paxctl-0.9
#		)
#	)
_PATCHES=(
#	"${FILESDIR}/${PN}-2.43.2-CaptionUserPreferencesDisplayMode-conditional.patch"
	"${FILESDIR}/extra-patches/${PN}-2.43.2-custom-page-size.patch"
	"${FILESDIR}/extra-patches/${PN}-2.46.3-gi-flags.patch"
)

get_gcc_ver_from_cxxabi() {
	local cxxabi_ver="${1}"
	local gcc_ver
# See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html
	if ver_test "${cxxabi_ver}" -eq "1.3.15" ; then
		gcc_ver="14.1.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.14" ; then
		gcc_ver="13.2.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.13" ; then
		gcc_ver="12.1.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.13" ; then
		gcc_ver="12.1.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.12" ; then
		gcc_ver="10.1.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.11" ; then
		gcc_ver="8.1.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.10" ; then
		gcc_ver="6.1.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.9" ; then
		gcc_ver="5.1.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.8" ; then
		gcc_ver="4.9.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.7" ; then
		gcc_ver="4.8.3"
	elif ver_test "${cxxabi_ver}" -eq "1.3.6" ; then
		gcc_ver="4.7.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.5" ; then
		gcc_ver="4.6.1"
	elif ver_test "${cxxabi_ver}" -eq "1.3.4" ; then
		gcc_ver="4.5.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.3" ; then
		gcc_ver="4.4.2"
	elif ver_test "${cxxabi_ver}" -eq "1.3.2" ; then
		gcc_ver="4.3.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3.1" ; then
		gcc_ver="4.0.0"
	elif ver_test "${cxxabi_ver}" -eq "1.3" ; then
		gcc_ver="3.4.1"
	elif ver_test "${cxxabi_ver}" -eq "1.2.1" ; then
		gcc_ver="3.3.3"
	elif ver_test "${cxxabi_ver}" -eq "1.2" ; then
		gcc_ver="3.2.3"
	elif ver_test "${cxxabi_ver}" -eq "1" ; then
		gcc_ver="3.1.1"
	fi
	echo "${gcc_ver}"
}

check_icu_build() {
	local icu_cxxabi_ver=$(strings "${ESYSROOT}/usr/$(get_libdir)/libicui18n.so" \
		| grep "CXXABI_1" \
		| sort -V \
		| tail -n 1 \
		| cut -f 2 -d "_")

	local gcc_pv=$(gcc-fullversion)
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	local gcc_slot=$(gcc-major-version)
	local gcc_cxxabi_ver=$(strings "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libstdc++.so" \
		| grep "CXXABI_1" \
		| sort -V \
		| tail -n 1 \
		| cut -f 2 -d "_")

	local icu_gcc_ver=$(get_gcc_ver_from_cxxabi "${icu_cxxabi_ver}")

	if ver_test "${icu_cxxabi_ver}" -gt "${gcc_cxxabi_ver}" ; then
# The CXXABI is less accurate than GLIBCXX
eerror
eerror "Detected missing symbol.  Please use the same GCC for both ICU and ${PN}."
eerror "Only GCC 11, 12, 13 supported."
eerror
eerror "Example solution:"
eerror
eerror "  eselect gcc set ${CHOST}-gcc-13"
eerror "  source /etc/profile"
eerror "  emerge -C dev-libs/icu"
eerror "  emerge -1vuDN dev-libs/icu"
eerror "  emerge -1vO =${CATEGORY}/${PN}-${PVR}"
eerror
		die
	fi
}

_set_clang() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if has_version "llvm-core/clang:${s}" ; then
			export CC="${CHOST}-clang-${s}"
			export CXX="${CHOST}-clang++-${s}"
			break
		fi
	done
	export CPP="${CC} -E"
	export AR="llvm-ar"
	export NM="llvm-nm"
	export OBJCOPY="llvm-objcopy"
	export OBJDUMP="llvm-objdump"
	export READELF="llvm-readelf"
	export STRIP="llvm-strip"
	export GCC_FLAGS=""
	strip-unsupported-flags
	${CC} --version || die
ewarn
ewarn "If \"Assumed value of MB_LEN_MAX wrong\" error encountered, rebuild"
ewarn "${CATEGORY}/${PN} and dev-libs/icu with GCC 12."
ewarn
}

_set_gcc() {
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot="${gcc_current_profile##*-}"

	if ver_test "${gcc_current_profile_slot}" -gt "13" ; then
ewarn "GCC ${gcc_current_profile_slot} is not supported upstream."
ewarn "If problems encountered, build both dev-libs/icu and ${CATEGORY}/${PN} with either GCC 11, 12, 13."
		export CC="${CHOST}-gcc-${gcc_current_profile_slot}"
		export CXX="${CHOST}-g++-${gcc_current_profile_slot}"
	elif has_version "sys-devel/gcc:13" ; then
		export CC="${CHOST}-gcc-13"
		export CXX="${CHOST}-g++-13"
	elif has_version "sys-devel/gcc:12" ; then
		export CC="${CHOST}-gcc-12"
		export CXX="${CHOST}-g++-12"
	elif has_version "sys-devel/gcc:11" ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-g++-11"
	else
eerror
eerror "GCC must be either 11, 12, 13"
eerror
eerror "Example:"
eerror
eerror "  eselect gcc set ${CHOST}-gcc-13"
eerror "  source /etc/profile"
eerror "  emerge -C dev-libs/icu"
eerror "  emerge -1vuDN dev-libs/icu"
eerror "  emerge -1vO =${CATEGORY}/${PN}-${PVR}"
eerror
		die
	fi
	export CPP="${CC} -E"
	export AR="ar"
	export NM="nm"
	export OBJCOPY="objcopy"
	export OBJDUMP="objdump"
	export READELF="readelf"
	export STRIP="strip"
	export GCC_FLAGS="-fno-allow-store-data-races"
	strip-unsupported-flags
}

_set_cxx() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
	# See https://docs.webkit.org/Ports/WebKitGTK%20and%20WPE%20WebKit/DependenciesPolicy.html
	# Based on D 12, U 22, U 24
	# D12 - gcc 12.2, clang 14.0
	# U22 - gcc 11.2, clang 14.0
	# U24 - gcc 13.2, clang 18.0
		if use clang ; then
			_set_clang
		else
			_set_gcc
		fi
	fi
}

get_olast() {
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
	if [[ -n "${olast}" ]] ; then
		echo "${olast}"
	else
		# Upstream default
		echo "-O3"
	fi
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi
	fi
	_set_cxx
	#check_icu_build

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
	if has_version "app-misc/geoclue" ; then
		if ! grep -q -e "submit-data=true" \
			"${EROOT}/etc/geoclue/geoclue.conf" ; then
ewarn
ewarn "${EROOT}/etc/geoclue/geoclue.conf should be changed to submit-data=true"
ewarn "to get GPS coordinates with the router's BSSID for non-mobile devices or"
ewarn "editing the [wifi] section to use another location service."
ewarn
		fi
	fi
}

_check_page_size_known_set() {
	use kernel_linux || return
	if use arm64 ; then
		known=1
		if (( ${page_size} == 64 )) ; then
			CONFIG_CHECK="
				~ARM64_64K_PAGES
				~!ARM64_16K_PAGES
				~!ARM64_4K_PAGES
			"
			WARNING_ARM64_64K_PAGES="CONFIG_ARM64_64K_PAGES must be set to =y in the kernel."
			WARNING_ARM64_16K_PAGES="CONFIG_ARM64_16K_PAGES must be set to =n in the kernel."
			WARNING_ARM64_4K_PAGES="CONFIG_ARM64_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				die "CUSTOM_PAGE_SIZE=64 must be set as an environment variable"
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="
				~!ARM64_64K_PAGES
				~ARM64_16K_PAGES
				~!ARM64_4K_PAGES
			"
			WARNING_ARM64_64K_PAGES="CONFIG_ARM64_64K_PAGES must be set to =n in the kernel."
			WARNING_ARM64_16K_PAGES="CONFIG_ARM64_16K_PAGES must be set to =y in the kernel."
			WARNING_ARM64_4K_PAGES="CONFIG_ARM64_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				die "CUSTOM_PAGE_SIZE=16 must be set as an environment variable"
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="
				~!ARM64_64K_PAGES
				~!ARM64_16K_PAGES
				~ARM64_4K_PAGES
			"
			WARNING_ARM64_64K_PAGES="CONFIG_ARM64_64K_PAGES must be set to =n in the kernel."
			WARNING_ARM64_16K_PAGES="CONFIG_ARM64_16K_PAGES must be set to =n in the kernel."
			WARNING_ARM64_4K_PAGES="CONFIG_ARM64_4K_PAGES must be set to =y in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				die "CUSTOM_PAGE_SIZE=4 must be set as an environment variable"
			fi
		else
			if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
eerror
eerror "Invalid value for CUSTOM_PAGE_SIZE."
eerror
eerror "Actual value:  ${CUSTOM_PAGE_SIZE}"
eerror "Expected values:  4, 16, 64"
eerror
				die
			else
eerror
eerror "QA:  Invalid value for page_size."
eerror
eerror "Actual value:  ${page_size}"
eerror "Expected values:  4, 16, 64"
eerror
				die
			fi
		fi
	fi

	if use loong ; then
		known=1
		if (( ${page_size} == 64 )) ; then
			CONFIG_CHECK="
				~PAGE_SIZE_64KB
				~!PAGE_SIZE_16KB
				~!PAGE_SIZE_4KB
			"
			WARNING_PAGE_SIZE_64KB="CONFIG_PAGE_SIZE_64KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_16KB="CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB="CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -z "${CUSTOM_PAGE_SIZE}" ]] ; then
				die "CUSTOM_PAGE_SIZE=64 must be set as an environment variable to avoid crash."
			fi
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				die "CUSTOM_PAGE_SIZE=64 must be set as an environment variable"
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="
				~!PAGE_SIZE_64KB
				~PAGE_SIZE_16KB
				~!PAGE_SIZE_4KB
			"
			WARNING_PAGE_SIZE_64KB="CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB="CONFIG_PAGE_SIZE_16KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_4KB="CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				die "CUSTOM_PAGE_SIZE=16 must be set as an environment variable"
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="
				~!PAGE_SIZE_64KB
				~!PAGE_SIZE_16KB
				~PAGE_SIZE_4KB
			"
			WARNING_PAGE_SIZE_64KB="CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB="CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB="CONFIG_PAGE_SIZE_4KB must be set to =y in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				die "CUSTOM_PAGE_SIZE=4 must be set as an environment variable"
			fi
		else
			if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
eerror
eerror "Invalid value for CUSTOM_PAGE_SIZE."
eerror
eerror "Actual value:  ${CUSTOM_PAGE_SIZE}"
eerror "Expected values:  4, 16, 64"
eerror
				die
			else
eerror
eerror "QA:  Invalid value for page_size."
eerror
eerror "Actual value:  ${page_size}"
eerror "Expected values:  4, 16, 64"
eerror
				die
			fi
		fi
	fi

	if use mips ; then
		known=1
		if (( ${page_size} == 64 )) ; then
			CONFIG_CHECK="
				~PAGE_SIZE_64KB
				~!PAGE_SIZE_32KB
				~!PAGE_SIZE_16KB
				~!PAGE_SIZE_8KB
				~!PAGE_SIZE_4KB
			"
			WARNING_PAGE_SIZE_64KB="CONFIG_PAGE_SIZE_64KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_32KB="CONFIG_PAGE_SIZE_32KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB="CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_8KB="CONFIG_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB="CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -z "${CUSTOM_PAGE_SIZE}" ]] ; then
				die "CUSTOM_PAGE_SIZE=64 must be set as an environment variable to avoid crash."
			fi
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				die "CUSTOM_PAGE_SIZE=64 must be set as an environment variable"
			fi
		elif (( ${page_size} == 32 )) ; then
			CONFIG_CHECK="
				~!PAGE_SIZE_64KB
				~PAGE_SIZE_32KB
				~!PAGE_SIZE_16KB
				~!PAGE_SIZE_8KB
				~!PAGE_SIZE_4KB
			"
			WARNING_PAGE_SIZE_64KB="CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_32KB="CONFIG_PAGE_SIZE_32KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_16KB="CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_8KB="CONFIG_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB="CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -z "${CUSTOM_PAGE_SIZE}" ]] ; then
				die "CUSTOM_PAGE_SIZE=32 must be set as an environment variable to avoid crash."
			fi
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "32" ]] ; then
				die "CUSTOM_PAGE_SIZE=32 must be set as an environment variable"
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="
				~!PAGE_SIZE_64KB
				~!PAGE_SIZE_32KB
				~PAGE_SIZE_16KB
				~!PAGE_SIZE_8KB
				~!PAGE_SIZE_4KB
			"
			WARNING_PAGE_SIZE_64KB="CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_32KB="CONFIG_PAGE_SIZE_32KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB="CONFIG_PAGE_SIZE_16KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_8KB="CONFIG_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB="CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				die "CUSTOM_PAGE_SIZE=16 must be set as an environment variable."
			fi
		elif (( ${page_size} == 8 )) ; then
			CONFIG_CHECK="
				~!PAGE_SIZE_64KB
				~!PAGE_SIZE_32KB
				~!PAGE_SIZE_16KB
				~PAGE_SIZE_8KB
				~!PAGE_SIZE_4KB
			"
			WARNING_PAGE_SIZE_64KB="CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_32KB="CONFIG_PAGE_SIZE_32KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB="CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_8KB="CONFIG_PAGE_SIZE_8KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_4KB="CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "8" ]] ; then
				die "CUSTOM_PAGE_SIZE=8 must be set as an environment variable."
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="
				~!PAGE_SIZE_64KB
				~!PAGE_SIZE_32KB
				~!PAGE_SIZE_16KB
				~!PAGE_SIZE_8KB
				~PAGE_SIZE_4KB
			"
			WARNING_PAGE_SIZE_64KB="CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_32KB="CONFIG_PAGE_SIZE_32KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB="CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_8KB="CONFIG_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB="CONFIG_PAGE_SIZE_4KB must be set to =y in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				die "CUSTOM_PAGE_SIZE=4 must be set as an environment variable."
			fi
		else
			if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
eerror
eerror "Invalid value for CUSTOM_PAGE_SIZE."
eerror
eerror "Actual value:  ${CUSTOM_PAGE_SIZE}"
eerror "Expected values:  4, 8, 16, 32, 64"
eerror
				die
			else
eerror
eerror "QA:  Invalid value for page_size."
eerror
eerror "Actual value:  ${page_size}"
eerror "Expected values:  4, 8, 16, 32, 64"
eerror
				die
			fi
		fi
	fi

	if use ppc || use ppc64 ; then
		known=1
		if (( ${page_size} == 256 )) ; then
			CONFIG_CHECK="
				~PPC_256K_PAGES
				~!PPC_64K_PAGES
				~!PPC_16K_PAGES
				~!PPC_4K_PAGES
			"
			WARNING_PPC_256K_PAGES="CONFIG_PPC_256K_PAGES must be set to =y in the kernel."
			WARNING_PPC_64K_PAGES="CONFIG_PPC_64K_PAGES must be set to =n in the kernel."
			WARNING_PPC_16K_PAGES="CONFIG_PPC_16K_PAGES must be set to =n in the kernel."
			WARNING_PPC_4K_PAGES="CONFIG_PPC_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ -z "${CUSTOM_PAGE_SIZE}" ]] ; then
				die "CUSTOM_PAGE_SIZE=256 must be set as an environment variable to avoid crash."
			fi
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "256" ]] ; then
				die "CUSTOM_PAGE_SIZE=256 must be set as an environment variable."
			fi
		elif (( ${page_size} == 64 )) ; then
			CONFIG_CHECK="
				~!PPC_256K_PAGES
				~PPC_64K_PAGES
				~!PPC_16K_PAGES
				~!PPC_4K_PAGES
			"
			WARNING_PPC_256K_PAGES="CONFIG_PPC_256K_PAGES must be set to =n in the kernel."
			WARNING_PPC_64K_PAGES="CONFIG_PPC_64K_PAGES must be set to =y in the kernel."
			WARNING_PPC_16K_PAGES="CONFIG_PPC_16K_PAGES must be set to =n in the kernel."
			WARNING_PPC_4K_PAGES="CONFIG_PPC_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				die "CUSTOM_PAGE_SIZE=64 must be set as an environment variable."
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="
				~!PPC_256K_PAGES
				~!PPC_64K_PAGES
				~PPC_16K_PAGES
				~!PPC_4K_PAGES
			"
			WARNING_PPC_256K_PAGES="CONFIG_PPC_256K_PAGES must be set to =n in the kernel."
			WARNING_PPC_64K_PAGES="CONFIG_PPC_64K_PAGES must be set to =n in the kernel."
			WARNING_PPC_16K_PAGES="CONFIG_PPC_16K_PAGES must be set to =y in the kernel."
			WARNING_PPC_4K_PAGES="CONFIG_PPC_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				die "CUSTOM_PAGE_SIZE=16 must be set as an environment variable."
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="
				~!PPC_256K_PAGES
				~!PPC_64K_PAGES
				~!PPC_16K_PAGES
				~PPC_4K_PAGES
			"
			WARNING_PPC_256K_PAGES="CONFIG_PPC_256K_PAGES must be set to =n in the kernel."
			WARNING_PPC_64K_PAGES="CONFIG_PPC_64K_PAGES must be set to =n in the kernel."
			WARNING_PPC_16K_PAGES="CONFIG_PPC_16K_PAGES must be set to =n in the kernel."
			WARNING_PPC_4K_PAGES="CONFIG_PPC_4K_PAGES must be set to =y in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				die "CUSTOM_PAGE_SIZE=4 must be set as an environment variable."
			fi
		else
			if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
eerror
eerror "Invalid value for CUSTOM_PAGE_SIZE."
eerror
eerror "Actual value:  ${CUSTOM_PAGE_SIZE}"
eerror "Expected values:  4, 16, 64, 256"
eerror
				die
			else
eerror
eerror "QA:  Invalid value for page_size."
eerror
eerror "Actual value:  ${page_size}"
eerror "Expected values:  4, 16, 64, 256"
eerror
				die
			fi
		fi
	fi

	if use amd64 || use arm ; then
		known=1
		if (( ${page_size} == 4 )) ; then
			:
		else
			if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
eerror
eerror "Invalid value for CUSTOM_PAGE_SIZE."
eerror
eerror "Actual value:  ${CUSTOM_PAGE_SIZE}"
eerror "Expected values:  4"
eerror
				die
			else
eerror
eerror "QA:  Invalid value for page_size."
eerror
eerror "Actual value:  ${page_size}"
eerror "Expected values:  4"
eerror
				die
			fi
		fi
	fi
}

_get_actual_page_size() {
	# Upstream doesn't do a comprehensive job.
	if [[ "${ARCH}" == "alpha" ]] ; then
		echo "8"
	elif [[ "${ARCH}" == "arm" ]] ; then
		echo "4"
	elif [[ "${ARCH}" == "arm64" ]] ; then
		if linux_config_exists ; then
			if linux_chkconfig_builtin ARM64_4K_PAGES ; then
				echo "4"
			elif linux_chkconfig_builtin ARM64_16K_PAGES ; then
				echo "16"
			elif linux_chkconfig_builtin ARM64_64K_PAGES ; then
				echo "64"
			else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
				die
			fi
		else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
			die
		fi
	elif [[ "${ARCH}" == "hppa" ]] ; then
		if linux_config_exists ; then
			if linux_chkconfig_builtin PARISC_PAGE_SIZE_4KB ; then
				echo "4"
			elif linux_chkconfig_builtin PARISC_PAGE_SIZE_16KB ; then
				echo "16"
			elif linux_chkconfig_builtin PARISC_PAGE_SIZE_64KB ; then
				echo "64"
			else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
				die
			fi
		else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
			die
		fi
	elif [[ "${ARCH}" == "loong" ]] ; then
		if linux_config_exists ; then
			if linux_chkconfig_builtin PAGE_SIZE_4KB ; then
				echo "4"
			elif linux_chkconfig_builtin PAGE_SIZE_16KB ; then
				echo "16"
			elif linux_chkconfig_builtin PAGE_SIZE_64KB ; then
				echo "64"
			else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
				die
			fi
		else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
			die
		fi
	elif [[ "${ARCH}" == "m68k" ]] ; then
		if linux_config_exists ; then
			if linux_chkconfig_builtin SUN3 ; then
				echo "8"
			elif linux_chkconfig_builtin COLDFIRE ; then
				echo "8"
			else
				echo "4"
			fi
		else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
			die
		fi
	elif [[ "${ARCH}" == "ppc" || "${ARCH}" == "ppc64" ]] ; then
		if linux_config_exists ; then
			if linux_chkconfig_builtin PPC_4K_PAGES ; then
				echo "4"
			elif linux_chkconfig_builtin PPC_16K_PAGES ; then
				echo "16"
			elif linux_chkconfig_builtin PPC_64K_PAGES" ; then
				echo "64"
			elif linux_chkconfig_builtin PPC_256K_PAGES" ; then
				echo "256"
			else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
				die
			fi
		else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
			die
		fi
	elif [[ \
		   "${ARCH}" == "mips" \
		|| "${ARCH}" == "mips64" \
		|| "${ARCH}" == "mips64el" \
		|| "${ARCH}" == "mipsel" \
	]] ; then
		if linux_config_exists ; then
			if linux_chkconfig_builtin PAGE_SIZE_4KB ; then
				echo "4"
			elif linux_chkconfig_builtin PAGE_SIZE_8KB ; then
				echo "8"
			elif linux_chkconfig_builtin PAGE_SIZE_16KB ; then
				echo "16"
			elif linux_chkconfig_builtin PAGE_SIZE_32KB ; then
				echo "32"
			elif linux_chkconfig_builtin PAGE_SIZE_64KB ; then
				echo "64"
			else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
				die
			fi
		else
eerror
eerror "Run menuconfig to fix the kernel config."
eerror
			die
		fi
	elif [[ "${ARCH}" == "riscv" ]] ; then
		echo "4"
	elif [[ "${ARCH}" == "s390" ]] ; then
		echo "4"
	elif [[ "${ARCH}" == "sparc" ]] ; then
		if tc-cpp-is-true "defined(__sparc__) && defined(__arch64__)" ; then
			echo "8"
		else
			echo "4"
		fi
	elif [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" ]] ; then
		echo "4"
	else
eerror
eerror "ARCH not supported.  Provide a numerical value for CUSTOM_PAGE_SIZE"
eerror "or unset CUSTOM_PAGE_SIZE."
eerror
		die
	fi
}

check_page_size() {
	use kernel_linux || return
# See
# https://github.com/WebKit/WebKit/blob/main/Source/WTF/wtf/PageBlock.h
# https://github.com/WebKit/WebKit/blob/main/Source/cmake/WebKitFeatures.cmake#L76
#
# Anything beyond the programmed ceiling will do a planned forced crash
# according to links above.
#
	local page_size
	local default_page_size=64

	# These are based on the kernel defaults.
	if [[ "${ARCH}" == "loong" ]] ; then
		default_page_size=16
	elif [[ "${ARCH}" == "ppc64" ]] ; then
		if tc-is-cross-compiler ; then
			default_page_size=64
		else
			if ! linux_config_exists ; then
				default_page_size=64
			elif linux_chkconfig_builtin PPC_BOOK3S_64 ; then
				default_page_size=64
			else
				default_page_size=4
			fi
		fi
	elif [[ \
		   "${ARCH}" == "amd64" \
		|| "${ARCH}" == "arm" \
		|| "${ARCH}" == "arm64" \
		|| "${ARCH}" == "ppc" \
		|| "${ARCH}" == "mips" \
		|| "${ARCH}" == "mips64" \
		|| "${ARCH}" == "mips64el" \
		|| "${ARCH}" == "mipsel" \
		|| "${ARCH}" == "riscv" \
		|| "${ARCH}" == "x86" \
	]] ; then
		default_page_size=4
	fi

	if [[ -z "${CUSTOM_PAGE_SIZE}" ]] ; then
		page_size=${default_page_size}
	else
		page_size=${CUSTOM_PAGE_SIZE}
	fi

	if (( ${page_size} == 4 || ${page_size} == 16 || ${page_size} == 64 )) ; then
		:
	else
ewarn
ewarn "You are using a page size not documented in the source code."
ewarn "The chosen page size may result in runtime bugs or startup failure."
ewarn
ewarn "Upstream assumed page sizes:  4, 16, 64"
ewarn "Chosen page size:  ${page_size}"
ewarn
	fi

	if ! tc-is-cross-compiler && [[ "${page_size}" == "kconfig" ]] ; then
		# Use the exact page size
		page_size=$(_get_actual_page_size)
		WK_PAGE_SIZE=${page_size}
		CUSTOM_PAGE_SIZE=${page_size}
		return
	elif ! tc-is-cross-compiler && [[ "${page_size}" == "getconf" ]] ; then
		# Use the exact page size
		page_size=$(($(getconf PAGE_SIZE)/1024))
		WK_PAGE_SIZE=${page_size}
		CUSTOM_PAGE_SIZE=${page_size}
		return
	elif tc-is-cross-compiler && [[ "${page_size}" == "kconfig" ]] ; then
eerror
eerror "CUSTOM_PAGE_SIZE=kconfig cannot be used while cross compiling."
eerror "Use a numerical value instead."
eerror
		die
	elif tc-is-cross-compiler && [[ "${page_size}" == "getconf" ]] ; then
eerror
eerror "CUSTOM_PAGE_SIZE=getconf cannot be used while cross compiling."
eerror "Use a numerical value instead."
eerror
		die
	fi

	if (( ${page_size} == 64 )) ; then
ewarn
ewarn "You using 64 KB pages which may degrade performance severely and"
ewarn "decrease security."
ewarn
ewarn "Steps to remedy:"
ewarn
ewarn "(1) Change the kernel config to use a smaller memory page size if"
ewarn "    suppored by ARCH."
ewarn "(2) Set CUSTOM_PAGE_SIZE to the same value."
ewarn
ewarn "See metadata.xml for details."
ewarn
	fi

	local known=0

	if ! tc-is-cross-compiler ; then
		_check_page_size_known_set
	fi

	if (( ${known} == 1 )) ; then
		:
	else
		if ! tc-is-cross-compiler ; then
			local actual_page_size=$(($(getconf PAGE_SIZE)/1024))
			if [[ -n "${CUSTOM_PAGE_SIZE}" ]] && (( ${actual_page_size} > ${CUSTOM_PAGE_SIZE} )) ; then
ewarn
ewarn "Invalid value for CUSTOM_PAGE_SIZE."
ewarn
ewarn "CUSTOM_PAGE_SIZE value:  ${CUSTOM_PAGE_SIZE}"
ewarn "Expected value:  ${actual_page_size}"
ewarn
ewarn "You are responsible to either fixing CUSTOM_PAGE_SIZE or configuring"
ewarn "the kernel to use the CUSTOM_PAGE_SIZE value."
ewarn
			elif (( ${actual_page_size} > ${page_size} )) ; then
ewarn
ewarn "You must set CUSTOM_PAGE_SIZE to the actual page size.  The default"
ewarn "page size is unfortunately incorrect and is too small."
ewarn
ewarn "Actual page size:  ${actual_page_size}"
ewarn "Default page size:  ${page_size}"
ewarn
ewarn "You are responsible to either fixing CUSTOM_PAGE_SIZE or configuring"
ewarn "the kernel to use the CUSTOM_PAGE_SIZE value."
ewarn
			fi
		else
			if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
ewarn
ewarn "UNKNOWN arch encountered.  Cannot validate CUSTOM_PAGE_SIZE correctness."
ewarn "You are responsible for the correctness of CUSTOM_PAGE_SIZE for CHOST."
ewarn
ewarn "See metadata.xml for details."
ewarn
ewarn "CUSTOM_PAGE_SIZE value:  ${CUSTOM_PAGE_SIZE}"
ewarn
			else
ewarn
ewarn "UNKNOWN arch encountered.  Cannot validate page_size correctness."
ewarn "${page_size} KB is assumed, but you may supply the correct page size"
ewarn "value of CUSTOM_PAGE_SIZE.  If the actual page size is larger, you are"
ewarn "required to set CUSTOM_PAGE_SIZE to the actual value of the CHOST"
ewarn "machine to avoid a crash."
ewarn
ewarn "See metadata.xml for details."
ewarn
			fi
		fi
	fi
	WK_PAGE_SIZE=${page_size}
}

check_security_expire() {
	local safe_period
	local now=$(date +%s)
	local dhms_passed=$(dhms_get ${MITIGATION_LAST_UPDATE} ${now})
	local channel="stable"

	local desc=""
	local mitigation_use_case="${MITIGATION_USE_CASE:-default}"
	if [[ "${mitigation_use_case}" =~ ("donations"|"email"|"legal"|"money"|"shopping") ]] ; then
		safe_period=$((60*60*24*7))
		desc="1 week"
	elif [[ "${mitigation_use_case}" =~ "socials" ]] ; then
		safe_period=$((60*60*24*14))
		desc="2 weeks"
	else
	# Upstream may release several months in between releases
		safe_period=$((60*60*24*60))
		desc="60 days"
	fi

	if (( ${now} > ${MITIGATION_LAST_UPDATE} + ${safe_period} )) ; then
eerror
eerror "This ebuild release period is past ${desc} since release."
eerror "It is considered insecure.  As a precaution, this particular point"
eerror "release will not (re-)install."
eerror
eerror "Time passed since the last security update:  ${dhms_passed}"
eerror
eerror "Solutions:"
eerror
eerror "1.  Use a newer ${channel} release from the overlay."
eerror "2.  Use the latest ${channel} distro release."
eerror
eerror "See metadata.xml for details to adjust MITIGATION_USE_CASE."
eerror
		die
	else
einfo "Time passed since the last security update:  ${dhms_passed}"
	fi
}

check_ulimit() {
	local current_ulimit=$(ulimit -n)
	local ulimit
	if use mold ; then
	# See issue #851 in mold repo.
		ulimit=${ULIMIT:-16384}
	else
	# The default
		ulimit=${ULIMIT:-1024}
	fi

	if (( ${current_ulimit} < ${ulimit} )) ; then
eerror
eerror "The ulimit is too low and must be ${ulimit} or higher."
eerror
eerror "Expected ulimit:  ${ulimit}"
eerror "Actual ulimit:  ${current_ulimit}"
eerror
eerror "To fix, follow exactly these steps."
eerror
eerror "1.  Add/change /etc/security/limits.conf with the following lines:"
eerror "portage         soft    nofile      ${ulimit}"
eerror "portage         hard    nofile      ${ulimit}"
eerror "2.  Run \`ulimit -n ${ulimit}\`"
eerror "3.  Run \`emerge =${CATEGORY}/${PN}-${PVR}\`"
eerror
		die
	fi
}

pkg_setup() {
	if is-flagq '-Oshit' ; then
einfo "Detected -Oshit"
		replace-flags '-O*' '-O1'
		export OSHIT=1
	else
		export OSHIT=0
	fi
	dhms_start
einfo "This is the stable branch."
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security advisory date:  ${MITIGATION_DATE}"
einfo "Latest security advisory:  ${MITIGATION_URI}"
	fi
	vf_show
	_set_cxx
	#check_icu_build
	if [[ ${MERGE_TYPE} != "binary" ]] \
		&& is-flagq "-g*" \
		&& ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi
	python-single-r1_pkg_setup

	check_geolocation
	cflags-depends_check

	if use kernel_linux ; then
		linux-info_pkg_setup
	fi

	if ( use arm || use arm64 ) && ! use gles2 ; then
ewarn "gles2 is the default on upstream."
	fi

	if use openmp ; then
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
		${CC} --version
		tc-check-openmp
	fi

	tc-is-clang && llvm_pkg_setup

	if use v4l ; then
		local gst_plugins_v4l2_repo=\
$(cat "${EROOT}/var/db/pkg/media-plugins/gst-plugins-v4l2-"*"/repository")
einfo "gst-plugins-v4l2 repo:  ${gst_plugins_v4l2_repo}"
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
ewarn "WebRTC support is currently in development and feature incomplete."
	fi

	if ! use mold && is-flagq '-fuse-ld=mold' ; then
eerror "-fuse-ld=mold requires the mold USE flag."
		die
	fi

	if [[ "${ARCH}" == "riscv" ]] ; then
		use ilp32d && die "Disable the unsupported ilp32d ABI"
		use ilp32 && die "Disable the unsupported ilp32 ABI"
	fi

einfo
einfo "To disable the distro hard USE block on gstreamer and decrease the"
einfo "attack surface, do the following:"
einfo
einfo "mkdir -p /etc/portage/profile"
einfo "echo \"net-libs/webkit-gtk -gstreamer\" >> /etc/portage/profile/package.use.force"
einfo

	check_page_size
	check_security_expire
	check_ulimit
}

_check_langs() {
	cd "${S}" || die
	local actual_list_raw=$(find Source/WebCore/platform/gtk/po -name "*.po"  \
		| cut -f 6 -d "/"  \
		| sort  \
		| sed -e "s|.po||g" \
		| tr "\n" " " \
		| fold -w 80 -s)
	local actual_list=(${actual_list_raw})
	if [[ "${actual_list[@]}" != "${LANGS[@]}" ]] ; then
eerror
eerror "QA:  Update the LANGS variable:"
eerror
echo "${actual_list_raw}"
		die
	fi
}

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

	_check_langs
}

src_prepare() {
#	use webrtc && eapply "${FILESDIR}/2.33.2-add-openh264-headers.patch"

	# Precautions
	eapply "${FILESDIR}/extra-patches/webkit-gtk-2.39.1-jsc-disable-fast-math.patch"
	eapply "${FILESDIR}/extra-patches/webkit-gtk-2.39.1-webcore-honor-finite-math-and-nan.patch"
	eapply "${FILESDIR}/extra-patches/webkit-gtk-2.48.0-custom-optimization.patch"

ewarn
ewarn "Try adding -Wl,--no-keep-memory to per-package LDFLAGS if out of memory (OOM)"
ewarn "or adding additional swap space.  The latter is more efficient."
ewarn
	# You still can have swapping + O(n^2) or swapping + O(1).

	eapply "${FILESDIR}/extra-patches/webkit-gtk-2.48.0-linkers.patch"

	eapply "${_PATCHES[@]}"
	cmake_src_prepare
	gnome2_src_prepare
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

_src_configure_compiler() {
	_set_cxx
}

src_configure() {
	 :
}

_src_configure() {
	local total_ram=$(free | grep "Mem:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	local total_ram_gib=$(python -c "print(round(${total_ram} / (1024*1024)))" )
	local total_swap=$(free | grep "Swap:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	[[ -z "${total_swap}" ]] && total_swap=0
	local total_swap_gib=$(( ${total_swap} / (1024*1024) ))
	local total_mem=$(free -t | grep "Total:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	local total_mem_gib=$(python -c "print(round(${total_mem} / (1024*1024)))" )

	local jobs=$(get_makeopts_jobs)
	local cores=$(get_nproc)

	local minimal_gib_per_core=2
	local actual_gib_per_core=$(python -c "print(${total_mem_gib} / ${cores})")
	local ram_gib_per_core=$(python -c "print(${total_ram_gib} / ${cores})")

	if (( ${actual_gib_per_core%.*} >= ${minimal_gib_per_core} )) ; then
einfo "Minimal GiB per core:  >= ${minimal_gib_per_core} GiB"
einfo "Actual GiB per core:  ${actual_gib_per_core} GiB"
	else
ewarn "Minimal GiB per core:  >= ${minimal_gib_per_core} GiB"
ewarn "Actual GiB per core:  ${actual_gib_per_core} GiB"
	fi

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

	filter-flags \
		'-DENABLE_ASSEMBLER=*' \
		'-DENABLE_JIT=*' \
		'-DENABLE_YARR_JIT=*' \
		'-fprofile*'

	# It does not compile on alpha without this in LDFLAGS
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648761
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu and co., bug #???
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	# CE - Code Execution
	# DoS - Denial of Service
	# DT - Data Tamperint
	# ID - Information Disclosure

	cflags-hardened_append

	# Add more swap if linker OOMs computer.

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

	if use system-malloc ; then
ewarn
ewarn "Disabling bmalloc for ABI=${ABI} may lower security.  Consider using an"
ewarn "LD_PRELOAD wrapper script to a hardened allocator library instead when"
ewarn "calling your ${PN} based app."
ewarn
	fi
	if use libpas ; then
		if [[ "${ABI}" =~ ("amd64"|"arm64") ]] ; then
	# The B before ENABLE is not a typo
			append-cppflags -DBENABLE_LIBPAS=1
			append-cppflags -DPAS_BMALLOC=1
		else
			append-cppflags -DBENABLE_LIBPAS=0
		fi
	else
		append-cppflags -DBENABLE_LIBPAS=0
	fi

	# TODO: Check Web Audio support
	# should somehow let user select between them?
	# opengl needs to be explictly handled, bug #576634

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
		-DENABLE_CACHE_PARTITIONING=$(usex cache-partitioning)
		-DENABLE_DOCUMENTATION=$(usex doc)
		-DENABLE_ENCRYPTED_MEDIA=$(usex eme)
		-DENABLE_GAMEPAD=$(usex gamepad)
		-DENABLE_GEOLOCATION=$(multilib_native_usex geolocation) # \
# Runtime optional (talks over dbus service)
		-DENABLE_INTROSPECTION=$(multilib_native_usex introspection)
		-DENABLE_JAVASCRIPTCORE=$(usex javascript)
		-DENABLE_JOURNALD_LOG=$(usex journald)
		-DENABLE_MEDIA_RECORDER=$(usex mediarecorder)
		-DENABLE_MEDIA_STREAM=$(usex mediastream)
		-DENABLE_MINIBROWSER=$(usex minibrowser)
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_RELEASE_LOG=ON
		-DENABLE_SPEECH_SYNTHESIS=$(usex speech-synthesis)
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_THUNDER=$(usex thunder)
		-DENABLE_UNIFIED_BUILDS=$(usex debug "OFF" "ON") # Reduce rebuild cost for debug
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_WEB_RTC=$(usex webrtc)
		-DENABLE_WEBCORE=ON
		-DENABLE_WEBDRIVER=$(usex webdriver)
		-DENABLE_WEBGL=$(usex webgl)
		-DENABLE_X11_TARGET=$(usex X)
		-DPORT=GTK
		-DUSE_ANGLE_WEBGL=OFF
		-DUSE_AVIF=$(usex avif)
		-DUSE_FLITE=$(usex flite)
		-DUSE_GBM=$(usex gbm)
		-DUSE_GSTREAMER_TRANSCODER=$(usex mediarecorder)
		-DUSE_GSTREAMER_WEBRTC=$(usex gstwebrtc)
		-DUSE_GTK4=OFF
		-DUSE_JPEGXL=$(usex jpegxl)
		-DUSE_LIBDRM=$(usex gbm)
		-DUSE_LIBHYPHEN=$(usex libhyphen)
		-DUSE_LCMS=$(usex lcms)
		-DUSE_LIBBACKTRACE=$(usex libbacktrace)
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_SOUP2=ON
		-DUSE_SPIEL=OFF
		-DUSE_SYSTEM_MALLOC=$(usex system-malloc)
		-DUSE_WOFF2=$(usex woff2)
		$(cmake_use_find_package gles2 OpenGLES2)
		$(cmake_use_find_package opengl OpenGL)
	)

	if use debug ; then
		mycmakeargs+=(
			-DCMAKE_BUILD_TYPE="Debug"
		)
	fi

	if ! has_version "dev-util/sysprof-capture:4" ; then
		mycmakeargs+=(
			-DUSE_SYSTEM_SYSPROF_CAPTURE=NO
		)
	fi

	if ( use gles2 || use opengl || use wayland ) ; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_EGL=OFF
		)
	else
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_EGL=ON
		)
	fi

	if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
		append-cppflags -DCUSTOM_PAGE_SIZE=${CUSTOM_PAGE_SIZE}
	fi

	# Anything less than -O2 may break rendering.
	# GCC -O1:  pas_generic_large_free_heap.h:140:1: error: inlining failed in call to 'always_inline'
	# Clang -Os:  slower than expected rendering.
	# Forced >= -O3 to be about same relative performance to other browser engines.
	# -O2 feels like C- grade relative other browser engines.

	if [[ "${OSHIT}" == "1" ]] ; then
		replace-flags "-O*" "-O1"
	# Input validate to prevent artifacts or weakend security.
		if [[ -n "${OSHIT_OPT_LEVEL_ANGLE}" ]] ; then
			if [[ "${OSHIT_OPT_LEVEL_ANGLE}" == "1" || "${OSHIT_OPT_LEVEL_ANGLE}" == "2" || "${OSHIT_OPT_LEVEL_ANGLE}" == "3" || "${OSHIT_OPT_LEVEL_ANGLE}" == "fast" ]] ; then
				export OSHIT_OPT_LEVEL_ANGLE
			elif [[ "${OSHIT_OPT_LEVEL_ANGLE}" == "4" ]] ; then
				export OSHIT_OPT_LEVEL_ANGLE="3"
			else
				export OSHIT_OPT_LEVEL_ANGLE="1"
			fi
		else
			export OSHIT_OPT_LEVEL_ANGLE="1"
		fi

		if [[ -n "${OSHIT_OPT_LEVEL_JSC}" ]] ; then
			if [[ "${OSHIT_OPT_LEVEL_JSC}" == "2" || "${OSHIT_OPT_LEVEL_JSC}" == "3" ]] ; then
				export OSHIT_OPT_LEVEL_JSC
			elif [[ "${OSHIT_OPT_LEVEL_JSC}" == "fast" || "${OSHIT_OPT_LEVEL_JSC}" == "4" ]] ; then
				export OSHIT_OPT_LEVEL_JSC="3"
			else
				export OSHIT_OPT_LEVEL_JSC="2"
			fi
		else
			export OSHIT_OPT_LEVEL_JSC="2" # ~90% to ~95% optimized
		fi

		if [[ -n "${OSHIT_OPT_LEVEL_SHA1}" ]] ; then
			if [[ "${OSHIT_OPT_LEVEL_SHA1}" == "1" || "${OSHIT_OPT_LEVEL_SHA1}" == "2" || "${OSHIT_OPT_LEVEL_SHA1}" == "3" || "${OSHIT_OPT_LEVEL_SHA1}" == "fast" ]] ; then
				export OSHIT_OPT_LEVEL_SHA1
			elif [[ "${OSHIT_OPT_LEVEL_SHA1}" == "4" ]] ; then
				export OSHIT_OPT_LEVEL_SHA1="3"
			else
				export OSHIT_OPT_LEVEL_SHA1="1"
			fi
		else
			export OSHIT_OPT_LEVEL_SHA1="1"
		fi

		if [[ -n "${OSHIT_OPT_LEVEL_SKIA}" ]] ; then
			if [[ "${OSHIT_OPT_LEVEL_SKIA}" == "1" || "${OSHIT_OPT_LEVEL_SKIA}" == "2" || "${OSHIT_OPT_LEVEL_SKIA}" == "3" || "${OSHIT_OPT_LEVEL_SKIA}" == "fast" ]] ; then
				export OSHIT_OPT_LEVEL_SKIA
			elif [[ "${OSHIT_OPT_LEVEL_SKIA}" == "4" ]] ; then
				export OSHIT_OPT_LEVEL_SKIA="3"
			else
				export OSHIT_OPT_LEVEL_SKIA="1"
			fi
		else
			export OSHIT_OPT_LEVEL_SKIA="1"
		fi

		if [[ -n "${OSHIT_OPT_LEVEL_WEBCORE}" ]] ; then
			if [[ "${OSHIT_OPT_LEVEL_WEBCORE}" == "1" || "${OSHIT_OPT_LEVEL_WEBCORE}" == "2" || "${OSHIT_OPT_LEVEL_WEBCORE}" == "3" ]] ; then
				export OSHIT_OPT_LEVEL_WEBCORE
			elif [[ "${OSHIT_OPT_LEVEL_WEBCORE}" == "fast" || "${OSHIT_OPT_LEVEL_WEBCORE}" == "4" ]] ; then
				export OSHIT_OPT_LEVEL_WEBCORE="3"
			else
				export OSHIT_OPT_LEVEL_WEBCORE="1"
			fi
		else
			export OSHIT_OPT_LEVEL_WEBCORE="1"
		fi

		if [[ -n "${OSHIT_OPT_LEVEL_XXHASH}" ]] ; then
			if [[ "${OSHIT_OPT_LEVEL_XXHASH}" == "1" || "${OSHIT_OPT_LEVEL_XXHASH}" == "2" || "${OSHIT_OPT_LEVEL_XXHASH}" == "3" || "${OSHIT_OPT_LEVEL_XXHASH}" == "fast" ]] ; then
				export OSHIT_OPT_LEVEL_XXHASH
			elif [[ "${OSHIT_OPT_LEVEL_XXHASH}" == "4" ]] ; then
				export OSHIT_OPT_LEVEL_XXHASH="3"
			else
				export OSHIT_OPT_LEVEL_XXHASH="1"
			fi
		else
			export OSHIT_OPT_LEVEL_XXHASH="1"
		fi

einfo "OSHIT_OPT_LEVEL_ANGLE: ${OSHIT_OPT_LEVEL_ANGLE}"
einfo "OSHIT_OPT_LEVEL_JSC: ${OSHIT_OPT_LEVEL_JSC}"
einfo "OSHIT_OPT_LEVEL_SHA1: ${OSHIT_OPT_LEVEL_SHA1}"
einfo "OSHIT_OPT_LEVEL_SKIA: ${OSHIT_OPT_LEVEL_SKIA}"
einfo "OSHIT_OPT_LEVEL_WEBCORE: ${OSHIT_OPT_LEVEL_WEBCORE}"
einfo "OSHIT_OPT_LEVEL_XXHASH: ${OSHIT_OPT_LEVEL_XXHASH}"
	else
		local olast=$(get_olast)
		if [[ "${olast}" == "-O3" || "${olast}" == "-O4" || "${olast}" == "-Ofast" ]] ; then
			replace-flags "-O*" "-O3"
			OSHIT_OPT_LEVEL_ANGLE=3
			OSHIT_OPT_LEVEL_JSC=3
			OSHIT_OPT_LEVEL_SHA1=3
			OSHIT_OPT_LEVEL_SKIA=3
			OSHIT_OPT_LEVEL_WEBCORE=3
			OSHIT_OPT_LEVEL_XXHASH=3
		elif [[ "${olast}" == "-O2" ]] ; then
			replace-flags "-O*" "-O2"
			OSHIT_OPT_LEVEL_ANGLE=2
			OSHIT_OPT_LEVEL_JSC=2
			OSHIT_OPT_LEVEL_SHA1=2
			OSHIT_OPT_LEVEL_SKIA=2
			OSHIT_OPT_LEVEL_WEBCORE=2
			OSHIT_OPT_LEVEL_XXHASH=2
		else
			replace-flags "-O*" "-O1"
			OSHIT_OPT_LEVEL_ANGLE=1
			OSHIT_OPT_LEVEL_JSC=1
			OSHIT_OPT_LEVEL_SHA1=1
			OSHIT_OPT_LEVEL_SKIA=1
			OSHIT_OPT_LEVEL_WEBCORE=1
			OSHIT_OPT_LEVEL_XXHASH=1
		fi
	fi

	# See Source/cmake/WebKitFeatures.cmake
	local pointer_size=$(tc-get-ptr-size)

einfo "WK_PAGE_SIZE:  ${WK_PAGE_SIZE}"

	_jit_level_0() {
		# ~ 2% performance, similar to hard swap
		mycmakeargs+=(
			-DENABLE_JIT=OFF
			-DENABLE_DFG_JIT=OFF
			-DENABLE_FTL_JIT=OFF
			-DENABLE_WEBASSEMBLY=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=OFF
			-DENABLE_WEBASSEMBLY_BBQJIT=OFF
			-DENABLE_WEBASSEMBLY_OMGJIT=OFF
		)
		if [[ "${ABI}" == "arm64" ]] && (( ${WK_PAGE_SIZE} == 64 )) ; then
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
	}

	_jit_level_1() {
		# ~ 23% performance, similar to light swap and a feeling of progress
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=OFF
			-DENABLE_FTL_JIT=OFF
			-DENABLE_WEBASSEMBLY_OMGJIT=OFF
		)
		if [[ "${ARCH}" =~ "amd64" || "${ARCH}" =~ "arm64" || "${ARCH}" =~ "riscv" ]] ; then
			mycmakeargs+=(
				-DENABLE_WEBASSEMBLY=OFF
				-DENABLE_WEBASSEMBLY_B3JIT=OFF
				-DENABLE_WEBASSEMBLY_BBQJIT=OFF
			)
		else
			mycmakeargs+=(
				-DENABLE_WEBASSEMBLY=OFF
				-DENABLE_WEBASSEMBLY_B3JIT=OFF
				-DENABLE_WEBASSEMBLY_BBQJIT=OFF
			)
		fi

		if [[ "${ABI}" == "amd64" || "${ABI}" == "amd64" ]] && ( [[ "${ABI}" == "arm" ]] && use cpu_flags_arm_thumb2 ) ; then
			mycmakeargs+=(
				-DENABLE_SAMPLING_PROFILER=$(usex jit)
			)
		else
			mycmakeargs+=(
				-DENABLE_SAMPLING_PROFILER=OFF
			)
		fi
	}

	_jit_level_4() {
		# ~ 72% performance
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex jit)
			-DENABLE_FTL_JIT=OFF
			-DENABLE_WEBASSEMBLY=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=OFF
			-DENABLE_WEBASSEMBLY_BBQJIT=OFF
			-DENABLE_WEBASSEMBLY_OMGJIT=OFF
		)

		if [[ "${ABI}" == "amd64" || "${ABI}" == "amd64" ]] && ( [[ "${ABI}" == "arm" ]] && use cpu_flags_arm_thumb2 ) ; then
			mycmakeargs+=(
				-DENABLE_SAMPLING_PROFILER=$(usex jit)
			)
		else
			mycmakeargs+=(
				-DENABLE_SAMPLING_PROFILER=OFF
			)
		fi
	}

	_jit_level_5() {
		# ~ 100% performance
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex jit)
			-DENABLE_FTL_JIT=$(usex jit)
			-DENABLE_WEBASSEMBLY=$(usex webassembly "ON" "OFF")
		)

		if [[ "${ABI}" == "arm" ]] ; then
			mycmakeargs+=(
				-DENABLE_WEBASSEMBLY_B3JIT=$(usex webassembly)
				-DENABLE_WEBASSEMBLY_BBQJIT=$(usex webassembly)
				-DENABLE_WEBASSEMBLY_OMGJIT=OFF
			)
		elif [[ "${ABI}" == "riscv" ]] ; then
			mycmakeargs+=(
				-DENABLE_WEBASSEMBLY_B3JIT=OFF
				-DENABLE_WEBASSEMBLY_BBQJIT=OFF
				-DENABLE_WEBASSEMBLY_OMGJIT=OFF
			)
		else
			mycmakeargs+=(
				-DENABLE_WEBASSEMBLY_B3JIT=$(usex webassembly)
				-DENABLE_WEBASSEMBLY_BBQJIT=$(usex webassembly) # -O0 build speed
				-DENABLE_WEBASSEMBLY_OMGJIT=$(usex webassembly) # -O2 runtime speed + PGO
			)
		fi

		if [[ "${ABI}" == "amd64" || "${ABI}" == "amd64" ]] && ( [[ "${ABI}" == "arm" ]] && use cpu_flags_arm_thumb2 ) ; then
			mycmakeargs+=(
				-DENABLE_SAMPLING_PROFILER=$(usex jit)
			)
		else
			mycmakeargs+=(
				-DENABLE_SAMPLING_PROFILER=OFF
			)
		fi
	}

	local olast=$(get_olast)
	if [[ "${OSHIT}" == "1" ]] ; then
		if [[ "${OSHIT_OPT_LEVEL_JSC}" == "3" ]] ; then
			jit_level=6
		else
			jit_level=5
		fi
	elif [[ "${olast}" =~ "-Ofast" ]] ; then
		jit_level=7
	elif [[ "${olast}" =~ "-O3" ]] ; then
		jit_level=6
	elif [[ "${olast}" =~ "-O2" ]] ; then
		jit_level=5
	elif [[ "${olast}" =~ "-Os" ]] ; then
		jit_level=4
	elif [[ "${olast}" =~ "-Oz" ]] ; then
		jit_level=3
	elif [[ "${olast}" =~ "-O1" ]] ; then
		jit_level=2
	elif [[ "${olast}" =~ "-O0" ]] && use jit ; then
		jit_level=1
	elif [[ "${olast}" =~ "-O0" ]] ; then
		jit_level=0
	fi

	if use webassembly && (( ${jit_level} < 5 )) ; then
einfo "Changing jit_level=${jit_level} to jit_level=5 for WebAssembly."
		jit_level=5
	fi

	if [[ -n "${JIT_LEVEL_OVERRIDE}" ]] ; then
		jit_level=${JIT_LEVEL_OVERRIDE}
	fi

	use jit || jit_level=0

	local max_jit_level=6
	if (( ${WK_PAGE_SIZE} == 64 )) ; then
		max_jit_level=0
	elif \
		[[ \
			   "${ABI}" == "amd64" \
			|| "${ABI}" == "arm64" \
			|| ( "${ARCH}" == "riscv" && "${pointer_size}" == "8" ) \
		]] \
	; then
		max_jit_level=7
	elif \
		( [[ "${ABI}" == "arm" ]] && use cpu_flags_arm_thumb2 ) \
			|| \
		[[ "${ARCH}" =~ "mips" && "${ABI}" =~ ("n32"|"o32") ]] \
	; then
		max_jit_level=4
	else
		max_jit_level=0
	fi

	if (( ${jit_level} > ${max_jit_level} )) ; then
		jit_level=${max_jit_level}
	fi

	local jit_level_desc
	if (( ${jit_level} == 7 )) ; then
		jit_level_desc="fast" # 100%
	elif (( ${jit_level} == 6 )) ; then
		jit_level_desc="3" # 100%
	elif (( ${jit_level} == 5 )) ; then
		jit_level_desc="2" # 95%
	elif (( ${jit_level} == 4 )) ; then
		jit_level_desc="s" # 75%
	elif (( ${jit_level} == 3 )) ; then
		jit_level_desc="z"
	elif (( ${jit_level} == 2 )) ; then
		jit_level_desc="1" # 60 %
	elif (( ${jit_level} == 1 )) ; then
		jit_level_desc="0"
	elif (( ${jit_level} == 0 )) ; then
		jit_level_desc="0" # 5%
	fi

	if (( ${jit_level} >= 5 )) ; then
einfo "JIT is similar to -O${jit_level_desc} + PDO/PGO."
		_jit_level_5
	elif (( ${jit_level} >= 2 )) ; then
einfo "JIT is similar to -O${jit_level_desc}."
		_jit_level_4
	elif (( ${jit_level} >= 1 )) ; then
einfo "JIT is similar to -O${jit_level_desc} best case."
		_jit_level_1
	else
einfo "JIT off is similar to -O${jit_level_desc} worst case."
		_jit_level_0
	fi

	if (( ${pointer_size} != 8 )) ; then
ewarn "WebAssembly is not supported for ABI=${ABI}"
	elif [[ "${mycmakeargs[@]}" =~ "-DENABLE_WEBASSEMBLY=ON" ]] ; then
einfo "WebAssembly is on"
	else
einfo "WebAssembly is off"
ewarn
ewarn "If you want to use WebAssembly, the following steps are required:"
ewarn
ewarn "(1) Enable the jit USE flag."
ewarn "(2) Change the kernel config to use memory page sizes less than 64 KB."
ewarn "(3) Set CUSTOM_PAGE_SIZE environment variable less than 64 KB."
ewarn "(4) Set to at least -O2 or JIT_LEVEL_OVERRIDE=5 or higher."
ewarn "(5) Use a supported architecture and ABI (amd64, arm64, riscv)."
ewarn
	fi

	if (( ${jit_level} >= 1 )) ; then
		append-cppflags \
			-DENABLE_ASSEMBLER=1
	else
		append-cppflags \
			-DENABLE_ASSEMBLER=0
	fi

	if (( ${jit_level} >= 1 )) ; then
einfo "Enabled YARR JIT (aka RegEx JIT)" # default
	else
einfo "Disabled YARR JIT (aka RegEx JIT)"
		append-cppflags \
			-DENABLE_YARR_JIT=0
	fi

einfo "CPPFLAGS:  ${CPPFLAGS}"

	if use eme ; then
		sed -i -e "s|ENABLE_ENCRYPTED_MEDIA PRIVATE|ENABLE_ENCRYPTED_MEDIA PUBLIC|g" \
			"${S}/Source/cmake/OptionsGTK.cmake" || die
	fi

	mycmakeargs+=(
		-DUSE_LD_BFD=OFF
		-DUSE_LD_GOLD=OFF
		-DUSE_LD_MOLD=OFF
		-DUSE_LD_LLD=OFF
	)

einfo "Add -flto to CFLAGS/CXXFLAGS and -fuse-ld=<bfd|gold|lld|mold> to LDFLAGS for LTO optimization."
	local linker_type=$(check-linker_get_lto_type)
	if [[ \
		    "${linker_type}" =~ ("bfdlto"|"goldlto"|"moldlto"|"thinlto") \
		|| "${SELECTED_LTO}" =~ ("bfdlto"|"goldlto"|"moldlto"|"thinlto") \
	   ]] \
		&& tc-is-clang ; then
		local clang_major_pv=$(clang-major-version)
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="${CHOST}-clang-${clang_major_pv}"
			-DCMAKE_CXX_COMPILER="${CHOST}-clang++-${clang_major_pv}"
		)
		[[ -z "${SELECTED_LTO}" ]] && SELECTED_LTO="${linker_type}"
		if [[ "${SELECTED_LTO}" == "bfdlto" ]] ; then
			mycmakeargs+=(
				-DLTO_MODE=full
				-DUSE_LD_BFD=ON
			)
		elif [[ "${SELECTED_LTO}" == "goldlto" ]] ; then
			mycmakeargs+=(
				-DLTO_MODE=full
				-DUSE_LD_GOLD=ON
			)
		elif [[ "${SELECTED_LTO}" == "moldlto" ]] ; then
			mycmakeargs+=(
				-DLTO_MODE=full
				-DUSE_LD_MOLD=ON
			)
		elif [[ "${SELECTED_LTO}" == "thinlto" ]] ; then
			mycmakeargs+=(
				-DLTO_MODE=thin
				-DUSE_LD_LLD=ON
			)
		fi
	else
		if use mold ; then
			mycmakeargs+=(
				-DUSE_LD_MOLD=ON
			)
		#else
		#	Use default linker
		fi
	fi
	filter-flags \
		'-flto*' \
		'-fuse-ld=*'

	if use mediastream ; then
		sed -i -e "s|ENABLE_MEDIA_STREAM PRIVATE|ENABLE_MEDIA_STREAM PUBLIC|g" \
			"${S}/Source/cmake/OptionsGTK.cmake" || die
	fi

	if use openmp && tc-is-clang ; then
		local llvm_slot=$(clang-major-version)
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}/usr/lib/llvm/${llvm_slot}/include -fopenmp=openmp"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="${ESYSROOT}/usr/lib/llvm/${llvm_slot}/$(get_libdir)/libomp.so.${LLVM_MAX_SLOT}"
		)
	fi

	if use openmp && tc-is-gcc ; then
		local gcc_slot=$(gcc-major-version)
		local gomp_abspath
		# Known list
		if [[ "${ABI}" =~ (amd64) && -e "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libgomp.so" ]] ; then
			gomp_abspath="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libgomp.so"
		elif [[ "${ABI}" =~ (x86) && -e "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/32/libgomp.so" ]] ; then
			gomp_abspath="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/32/libgomp.so"

		# RISC V
		elif [[ -e "${GOMP_LIB64_LP64D_ABSPATH}" ]] && [[ "${ABI}" =~ (lp64d) ]] ; then
			gomp_abspath="${GOMP_LIB64_LP64D_ABSPATH}"
		elif [[ -e "${GOMP_LIB64_LP64_ABSPATH}" ]] && [[ "${ABI}" =~ (lp64) ]] ; then
			gomp_abspath="${GOMP_LIB64_LP64_ABSPATH}"
		elif [[ -e "${GOMP_LIB32_ILP32D_ABSPATH}" ]] && [[ "${ABI}" =~ (ilp32d) ]] ; then
			gomp_abspath="${GOMP_LIB64_ILP32D_ABSPATH}"
		elif [[ -e "${GOMP_LIB32_ILP32_ABSPATH}" ]] && [[ "${ABI}" =~ (ilp32) ]] ; then
			gomp_abspath="${GOMP_LIB64_ILP32_ABSPATH}"
		elif [[ -e "${GOMP_LIBX32_ABSPATH}" ]] && [[ "${ABI}" =~ (x32) ]] ; then
			gomp_abspath="${GOMP_LIBX32_ABSPATH}"

		# MIPS
		elif [[ -e "${GOMP_LIBN64_ABSPATH}" ]] && [[ "${ABI}" =~ (n64) ]] ; then
			gomp_abspath="${GOMP_LIBN64_ABSPATH}"
		elif [[ -e "${GOMP_LIBN32_ABSPATH}" ]] && [[ "${ABI}" =~ (n32) ]] ; then
			gomp_abspath="${GOMP_LIBN32_ABSPATH}"
		elif [[ -e "${GOMP_LIBO32_ABSPATH}" ]] && [[ "${ABI}" =~ (o32) ]] ; then
			gomp_abspath="${GOMP_LIBO32_ABSPATH}"

		# 64-bit
		elif [[ -e "${GOMP_LIB64_ABSPATH}" ]] && [[ "${ABI}" =~ (amd64|lp64d|ppc64|sparc64) ]] ; then
			gomp_abspath="${GOMP_LIB64_ABSPATH}"
		# 32-bit
		elif [[ -e "${GOMP_LIB32_ABSPATH}" ]] && [[ "${ABI}" =~ (arm|ppc|sparc32|x86) ]] ; then
			gomp_abspath="${GOMP_LIB32_ABSPATH}"
		else
# TODO:  prune
eerror
eerror "${ABI} is unknown.  Please set one or more of the following per-package"
eerror "environment variables:"
eerror
eerror "  GOMP_LIB32_ABSPATH"
eerror "  GOMP_LIB32_ILP32_ABSPATH"
eerror "  GOMP_LIB32_ILP32D_ABSPATH"
eerror "  GOMP_LIB64_ABSPATH"
eerror "  GOMP_LIB64_LP64_ABSPATH"
eerror "  GOMP_LIB64_LP64D_ABSPATH"
eerror "  GOMP_LIBN32_LP64D_ABSPATH"
eerror "  GOMP_LIBN64_LP64D_ABSPATH"
eerror "  GOMP_LIBO32_LP64D_ABSPATH"
eerror "  GOMP_LIBX32_ABSPATH"
eerror
eerror "to point to the absolute path to libgomp.so for GCC slot ${gcc_slot}"
eerror "corresponding to that ABI."
eerror
			die
		fi
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/include -fopenmp"
			-DOpenMP_CXX_LIB_NAMES="libgomp"
			-DOpenMP_libgomp_LIBRARY="${gomp_abspath}"
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

	# Anything less than -O2 may break rendering.
	# GCC -O1:  pas_generic_large_free_heap.h:140:1: error: inlining failed in call to 'always_inline'
	# Clang -Os:  slower than expected rendering.
	# Forced >= -O3 to be about same relative performance to other browser engines.
	# -O2 feels like C- grade relative other browser engines.


	filter-flags '-ffast-math'

	if is-flagq "-Ofast" ; then
		# Precaution
		append_all $(test-flags -fno-allow-store-data-races)
	fi

	if [[ "${FEATURES}" =~ "ccache" ]] ; then
		export WK_USE_CCACHE=ON
	else
		export WK_USE_CCACHE=OFF
	fi

	cmake_src_configure
}

_src_compile() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	cd "${BUILD_DIR}" || die
	cmake_src_compile
}

src_compile() {
	compile_abi() {
		export CC=$(tc-getCC ${CTARGET:-${CHOST}})
		export CXX=$(tc-getCXX ${CTARGET:-${CHOST}})
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
		_src_configure_compiler
		_src_configure
		_src_compile
	}
	multilib_foreach_abi compile_abi
}

_src_test() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	cd "${BUILD_DIR}"
	# Prevent test failures on PaX systems
	# Programs/unittests/.libs/test*
	pax-mark m $(list-paxables Programs/*[Tt]ests/*)
	cmake_src_test
}

src_test() {
	test_abi() {
		_src_test
	}
	multilib_foreach_abi test_abi
}

_src_install() {
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
			"/usr/$(get_libdir)/misc/webkit2gtk-${API_VERSION}/MiniBrowser" \
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
}

_src_install_all() {
	local hls_env

	if use hls ; then
		hls_env="WEBKIT_GST_ENABLE_HLS_SUPPORT=1"
	fi

	dodir /etc/env.d
newenvd - 50${PN}${API_VERSION} <<-EOF
${hls_env}
EOF

        einstalldocs

	LCNR_SOURCE="${S}"
	lcnr_install_files
}

src_install() {
	install_abi() {
		_src_install
		multilib_prepare_wrappers
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_install_wrappers
	_src_install_all
}

pkg_postinst() {
	dhms_end

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

	if ! use alsa && use pulseaudio \
		&& has_version "media-sound/pulseaudio-daemon[-alsa]" ; then
ewarn "You may need media-sound/pulseaudio-daemon[alsa] to hear sound."
	fi

# See https://bugs.webkit.org/show_bug.cgi?id=174458
	if use hls ; then
ewarn
ewarn "HLS support may break on some sites.  Do either:"
ewarn
ewarn "  \`unset WEBKIT_GST_ENABLE_HLS_SUPPORT\`"
ewarn
ewarn "or"
ewarn
ewarn "  \`export WEBKIT_GST_ENABLE_HLS_SUPPORT=0\`"
ewarn
ewarn "with a wrapper script or before invocation to use fallback protocol(s)"
ewarn "requested by the site."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  license-transparency, webvtt, avif
# OILEDMACHINE-OVERLAY-META-WIP:  pgo, webrtc

# OILEDMACHINE-OVERLAY-TEST: passed with -Oshit, clang 18.1.8 (2.46.3, 20241116):
# OILEDMACHINE-OVERLAY-TEST: passed with -Oshit, clang 18.1.8 (2.48.1, 20250422) for slot 4.1/0:
#
#   CFLAGS=-Oshit build config:
#
#     OSHIT_OPT_LEVEL_ANGLE="fast"
#     OSHIT_OPT_LEVEL_JSC="3"
#     OSHIT_OPT_LEVEL_SHA1="fast"
#     OSHIT_OPT_LEVEL_SKIA="fast"
#     OSHIT_OPT_LEVEL_XXHASH="fast"
#     OSHIT_OPT_LEVEL_WEBCORE="1"
#
#   interactive test:
#
#     minibrowser:  passed
#     surf:  passed
#     search engine(s):  passed
#     video site(s):  fail (minibrowser), passed (surf)
#       vpx (streaming):  passed
#       vpx (on demand):  passed
#       opus:  passed
#       misc notes:  bad render on chat
#     wiki(s):  passed
#     audio:  fail
#       streaming radio:  segfault
#     scroll: fast, random slowdown
#     stability:  unstable
#
