# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# -r revision notes
# -rabcde
# ab = WEBKITGTK_API_VERSION version (4.1)
# c = reserved
# de = ebuild revision

# Corresponds to
# WebKit 612.1.18 (20210608, main) ; See Source/WebKit/Configurations/Version.xcconfig

LLVM_MAX_SLOT=12 # This should not be more than Mesa's llvm \
# dependency (mesa 20.x (stable): llvm-11, mesa 21.x (testing): llvm-12).

CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{8..10} )
USE_RUBY="ruby26 ruby27 ruby30"
inherit check-reqs cmake desktop flag-o-matic gnome2 linux-info llvm \
multilib-minimal pax-utils python-any-r1 ruby-single subversion \
toolchain-funcs virtualx

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
	LGPL-2.1"
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
	pgo? (
		all-rights-reserved
		BSD
		BSD-2
		GPL-2+
		LGPL-2+
		LGPL-2.1+
		wk_pgo_trainers_bigintbench? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_bindings? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_css? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_indexeddb? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_interactive? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_intl? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_media? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_mutation? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_stylebench? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_tailbench9000? (
			LGPL-2 BSD-2
		)
		wk_pgo_trainers_apibench? (
			BSD
			BSD-2
		)
		wk_pgo_trainers_ares6? (
			BSD
			BSD-2
			MIT
		)
		wk_pgo_trainers_canvas? (
			BSD
		)
		wk_pgo_trainers_decodertest? (
			BSD-2
		)
		wk_pgo_trainers_dom? (
			BSD
		)
		wk_pgo_trainers_dromaeo-cssquery? (
			${LICENSE_DROMAEO}
		)
		wk_pgo_trainers_dromaeo-dom? (
			${LICENSE_DROMAEO}
		)
		wk_pgo_trainers_dromaeo-jslib? (
			${LICENSE_DROMAEO}
		)
		wk_pgo_trainers_jetstream? (
			( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
			( all-rights-reserved Apache-2.0 )
			( all-rights-reserved GPL-2+ )
			( all-rights-reserved MIT )
			Apache-2.0
			BSD-2
			BSD
			GPL-2
			GPL-2+
			LGPL-2.1
			MIT
			UoI-NCSA
			ZLIB
		)
		wk_pgo_trainers_jetstream2? (
			|| ( BSD GPL-2+ )
			( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2+ ) )
			( all-rights-reserved Apache-2.0 )
			( all-rights-reserved GPL-2+ )
			( all-rights-reserved MIT )
			all-rights-reserved
			Apache-2.0
			BSD-2
			BSD
			FPL
			GPL-2
			LGPL-2+
			LGPL-2.1
			MIT
			ZLIB
		)
		wk_pgo_trainers_jsbench? (
			BSD-2
			MIT
		)
		wk_pgo_trainers_layout? (
			PGL
		)
		wk_pgo_trainers_launchtime? (
			BSD-2
		)
		wk_pgo_trainers_longspider? (
			( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
			( all-rights-reserved Apache-2.0 )
			BSD
			BSD-2
			LGPL-2.1
		)
		wk_pgo_trainers_mallocbench? (
			BSD-2
		)
		wk_pgo_trainers_mediatime? (
			BSD-2
		)
		wk_pgo_trainers_motionmark? (
			all-rights-reserved
			BSD-2
		)
		wk_pgo_trainers_octane? (
			BSD
		)
		wk_pgo_trainers_parser? (
			BSD
		)
		wk_pgo_trainers_resources? (
			BSD-2
			MIT
		)
		wk_pgo_trainers_rexbench? (
			BSD
			BSD-2
		)
		wk_pgo_trainers_sixspeed? (
			MIT
		)
		wk_pgo_trainers_speedometer? (
			|| ( MIT BSD )
			( all-rights-reserved GPL-2 )
			( all-rights-reserved MIT )
			( MIT CC0-1.0 )
			Apache-2.0
			BSD
			CC-BY-4.0
			MIT
		)
		wk_pgo_trainers_sunspider? (
			|| ( MIT AFL-2.1 )
			( all-rights-reserved || ( MPL-1.1 GPL-2.0+ LGPL-2.1+ ) )
			( all-rights-reserved MIT )
			( MIT GPL-2 )
			BSD
			BSD-2
			GPL-2+
			LGPL-2.1
		)
		wk_pgo_trainers_testmem? (
			( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2+ ) )
			( all-rights-reserved Apache-2.0 )
			BSD
			BSD-2
			ZLIB
		)
		wk_pgo_trainers_svg? (
			CC-BY-ND-2.5
			custom-public-domain-non-commercial
			Free-Art-1.3
			GPL-2
			LGPL-2.1
		)
	)
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
		ooura
		openssl
		QU-fft
		sigslot
	)" # \
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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~x86"

