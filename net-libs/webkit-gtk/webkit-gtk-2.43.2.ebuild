# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# -r revision notes
# -rabcde
# ab = WEBKITGTK_API_VERSION version (4.0)
# c = reserved
# de = ebuild revision

# See also, https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/WebKit/Configurations/Version.xcconfig
# To make sure that libwebrtc is the same revision

LLVM_MAX_SLOT=16 # This should not be more than Mesa's package LLVM_MAX_SLOT
LLVM_SLOTS=( 16 15 14 13 )

CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{8..11} )
USE_RUBY="ruby26 ruby27 ruby30 ruby31 "
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0
inherit check-linker check-reqs cmake desktop flag-o-matic git-r3 gnome2 lcnr
inherit linux-info llvm multilib-minimal pax-utils python-any-r1 ruby-single
inherit toolchain-funcs uopts
inherit cflags-depends

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
#KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~sparc ~riscv ~x86"

API_VERSION="4.0"
UOPTS_IMPLS="_${API_VERSION}"
SLOT_MAJOR=$(ver_cut 1 ${API_VERSION})
# See Source/cmake/OptionsGTK.cmake
# CALCULATE_LIBRARY_VERSIONS_FROM_LIBTOOL_TRIPLE(WEBKIT C R A),
# SOVERSION = C - A
# WEBKITGTK_API_VERSION is 4.0
CURRENT="105"
#REVISION=""
AGE="68"
SOVERSION=$((${CURRENT} - ${AGE}))
SLOT="${API_VERSION%.*}/${SOVERSION}"
# SLOT=6/4    GTK4 SOUP3
# SLOT=4.1/0  GTK3 SOUP3
# SLOT=4/37   GTK3 SOUP2

LANGS=(
ar as bg ca cs da de el en_CA en_GB eo es et eu fi fr gl gu he hi hr hu id it
ja ka kn ko lt lv ml mr nb nl or pa pl pt pt_BR ro ru sl sr sr@latin sv ta te
tr uk vi zh_CN
)

# aqua (quartz) is enabled upstream but disabled
# systemd is enabled upstream but gentoo uses openrc by default
# wayland is enabled upstream but disabled because it is not defacto default
#   standard for desktop yet

# For codecs, see
# https://github.com/WebKit/WebKit/blob/main/Source/WebCore/platform/graphics/gstreamer/eme/WebKitThunderDecryptorGStreamer.cpp#L49
# https://github.com/WebKit/WebKit/blob/main/Source/WebCore/platform/graphics/gstreamer/GStreamerRegistryScanner.cpp#L280
# https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/WebCore/platform/mediastream/gstreamer/RealtimeOutgoingAudioSourceGStreamer.cpp#L52

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
# Compare https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Tools/glib/dependencies
DEFAULT_GST_PLUGINS="
+a52
-aac
+alsa
-aom
+dav1d
+flac
+g722
-hls
-libde265
+mp3
+ogg
+pulseaudio
+opus
+speex
+theora
-v4l
-vaapi
-vaapi-stateless-decoding
+vorbis
+vpx
-x264
"
# alsa is disabled on D11, enabled on A/L, enabled in F/L
# D11, A/L, F/L are currently not distributing stateless vaapi decoding.
# Using dav1d because aom is slow for decoding.
# libbacktrace is enabled upstream but disabled for security reasons.