API_VERSION="4.1"
SLOT_MAJOR=$(ver_cut 1 ${API_VERSION})
# See Source/cmake/OptionsGTK.cmake
# CALCULATE_LIBRARY_VERSIONS_FROM_LIBTOOL_TRIPLE(WEBKIT C R A),
# SOVERSION = C - A
# WEBKITGTK_API_VERSION is 4.1
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
dav1d +dfg-jit +egl +ftl-jit -gamepad +geolocation gles2 gnome-keyring
+gstreamer -gtk-doc hardened +introspection +jit +jpeg2k +jumbo-build +lcms
+libhyphen +libnotify lto -mediastream -minibrowser +opengl openmp pgo
+pulseaudio -seccomp -spell -systemd test variation-fonts +v4l wayland
+webassembly +webassembly-b3-jit +webcrypto +webgl -webrtc webvtt -webxr +X
+yarr-jit"

PGO_PLANS=(
	ares6
	content-animation
	dromaeo-cssquery
	dromaeo-dom
	dromaeo-jslib
	jetstream2
	jetstream
	jsbench
	kraken
	motionmark1.1
	motionmark
	octane
	speedometer2
	speedometer
	stylebench
	sunspider
)

#	Animation
#	ARES-6
#	Dromaeo
PGO_LOCAL_COPY=(
	APIBench
	BigIntBench
	Bindings
	Canvas
	CSS
	DecoderTest
	DOM
	IndexedDB
	Interactive
	Intl
	JetStream
	JetStream2
	JSBench
	LaunchTime
	Layout
	LongSpider
	MallocBench
	Media
	MediaTime
	MotionMark
	Mutation
	Octane
	Parser
	resources
	RexBench
	ShadowDOM
	SixSpeed
	Speedometer
	StyleBench
	SunSpider
	SVG
	TailBench9000
	testmem
	XSSAuditor
)

PGO_USE_NORMALIZED=()
gen_pgo_iuse() {
	local out
	for p in ${PGO_PLANS[@]} ${PGO_LOCAL_COPY[@]} ; do
		local t="${p,,}"
		t="${t/./_}"
		found=0
		for u in ${PGO_USE_NORMALIZED[@]} ; do
			if [[ "${u}" == "wk_pgo_trainers_${t}" ]] ; then
				found=1
			fi
		done
		if (( ${found} == 0 )) ; then
			PGO_USE_NORMALIZED+=( wk_pgo_trainers_${t} )
		fi
	done
	for p in ${PGO_USE_NORMALIZED[@]} ; do
		out+=" ${p}"
	done
	echo "${out}"
}

IUSE+=" "$(gen_pgo_iuse)

gen_pgo_required_use() {
	local out
	for p in ${PGO_IUSE_NORMALIZED[@]} ; do
		out+=" ${p}? ( pgo )"
	done
	echo "${out}"
}

REQUIRED_USE+=" "$(gen_pgo_required_use)
REQUIRED_USE+=" pgo? ( || ( $(gen_pgo_iuse) ) )"

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
	gles2? ( egl !opengl )
	gstreamer? ( || ( opengl gles2 ) )
	hardened? ( !jit )
	opengl? ( egl !gles2 )
	pgo? ( minibrowser )
	pulseaudio? ( gstreamer )
	v4l? ( gstreamer mediastream )
	wayland? ( egl )
	webassembly? ( jit )
	webassembly-b3-jit? ( ftl-jit webassembly )
	webgl? ( gstreamer
		|| ( gles2 opengl ) )
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
#   [1] https://github.com/WebKit/WebKit/blob/9467df8e0134156fa95c4e654e956d8166a54a13/Tools/gstreamer/jhbuild.modules#L16

# [1] Packaging this CDM is not feasible because of licensing and closed source
# SDK.

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
	>=media-libs/fontconfig-2.8.0:1.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.4.2:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-0.9.18:=[icu(+),${MULTILIB_USEDEP}]
	>=media-libs/lcms-2.9[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.34:0=[${MULTILIB_USEDEP}]
	>=media-libs/libwebp-0.6.1:=[${MULTILIB_USEDEP}]
	>=media-libs/woff2-1.0.2[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.99.5:3[introspection?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.11:0[${MULTILIB_USEDEP}]
	  virtual/jpeg:0=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-${CAIRO_V}:=[X?,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.22.0:3[aqua?,introspection?,wayland?,X?,${MULTILIB_USEDEP}]
	avif? ( >=media-libs/libavif-0.9.0[${MULTILIB_USEDEP}] )
	egl? ( >=media-libs/mesa-${MESA_V}[egl,${MULTILIB_USEDEP}] )
	gamepad? ( >=dev-libs/libmanette-0.2.4[${MULTILIB_USEDEP}] )
	geolocation? ( >=app-misc/geoclue-0.12.99:2.0 )
	gles2? ( >=media-libs/mesa-${MESA_V}[gles2,${MULTILIB_USEDEP}] )
	gnome-keyring? ( >=app-crypt/libsecret-0.18.6[${MULTILIB_USEDEP}] )
	gstreamer? (
		>=media-libs/gstreamer-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
>=media-libs/gst-plugins-base-${GSTREAMER_V}:1.0[gles2?,egl?,opengl?,X?,${MULTILIB_USEDEP}]
		media-plugins/gst-plugins-meta:1.0[${MULTILIB_USEDEP},pulseaudio?,v4l?]
		>=media-plugins/gst-plugins-opus-${GSTREAMER_V}:1.0[${MULTILIB_USEDEP}]
		dav1d? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},dav1d]
		)
		webvtt? (
			>=media-plugins/gst-plugins-rs-0.6.0:1.0[${MULTILIB_USEDEP},closedcaption]
		)
	)
	introspection? ( >=dev-libs/gobject-introspection-1.56.1:= )
	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2=[${MULTILIB_USEDEP}] )
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
		|| (
			(
				sys-devel/clang:11[${MULTILIB_USEDEP}]
				sys-devel/llvm:11[${MULTILIB_USEDEP}]
				>=sys-devel/lld-11
			)
			(
				sys-devel/clang:12[${MULTILIB_USEDEP}]
				sys-devel/llvm:12[${MULTILIB_USEDEP}]
				>=sys-devel/lld-12
			)
		)
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
	pgo? ( dev-vcs/subversion )
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
EGIT_COMMIT="9467df8e0134156fa95c4e654e956d8166a54a13"
ESVN_REVISION="278597"
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
die "You need at least GCC 7.3.x or Clang >= 6 for C++17-specific compiler flags"
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
			local geoclue_repo=$(cat /var/db/pkg/app-misc/geoclue-2.5.7*/repository)
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
ewarn
ewarn "Page size is not 16k but currently ${pagesize}.  Disable 64k-pages USE"
ewarn "flag."
ewarn
			fi
		else
die "64k pages is not supported.  Remove the 64k-pages USE flag."
		fi

		if ! linux_config_exists ; then
die "Missing .config for kernel."
		fi

		if [[ "${ABI}" == "arm64" ]] ; then
			if ! linux_chkconfig_present "ARM64_64K_PAGES" ; then
eerror
eerror "CONFIG_ARM64_64K_PAGES is unset in the kernel config.  Remove the"
eerror "64k-pages USE flag or change the kernel config."
eerror
				die
			fi
		elif [[ "${ABI}" == "n32" ]] ; then
			if ! linux_chkconfig_present "PAGE_SIZE_64KB" ; then