IUSE+="
${LANGS[@]/#/l10n_}
${GST_ACODECS_IUSE}
${GST_CONTAINERS_IUSE}
${GST_VCODECS_IUSE}
${MSE_ACODECS_IUSE}
${MSE_VCODECS_IUSE}
${DEFAULT_GST_PLUGINS}

aqua +avif +bmalloc -cache-partitioning cpu_flags_arm_thumb2
dash +dfg-jit +doc -eme +ftl-jit -gamepad +gbm +geolocation gles2 gnome-keyring
+gstreamer gstwebrtc hardened +introspection +javascriptcore +jit +journald
+jpeg2k +jpegxl +lcms -libbacktrace +libhyphen -libwebrtc -mediarecorder
-mediastream +minibrowser mold +opengl openmp proprietary-codecs
proprietary-codecs-disable proprietary-codecs-disable-nc-developer
proprietary-codecs-disable-nc-user -seccomp speech-synthesis -spell test thunder
+unified-builds +variation-fonts wayland +webassembly +webassembly-b3-jit
+webassembly-bbq-jit +webassembly-omg-jit +webcore +webcrypto -webdriver +webgl
webm-eme -webrtc webvtt -webxr +woff2 +X +yarr-jit
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

NON_FREE_REQUIRED_USE="
	^^ (
		proprietary-codecs
		proprietary-codecs-disable
		proprietary-codecs-disable-nc-developer
		proprietary-codecs-disable-nc-user
	)
	aac? (
		|| (
			proprietary-codecs
			proprietary-codecs-disable-nc-user
		)
	)
	dash? (
		proprietary-codecs
	)
	hls? (
		proprietary-codecs
	)
	libde265? (
		proprietary-codecs
	)
	mold? (
		proprietary-codecs-disable
	)
	openh264? (
		proprietary-codecs
	)
	proprietary-codecs-disable? (
		!aac
		!dash
		!eme
		!hls
		!libde265
		!libwebrtc
		!openh264
		!thunder
		!vaapi
		!vaapi-stateless-decoding
		!webm-eme
		!x264
	)
	proprietary-codecs-disable-nc-developer? (
		!aac
		!dash
		!eme
		!hls
		!libde265
		!libwebrtc
		!openh264
		!thunder
		!vaapi
		!vaapi-stateless-decoding
		!webm-eme
		!x264
	)
	proprietary-codecs-disable-nc-user? (
		!dash
		!eme
		!hls
		!libde265
		!libwebrtc
		!openh264
		!thunder
		!vaapi
		!vaapi-stateless-decoding
		!webm-eme
		!x264
	)
	v4l? (
		proprietary-codecs
	)
	vaapi? (
		proprietary-codecs
	)
	vaapi-stateless-decoding? (
		proprietary-codecs
	)
	x264? (
		proprietary-codecs
	)
"

REQUIRED_USE+="
	${NON_FREE_REQUIRED_USE}
	alsa? (
		!pulseaudio
		gstreamer
	)
	cpu_flags_arm_thumb2? (
		!ftl-jit
	)
	dash? (
		gstreamer
	)
	dfg-jit? (
		jit
		yarr-jit
	)
	ftl-jit? (
		jit
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
		bmalloc
		|| (
			gles2
			opengl
		)
	)
	gstwebrtc? (
		gstreamer
		webrtc
	)
	hardened? (
		!jit
	)
	hls? (
		gstreamer
	)
	jit? (
		dfg-jit
	)
	opengl? (
		!gles2
	)
	pulseaudio? (
		!alsa
		gstreamer
	)
	thunder? (
		eme
	)
	v4l? (
		gstreamer
		mediastream
	)
	webassembly-b3-jit? (
		ftl-jit
		webassembly
	)
	webassembly-bbq-jit? (
		webassembly
		webassembly-b3-jit
	)
	webassembly-omg-jit? (
		webassembly
		webassembly-b3-jit
	)
	webgl? (
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
		webcrypto
	)
	webvtt? (
		gstreamer
	)
	webxr? (
		webgl
	)
	yarr-jit? (
		jit
	)
	|| (
		aqua
		wayland
		X
	)
"

# libwebrtc requires git clone or the fix the tarball to contain the libwebrtc folder.

# Introspection for 32 webkit on 64 bit cannot be used because it requires 32 bit
# libs/build for python from gobject-introspection.  It produces this error:
#
# pyport.h:686:2: error: #error "LONG_BIT definition appears wrong for platform
#   (bad gcc/glibc config?)."
#
# This means also you cannot use the geolocation feature.

# For dependencies, see:
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/CMakeLists.txt
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/cmake/BubblewrapSandboxChecks.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/cmake/FindGStreamer.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/cmake/GStreamerChecks.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/cmake/OptionsGTK.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/cmake/WebKitCommon.cmake
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Tools/buildstream/elements/sdk-platform.bst
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Tools/buildstream/elements/sdk/gst-plugin-dav1d.bst
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Tools/gtk/install-dependencies
#   https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Tools/gtk/dependencies
#   https://github.com/WebKit/WebKit/tree/webkitgtk-2.43.1/Tools/glib/dependencies
#   https://trac.webkit.org/wiki/WebKitGTK/DependenciesPolicy
#   https://trac.webkit.org/wiki/WebKitGTK/GCCRequirement

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
CAIRO_PV="1.16.0"
CLANG_PV="13"
CXX_STD="20"
GCC_PV="10.2.0"
GLIB_PV="2.56.4"
GSTREAMER_PV="1.20.0" # Upstream min is 1.16.2, but distro only offers 1.20
FONTCONFIG_PV="2.13.0"
FREETYPE_PV="2.9.0"
HARFBUZZ_PV="1.4.2"
MESA_PV="18.0.0_rc5"
# xdg-dbus-proxy is using U 20.04 version
OCDM_WV="virtual/libc" # Placeholder
# Dependencies last updated from
# https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1
# Do not use trunk!
# media-libs/gst-plugins-bad should check libkate as a *DEPENDS but does not

RDEPEND_PROPRIETARY_CODECS_DISABLE="
	!media-plugins/gst-plugins-dash
	!media-plugins/gst-plugins-hls
	!media-plugins/gst-plugins-libde265
	!media-plugins/gst-plugins-openh264
	!media-plugins/gst-plugins-vaapi
	!media-plugins/gst-plugins-x264
	!media-plugins/gst-plugins-x265
	g722? (
		!<media-video/ffmpeg-5[openssl]
		|| (
			(
				!<dev-libs/openssl-3
				>=media-video/ffmpeg-5[${MULTILIB_USEDEP},-amr,-cuda,-fdk,-kvazaar,-openh264,openssl,-vaapi,-x264,-x265,-xvid]
			)
			(
				>=media-video/ffmpeg-5[${MULTILIB_USEDEP},-amr,-cuda,-fdk,-kvazaar,-openh264,-openssl,-vaapi,-x264,-x265,-xvid]
			)
		)
	)
	gles2? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},-proprietary-codecs]
	)
	gstreamer? (
		>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},-vaapi]
	)
	opengl? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},-proprietary-codecs]
	)
	wayland? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},-proprietary-codecs]
	)
	webgl? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},-proprietary-codecs]
	)
"