eerror
eerror "CONFIG_PAGE_SIZE_64KB is unset in the kernel config.  Remove the"
eerror "64k-pages USE flag or change the kernel config."
eerror
				die
			fi
		elif [[ "${ABI}" == "n64" ]] ; then
			if ! linux_chkconfig_present "PAGE_SIZE_64KB" ; then
eerror
eerror "CONFIG_PAGE_SIZE_64KB is unset in the kernel config.  Remove the"
eerror "64k-pages USE flag or change the kernel config."
eerror
				die
			fi
		elif [[ "${ABI}" == "n64" ]] ; then
			if ! linux_chkconfig_present "PAGE_SIZE_64KB" ; then
eerror
eerror "CONFIG_PAGE_SIZE_64KB is unset in the kernel config.  Remove the"
eerror "64k-pages USE flag or change the kernel config."
eerror
				die
			fi
		elif [[ "${ABI}" == "ppc64" ]] ; then
			if ! linux_chkconfig_present "PPC_64K_PAGES" ; then
eerror
eerror "CONFIG_PPC_64K_PAGES is unset in the kernel config.  Remove the"
eerror "64k-pages USE flag or change the kernel config."
eerror
				die
			fi
		elif [[ "${ABI}" == "sparc32" ]] ; then
			if linux_chkconfig_present "HUGETLB_PAGE" ; then
				:;
			elif linux_chkconfig_present "TRANSPARENT_HUGEPAGE" ; then
				:;
			else
eerror
eerror "CONFIG_TRANSPARENT_HUGEPAGE or CONFIG_HUGETLB_PAGE is unset in the"
eerror "kernel config.  Remove the 64k-pages USE flag or change the kernel"
eerror "config."
eerror
				die
			fi
		elif [[ "${ABI}" == "sparc64" ]] ; then
			if linux_chkconfig_present "HUGETLB_PAGE" ; then
				:;
			elif linux_chkconfig_present "TRANSPARENT_HUGEPAGE" ; then
				:;
			else
eerror
eerror "CONFIG_TRANSPARENT_HUGEPAGE or CONFIG_HUGETLB_PAGE is unset in the"
eerror "kernel config.  Remove the 64k-pages USE flag or change the kernel"
eerror "config."
eerror
				die
			fi
		fi
	fi

	check_geolocation

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
$(cat "${ESYSROOT}/var/db/pkg/media-plugins/gst-plugins-v4l2-"*"/repository")
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
}

unpack_pgo_trainers() {
	declare -Ax USE_TO_LOCAL_COPY=(
		[wk_pgo_trainers_ares6]="ARES-6"
		[wk_pgo_trainers_content-animation]="Animation"
		[wk_pgo_trainers_apibench]="APIBench"
		[wk_pgo_trainers_bigintbench]="BigIntBench"
		[wk_pgo_trainers_bindings]="Bindings"
		[wk_pgo_trainers_canvas]="Canvas"
		[wk_pgo_trainers_css]="CSS"
		[wk_pgo_trainers_decodertest]="DecoderTest"
		[wk_pgo_trainers_dom]="DOM"
		[wk_pgo_trainers_dromaeo-cssquery]="Dromaeo"
		[wk_pgo_trainers_dromaeo-dom]="Dromaeo"
		[wk_pgo_trainers_dromaeo-jslib]="Dromaeo"
		[wk_pgo_trainers_indexeddb]="IndexedDB"
		[wk_pgo_trainers_interactive]="Interactive"
		[wk_pgo_trainers_intl]="Intl"
		[wk_pgo_trainers_jetstream]="JetStream"
		[wk_pgo_trainers_jetstream2]="JetStream2"
		[wk_pgo_trainers_jsbench]="JSBench"
		[wk_pgo_trainers_kraken]="FIXME"
		[wk_pgo_trainers_launchtime]="LaunchTime"
		[wk_pgo_trainers_layout]="Layout"
		[wk_pgo_trainers_longspider]="LongSpider"
		[wk_pgo_trainers_mallocbench]="MallocBench"
		[wk_pgo_trainers_media]="Media"
		[wk_pgo_trainers_mediatime]="MediaTime"
		[wk_pgo_trainers_motionmark1_1]="FIXME"
		[wk_pgo_trainers_motionmark]="MotionMark"
		[wk_pgo_trainers_mutation]="Mutation"
		[wk_pgo_trainers_octane]="Octane"
		[wk_pgo_trainers_parser]="Parser"
		[wk_pgo_trainers_resources]="resources"
		[wk_pgo_trainers_rexbench]="RexBench"
		[wk_pgo_trainers_sixspeed]="SixSpeed"
		[wk_pgo_trainers_shadowdom]="ShadowDOM"
		[wk_pgo_trainers_speedometer2]="Speedometer"
		[wk_pgo_trainers_speedometer]="FIXME"
		[wk_pgo_trainers_stylebench]="StyleBench"
		[wk_pgo_trainers_sunspider]="SunSpider"
		[wk_pgo_trainers_svg]="SVG"
		[wk_pgo_trainers_tailbench9000]="TailBench9000"
		[wk_pgo_trainers_testmem]="testmem"
		[wk_pgo_trainers_xssauditor]="XSSAuditor"
	)

	# Unpacked individually to resolve the all-rights-reserved issues
	for u in ${!USE_TO_LOCAL_COPY[@]} ; do
		local f="${USE_TO_LOCAL_COPY[${u}]}"
		if use "${u}" ; then
			if [[ "${f}" == "FIXME" ]] ; then
eerror
eerror "FIXME: Add algorithm for local copy of ${u} to ebuild.  Do not use the"
eerror "${u} USE flag at this time."
eerror
				die
			fi
			subversion_fetch \
https://svn.webkit.org/repository/webkit/trunk/PerformanceTests/${f} \
PerformanceTests/${f}
		fi
	done
}

src_unpack() {
	unpack ${A}
	if use pgo ; then
		ewarn "The PGO use flag is a Work In Progress (WIP) and is not production ready."
		unpack_pgo_trainers
		# TODO: Add all-rights-reserved to exclusion for Tools/Scripts
		# if possible
		subversion_fetch \
https://svn.webkit.org/repository/webkit/trunk/Tools/Scripts/ \
Tools/Scripts
	fi
	if use webrtc ; then
		subversion_fetch \
https://svn.webkit.org/repository/webkit/trunk/Source/ThirdParty/libwebrtc/ \
Source/ThirdParty/libwebrtc
	fi
}

src_prepare() {
	eapply "${FILESDIR}/2.33.1-opengl-without-X-fixes.patch"
	if use webrtc ; then
		eapply "${FILESDIR}/2.33.2-add-openh264-headers.patch"
	fi
	cmake_src_prepare
	gnome2_src_prepare
	multilib_copy_sources
}

_config_pgx() {
	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	filter-flags -DENABLE_JIT=* -DENABLE_YARR_JIT=* -DENABLE_ASSEMBLER=*
	filter-flags -fprofile-generate* -fprofile-use* -fprofile-dir=*

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
	if use opengl || use gles2; then
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
		-DENABLE_GLES2=$(usex gles2)
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
		-DUSE_GTK4=OFF
		-DUSE_LIBHYPHEN=$(usex libhyphen)
		-DUSE_LCMS=$(usex lcms)
		-DUSE_LIBNOTIFY=$(usex libnotify)
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_SOUP2=OFF
		-DUSE_SYSTEMD=$(usex systemd) # Whether to enable journald logging
		-DUSE_WOFF2=ON
		-DUSE_WPE_RENDERER=${use_wpe_renderer} # \
# WPE renderer is used to implement accelerated compositing under wayland
		$(cmake_use_find_package gles2 OpenGLES2)
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

	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] ; then
		if tc-is-clang ; then
			append-cflags -fprofile-generate="${BUILD_DIR}"
			append-cxxflags -fprofile-generate="${BUILD_DIR}"
		elif tc-is-gcc ; then
			append-cflags -fprofile-generate -fprofile-dir="${BUILD_DIR}"
			append-cxxflags -fprofile-generate -fprofile-dir="${BUILD_DIR}"
		else
			die "Only GCC and Clang are supported for PGO."
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] ; then
		if tc-is-clang ; then
			append-cflags -fprofile-use="${BUILD_DIR}/custom-pgo.profdata"
			append-cxxflags -fprofile-use="${BUILD_DIR}/custom-pgo.profdata"
		elif tc-is-gcc ; then
			append-cflags -fprofile-use -fprofile-dir="${T}/${BUILD_DIR}"
			append-cxxflags -fprofile-use -fprofile-dir="${T}/${BUILD_DIR}"
		fi
	fi

	WK_USE_CCACHE=NO cmake_src_configure
}