gen_depend_llvm() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
				openmp? (
					sys-libs/libomp:${s}[${MULTILIB_USEDEP}]
				)
			)
		"
	done
}
# Reasons for restrictions with mold section are due to the the patent status
# if not expired or not granted free.
RDEPEND+="
	>=dev-db/sqlite-3.22.0:3=[${MULTILIB_USEDEP}]
	>=dev-libs/icu-61.2:=[${MULTILIB_USEDEP}]
	>=dev-libs/glib-${GLIB_PV}:2[${MULTILIB_USEDEP}]
	>=dev-libs/gmp-6.1.2[-pgo(-),${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.6.0:0=[${MULTILIB_USEDEP}]
	>=dev-libs/libtasn1-4.13:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.8.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxslt-1.1.7[${MULTILIB_USEDEP}]
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
	virtual/jpeg:0=[${MULTILIB_USEDEP}]
	alsa? (
		!media-plugins/gst-plugins-pulse
	)
	avif? (
		>=media-libs/libavif-0.9.0[${MULTILIB_USEDEP}]
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
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},egl(+),gles2]
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
			!vaapi-stateless-decoding? (
				>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},vaapi]
			)
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},ffmpeg]
			media-libs/vaapi-drivers[${MULTILIB_USEDEP}]
			media-video/ffmpeg[${MULTILIB_USEDEP},vaapi]
		)
		vaapi-stateless-decoding? (
			>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},vaapi]
		)
		webvtt? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},closedcaption]
		)
	)
	introspection? (
		>=dev-libs/gobject-introspection-1.56.1:=
	)
	journald? (
		|| (
			>=sys-apps/systemd-245.4[${MULTILIB_USEDEP}]
			sys-auth/elogind
		)
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.2.0:2=[${MULTILIB_USEDEP}]
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
	proprietary-codecs-disable? (
		${RDEPEND_PROPRIETARY_CODECS_DISABLE}
		!media-plugins/gst-plugins-faac
		!media-plugins/gst-plugins-faad
	)
	proprietary-codecs-disable-nc-developer? (
		${RDEPEND_PROPRIETARY_CODECS_DISABLE}
		!media-plugins/gst-plugins-faac
		!media-plugins/gst-plugins-faad
	)
	proprietary-codecs-disable-nc-user? (
		${RDEPEND_PROPRIETARY_CODECS_DISABLE}
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
		net-libs/thunder
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
	webcrypto? (
		>=dev-libs/libgcrypt-1.7.0:0=[${MULTILIB_USEDEP}]
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
"
# For ${OCDM_WV}, \
#   You need a license, the proprietary SDK, and OCDM plugin.
# see https://github.com/WebKit/WebKit/blob/9467df8e0134156fa95c4e654e956d8166a54a13/Source/WebCore/platform/graphics/gstreamer/eme/WebKitThunderDecryptorGStreamer.cpp#L97
DEPEND+=" ${RDEPEND}"
# paxctl is needed for bug #407085
# It needs real bison, not yacc.

BDEPEND+="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=app-accessibility/at-spi2-core-2.5.3[${MULTILIB_USEDEP}]
	>=dev-lang/perl-5.10.0
	>=dev-lang/python-2.7
	>=dev-lang/ruby-1.9
	>=dev-util/cmake-3.16
	>=dev-util/glib-utils-${GLIB_PV}
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=dev-util/unifdef-2.10
	>=sys-devel/bison-3.0.4
	>=sys-devel/gettext-0.19.8.1[${MULTILIB_USEDEP}]
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-JSON-PP
	doc? (
		dev-util/gi-docgen
	)
	geolocation? (
		>=dev-util/gdbus-codegen-${GLIB_PV}
	)
	mold? (
		sys-devel/mold
	)
	thunder? (
		net-libs/thunder
	)
	webcore? (
		>=dev-util/gperf-3.0.1
	)
	|| (
		$(gen_depend_llvm)
		>=sys-devel/gcc-${GCC_PV}
	)
"
#	test? (
#		>=dev-python/pygobject-3.26.1:3[python_targets_python2_7]
#		>=x11-themes/hicolor-icon-theme-0.17
#		jit? (
#			>=sys-apps/paxctl-0.9
#		)
#	)
#
# Revisions and commit hashes provided since no tags specifically for the
# webkit-gtk project.
# Revisions can be found at:
# https://trac.webkit.org/log/webkit/trunk/Source/WebKit/gtk/NEWS
# https://trac.webkit.org/browser/webkit/releases/WebKitGTK
# Commits can be found at:
# https://github.com/WebKit/WebKit/commits/main/Source/WebKit/gtk/NEWS
# Or https://trac.webkit.org/browser/webkit/releases/WebKitGTK
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
_PATCHES=(
	"${FILESDIR}/webkit-gtk-2.43.2-CaptionUserPreferencesDisplayMode-conditional.patch"
	"${FILESDIR}/webkit-gtk-2.43.2-custom-page-size.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
einfo
einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
einfo
			check-reqs_pkg_pretend
		fi

		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
		if ! test-flag-CXX -std=c++${CXX_STD} ; then
# See https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/cmake/WebKitCommon.cmake#L72
# See https://github.com/WebKit/WebKit/blob/webkitgtk-2.43.1/Source/cmake/OptionsCommon.cmake
eerror
eerror "You need at least GCC ${GCC_PV} or Clang >= ${CLANG_PV} for"
eerror "C++${CXX_STD} specific compiler flags"
eerror
			die
		fi

		if tc-is-gcc && ver_test $(gcc-fullversion) -lt ${GCC_PV} ; then
eerror
eerror "You need at least GCC ${GCC_PV}.  Switch to a newer version."
eerror
		fi

		if tc-is-clang && ver_test $(clang-fullversion) -lt ${CLANG_PV} ; then
eerror
eerror "You need at least Clang ${CLANG_PV}.  Switch to a newer version."
eerror
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

# One of the major sources of lag comes from dependencies
# These are strict to match performance to competition or normal builds.
declare -A CFLAGS_RDEPEND=(
	["media-libs/dav1d"]=">=;-O2" # -O0 skippy, -O1 faster but blurry, -Os blurry still, -O2 not blurry
	["media-libs/libvpx"]=">=;-O1" # -O0 causes FPS to lag below 25 FPS.
)

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

# It is not clear about the end scope/extent of non-commericial.
# It may use runtime codec detection for both gst-ffmpeg and in webkit-gtk.
verify_codecs() {
	if use proprietary-codecs-disable \
		|| use proprietary-codecs-disable-nc-developer \
		|| use proprietary-codecs-disable-nc-user \
	; then
		:;
	else
		return
	fi
	local use_flags=(
		"amr"
		"cuda"
		"fdk"
		"openh264"
		"vaapi"
		"x264"
		"x265"
		"xvid"
	)
	if use proprietary-codecs-disable \
		|| use proprietary-codecs-disable-nc-developer ; then
		use_flags+=(
			"aac"
		)
	fi
	local flag
	for flag in ${use_flags[@]} ; do
# We check again because FFmpeg is not required, but user may set USE flags
# outside of package.
		if has_version "media-video/ffmpeg[${flag}]" ; then
eerror
eerror "Detected ${flag} USE enabled for media-video/ffmpeg.  This flag must be"
eerror "disabled to disable proprietary codecs."
eerror
eerror "Required changes:"
eerror
eerror    ">=dev-libs/openssl-3"
eerror    "media-video/ffmpeg[-amr,-cuda,-fdk,-openh264,openssl,-vaapi,-x264,-x265,-xvid]"
eerror
eerror "or"
eerror
eerror    "media-video/ffmpeg[-amr,-cuda,-fdk,-openh264,-openssl,-vaapi,-x264,-x265,-xvid]"
eerror
			die
		fi
	done
	if has_version "media-libs/gst-plugins-bad[vaapi]" ; then
eerror
eerror "Disabling vaapi in the media-libs/gst-plugins-bad package is required"
eerror "for proprietary-codecs-disable* USE flags."
eerror
		die
	fi
	if has_version "<dev-libs/openssl-3" \
		&& has_version "media-video/ffmpeg[openssl]" ; then
# Version 3 is allowed because of the Grant of Patent Clause in Apache-2.0.
eerror
eerror "Using <dev-libs/openssl-3 is disallowed with the"
eerror "proprietary-codecs-disable* USE flags."
eerror
		die
	fi
	if has_version ">=dev-libs/openssl-3" \
		&& has_version "<media-video/ffmpeg-5[openssl]" ; then
eerror
eerror "Using <media-video/ffmpeg-5 is disallowed with the"
eerror "proprietary-codecs-disable* USE flags.  This may add nonfree code"
eerror "paths in FFmpeg."
eerror
		die
	fi
	if has_version "media-video/ffmpeg" ; then
ewarn
ewarn "Use a corrected local copy or the FFmpeg ebuild from the"
ewarn "oiledmachine-overlay to eliminate the possiblity of nonfree codepaths"
ewarn "and to ensure the package is LGPL/GPL."
ewarn
	fi
}

WK_PAGE_SIZE=64
check_page_size() {
# See
# https://github.com/WebKit/WebKit/blob/main/Source/WTF/wtf/PageBlock.h
# https://github.com/WebKit/WebKit/blob/main/Source/cmake/WebKitFeatures.cmake#L76
#
# Anything beyond the programmed ceiling with do a planned forced crash
# according to upstream.
#
	local page_size
	local default_page_size=64

	# These are based on the kernel defaults.
	if [[ "${ARCH}" == "arm64" ]] ; then
		# Based in the kernel Kconfig
		default_page_size=64
	elif [[ \
		   "${ARCH}" == "loong" \
	]] ; then
		default_page_size=16
	elif [[ \
		   "${ARCH}" == "amd64" \
		|| "${ARCH}" == "arm" \
		|| "${ARCH}" == "ppc" \
		|| "${ARCH}" == "ppc64" \
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

	if (( ${page_size} == 64 )) ; then
ewarn
ewarn "You using 64 KB pages which may degrade performance severely and"
ewarn "decrease security."
ewarn
	fi

	local known=0
	if use arm64 ; then
		known=1
		if (( ${page_size} == 64 )) ; then
			CONFIG_CHECK="~ARM64_64K_PAGES ~!ARM64_16K_PAGES ~!ARM64_4K_PAGES"
			WARNING_ARM64_64K_PAGES=\
"CONFIG_ARM64_64K_PAGES must be set to =y in the kernel."
			WARNING_ARM64_16K_PAGES=\
"CONFIG_ARM64_16K_PAGES must be set to =n in the kernel."
			WARNING_ARM64_4K_PAGES=\
"CONFIG_ARM64_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=64 must be set as an environment variable"
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="~!ARM64_64K_PAGES ~ARM64_16K_PAGES ~!ARM64_4K_PAGES"
			WARNING_ARM64_64K_PAGES=\
"CONFIG_ARM64_64K_PAGES must be set to =n in the kernel."
			WARNING_ARM64_16K_PAGES=\
"CONFIG_ARM64_16K_PAGES must be set to =y in the kernel."
			WARNING_ARM64_4K_PAGES=\
"CONFIG_ARM64_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=16 must be set as an environment variable"
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="~!ARM64_64K_PAGES ~!ARM64_16K_PAGES ~ARM64_4K_PAGES"
			WARNING_ARM64_64K_PAGES=\
"CONFIG_ARM64_64K_PAGES must be set to =n in the kernel."
			WARNING_ARM64_16K_PAGES=\
"CONFIG_ARM64_16K_PAGES must be set to =n in the kernel."
			WARNING_ARM64_4K_PAGES=\
"CONFIG_ARM64_4K_PAGES must be set to =y in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=4 must be set as an environment variable"
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

	if use ia64 ; then
		known=1
		if (( ${page_size} == 64 )) ; then
			CONFIG_CHECK="~IA64_PAGE_SIZE_64KB ~!IA64_PAGE_SIZE_16KB ~!IA64_PAGE_SIZE_8KB ~!IA64_PAGE_SIZE_4KB"
			WARNING_IA64_PAGE_SIZE_64KB=\
"CONFIG_IA64_PAGE_SIZE_64KB must be set to =y in the kernel."
			WARNING_IA64_PAGE_SIZE_16KB=\
"CONFIG_IA64_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_8KB=\
"CONFIG_IA64_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_4KB=\
"CONFIG_IA64_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=64 must be set as an environment variable"
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="~IA64_PAGE_SIZE_64KB ~IA64_PAGE_SIZE_16KB ~!IA64_PAGE_SIZE_8KB ~!IA64_PAGE_SIZE_4KB"
			WARNING_IA64_PAGE_SIZE_64KB=\
"CONFIG_IA64_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_16KB=\
"CONFIG_IA64_PAGE_SIZE_16KB must be set to =y in the kernel."
			WARNING_IA64_PAGE_SIZE_8KB=\
"CONFIG_IA64_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_4KB=\
"CONFIG_IA64_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=16 must be set as an environment variable"
			fi
		elif (( ${page_size} == 8 )) ; then
			CONFIG_CHECK="~!IA64_PAGE_SIZE_64KB ~!IA64_PAGE_SIZE_16KB ~IA64_PAGE_SIZE_8KB ~!IA64_PAGE_SIZE_4KB"
			WARNING_IA64_PAGE_SIZE_64KB=\
"CONFIG_IA64_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_16KB=\
"CONFIG_IA64_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_8KB=\
"CONFIG_IA64_PAGE_SIZE_8KB must be set to =y in the kernel."
			WARNING_IA64_PAGE_SIZE_4KB=\
"CONFIG_IA64_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "8" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=8 must be set as an environment variable"
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="~!IA64_PAGE_SIZE_64KB ~!IA64_PAGE_SIZE_16KB ~!IA64_PAGE_SIZE_8KB ~IA64_PAGE_SIZE_4KB"
			WARNING_IA64_PAGE_SIZE_64KB=\
"CONFIG_IA64_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_16KB=\
"CONFIG_IA64_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_8KB=\
"CONFIG_IA64_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_IA64_PAGE_SIZE_4KB=\
"CONFIG_IA64_PAGE_SIZE_4KB must be set to =y in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=4 must be set as an environment variable"
			fi
		else
			if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
eerror
eerror "Invalid value for CUSTOM_PAGE_SIZE."
eerror
eerror "Actual value:  ${CUSTOM_PAGE_SIZE}"
eerror "Expected values:  4, 8, 16, 64"
eerror
				die
			else
eerror
eerror "QA:  Invalid value for page_size."
eerror
eerror "Actual value:  ${page_size}"
eerror "Expected values:  4, 8, 16, 64"
eerror
				die
			fi
		fi
	fi

	if use loong ; then
		known=1
		if (( ${page_size} == 64 )) ; then
			CONFIG_CHECK="~PAGE_SIZE_64KB ~!PAGE_SIZE_16KB ~!PAGE_SIZE_4KB"
			WARNING_PAGE_SIZE_64KB=\
"CONFIG_PAGE_SIZE_64KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_16KB=\
"CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB=\
"CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=64 must be set as an environment variable"
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="~!PAGE_SIZE_64KB ~PAGE_SIZE_16KB ~!PAGE_SIZE_4KB"
			WARNING_PAGE_SIZE_64KB=\
"CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB=\
"CONFIG_PAGE_SIZE_16KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_4KB=\
"CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=16 must be set as an environment variable"
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="~!PAGE_SIZE_64KB ~!PAGE_SIZE_16KB ~PAGE_SIZE_4KB"
			WARNING_PAGE_SIZE_64KB=\
"CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB=\
"CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB=\
"CONFIG_PAGE_SIZE_4KB must be set to =y in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=4 must be set as an environment variable"
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
			CONFIG_CHECK="~PAGE_SIZE_64KB ~!PAGE_SIZE_32KB ~!PAGE_SIZE_16KB ~!PAGE_SIZE_8KB ~!PAGE_SIZE_4KB"
			WARNING_PAGE_SIZE_64KB=\
"CONFIG_PAGE_SIZE_64KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_32KB=\
"CONFIG_PAGE_SIZE_32KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB=\
"CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_8KB=\
"CONFIG_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB=\
"CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=64 must be set as an environment variable"
			fi
		elif (( ${page_size} == 32 )) ; then
			CONFIG_CHECK="~!PAGE_SIZE_64KB ~PAGE_SIZE_32KB ~!PAGE_SIZE_16KB ~!PAGE_SIZE_8KB ~!PAGE_SIZE_4KB"
			WARNING_PAGE_SIZE_64KB=\
"CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_32KB=\
"CONFIG_PAGE_SIZE_32KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_16KB=\
"CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_8KB=\
"CONFIG_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB=\
"CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "32" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=32 must be set as an environment variable"
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="~!PAGE_SIZE_64KB ~!PAGE_SIZE_32KB ~PAGE_SIZE_16KB ~!PAGE_SIZE_8KB ~!PAGE_SIZE_4KB"
			WARNING_PAGE_SIZE_64KB=\
"CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_32KB=\
"CONFIG_PAGE_SIZE_32KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB=\
"CONFIG_PAGE_SIZE_16KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_8KB=\
"CONFIG_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB=\
"CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=16 must be set as an environment variable."
			fi
		elif (( ${page_size} == 8 )) ; then
			CONFIG_CHECK="~!PAGE_SIZE_64KB ~!PAGE_SIZE_32KB ~!PAGE_SIZE_16KB ~PAGE_SIZE_8KB ~!PAGE_SIZE_4KB"
			WARNING_PAGE_SIZE_64KB=\
"CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_32KB=\
"CONFIG_PAGE_SIZE_32KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB=\
"CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_8KB=\
"CONFIG_PAGE_SIZE_8KB must be set to =y in the kernel."
			WARNING_PAGE_SIZE_4KB=\
"CONFIG_PAGE_SIZE_4KB must be set to =n in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "8" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=8 must be set as an environment variable."
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="~!PAGE_SIZE_64KB ~!PAGE_SIZE_32KB ~!PAGE_SIZE_16KB ~!PAGE_SIZE_8KB ~PAGE_SIZE_4KB"
			WARNING_PAGE_SIZE_64KB=\
"CONFIG_PAGE_SIZE_64KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_32KB=\
"CONFIG_PAGE_SIZE_32KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_16KB=\
"CONFIG_PAGE_SIZE_16KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_8KB=\
"CONFIG_PAGE_SIZE_8KB must be set to =n in the kernel."
			WARNING_PAGE_SIZE_4KB=\
"CONFIG_PAGE_SIZE_4KB must be set to =y in the kernel."
			check_extra_config
			if [[ -n "${CUSTOM_PAGE_SIZE}" && "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=4 must be set as an environment variable."
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
			CONFIG_CHECK="~PPC_256K_PAGES ~!PPC_64K_PAGES ~!PPC_16K_PAGES ~!PPC_4K_PAGES"
			WARNING_PPC_256K_PAGES=\
"CONFIG_PPC_256K_PAGES must be set to =y in the kernel."
			WARNING_PPC_64K_PAGES=\
"CONFIG_PPC_64K_PAGES must be set to =n in the kernel."
			WARNING_PPC_16K_PAGES=\
"CONFIG_PPC_16K_PAGES must be set to =n in the kernel."
			WARNING_PPC_4K_PAGES=\
"CONFIG_PPC_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ "${CUSTOM_PAGE_SIZE}" != "256" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=256 must be set as an environment variable."
			fi
		elif (( ${page_size} == 64 )) ; then
			CONFIG_CHECK="~!PPC_256K_PAGES ~PPC_64K_PAGES ~!PPC_16K_PAGES ~!PPC_4K_PAGES"
			WARNING_PPC_256K_PAGES=\
"CONFIG_PPC_256K_PAGES must be set to =n in the kernel."
			WARNING_PPC_64K_PAGES=\
"CONFIG_PPC_64K_PAGES must be set to =y in the kernel."
			WARNING_PPC_16K_PAGES=\
"CONFIG_PPC_16K_PAGES must be set to =n in the kernel."
			WARNING_PPC_4K_PAGES=\
"CONFIG_PPC_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ "${CUSTOM_PAGE_SIZE}" != "64" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=64 must be set as an environment variable."
			fi
		elif (( ${page_size} == 16 )) ; then
			CONFIG_CHECK="~!PPC_256K_PAGES ~!PPC_64K_PAGES ~PPC_16K_PAGES ~!PPC_4K_PAGES"
			WARNING_PPC_256K_PAGES=\
"CONFIG_PPC_256K_PAGES must be set to =n in the kernel."
			WARNING_PPC_64K_PAGES=\
"CONFIG_PPC_64K_PAGES must be set to =n in the kernel."
			WARNING_PPC_16K_PAGES=\
"CONFIG_PPC_16K_PAGES must be set to =y in the kernel."
			WARNING_PPC_4K_PAGES=\
"CONFIG_PPC_4K_PAGES must be set to =n in the kernel."
			check_extra_config
			if [[ "${CUSTOM_PAGE_SIZE}" != "16" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=16 must be set as an environment variable."
			fi
		elif (( ${page_size} == 4 )) ; then
			CONFIG_CHECK="~!PPC_256K_PAGES ~!PPC_64K_PAGES ~!PPC_16K_PAGES ~PPC_4K_PAGES"
			WARNING_PPC_256K_PAGES=\
"CONFIG_PPC_256K_PAGES must be set to =n in the kernel."
			WARNING_PPC_64K_PAGES=\
"CONFIG_PPC_64K_PAGES must be set to =n in the kernel."
			WARNING_PPC_16K_PAGES=\
"CONFIG_PPC_16K_PAGES must be set to =n in the kernel."
			WARNING_PPC_4K_PAGES=\
"CONFIG_PPC_4K_PAGES must be set to =y in the kernel."
			check_extra_config
			if [[ "${CUSTOM_PAGE_SIZE}" != "4" ]] ; then
				ewarn "CUSTOM_PAGE_SIZE=4 must be set as an environment variable."
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
			:;
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

	if (( ${known} == 1 )) ; then
		:;
	elif (( ${page_size} == 64 )) ; then
		:;
	else
		if [[ -n "${CUSTOM_PAGE_SIZE}" ]] ; then
eerror
eerror "Invalid value for CUSTOM_PAGE_SIZE."
eerror
eerror "Actual value:  ${CUSTOM_PAGE_SIZE}"
eerror "Expected values:  64"
eerror
				die
		else
eerror
eerror "QA:  Invalid value for page_size."
eerror
eerror "Actual value:  ${page_size}"
eerror "Expected values:  64"
eerror
			die
		fi
	fi
	WK_PAGE_SIZE=${page_size}
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
	cflags-depends_check

	if ( use arm || use arm64 ) && ! use gles2 ; then
ewarn
ewarn "gles2 is the default on upstream."
ewarn
	fi

	if use openmp ; then
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
einfo "CC:\t\t\t${CC}"
einfo "CXX:\t\t\t${CXX}"
		${CC} --version
		tc-check-openmp
	fi

	tc-is-clang && llvm_pkg_setup

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

	if ! use mold && is-flagq '-fuse-ld=mold' ; then
eerror
eerror "-fuse-ld=mold requires the mold USE flag."
eerror
		die
	fi

	if [[ "${ARCH}" == "riscv" ]] ; then
		use ilp32d && die "Disable the unsupported ilp32d ABI"
		use ilp32 && die "Disable the unsupported ilp32 ABI"
	fi

	check_page_size
	verify_codecs
	uopts_setup
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

ewarn
ewarn "Try adding -Wl,--no-keep-memory to per-package LDFLAGS if out of memory (OOM)"
ewarn "or adding additional swap space.  The latter is more efficient."
ewarn
	# You still can have swapping + O(n^2) or swapping + O(1).

	eapply "${FILESDIR}/extra-patches/webkit-gtk-2.39.90-linkers.patch"

	eapply "${_PATCHES[@]}"
	cmake_src_prepare
	gnome2_src_prepare

	prepare_abi() {
		uopts_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

SELECTED_LTO=""
_src_configure() {
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

	# ld segfaults on ia64 with LDFLAGS --as-needed, bug #555504
	use ia64 && append-ldflags "-Wl,--no-as-needed"

	# Sigbuses on SPARC with mcpu and co., bug #???
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

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
		-DENABLE_JAVASCRIPTCORE=$(usex javascriptcore)
		-DENABLE_JOURNALD_LOG=$(usex journald)
		-DENABLE_MEDIA_RECORDER=$(usex mediarecorder)
		-DENABLE_MEDIA_STREAM=$(usex mediastream)
		-DENABLE_MINIBROWSER=$(usex minibrowser)
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_RELEASE_LOG=ON
		-DENABLE_SPEECH_SYNTHESIS=$(usex speech-synthesis)
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_THUNDER=$(usex thunder)
		-DENABLE_UNIFIED_BUILDS=$(usex unified-builds)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_WEB_CRYPTO=$(usex webcrypto)
		-DENABLE_WEB_RTC=$(usex webrtc)
		-DENABLE_WEBCORE=$(usex webcore)
		-DENABLE_WEBDRIVER=$(usex webdriver)
		-DENABLE_WEBGL=$(usex webgl)
		-DENABLE_X11_TARGET=$(usex X)
		-DPORT=GTK
		-DUSE_64KB_PAGE_BLOCK=$(usex 64kb-page-block)
		-DUSE_ANGLE_WEBGL=OFF
		-DUSE_AVIF=$(usex avif)
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
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_SOUP2=ON
		-DUSE_WOFF2=$(usex woff2)
		$(cmake_use_find_package gles2 OpenGLES2)
		$(cmake_use_find_package opengl OpenGL)
	)

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

	# See Source/cmake/WebKitFeatures.cmake
	local jit_enabled=$(usex jit "1" "0")
	local system_malloc=$(usex !bmalloc "1" "0")
	local webassembly_allowed=$(usex jit "1" "0")
	if (( ${WK_PAGE_SIZE} == 64 )) ; then
		mycmakeargs+=(
			-DENABLE_JIT=OFF
			-DENABLE_DFG_JIT=OFF
			-DENABLE_FTL_JIT=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=OFF
			-DENABLE_WEBASSEMBLY_BBQJIT=OFF
			-DENABLE_WEBASSEMBLY_OMGJIT=OFF
			-DUSE_SYSTEM_MALLOC=ON
		)
		if [[ "${ABI}" == "arm64" ]] ; then
			mycmakeargs+=(
				-DENABLE_C_LOOP=OFF
				-DENABLE_SAMPLING_PROFILER=ON
			)
			webassembly_allowed=1
		else
			mycmakeargs+=(
				-DENABLE_C_LOOP=ON
				-DENABLE_SAMPLING_PROFILER=OFF
			)
			webassembly_allowed=0
		fi
		jit_enabled=0
		system_malloc=1
	elif [[ "${ABI}" == "amd64" || "${ABI}" == "arm64" ]] ; then
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex dfg-jit)
			-DENABLE_FTL_JIT=$(usex ftl-jit)
			-DENABLE_SAMPLING_PROFILER=$(usex jit)
			-DENABLE_WEBASSEMBLY_B3JIT=$(usex webassembly-b3-jit)
			-DENABLE_WEBASSEMBLY_BBQJIT=$(usex webassembly-bbq-jit)
			-DENABLE_WEBASSEMBLY_OMGJIT=$(usex webassembly-omg-jit)
			-DUSE_SYSTEM_MALLOC=$(usex !bmalloc)
		)
	elif [[ "${ABI}" == "arm" ]] && use cpu_flags_arm_thumb2 ; then
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex dfg-jit)
			-DENABLE_FTL_JIT=OFF
			-DENABLE_SAMPLING_PROFILER=$(usex jit)
			-DENABLE_WEBASSEMBLY_B3JIT=OFF
			-DENABLE_WEBASSEMBLY_BBQJIT=OFF
			-DENABLE_WEBASSEMBLY_OMGJIT=OFF
			-DUSE_SYSTEM_MALLOC=$(usex !bmalloc)
		)
	elif [[ "${ARCH}" == "mips" ]] ; then
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex dfg-jit)
			-DENABLE_FTL_JIT=OFF
			-DENABLE_SAMPLING_PROFILER=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=OFF
			-DENABLE_WEBASSEMBLY_BBQJIT=OFF
			-DENABLE_WEBASSEMBLY_OMGJIT=OFF
			-DUSE_SYSTEM_MALLOC=$(usex !bmalloc)
		)
	elif [[ "${ARCH}" == "riscv" ]] ; then
		# 64-bit only
		mycmakeargs+=(
			-DENABLE_C_LOOP=$(usex !jit)
			-DENABLE_JIT=$(usex jit)
			-DENABLE_DFG_JIT=$(usex dfg-jit)
			-DENABLE_FTL_JIT=$(usex ftl-jit)
			-DENABLE_SAMPLING_PROFILER=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=$(usex webassembly-b3-jit)
			-DENABLE_WEBASSEMBLY_BBQJIT=$(usex webassembly-bbq-jit)
			-DENABLE_WEBASSEMBLY_OMGJIT=$(usex webassembly-omg-jit)
			-DUSE_SYSTEM_MALLOC=$(usex !bmalloc)
		)
	else
einfo
einfo "Disabling JIT for ${ABI}."
einfo
		mycmakeargs+=(
			-DENABLE_C_LOOP=ON
			-DENABLE_JIT=OFF
			-DENABLE_DFG_JIT=OFF
			-DENABLE_FTL_JIT=OFF
			-DENABLE_SAMPLING_PROFILER=OFF
			-DENABLE_WEBASSEMBLY_B3JIT=OFF
			-DENABLE_WEBASSEMBLY_BBQJIT=OFF
			-DENABLE_WEBASSEMBLY_OMGJIT=OFF
			-DUSE_SYSTEM_MALLOC=ON
		)
		jit_enabled=0
		system_malloc=1
		webassembly_allowed=0
	fi

	if (( ${webassembly_allowed} == 1 )) ; then
		mycmakeargs+=(
			-DENABLE_WEBASSEMBLY=$(usex webassembly)
		)
	else
ewarn
ewarn "WebAssembly disabled.  The following steps are required to easily enable"
ewarn "it:"
ewarn
ewarn "(1) Enable the jit USE flag."
ewarn "(2) Change the kernel config to use page sizes less than 64 KB."
ewarn "(3) Set CUSTOM_PAGE_SIZE environment variable less than 64 KB."
ewarn
		mycmakeargs+=(
			-DENABLE_WEBASSEMBLY=OFF
		)
	fi

	if (( ${system_malloc} == 1 )) ; then
ewarn
ewarn "Disabling bmalloc for ABI=${ABI} may lower security."
ewarn
	fi

	# Arches without JIT support also need this to really disable it in all
	# places
	if (( ${jit_enabled} == 0 )) ; then
einfo
einfo "Disabled JIT"
einfo
		append-cppflags \
			-DENABLE_ASSEMBLER=0 \
			-DENABLE_JIT=0
	fi
	if use yarr-jit ; then
einfo
einfo "Enabled YARR (regex) JIT" # default
einfo
	else
einfo
einfo "Disabled YARR (regex) JIT"
einfo
		append-cppflags \
			-DENABLE_YARR_JIT=0
	fi

einfo
einfo "CPPFLAGS=${CPPFLAGS}"
einfo

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

einfo "Add -flto with one of -fuse-ld=<bfd|gold|lld|mold> for LTO optimization"
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

	uopts_src_configure
	if use epgo && tc-is-clang ; then
		append-flags -mllvm -vp-counters-per-site=3
	fi

	# Anything less than -O2 may break rendering.
	# GCC -O1:  pas_generic_large_free_heap.h:140:1: error: inlining failed in call to 'always_inline'
	# Clang -Os:  slower than expected rendering.
	# Forced >= -O3 to be about same relative performance to other browser engines.
	# -O2 feels like C- grade relative other browser engines.

	replace-flags "-O0" "-O3"
	replace-flags "-O1" "-O3"
	replace-flags "-Oz" "-O3"
	replace-flags "-Os" "-O3"
	replace-flags "-O2" "-O3"
	replace-flags "-O3" "-O3"
	replace-flags "-O4" "-O3"
	replace-flags "-Ofast" "-O3"
	filter-flags '-ffast-math'

	if is-flagq "-Ofast" ; then
		# Precaution
		append_all $(test-flags -fno-allow-store-data-races)
	fi

	WK_USE_CCACHE=NO cmake_src_configure
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
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
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
			/usr/$(get_libdir)/misc/webkit2gtk-${API_VERSION}/MiniBrowser \
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
	uopts_src_install
}

multilib_src_install_all() {
	local vaapi_env
	local hls_env
	if ! use vaapi-stateless-decoding && use vaapi ; then
		vaapi_env="WEBKIT_GST_ENABLE_LEGACY_VAAPI=1"
	fi

	if use hls ; then
		hls_env="WEBKIT_GST_ENABLE_HLS_SUPPORT=1"
	fi

	dodir /etc/env.d
newenvd - 50${PN}${API_VERSION} <<-EOF
${vaapi_env}
${hls_env}
EOF

	LCNR_SOURCE="${S}"
	lcnr_install_files
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

	uopts_pkg_postinst

einfo
einfo "See metadata.xml or \`epkginfo -x =${CATEGORY}/${P}::oiledmachine-overlay\`"
einfo "for proper building with PGO+BOLT"
einfo

	if ! use alsa && use pulseaudio \
		&& has_version "media-sound/pulseaudio-daemon[-alsa]" ; then
ewarn
ewarn "You may need media-sound/pulseaudio-daemon[alsa] to hear sound."
ewarn
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

# OILEDMACHINE-OVERLAY-TEST:
# with -O2, clang 15.0.7 (2.43.1, 20231203):
#   minibrowser:  passed
#   search engine(s):  passed
#   video site(s):  fail (minibrowser), passed (surf)
#     vpx (streaming):  passed
#     vpx (on demand):  passed
#     opus:  TBA
#   wiki(s):  passed
#   audio:  TBA
#   stability:  crashy within a few minutes

# with -O3 -jit* -gstreamer, clang 15.0.7 (2.43.2, 20231205):
#   startup:  fail