_build_pgx() {
	if [[ ! -f build.ninja ]] ; then
		die "Missing build.ninja"
	fi
	eninja clean
	cmake_src_compile
}

_get_local_perf_path() {
	local u="${1}"
	case ${u} in
		wk_pgo_trainers_ares6)
			echo "${S}/PerformanceTests/ARES-6"
			;;
		wk_pgo_trainers_content-animation)
			echo "${S}/PerformanceTests/Animation"
			;;
		wk_pgo_trainers_dromaeo-cssquery)
			echo "${S}/PerformanceTests/Dromaeo"
			;;
		wk_pgo_trainers_dromaeo-dom)
			echo "${S}/PerformanceTests/Dromaeo"
			;;
		wk_pgo_trainers_dromaeo-jslib)
			echo "${S}/PerformanceTests/Dromaeo"
			;;
		wk_pgo_trainers_speedometer2)
			echo "${S}/PerformanceTests/Speedometer"
			;;
		wk_pgo_trainers_speedometer)
			die "Missing local copy speedometer"
			;;
		*)
			local found=0
			for t in ${PGO_LOCAL_COPY[@]} ; do
				[[ "${t}" != "${u}" ]] && continue
				if [[ "${t/wk_pgo_trainers_/}" == "${t,,}" ]] ; then
					echo "${S}/PerformanceTests/${t}"
					found=1
					break
				fi
			done
			if (( ${found} == 0 )) ; then
				die "Missing local copy for ${u/wk_pgo_trainers_/}"
			fi
			;;
	esac
}

_get_benchmark_plan() {
	local u="${1}"
	for p in ${PGO_PLANS[@]} ; do
		local t="${p,,}"
		t="${t/./_}"
		if [[ "${u}" == "wk_pgo_trainers_${t}" ]] ; then
			echo "--plan ${p}"
		fi
	done
}

_run_trainer() {
	if [[ ! -f "${BUILD_DIR}/minibrowser-gtk" ]] ; then
		die "Missing ${BUILD_DIR}/minibrowser-gtk"
	fi
	local train_with=()
	for p in ${PGO_USE_NORMALIZED[@]} ; do
		if use ${p} ; then
			train_with+=( ${p} )
		fi
	done
	export MESA_GLSL_CACHE_DIR="${HOME}/mesa_shader_cache" # \
	  # Prevent a sandbox violation and isolate between parallel running emerges.
	for t in ${train_with[@]} ; do
		einfo "Training with ${t/wk_pgo_trainers_/}"
		# See https://github.com/WebKit/WebKit/tree/9467df8e0134156fa95c4e654e956d8166a54a13/Tools/Scripts/webkitpy/benchmark_runner
		virtx ${EPYTHON} Tools/Scripts/webkitpy/benchmark_runner/run_benchmark.py \
			--build-directory "${BUILD_DIR}" \
			$(_get_benchmark_plan ${t}) \
			--local-copy $(_get_local_perf_path ${t}) \
			|| die
	done
	if use tc-is-clang ; then
		einfo "Merging PGO data to generate a PGO profile"
		if ! ls "${BUILD_DIR}/"*.profraw 2>/dev/null 1>/dev/null ; then
			die "Missing *.profraw files"
		fi
		llvm-profdata merge -output="${BUILD_DIR}/custom-pgo.profdata" \
			"${BUILD_DIR}" || die
	fi
}

multilib_src_compile() {
	if use pgo ; then
		PGO_PHASE="pgi"
		_config_pgx
		_build_pgx
		_run_trainer
		PGO_PHASE="pgo"
		_config_pgx
		_build_pgx
	else
		_config_pgx
		_build_pgx
	fi
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
}
