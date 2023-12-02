# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2009-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Monitor
#   https://chromereleases.googleblog.com/search/label/Dev%20updates
# for security updates.  They are announced faster than NVD.
# See https://chromiumdash.appspot.com/releases?platform=Linux for the latest linux version

EAPI=8

# CHROMIUM_EBUILD_MAINTAINER="1" # See also GEN_ABOUT_CREDITS

# Can't do 12 yet: heavy use of imp, among other things (bug #915001, bug #915062)
PYTHON_COMPAT=( python3_{9..11} )

PYTHON_REQ_USE="xml(+)"

# LANGS obtainable from:
# src="./build/config/locales.gni"
# s=$(grep -n "all_chrome_locales =" "${src}" | cut -f 1 -d ":") ; \
# f=$(grep -F -n "+ pseudolocales" "${src}" | cut -f 1 -d ":") ; \
# sed -ne "${s},${f}p" "${src}" \
#	| grep "\"" \
#	| cut -f 2 -d "\"" \
#	| tr "\n" " " \
#	| sed -E -e "s/(as|az|be|bs|cy|eu|fr-CA|gl|hy|is|ka|kk|km|ky|lo|mk|mn|my|ne|or|pa|si|sq|sr-Latn|uz|zh-HK|zu)[ ]?//g" \
#	| fold -s -w 80 \
#	| sed -e "s| $||g"

CHROMIUM_LANGS="
af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi hr
hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv sw ta
te th tr uk ur vi zh-CN zh-TW
"

# For depends see:
# https://github.com/chromium/chromium/tree/118.0.5993.117/build/linux/sysroot_scripts/generated_package_lists				; Last update Jun 12, 2023
# https://github.com/chromium/chromium/blob/118.0.5993.117/build/install-build-deps.py

#
# Additional DEPENDS versioning info:
#
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/dav1d/version/vcs_version.h#L2					; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/fontconfig/include/config.h#L290
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/libaom/source/config/config/aom_version.h#L19			; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/libpng/pnglibconf.h
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/libxml/linux/config.h#L160					; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/libxslt/linux/config.h#L116					; newer than generated_package_lists
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/node/update_node_binaries#L18
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/re2/README.chromium#L4						; older than generated_package_lists, (live)
# https://github.com/chromium/chromium/blob/118.0.5993.117/third_party/zlib/zlib.h#L40
# https://github.com/chromium/chromium/blob/118.0.5993.117/tools/rust/update_rust.py#L35							; commit
#   https://github.com/rust-lang/rust/blob/006a26c0b546abc0fbef59a773639582b641e500/src/version						; live version
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/flac/BUILD.gn			L122	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/freetype/src/CMakeLists.txt	L165	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/harfbuzz-ng/src/configure.ac	L3	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/icu/source/configure		L585	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/libdrm/src/meson.build		L24	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/libjpeg_turbo/jconfig.h		L7	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/libwebp/src/configure.ac		L1	; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/openh264/src/meson.build		L2
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/opus/README.chromium		L3	; newer than generated_package_lists, live
#   https://gitlab.xiph.org/xiph/opus/-/commit/8cf872a1											; see tag
# /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/third_party/zstd/README.chromium			; live version
#   https://github.com/facebook/zstd/commit/25822342be59d831bad65426ae51f5cc22157b09							; no tag
#   https://github.com/facebook/zstd/blob/25822342be59d831bad65426ae51f5cc22157b09/lib/zstd.h#L107					; version
#

# About PGO version compatibility
#
# The answer to the profdata compatibility is answered in
# https://clang.llvm.org/docs/SourceBasedCodeCoverage.html#format-compatibility-guarantees
#
# The profdata (aka indexed profile) version is 10 corresponding from LLVM 16+
# and is after the magic (lprofi - i for index) in the profdata file located in
# chrome/build/pgo_profiles/*.profdata.
#
# Profdata versioning:
# https://github.com/llvm/llvm-project/blob/0c545a44/llvm/include/llvm/ProfileData/InstrProf.h#L1024
# LLVM version:
# https://github.com/llvm/llvm-project/blob/0c545a44/llvm/CMakeLists.txt#L14

# LLVM 17
CR_CLANG_USED="0c545a44" # Obtained from \
# https://github.com/chromium/chromium/blob/118.0.5993.117/tools/clang/scripts/update.py#L42 \
# https://github.com/llvm/llvm-project/commit/0c545a44
CR_CLANG_USED_UNIX_TIMESTAMP="1688123657" # Cached.  Use below to obtain this. \
# TIMESTAMP=$(wget -q -O - https://github.com/llvm/llvm-project/commit/${CR_CLANG_USED}.patch \
#	| grep -F -e "Date:" | sed -e "s|Date: ||") ; date -u -d "${TIMESTAMP}" +%s
# Change also CR_CLANG_SLOT_OFFICIAL

FFMPEG_LIBAVUTIL_SOVER="58.14.100" # third_party/ffmpeg/libavutil/version.h
FFMPEG_LIBAVCODEC_SOVER="60.22.100" # third_party/ffmpeg/libavcodec/version*.h
FFMPEG_LIBAVFORMAT_SOVER="60.10.100" # third_party/ffmpeg/libavformat/version*.h
FFMPEG_PV="6.0" # It should be 9999 but relaxed.  ; They don't use a tagged version.
FFMPEG_SUBSLOT="$(ver_cut 1 ${FFMPEG_LIBAVUTIL_SOVER}).$(ver_cut 1 ${FFMPEG_LIBAVCODEC_SOVER}).$(ver_cut 1 ${FFMPEG_LIBAVFORMAT_SOVER})"
GCC_PV="10.2.1" # Minimum
GCC_SLOTS=( 14 13 12 11 10 )
GTK3_PV="3.24.24"
GTK4_PV="4.8.3"
LIBVA_PV="2.17.0"
LLVM_MAX_SLOT=17 # Same slot listed in https://github.com/chromium/chromium/blob/118.0.5993.117/tools/clang/scripts/update.py#L42
LLVM_MIN_SLOT=17 # The pregenerated PGO profile needs profdata index version 10.
PREGENERATED_PGO_PROFILE_MIN_LLVM_SLOT=17
LLVM_SLOTS=( ${LLVM_MAX_SLOT} ${LLVM_MIN_SLOT} ) # [inclusive, inclusive] high to low
MESA_PV="20.3.5"
QT5_PV="5.15.2"
QT6_PV="6.4.2"
UOPTS_PGO_PV=$(ver_cut 1-3 ${PV})
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0
ZLIB_PV="1.2.13"

# LLVM compatibility is based on libcxx which is
# 1 +- CR_CLANG_SLOT_OFFICIAL
CR_CLANG_SLOT_OFFICIAL=${LLVM_MAX_SLOT}

# For PGO
PGO_LLVM_SUPPORTED_VERSIONS=(
	"${CR_CLANG_SLOT_OFFICIAL}.0.0.9999"
	"${CR_CLANG_SLOT_OFFICIAL}.0.0"
	"18.0.0.9999"
	"17.0.3.9999"
	"17.0.3"
	"17.0.2"
	"17.0.1"
	"17.0.0"
)

inherit check-reqs chromium-2 desktop flag-o-matic ninja-utils pax-utils
inherit python-any-r1 qmake-utils readme.gentoo-r1 toolchain-funcs xdg-utils

# Added by the oiledmachine-overlay
inherit check-linker flag-o-matic-om lcnr llvm multilib multilib-minimal uopts
inherit cflags-depends

DESCRIPTION="The open-source version of the Chrome web browser"
HOMEPAGE="https://www.chromium.org/"

PATCHSET_PPC64="118.0.5993.70-1raptor0~deb11u1"
PATCH_VER="${PV%%\.*}-2"

SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.xz
	https://gitlab.com/Matt.Jolly/chromium-patches/-/archive/${PATCH_VER}/chromium-patches-${PATCH_VER}.tar.bz2
	ppc64? (
		https://quickbuild.io/~raptor-engineering-public/+archive/ubuntu/chromium/+files/chromium_${PATCHSET_PPC64}.debian.tar.xz
		https://deps.gentoo.zip/chromium-ppc64le-gentoo-patches-1.tar.xz
	)
"
RESTRICT="mirror"

#
# emerge does not understand ^^ in the LICENSE variable and have been replaced
# with ||.  You should choose at most one at some instances.

#
# Uncomment below to generate an about_credits.html including bundled internal
# dependencies.
#
# GEN_ABOUT_CREDITS=1
#

# SHA512 about_credits.html fingerprint:
#
LICENSE_FINGERPRINT="\
167a4093663a8a25698a2a86de549b1e8f212b9d3e13f2b5a65e032f22e3925e\
3a84953a69bbc914fb989d045ae1af68984caf9225db806335970990fd635475\
"
LICENSE="
	BSD
	chromium-$(ver_cut 1-3 ${PV}).x
	custom
	(
		all-rights-reserved
		MIT
	)
	(
		CC-BY-SA-4.0
		ISC
	)
	(
		CC0-1.0
		MIT
	)
	(
		all-rights-reserved
		HPND
	)
	APSL-2
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	Boost-1.0
	BSD-2
	BSD-4
	base64
	CC0-1.0
	CC-BY-3.0
	CC-BY-4.0
	CC-BY-ND-2.5
	FLEX
	FTL
	fft2d
	GPL-2+
	g711
	g722
	HPND
	icu
	IJG
	ILA-OpenCV
	ISC
	Khronos-CLHPP
	LGPL-2
	LGPL-2+
	LGPL-2.1+
	libpng2
	libwebrtc-PATENTS
	MIT
	MPL-1.1
	MPL-2.0
	neon_2_sse
	OFL-1.1
	ooura
	openssl
	PSF-2.4
	QU-fft
	Unlicense
	UoI-NCSA
	unRAR
	unicode
	Unicode-DFS-2016
	SGI-B-2.0
	sigslot
	SunPro
	svgo
	trio
	W3C
	W3C-Document-License-2002
	WTFPL-2
	x11proto
	ZLIB
	widevine? (
		widevine
	)
	|| (
		MPL-1.1
		GPL-2
		LGPL-2.1
	)
	|| (
		(
			MPL-2.0
			GPL-2+
		)
		(
			MPL-2.0
			LGPL-2.1+
		)
		MPL-2.0
		GPL-2.0+
	)
"
#
# Benchmark website licenses:
# See the webkit-gtk ebuild
#
# BSD-2 BSD LGPL-2.1 - Kraken benchmark
#   ( ( all-rights-reserved || ( MIT AFL-2.1 ) ) (MIT GPL) BSD MIT )
#   ( all-rights-reserved GPL-3+ ) tests/kraken-1.0/audio-beat-detection-data.js
#   MPL-1.1 tests/kraken-1.0/imaging-desaturate.js
#   public-domain hosted/json2.js
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ )
#   || ( BSD GPL-2 ) ; for SJCL

# Third Party Licenses:
#
# TODO:  The rows marked custom need to have or be placed a license file or
#        reevaluated.
# TODO:  scan all font files for embedded licenses
#
# APSL-2 - third_party/apple_apsl/LICENSE
# APSL-2 Apache-2.0 BSD MIT - third_party/breakpad/LICENSE
# Apache-2.0 - CIPD - https://chromium.googlesource.com/infra/luci/luci-go/+/refs/heads/main/cipd
# Apache-2.0 - third_party/node/node_modules/typescript/LICENSE.txt
# Apache-2.0-with-LLVM-exceptions UoI-NCSA - \
#   third_party/llvm/debuginfo-tests/dexter/LICENSE.txt
# Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT - third_party/llvm/libclc/LICENSE.TXT
# all-rights-reserved MIT - third_party/xcbproto/LICENSE ; the plain MIT \
#   license doesn't come with all rights reserved in the license template
# BSD - third_party/vulkan-deps/glslang/src/LICENSE.txt
# BSD || ( MPL-1.1 GPL-2+ LGPL-2+ ) - \
#   third_party/openscreen/src/third_party/mozilla/LICENSE.txt
# BSD CC-BY-3.0 CC-BY-4.0 MIT public-domain - third_party/snappy/src/COPYING
# BSD HPND (modified) - native_client_sdk/src/libraries/third_party/newlib-extras/netdb.h
# BSD ISC MIT openssl - third_party/boringssl/src/LICENSE
# BSD || ( MPL-1.1 GPL-2+ LGPL-2+ ) - url/third_party/mozilla/LICENSE.txt
# BSD-2 - third_party/node/node_modules/eslint-scope/LICENSE
# BSD-2 IJG MIT - third_party/libavif/src/LICENSE
# BSD-2 - third_party/libaom/source/libaom/LICENSE
# base64 - third_party/webrtc/rtc_base/third_party/base64/LICENSE
# custom - out/Release/gen/components/resources/about_credits.html [Same as chromium-111.0.5563.x file]
#   keyword search: "venue in the state and federal courts"
# custom - third_party/llvm/clang-tools-extra/clang-tidy/cert/LICENSE.TXT
# custom - third_party/llvm/clang-tools-extra/clang-tidy/hicpp/LICENSE.TXT
# custom ^^ ( BSD-2 BSD ) - third_party/blink/LICENSE_FOR_ABOUT_CREDITS
# custom Apache-2.0-with-LLVM-exceptions UoI-NCSA third_party/llvm/openmp/LICENSE.TXT
# custom CC-BY-ND-2.5 LGPL-2.1+ GPL-2+ public-domain - \
#   third_party/blink/perf_tests/svg/resources/LICENSES
# custom BSD APSL-2 MIT BSD-4 - third_party/breakpad/breakpad/LICENSE
# custom Boost-1.0 BSD BSD-2 BSD-4 gcc-runtime-library-exception-3.1 FDL-1.1 \
#   GPL-2 GPL-2+ GPL-2-with-classpath-exception GPL-3 HPND icu LIBGLOSS LGPL-2
#   LGPL-2.1 LGPL-2.1+ LGPL-3 MIT NEWLIB PSF-2.4 rc UoI-NCSA ZLIB \
#   || ( MPL-1.1 GPL-2.0+ LGPL-2.1+ ) - native_client/NOTICE
#   NSIS: BZIP2 CPL-1.0 libpng ZLIB
#   (Some third_party modules do not exist like NSIS)
# custom, W3C-IPR, BSD, MIT, GPL-2, LPGL-2.1, PSF-2.4, BSD-2, SunPro, \
#   GPL-2+, ZLIB, LGPL-2.1+, NEWLIB, LIBGLOSS, GPL-2-with-classpath-exception, \
#   SAX-PD, GPL-2-with-classpath-exception, UoI-NCSA, FDL-1.1, Boost-1.0, \
#   CPL-1.0, BZIP2, ZLIB, LGPL-3, GPL-3, gcc-runtime-library-exception-3.1, \
#   W3C-SOFTWARE-NOTICE-AND-LICENSE-2004 (LICENSE.DOM), HPND, BSD-4, \
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ ),    - native_client/NOTICE \
#   Not all folders present so not all licenses will apply.
# custom IJG - third_party/iccjpeg/LICENSE
# custom MPL-2.0 BSD GPL-3 LGPL-3 Apache-1.1 - \
#   third_party/tflite/src/third_party/eigen3/LICENSE ; Only MPL-2.0 files are \
#   found
# custom UoI-NCSA - third_party/llvm/llvm/include/llvm/Support/LICENSE.TXT
# custom public-domain - third_party/sqlite/LICENSE
# CC-BY-3.0 https://peach.blender.org/download/ # avi is mp4 and h264 is mov
#   (c) copyright 2008, Blender Foundation / www.bigbuckbunny.org
# CC-BY-4.0 - third_party/devtools-frontend/src/node_modules/caniuse-lite/LICENSE
# CC0-1.0 - tools/perf/page_sets/trivial_sites/trivial_fullscreen_video.html
# fft2d - third_party/tflite/src/third_party/fft2d/LICENSE
# g711 - third_party/webrtc/modules/third_party/g711/LICENSE
# g722 - third_party/webrtc/modules/third_party/g722/LICENSE
# GPL-2 - third_party/freetype-testing/LICENSE
# GPL-2+ - third_party/devscripts/licensecheck.pl.vanilla
# HPND PSF-2.4 - v8/third_party/v8/builtins/LICENSE
# ILA-OpenCV (BSD with additional clauses) - third_party/opencv/src/LICENSE
# icu Unicode-DFS-2016 - base/third_party/icu/LICENSE
# ISC - third_party/node/node_modules/rimraf/LICENSE
# ISC - third_party/libaom/source/libaom/third_party/x86inc/LICENSE
# ISC CC-BY-SA-4.0 - third_party/node/node_modules/glob/LICENSE ; no logo \
#   image file found
# ISC MIT - third_party/devtools-frontend/src/node_modules/rollup/LICENSE.md
# Khronos-CLHPP - third_party/vulkan-deps/spirv-headers/src/LICENSE
# LGPL-2 - third_party/blink/renderer/core/LICENSE-LGPL-2
#   third_party/blink/renderer/core/layout/table_layout_algorithm.h
# LGPL-2+ - third_party/blink/renderer/core/svg/svg_set_element.h
# LGPL-2.1 - third_party/blink/renderer/core/LICENSE-LGPL-2.1 ; cannot find a \
#   file that is 2.1 only
# LGPL-2.1+ - third_party/blink/renderer/core/paint/paint_layer.h
# LGPL-2.1+ - third_party/libsecret/LICENSE
# libpng2 - third_party/pdfium/third_party/libpng16/LICENSE
# MIT CC0-1.0 - third_party/node/node_modules/eslint/node_modules/lodash/LICENSE
# MIT SGI-B-2.0 - third_party/khronos/LICENSE
# MIT Unicode-DFS-2016 CC-BY-4.0 W3C W3C-Community-Final-Specification-Agreement - third_party/node/node_modules/typescript/ThirdPartyNoticeText.txt
# MPL-2.0 - third_party/node/node_modules/mdn-data/LICENSE
# neon_2_sse - third_party/neon_2_sse/LICENSE
# OFL-1.1 - third_party/freetype-testing/src/fuzzing/corpora/cff-render-ftengine/bungeman/HangingS.otf
# ooura - third_party/webrtc/common_audio/third_party/ooura/LICENSE
# PATENTS - third_party/dav1d/libdav1d/doc/PATENTS
# PATENTS - third_party/libaom/source/libaom/PATENTS
# PATENTS - third_party/libaom/source/libaom/third_party/libwebm/PATENTS.TXT
# PATENTS - third_party/libjxl/src/PATENTS
# PATENTS - third_party/libvpx/source/libvpx/PATENTS
# PATENTS - third_party/libvpx/source/libvpx/third_party/libwebm/PATENTS.TXT
# PATENTS - third_party/libwebm/source/PATENTS.TXT
# PATENTS - third_party/libwebp/src/PATENTS
# PATENTS - third_party/libyuv/PATENTS
# PATENTS - third_party/webrtc/PATENTS
# public-domain - third_party/lzma_sdk/LICENSE
# public-domain with no warranty - third_party/pdfium/third_party/bigint/LICENSE
# public-domain - \
#   third_party/webrtc/common_audio/third_party/spl_sqrt_floor/LICENSE
# PSF-2 - third_party/devtools-frontend/src/node_modules/mocha/node_modules/argparse/LICENSE
# QU-fft - third_party/webrtc/modules/third_party/fft/LICENSE
# sigslot - third_party/webrtc/rtc_base/third_party/sigslot/LICENSE
# SunPro - third_party/fdlibm/LICENSE
# svgo (with russian MIT license translation) - \
#   third_party/node/node_modules/svgo/LICENSE
# Unlicense Apache-2.0 - \
#   third_party/devtools-frontend/src/node_modules/@sinonjs/text-encoding/LICENSE.md
# unicode [3 clause DFS] - third_party/icu4j/LICENSE
# Unicode-DFS-2016 [2 clause DFS] - third_party/cldr/LICENSE
# unRAR - third_party/unrar/LICENSE
# UoI-NCSA - third_party/swiftshader/third_party/llvm-subzero/LICENSE.TXT
# W3C-Document-License-2002, MIT, Unicode-DFS-2016, CC-BY-4.0, W3C-Community-Final-Specification-Agreement - third_party/node/node_modules/typescript/ThirdPartyNoticeText.txt
# widevine - third_party/widevine/LICENSE
# WTFPL BSD-2 - third_party/catapult/third_party/polymer2/bower_components/sinon-chai/LICENSE.txt
# x11proto - third_party/x11proto/LICENSE
# ^^ ( FTL GPL-2 ) ZLIB public-domain - third_party/freetype/src/LICENSE.TXT
# || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) - chrome/utility/importer/nss_decryptor.cc
# || ( WTFPL-2 Apache-2.0 ) - \
#   third_party/catapult/third_party/polymer2/bower_components/sinon-chai/LICENSE.txt ; \
#   the WTFPL is the better choice because Apache-2.0 has more restrictions
# || ( MIT GPL-3 ) third_party/catapult/tracing/third_party/jszip/LICENSE.markdown ; \
#   upstream has more MIT than GPL3 copyright notices, so MIT is assumed
# * The public-domain entry was not added to the LICENSE ebuild variable to not
#   give the wrong impression that the entire software was released in public
#   domain.
#
SLOT="0/stable"
KEYWORDS="amd64 arm64 ~ppc64"
#
# vaapi is enabled by default upstream for some arches \
# See https://github.com/chromium/chromium/blob/118.0.5993.117/media/gpu/args.gni#L24
#
# Using the system-ffmpeg or system-icu breaks cfi-icall or cfi-cast which is
#   incompatible as a shared lib.
#
# The suid is built by default upstream but not necessarily used:  \
#   https://github.com/chromium/chromium/blob/118.0.5993.117/sandbox/linux/BUILD.gn
#
CPU_FLAGS_ARM=(
	neon
)
CPU_FLAGS_X86=(
	avx2
	sse2
	ssse3
	sse4_2
)
IUSE_LIBCXX=(
	bundled-libcxx
	system-libstdcxx
)
# CFI Basic (.a) mode requires all third party modules built as static.

# Option defaults based on build files.
IUSE_CODECS="
+dav1d
+openh264
+opus
+libaom
+vpx
+vaapi-hevc
+vorbis
"

# Option defaults based on build files.
IUSE="
${CPU_FLAGS_ARM[@]/#/cpu_flags_arm_}
${CPU_FLAGS_X86[@]/#/cpu_flags_x86_}
${IUSE_CODECS}
${IUSE_LIBCXX[@]}
bluetooth +bundled-libcxx branch-protection +cfi +cups -debug
+encode -gtk4 -hangouts -headless +js-type-check +kerberos +official pax-kernel
pic +pgo +pre-check-vaapi +proprietary-codecs proprietary-codecs-disable
proprietary-codecs-disable-nc-developer proprietary-codecs-disable-nc-user
+pulseaudio qt5 qt6 +screencast selinux -system-dav1d +system-ffmpeg
-system-flac -system-fontconfig -system-freetype -system-harfbuzz -system-icu
-system-libaom -system-libdrm -system-libjpeg-turbo -system-libpng
-system-libwebp -system-libxml -system-libxslt -system-openh264 -system-opus
-system-re2 -system-zlib +system-zstd +thinlto-opt +vaapi +wayland -widevine +X

r1
"

# What is considered a proprietary codec can be found at:
#
#   https://github.com/chromium/chromium/blob/118.0.5993.117/media/filters/BUILD.gn#L160
#   https://github.com/chromium/chromium/blob/118.0.5993.117/media/media_options.gni#L38
#   https://github.com/chromium/chromium/blob/118.0.5993.117/media/base/supported_types.cc#L203
#   https://github.com/chromium/chromium/blob/118.0.5993.117/media/base/supported_types.cc#L284
#
# Codec upstream default:
#   https://github.com/chromium/chromium/blob/118.0.5993.117/tools/mb/mb_config_expectations/chromium.linux.json#L89
#

#
# For cfi-vcall, cfi-icall defaults status, see \
#   https://github.com/chromium/chromium/blob/118.0.5993.117/build/config/sanitizers/sanitizers.gni
# For cfi-cast default status, see \
#   https://github.com/chromium/chromium/blob/118.0.5993.117/build/config/sanitizers/sanitizers.gni#L123
# For pgo default status, see \
#   https://github.com/chromium/chromium/blob/118.0.5993.117/build/config/compiler/pgo/pgo.gni#L15
# For libcxx default, see \
#   https://github.com/chromium/chromium/blob/118.0.5993.117/build/config/c++/c++.gni#L14
# For cdm availability see third_party/widevine/cdm/widevine.gni#L28
#

#
# vaapi is not conditioned on proprietary-codecs upstream, but should
# be or by case-by-case (i.e. h264_vaapi, vp9_vaapi, av1_vaapi)
# with additional USE flags.
# The system-ffmpeg comes with aac which is unavoidable.  This is why
# there is a block with !proprietary-codecs.
# cfi-icall, cfi-cast requires static linking.  See
#   https://clang.llvm.org/docs/ControlFlowIntegrity.html#indirect-function-call-checking
#   https://clang.llvm.org/docs/ControlFlowIntegrity.html#bad-cast-checking
#
DISABLED_NON_FREE_USE_FLAGS="
	^^ (
		proprietary-codecs
		proprietary-codecs-disable
		proprietary-codecs-disable-nc-developer
		proprietary-codecs-disable-nc-user
	)
	openh264? (
		proprietary-codecs
	)
	proprietary-codecs-disable? (
		!openh264
		!vaapi-hevc
		!widevine
		system-ffmpeg
	)
	proprietary-codecs-disable-nc-developer? (
		!openh264
		!vaapi-hevc
		!widevine
		system-ffmpeg
	)
	proprietary-codecs-disable-nc-user? (
		!openh264
		!vaapi-hevc
		!widevine
		system-ffmpeg
	)
	vaapi-hevc? (
		proprietary-codecs
	)
	widevine? (
		proprietary-codecs
	)
"

# Unconditionals
# Retesting disablement
DISTRO_REQUIRE_USE="
	system-flac
	system-fontconfig
	system-freetype
	-system-harfbuzz
	system-libdrm
	system-libjpeg-turbo
	system-libwebp
	system-libxml
	system-libxslt
	system-openh264
	system-zlib
"

REQUIRED_USE+="
	${DISABLED_NON_FREE_USE_FLAGS}
	!headless (
		|| (
			wayland
			X
		)
	)
	^^ (
		${IUSE_LIBCXX[@]}
	)
	branch-protection? (
		arm64
	)
	cfi? (
		!system-dav1d
		!system-ffmpeg
		!system-flac
		!system-fontconfig
		!system-harfbuzz
		!system-icu
		!system-libaom
		!system-libdrm
		!system-libjpeg-turbo
		!system-libpng
		!system-libstdcxx
		!system-libwebp
		!system-libxml
		!system-libxslt
		!system-openh264
		!system-opus
		!system-re2
		!system-zlib
		!system-zstd
		bundled-libcxx
	)
	epgo? (
		!pgo
	)
	official? (
		!amd64? (
			!cfi
		)
		!debug
		!epgo
		!hangouts
		!system-dav1d
		!system-ffmpeg
		!system-flac
		!system-fontconfig
		!system-harfbuzz
		!system-icu
		!system-libaom
		!system-libdrm
		!system-libjpeg-turbo
		!system-libpng
		!system-libstdcxx
		!system-libwebp
		!system-libxml
		!system-libxslt
		!system-openh264
		!system-opus
		!system-re2
		!system-zlib
		!system-zstd
		bundled-libcxx
		dav1d
		cups
		encode
		kerberos
		libaom
		openh264
		opus
		pgo
		proprietary-codecs
		screencast
		thinlto-opt
		vaapi
		vaapi-hevc
		vorbis
		vpx
		wayland
		X
		amd64? (
			pulseaudio
			cfi
		)
		arm64? (
			branch-protection
		)
	)
	pgo? (
		!epgo
	)
	pre-check-vaapi? (
		vaapi
	)
	screencast? (
		wayland
	)
	system-libstdcxx? (
		!cfi
	)
	vaapi-hevc? (
		vaapi
	)
	widevine? (
		!arm64
		!ppc64
	)
"

LIBVA_DEPEND="
	vaapi? (
		>=media-libs/libva-${LIBVA_PV}:=[${MULTILIB_USEDEP},drm(+),wayland?,X?]
		media-libs/vaapi-drivers[${MULTILIB_USEDEP}]
		system-ffmpeg? (
			media-video/ffmpeg:0/${FFMPEG_SUBSLOT}[${MULTILIB_USEDEP},vaapi]
		)
	)
"

gen_depend_llvm() {
	local o_all=""
	local t=""
	local o_official=""
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		t="
			!official? (
				cfi? (
					=sys-libs/compiler-rt-sanitizers-${s}*:=[${MULTILIB_USEDEP},cfi]
				)
			)
			=sys-libs/compiler-rt-${s}*:=
			=sys-devel/clang-runtime-${s}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/lld:${s}
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			epgo? (
				=sys-libs/compiler-rt-sanitizers-${s}*:=[${MULTILIB_USEDEP},profile]
			)
			official? (
				amd64? (
					=sys-libs/compiler-rt-sanitizers-${s}*:=[${MULTILIB_USEDEP},cfi,profile]
				)
			)
		"
		o_all+="
			(
				${t}
			)
		"
		(( ${s} == ${CR_CLANG_SLOT_OFFICIAL} )) && o_official=" ${t} "
	done
	echo -e "
		official? (
			${o_official}
		)
		|| (
			${o_all}
		)
	"
}

COMMON_X_DEPEND="
	>=x11-libs/libXi-1.7.10:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXcomposite-0.4.5:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXcursor-1.2.0:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXdamage-1.1.5:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXfixes-5.0.3:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXrandr-1.5.1:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.10:=[${MULTILIB_USEDEP}]
	>=x11-libs/libxshmfence-1.3:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXtst-1.2.3:=[${MULTILIB_USEDEP}]
"

COMMON_SNAPSHOT_DEPEND="
	!headless? (
		${LIBVA_DEPEND}
		>=dev-libs/glib-2.66.8:2[${MULTILIB_USEDEP}]
		>=media-libs/alsa-lib-1.2.4:=[${MULTILIB_USEDEP}]
		>=sys-apps/pciutils-3.7.0:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-1.0.3:=[${MULTILIB_USEDEP}]
		kerberos? (
			virtual/krb5[${MULTILIB_USEDEP}]
		)
		pulseaudio? (
			>=media-libs/libpulse-14.2:=[${MULTILIB_USEDEP}]
		)
		vaapi? (
			>=media-libs/libva-${LIBVA_PV}:=[${MULTILIB_USEDEP},wayland?,X?]
		)
		wayland? (
			>=dev-libs/libffi-3.3:=[${MULTILIB_USEDEP}]
			>=dev-libs/wayland-1.18.0[${MULTILIB_USEDEP}]
			screencast? (
				>=media-video/pipewire-0.3.65:=[${MULTILIB_USEDEP}]
			)
		)
		X? (
			>=x11-libs/libX11-1.7.2:=[${MULTILIB_USEDEP}]
			>=x11-libs/libxcb-1.14:=[${MULTILIB_USEDEP}]
			>=x11-libs/libXext-1.3.3:=[${MULTILIB_USEDEP}]
		)
	)
	>=dev-libs/nss-3.61:=[${MULTILIB_USEDEP}]
	>=dev-libs/nspr-4.29:=[${MULTILIB_USEDEP}]
	>=media-libs/mesa-${MESA_PV}:=[${MULTILIB_USEDEP},gbm(+)]
	proprietary-codecs? (
		system-openh264? (
			>=media-libs/openh264-2.3.0:=[${MULTILIB_USEDEP}]
		)
	)
	system-dav1d? (
		>=media-libs/dav1d-1.2.0:=[${MULTILIB_USEDEP},8bit]
	)
	system-fontconfig? (
		>=media-libs/fontconfig-2.14.2:=[${MULTILIB_USEDEP}]
	)
	system-freetype? (
		>=media-libs/freetype-2.13.2:=[${MULTILIB_USEDEP}]
	)
	system-harfbuzz? (
		>=media-libs/harfbuzz-7.3.0:0=[${MULTILIB_USEDEP},icu(-)]
	)
	system-icu? (
		>=dev-libs/icu-73.1:=[${MULTILIB_USEDEP}]
	)
	system-libaom? (
		>=media-libs/libaom-3.6.1:=[${MULTILIB_USEDEP}]
	)
	system-libdrm? (
		>=x11-libs/libdrm-2.4.115:=[${MULTILIB_USEDEP}]
	)
	system-libjpeg-turbo? (
		>=media-libs/libjpeg-turbo-2.1.5.1:=[${MULTILIB_USEDEP}]
	)
	system-libpng? (
		>=media-libs/libpng-1.6.37:=[${MULTILIB_USEDEP},-apng]
	)
	system-libwebp? (
		>=media-libs/libwebp-1.3.1:=[${MULTILIB_USEDEP}]
	)
	system-libxml? (
		>=dev-libs/libxml2-2.12.0:=[${MULTILIB_USEDEP},icu]
	)
	system-libxslt? (
		>=dev-libs/libxslt-1.1.38:=[${MULTILIB_USEDEP}]
	)
	system-re2? (
		>=dev-libs/re2-0.2023.06.01:=[${MULTILIB_USEDEP}]
	)
	system-zlib? (
		>=sys-libs/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}]
	)
	system-zstd? (
		>=app-arch/zstd-1.5.5:=[${MULTILIB_USEDEP}]
	)
"

# No multilib for this virtual/udev when it should be.
VIRTUAL_UDEV="
	|| (
		>=sys-apps/systemd-252.5[${MULTILIB_USEDEP}]
		>=sys-fs/udev-252.5[${MULTILIB_USEDEP}]
		>=sys-fs/eudev-2.1.1[${MULTILIB_USEDEP}]
	)
"

COMMON_DEPEND="
	!headless? (
		${VIRTUAL_UDEV}
		>=app-accessibility/at-spi2-core-2.44.1:2[${MULTILIB_USEDEP}]
		>=media-libs/mesa-${MESA_PV}:=[${MULTILIB_USEDEP},wayland?,X?]
		>=x11-libs/cairo-1.16.0:=[${MULTILIB_USEDEP}]
		>=x11-libs/gdk-pixbuf-2.42.2:2[${MULTILIB_USEDEP}]
		>=x11-libs/pango-1.46.2:=[${MULTILIB_USEDEP}]
		cups? (
			>=net-print/cups-2.3.3:=[${MULTILIB_USEDEP}]
		)
		qt5? (
			>=dev-qt/qtcore-${QT5_PV}:5
			>=dev-qt/qtwidgets-${QT5_PV}:5[X?]
		)
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:6[widgets,X?]
		)
		X? (
			${COMMON_X_DEPEND}
		)
	)
	${COMMON_SNAPSHOT_DEPEND}
	>=dev-libs/expat-2.2.10:=[${MULTILIB_USEDEP}]
	>=net-misc/curl-7.88.1[${MULTILIB_USEDEP},ssl]
	>=sys-apps/dbus-1.12.24:=[${MULTILIB_USEDEP}]
	>=sys-devel/gcc-${GCC_PV}
	>=sys-libs/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP},minizip]
	app-arch/bzip2:=[${MULTILIB_USEDEP}]
	virtual/libc
	bluetooth? (
		>=net-wireless/bluez-5.55[${MULTILIB_USEDEP}]
	)
	system-ffmpeg? (
		system-opus? (
			>=media-libs/opus-1.4:=[${MULTILIB_USEDEP}]
		)
		proprietary-codecs? (
			media-video/ffmpeg:0/${FFMPEG_SUBSLOT}[${MULTILIB_USEDEP},encode?,opus?,vorbis?,vpx?]
		)
		proprietary-codecs-disable? (
			media-video/ffmpeg:0/${FFMPEG_SUBSLOT}[${MULTILIB_USEDEP},-amr,-cuda,encode?,-fdk,-kvazaar,-openh264,opus?,proprietary-codecs-disable,vaapi?,vorbis?,vpx?,-x264,-x265,-xvid]
		)
		proprietary-codecs-disable-nc-developer? (
			media-video/ffmpeg:0/${FFMPEG_SUBSLOT}[${MULTILIB_USEDEP},-amr,-cuda,encode?,-fdk,-kvazaar,-openh264,opus?,proprietary-codecs-disable-nc-developer,vaapi?,vorbis?,vpx?,-x264,-x265,-xvid]
		)
		proprietary-codecs-disable-nc-user? (
			media-video/ffmpeg:0/${FFMPEG_SUBSLOT}[${MULTILIB_USEDEP},-amr,-cuda,encode?,-fdk,-kvazaar,-openh264,opus?,proprietary-codecs-disable-nc-user,vaapi?,vorbis?,vpx?,-x264,-x265,-xvid]
		)
		|| (
			media-video/ffmpeg:0/${FFMPEG_SUBSLOT}[${MULTILIB_USEDEP},-samba]
			>=net-fs/samba-4.5.10-r1[${MULTILIB_USEDEP},-debug(-)]
		)
	)
	system-flac? (
		>=media-libs/flac-1.4.2:=[${MULTILIB_USEDEP}]
	)
"
CLANG_RDEPEND="
	bundled-libcxx? (
		$(gen_depend_llvm)
	)
	cfi? (
		$(gen_depend_llvm)
	)
	official? (
		$(gen_depend_llvm)
	)
"
RDEPEND+="
	!headless? (
		qt5? (
			>=dev-qt/qtgui-${QT5_PV}:5[wayland?,X?]
		)
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:6[gui,wayland?,X?]
			wayland? (
				>=dev-qt/qtdeclarative-${QT6_PV}:6[opengl]
				>=dev-qt/qtwayland-${QT6_PV}:6
			)
		)
		|| (
			>=gui-libs/gtk-${GTK4_PV}:4[wayland?,X?]
			>=x11-libs/gtk+-${GTK3_PV}:3[${MULTILIB_USEDEP},wayland?,X?]
		)
	)
	${COMMON_DEPEND}
	${CLANG_RDEPEND}
	virtual/ttf-fonts
	selinux? (
		sec-policy/selinux-chromium
	)
"
DEPEND+="
	!headless? (
		!gtk4? (
			>=x11-libs/gtk+-${GTK3_PV}:3[${MULTILIB_USEDEP},wayland?,X?]
		)
		gtk4? (
			>=gui-libs/gtk-${GTK4_PV}:4[wayland?,X?]
		)
	)
	${COMMON_DEPEND}
"
CLANG_BDEPEND="
	bundled-libcxx? (
		$(gen_depend_llvm)
	)
	cfi? (
		$(gen_depend_llvm)
	)
	official? (
		$(gen_depend_llvm)
	)
	pgo? (
		$(gen_depend_llvm)
	)
	thinlto-opt? (
		$(gen_depend_llvm)
	)
"
# Upstream uses live rust.  Rust version is relaxed.
BDEPEND+="
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	${CLANG_BDEPEND}
	${COMMON_SNAPSHOT_DEPEND}
	${PYTHON_DEPS}
	>=app-arch/gzip-1.7
	>=dev-util/gn-0.2114
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=net-libs/nodejs-16.13.0[inspector]
	>=sys-devel/bison-2.4.3
	>=virtual/rust-1.72.0[${MULTILIB_USEDEP}]
	dev-lang/perl
	dev-vcs/git
	sys-devel/flex[${MULTILIB_USEDEP}]
	vaapi? (
		media-video/libva-utils
	)
"

# One of the major sources of lag comes from dependencies
# These are strict to match performance to competition or normal builds.
declare -A CFLAGS_RDEPEND=(
	["media-libs/dav1d"]=">=;-O2" # -O0 skippy, -O1 faster but blurry, -Os blurry still, -O2 not blurry
)

# Upstream uses llvm:16
# When CFI + PGO + official was tested, it didn't work well with LLVM12.  Error noted in
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/f0c13049dc89f068370511b4664f7fb111df2d3a/www-client/chromium/bug_notes
# This is why LLVM13 was set as the minimum and did fix the problem.

# For the current llvm for this project, see
#   https://github.com/chromium/chromium/blob/118.0.5993.117/tools/clang/scripts/update.py#L42
# Use the same clang for official USE flag because of older llvm bugs which
#   could result in security weaknesses (explained in the llvm:12 note below).
# Used llvm >= 12 for arm64 for the same reason in the Linux kernel CFI comment.
#   Links below from https://github.com/torvalds/linux/commit/cf68fffb66d60d96209446bfc4a15291dc5a5d41
#     https://bugs.llvm.org/show_bug.cgi?id=46258
#     https://bugs.llvm.org/show_bug.cgi?id=47479
# To confirm the hash version match for the reported by CR_CLANG_REVISION, see
#   https://github.com/llvm/llvm-project/blob/98033fdc/llvm/CMakeLists.txt

# The preference now is CFI Cross-DSO if one prefers unbundled libs.
# CFI Cross-DSO is preferred to reduce duplicate pages at the cost of some
# security usually cfi-icall.  This is why CFI Basic mode (.a) is preferred
# and better security quality because cfi-icall is less buggy.  Using
# CFI Basic mode require more ebuild modding to isolate both .so/.a
# builds for -fvisibility changes.  Most ebuilds combine both, so for now
# only CFI Cross-DSO is the only practical recourse.

# Some libs here cannot be CFIed in @system due to IR incompatibility because
# gcc cannot use LLVM bitcode in .a files.  This is why the internal zlib is
# preferred over systemwide zlib in systems without CFI hardware implementation.

# Some require CFI flags because they support both CFI Cross-DSO mode (.so) and
# CFI Basic mode (.a).  Some should have the CFI flag so that CFI packages
# are properly prioritized in *DEPENDs to avoid missing symbols problems.

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS} ; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="

Some web pages may require additional fonts to display properly.  Try installing
some of the following packages if some characters are not displayed properly:

  - media-fonts/arphicfonts
  - media-fonts/droid
  - media-fonts/ipamonafont
  - media-fonts/noto
  - media-fonts/ja-ipafonts
  - media-fonts/takao-fonts
  - media-fonts/wqy-microhei
  - media-fonts/wqy-zenhei


To fix broken icons on the Downloads page, you should install an icon theme that
covers the appropriate MIME types, and configure this as your GTK+ icon theme.


For native file dialogs in KDE, install kde-apps/kdialog.


To make password storage work with your desktop environment you may have install
one of the supported credentials management applications:

  - app-crypt/libsecret (GNOME)
  - kde-frameworks/kwallet (KDE)

If you have one of above packages installed, but don't want to use them in
Chromium, then add --password-store=basic to CHROMIUM_FLAGS in
/etc/chromium/default.

"

python_check_deps() {
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

_compiler_version_checks() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		local -x CPP="$(tc-getCXX) -E"
		if tc-is-gcc && ! ver_test "$(gcc-version)" -ge "${GCC_PV}" ; then
eerror
eerror "At least gcc ${GCC_PV} is required"
eerror
			die
		fi
		if tc-is-clang ; then
			local slot=$(clang-major-version)
			if tc-is-cross-compiler ; then
				CPP="${CBUILD}-clang++-${slot}"
			else
				CPP="${CHOST}-clang++-${slot}"
			fi
			CPP+=" -E"
			local clang_min
			if use official ; then
				clang_min=${CR_CLANG_SLOT_OFFICIAL}
			else
				clang_min=${LLVM_MIN_SLOT}
			fi
			if ver_test ${slot} -lt ${clang_min} ; then
eerror
eerror "Your chosen clang does not meet requirements."
eerror
eerror "Actual slot:\t${slot}"
eerror "Expected slot:\t>= ${clang_min}"
eerror
clang --version
eerror
				die
			fi
		fi
	fi
}

has_zswap() {
	# 2.1875 is the average compression ratio
	# (or ratio of uncompressed:compressed)
	if grep -q -e "Y" "${BROOT}/sys/module/zswap/parameters/enabled" ; then
		return 0
	fi
	return 1
}

is_debug_flags() {
	is-flagq '-g?(gdb)?([1-9])'
}

pre_build_checks() {
	# Check build requirements: bugs #471810, #541816, #914220
	if use official ; then
	# https://github.com/chromium/chromium/blob/118.0.5993.117/docs/linux/build_instructions.md#system-requirements
		CHECKREQS_DISK_BUILD="100G"
		CHECKREQS_MEMORY="16G"
	else
		if is_debug_flags ; then
			CHECKREQS_DISK_BUILD="31G"
		elif use pgo ; then
			CHECKREQS_DISK_BUILD="26G"
		elif use lto ; then
			CHECKREQS_DISK_BUILD="22G"
		else
			CHECKREQS_DISK_BUILD="19G"
		fi
		if is_debug_flags ; then
	# Value is the same as vanilla ebuild which used the
	# build_instructions.md#system-requirements value.
			CHECKREQS_MEMORY="16G"
		else
			CHECKREQS_MEMORY="12G"
			if ! has_zswap ; then
	# Calculate uncompressed memory requirements
				tot_mem_without_zswap=$(python -c "import math ; v=${CHECKREQS_MEMORY/G}*2.1875 ; print( math.ceil(v/4) * 4 )")"G"
einfo
einfo "Detected zswap off.  Total memory required:"
einfo
einfo "With zswap:\t${CHECKREQS_MEMORY}"
einfo "Without zswap:\t${tot_mem_without_zswap}"
einfo
				CHECKREQS_MEMORY="${tot_mem_without_zswap}"
			fi
		fi
	fi

	# This is a nice idea but doesn't help noobs.
ewarn "Set CHECKREQS_DONOTHING=1 to bypass build requirements not met check"
	check-reqs_pkg_setup
}

pkg_pretend() {
	pre_build_checks

	if use headless; then
		local headless_unused_flags=(
			"cups"
			"kerberos"
			"pulseaudio"
			"qt5"
			"qt6"
			"vaapi"
			"wayland"
		)
		for myiuse in ${headless_unused_flags[@]}; do
			if use ${myiuse} ; then
ewarn
ewarn "Ignoring USE=${myiuse} since USE=headless is set."
ewarn
			fi
		done
	fi
}

get_pregenerated_profdata_index_version()
{
	local s
	s=$(_get_s)
	test -e "${s}/chrome/build/pgo_profiles/chrome-linux-"*".profdata" || die
	echo $(od -An -j 8 -N 1 -t d1 \
		"${s}/chrome/build/pgo_profiles/chrome-linux-"*".profdata" \
		| grep -E -o -e "[0-9]+")
}

# Grabs the INSTR_PROF_INDEX_VERSION in the pgo profile.
# https://github.com/llvm/llvm-project/blob/main/compiler-rt/include/profile/InstrProfData.inc#L653
get_llvm_profdata_version_info()
{
	[[ -z "${LLVM_SLOT}" ]] && die "LLVM_SLOT is empty"
	local profdata_index_version=0
	local compatible_pv
	local found_ver
	# The live versions can have different profdata versions over time.

	local PKGDB_PATH="${ESYSROOT}/var/db/pkg"
	for compatible_pv in ${PGO_LLVM_SUPPORTED_VERSIONS[@]} ; do
		(( $(ver_cut 1 "${compatible_pv}") != ${LLVM_SLOT} )) && continue
		( ! has_version "~sys-devel/llvm-${compatible_pv}" ) && continue
		found_ver=${compatible_pv}
		profdata_index_version=$(cat \
"${ESYSROOT}/usr/lib/llvm/$(ver_cut 1 ${found_ver})/include/llvm/ProfileData/InstrProfData.inc" \
			| grep "INSTR_PROF_INDEX_VERSION" \
			| head -n 1 \
			| grep -E -o -e "[0-9]+")
		break
	done
	if [[ -z "${profdata_index_version}" ]] ; then
eerror
eerror "Missing INSTR_PROF_INDEX_VERSION (aka profdata_index_version)"
eerror
		die
	fi
	if (( ${profdata_index_version} == 0 )) ; then
eerror
eerror "The profdata_index_version should not be 0.  Install the clang slot."
eerror
		request_clang_switch_message
		die
	fi
	if [[ -z "${found_ver}" ]] ; then
eerror
eerror "Missing the sys-devel/llvm version (aka found_ver)"
eerror
		die
	fi
	echo "${profdata_index_version}:${found_ver}"
}

is_profdata_compatible() {
	local a=$(get_pregenerated_profdata_index_version)
	local b=${CURRENT_PROFDATA_VERSION}
	if (( ${b} >= ${a} )) ; then
		return 0
	else
		return 1
	fi
}

# Generated from:
# for x in $(equery f chromium) ; do \
#	objdump -p ${x} 2>/dev/null | grep NEEDED ; \
# done \
# | sort \
# | uniq
PKG_LIBS=(
#ld-linux-x86-64.so.2
libX11.so.6
libXcomposite.so.1
libXdamage.so.1
libXext.so.6
libXfixes.so.3
libXrandr.so.2
libasound.so.2
libatk-1.0.so.0
libatk-bridge-2.0.so.0
libatspi.so.0
#libc.so.6
libcairo.so.2
libdbus-1.so.3
libdrm.so.2
libexpat.so.1
libffi.so.8
libgbm.so.1
#libgcc_s.so.1
libgio-2.0.so.0
libglib-2.0.so.0
libgobject-2.0.so.0
libm.so.6
libnspr4.so
libnss3.so
libnssutil3.so
libpango-1.0.so.0
libsmime3.so
libxcb.so.1
libxkbcommon.so.0
)

# Check the system for security weaknesses.
check_deps_cfi_cross_dso() {
	if ! use cfi ; then
einfo
einfo "Skipping CFI Cross-DSO checks"
einfo
		return
	fi
	# These are libs required by the prebuilt bin version.
	# This list was generated from the _maintainer_notes/get_package_libs script.
	# TODO:  Update list for source build.

	# TODO: check dependency n levels deep.
	# We are assuming CFI Cross-DSO.
einfo
einfo "Evaluating system for possible weaknesses."
einfo "Assuming systemwide CFI Cross-DSO."
einfo
	local f
	for f in ${PKG_LIBS[@]} ; do
		local paths=(
$(realpath "${EPREFIX}/usr/lib/gcc/"*"/"*"/${f}" 2>/dev/null)
$(realpath "${EPREFIX}/usr/lib/gcc/"*"/"*"/32/${f}" 2>/dev/null)
$(realpath "${EPREFIX}/lib"*"/${f}" 2>/dev/null)
$(realpath "${EPREFIX}/usr/lib"*"/${f}" 2>/dev/null)
		)
		if (( "${#paths[@]}" == 0 )) ; then
ewarn "${f} does not exist."
			continue
		fi
		local path
		path=$(echo "${paths[@]}" \
			| tr " " "\n" \
			| tail -n 1)
		local real_path=$(realpath "${path}")
		if "${BROOT}/usr/bin/readelf" -Ws "${real_path}" 2>/dev/null \
			| grep -E -q -e "(cfi_bad_type|cfi_check_fail|__cfi_init)" ; then
einfo "${f} is CFI protected."
		else
ewarn "${f} is NOT CFI protected."
		fi
	done
einfo
einfo "The information presented is a draft report that may not represent your"
einfo "configuration.  Some libraries listed may not be be able to be CFI"
einfo "Cross-DSOed."
einfo
einfo "An estimated >= 37.7% (26/69) of the libraries listed should be"
einfo "marked CFI protected."
einfo
}

request_clang_switch_message() {
eerror
eerror "You must switch to the proper Clang slot."
eerror
eerror "Supported clang slots:\t${LLVM_SLOTS[@]}"
eerror "Supported clang versions:\t${PGO_LLVM_SUPPORTED_VERSIONS[@]}"
eerror
eerror "To switch add a per-profile config file create the following files:"
eerror
eerror
eerror "Contents of ${ESYSROOT}/etc/portage/env/clang-${CR_CLANG_SLOT_OFFICIAL}.conf:"
eerror
eerror "CC=clang-${CR_CLANG_SLOT_OFFICIAL}"
eerror "CXX=clang++-${CR_CLANG_SLOT_OFFICIAL}"
eerror "AR=\"llvm-ar\""
eerror "NM=\"llvm-nm\""
eerror "OBJCOPY=\"llvm-objcopy\""
eerror "OBJDUMP=\"llvm-objdump\""
eerror "READELF=\"llvm-readelf\""
eerror "STRIP=\"llvm-strip\""
eerror
eerror
eerror "Contents of ${ESYSROOT}/etc/portage/package.env"
eerror
eerror "${CATEGORY}/${PN} clang-${CR_CLANG_SLOT_OFFICIAL}.conf"
eerror
}

print_use_flags_using_clang() {
	local U=(
		"bundled-libcxx"
		"cfi"
		"official"
		"pgo"
		"thinlto-opt"
	)

	local u
	for u in ${U} ; do
		if use "${u}" ; then
einfo "Using ${u} USE flag which is forcing clang."
		fi
	done
}

is_using_clang() {
	local U=(
		"bundled-libcxx"
		"cfi"
		"official"
		"pgo"
		"thinlto-opt"
	)

	local u
	for u in ${U} ; do
		use "${u}" && return 0
	done
	return 1
}

CURRENT_PROFDATA_VERSION=
CURRENT_PROFDATA_LLVM_VERSION=
NABIS=0
pkg_setup() {
einfo
einfo "The $(ver_cut 1 ${PV}) series is the stable channel."
einfo
	pre_build_checks

	chromium_suid_sandbox_check_kernel_config

	if ! use amd64 && [[ "${USE}" =~ "cfi" ]] ; then
ewarn
ewarn "All variations of the cfi USE flags are not defaults for this platform."
ewarn "Disable them if problematic."
ewarn
	fi

	local cprefix
	if tc-is-cross-compiler ; then
		cprefix="${CBUILD}"
	else
		cprefix="${CHOST}"
	fi

	# Do checks here because of references to tc-is-clang in src_prepare.
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP="$(tc-getCXX) -E"

	print_use_flags_using_clang
	if is_using_clang && ! tc-is-clang ; then
		export CC="clang"
		export CXX="clang++"
		export CPP="clang++ -E"
	fi

	if ver_test ${PV##*.} -ge 41 \
		&& ver_test ${PV##*.} -lt 107 \
		&& [[ "${SLOT}" =~ "beta" ]] ; then
# After two releases of stable and d=[41-107) in a.b.c.d, it may happen.
ewarn "QA:  Bump ebuild for major release.  Stable soon."
	fi

	if ver_test ${PV##*.} -lt 120 ; then
		if tc-is-gcc ; then
eerror
eerror "GCC is disallowed.  Still waiting for the GCC patchset."
eerror
eerror "Switch to clang, or use the older ebuild if GCC is preferred at the"
eerror "cost of security."
eerror
eerror "Using GCC will be allowed for this build when minor version is"
eerror ">= expected."
eerror
eerror "Current minor version:   ${PV##*.}"
eerror "Expected minor version:  >= 120"
eerror
			die
		fi
		if use ppc64 ; then
eerror
eerror "PPC64 is disallowed.  Still waiting for the PPC64 patchset."
eerror
eerror "Use the older ebuild if GCC is preferred at the cost of security."
eerror
eerror "Using PPC64 will be allowed for this build when minor version is"
eerror ">= expected."
eerror
eerror "Current minor version:   ${PV##*.}"
eerror "Expected minor version:  >= 120"
eerror
		fi
	fi

	if [[ -n "${CHROMIUM_EBUILD_MAINTAINER}" ]] ; then
		if [[ -z "${MY_OVERLAY_DIR}" ]] ; then
eerror
eerror "You need to set MY_OVERLAY_DIR as a per-package envvar to the base path"
eerror "of your overlay or local repo.  The base path should contain all the"
eerror "overlay's categories."
eerror
			die
		fi
	fi

	if use vaapi && ( use x86 || use amd64 ) ; then
		:;
	elif use vaapi ; then
ewarn
ewarn "VA-API is not enabled by default for this arch.  Please disable it if"
ewarn "problems are encountered."
ewarn
	fi

	if use system-libstdcxx ; then
ewarn
ewarn "The system's libstdcxx may weaken the security.  Consider using only the"
ewarn "bundled-libcxx instead."
ewarn
	fi

einfo
einfo "To remove the hard USE mask for the builtin pgo profile:"
einfo
einfo "  mkdir -p \"${EROOT}/etc/portage/profile\""
einfo "  echo \"www-client/chromium -pgo\" >> \"${EROOT}/etc/portage/profile/package.use.mask\""
einfo

einfo
einfo "To override the distro hard mask for ffmpeg5 do the following:"
einfo
einfo "  mkdir -p \"${EROOT}/etc/portage/profile\""
einfo "  echo \"www-client/chromium -system-ffmpeg\" >> \"${EROOT}/etc/portage/profile/package.use.mask\""
einfo

	uopts_setup

	local a
	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done

	( use system-dav1d || use system-libaom ) && cflags-depends_check
}

src_unpack() {
	local a
	for a in ${A} ; do
		unpack ${a}
	done
}

is_generating_credits() {
	if [[ -n "${GEN_ABOUT_CREDITS}" \
		&& "${GEN_ABOUT_CREDITS}" == "1" ]] ; then
		return 0
	else
		return 1
	fi
}

apply_distro_patchset() {
	# Disable global media controls, crashes with libstdc++
	sed -i -e \
		"/\"GlobalMediaControlsCastStartStop\",/{n;s/ENABLED/DISABLED/;}" \
		"chrome/browser/media/router/media_router_feature.cc" || die

	local PATCHES=(
		"${WORKDIR}/chromium-patches-${PATCH_VER}"
		"${FILESDIR}/chromium-cross-compile.patch"
		"${FILESDIR}/chromium-use-oauth2-client-switches-as-default.patch"
		"${FILESDIR}/chromium-108-EnumTable-crash.patch"
		$(use system-zlib && echo "${FILESDIR}/chromium-109-system-zlib.patch")
		"${FILESDIR}/chromium-111-InkDropHost-crash.patch"
	)

	# Disable global media controls.  It crashes with libstdc++.
	sed -i -e \
		"/\"GlobalMediaControlsCastStartStop\",/{n;s/ENABLED/DISABLED/;}" \
		"third_party/blink/common/features.cc" \
		|| die

        if use ppc64 ; then
		local p
		for p in $(grep -v "^#" "${WORKDIR}/debian/patches/series" \
				| grep "^ppc64le" \
				|| die); do
			if [[ ! ${p} =~ "fix-breakpad-compile.patch" ]]; then
				PATCHES+=(
					"${WORKDIR}/debian/patches/${p}"
				)
			fi
		done
		PATCHES+=(
			"${WORKDIR}/ppc64le"
		)
	fi
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	check_deps_cfi_cross_dso

	local PATCHES=()

	if use system-libstdcxx ; then
ewarn "Applying the distro patchset."
	# Proper CFI requires static linkage.
	# You can use Cross DSO CFI (aka dynamic .so linkage) but the attack
	# surface would increase.
	# cfi-icall with static linkage may have less breakage than dynamic,
	# which will force user to disable cfi-icall in Cross DSO CFI unvendored
	# lib.
		apply_distro_patchset
	else
ewarn "Disabling the distro patchset."
	fi

	if use epgo ; then
		PATCHES+=(
			"${FILESDIR}/extra-patches/chromium-104.0.5112.79-gcc-pgo-link-gcov.patch"
		)
	fi

	if tc-is-clang ; then
	# Using gcc with these patches results in this error:
	# Two or more targets generate the same output:
	#   lib.unstripped/libEGL.so
		PATCHES+=(
			"${FILESDIR}/extra-patches/${PN}-92-clang-toolchain-1.patch"
			"${FILESDIR}/extra-patches/${PN}-92-clang-toolchain-2.patch"
		)
	fi

	if use arm64 && has_sanitizer_option "shadow-call-stack" ; then
		PATCHES+=(
			"${FILESDIR}/extra-patches/chromium-94-arm64-shadow-call-stack.patch"
		)
	fi

	PATCHES+=(
		"${FILESDIR}/extra-patches/chromium-111.0.5563.64-zlib-selective-simd.patch"
		"${FILESDIR}/extra-patches/chromium-115.0.5790.40-qt6-split.patch"
	)

	if is-flagq '-Ofast' || is-flagq '-ffast-math' ; then
		PATCHES+=(
			"${FILESDIR}/extra-patches/chromium-114.0.5735.133-fast-math.patch"
		)
	fi

	# Slot 16 selected but spits out 17
#
# Fixes:
#
# Returned 1 and printed out:
#
# The expected clang version is llvmorg-17-init-4759-g547e3456-1 but the actual version is
# Did you run "gclient sync"?
#

	sed -i \
		-e "/verify-version/d" \
		"build/config/compiler/BUILD.gn" \
		|| die

	PATCHES+=(
#
# Fixes:
#
# The expected Rust version is 17c11672167827b0dd92c88ef69f24346d1286dd-1-llvmorg-17-init-8029-g27f27d15-3 (or fallback 17c11672167827b0dd92c88ef69f24346d1286dd-1-llvmorg-17-init-8029-g27f27d15-1 but the actual version is None
# Did you run "gclient sync"?
		"${FILESDIR}/extra-patches/chromium-117.0.5938.92-skip-rust-check.patch"

		"${FILESDIR}/extra-patches/chromium-117.0.5938.92-disable-unused-variable-ELOC_PROTO.patch"
		"${FILESDIR}/extra-patches/chromium-118.0.5993.117-clang-paths.patch"
	)

	default

	if (( ${#PATCHES[@]} > 0 )) \
		|| [[ -f "${T}/epatch_user.log" ]] ; then
		if use official ; then
ewarn
ewarn "The use of unofficial patches is not endorsed upstream."
ewarn
		fi

		if use pgo ; then
ewarn
ewarn "The use of patching can interfere with the pregenerated PGO profile."
ewarn
		fi
	fi

	mkdir -p third_party/node/linux/node-linux-x64/bin || die
	ln -s \
		"${EPREFIX}"/usr/bin/node \
		third_party/node/linux/node-linux-x64/bin/node \
		|| die

	# Adjust the python interpreter version
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die
	sed -i -e "s|vpython3|${EPYTHON}|g" testing/xvfb.py || die

	local keeplibs=(
		base/third_party/cityhash
		base/third_party/double_conversion
		base/third_party/dynamic_annotations
		base/third_party/icu
		base/third_party/nspr
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/valgrind
		base/third_party/xdg_mime
		base/third_party/xdg_user_dirs
		buildtools/third_party/libc++
		buildtools/third_party/libc++abi
		chrome/third_party/mozilla_security_manager
		courgette/third_party
		net/third_party/mozilla_security_manager
		net/third_party/nss
		net/third_party/quic
		net/third_party/uri_template
		third_party/abseil-cpp
		third_party/angle
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/ceval
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/volk
		third_party/apple_apsl
		third_party/axe-core
		third_party/blink
		third_party/bidimapper
		third_party/boringssl
		third_party/boringssl/src/third_party/fiat
		third_party/breakpad
		third_party/breakpad/breakpad/src/third_party/curl
		third_party/brotli
		third_party/catapult
		third_party/catapult/common/py_vulcanize/third_party/rcssmin
		third_party/catapult/common/py_vulcanize/third_party/rjsmin
		third_party/catapult/third_party/beautifulsoup4-4.9.3
		third_party/catapult/third_party/html5lib-1.1
		third_party/catapult/third_party/polymer
		third_party/catapult/third_party/six
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jpeg-js
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/catapult/tracing/third_party/oboe
		third_party/catapult/tracing/third_party/pako
		third_party/ced
		third_party/cld_3
		third_party/closure_compiler
		third_party/content_analysis_sdk
		third_party/cpuinfo
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/d3
		third_party/dawn
		third_party/dawn/third_party/gn/webgpu-cts
		third_party/dawn/third_party/khronos
		third_party/depot_tools
		third_party/devscripts
		third_party/devtools-frontend
		third_party/devtools-frontend/src/front_end/third_party/acorn
		third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json
		third_party/devtools-frontend/src/front_end/third_party/axe-core
		third_party/devtools-frontend/src/front_end/third_party/chromium
		third_party/devtools-frontend/src/front_end/third_party/codemirror
		third_party/devtools-frontend/src/front_end/third_party/diff
		third_party/devtools-frontend/src/front_end/third_party/i18n
		third_party/devtools-frontend/src/front_end/third_party/intl-messageformat
		third_party/devtools-frontend/src/front_end/third_party/lighthouse
		third_party/devtools-frontend/src/front_end/third_party/lit
		third_party/devtools-frontend/src/front_end/third_party/lodash-isequal
		third_party/devtools-frontend/src/front_end/third_party/marked
		third_party/devtools-frontend/src/front_end/third_party/puppeteer
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/mitt
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/rxjs
		third_party/devtools-frontend/src/front_end/third_party/vscode.web-custom-data
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/test/unittests/front_end/third_party/i18n
		third_party/devtools-frontend/src/third_party
		third_party/distributed_point_functions
		third_party/dom_distiller_js
		third_party/eigen3
		third_party/emoji-segmenter
		third_party/farmhash
		third_party/fdlibm
		third_party/fft2d
		third_party/flatbuffers
		third_party/fp16
		third_party/freetype
		third_party/fusejs
		third_party/fxdiv
		third_party/highway
		third_party/liburlpattern
		third_party/libzip
		third_party/gemmlowp
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/hunspell
		third_party/iccjpeg
		third_party/inspector_protocol
		third_party/ipcz
		third_party/jinja2
		third_party/jsoncpp
		third_party/jstemplate
		third_party/khronos
		third_party/leveldatabase
		third_party/libaddressinput
		third_party/libavif
		third_party/libevent
		third_party/libgav1
		third_party/libjingle
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/libudev
		third_party/libva_protected_content
		third_party/libvpx
		third_party/libvpx/source/libvpx/third_party/x86inc
		third_party/libwebm
		third_party/libx11
		third_party/libxcb-keysyms
		third_party/libxml/chromium
		third_party/libyuv
		third_party/llvm
		third_party/lottie
		third_party/lss
		third_party/lzma_sdk
		third_party/mako
		third_party/maldoca
		third_party/maldoca/src/third_party/tensorflow_protos
		third_party/maldoca/src/third_party/zlibwrapper
		third_party/markupsafe
		third_party/material_color_utilities
		third_party/mesa
		third_party/metrics_proto
		third_party/minigbm
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
		third_party/omnibox_proto
		third_party/one_euro_filter
		third_party/openscreen
		third_party/openscreen/src/third_party/mozilla
		third_party/openscreen/src/third_party/tinycbor/src/src
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/base
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
		third_party/pdfium/third_party/libopenjpeg
		third_party/pdfium/third_party/libtiff
		third_party/perfetto
		third_party/perfetto/protos/third_party/chromium
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private-join-and-compute
		third_party/private_membership
		third_party/protobuf
		third_party/pthreadpool
		third_party/puffin
		third_party/pyjson5
		third_party/pyyaml
		third_party/qcms
		third_party/rnnoise
		third_party/s2cellid
		third_party/securemessage
		third_party/selenium-atoms
		third_party/shell-encryption
		third_party/simplejson
		third_party/skia
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/snappy
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/astc-encoder
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/marl
		third_party/swiftshader/third_party/subzero
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv
		third_party/swiftshader/third_party/SPIRV-Tools
		third_party/tensorflow_models
		third_party/tensorflow-text
		third_party/tflite
		third_party/tflite/src/third_party/eigen3
		third_party/tflite/src/third_party/fft2d
		third_party/ruy
		third_party/six
		third_party/ukey2
		third_party/unrar
		third_party/utf
		third_party/vulkan
		third_party/wayland
		third_party/webdriver
		third_party/webgpu-cts
		third_party/webrtc
		third_party/webrtc/common_audio/third_party/ooura
		third_party/webrtc/common_audio/third_party/spl_sqrt_floor
		third_party/webrtc/modules/third_party/fft
		third_party/webrtc/modules/third_party/g711
		third_party/webrtc/modules/third_party/g722
		third_party/webrtc/rtc_base/third_party/base64
		third_party/webrtc/rtc_base/third_party/sigslot
		third_party/widevine
		third_party/woff2
		third_party/wuffs
		third_party/x11proto
		third_party/xcbproto
		third_party/xnnpack
		third_party/zxcvbn-cpp
		third_party/zlib/google
		url/third_party/mozilla
		v8/src/third_party/siphash
		v8/src/third_party/valgrind
		v8/src/third_party/utf8-decoder
		v8/third_party/glibc
		v8/third_party/inspector_protocol
		v8/third_party/v8

	# gyp -> gn leftovers
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils

	# Required in both cases
		third_party/ffmpeg

		$(use !system-dav1d && echo "
			third_party/dav1d
		")
		$(use !system-flac && echo "
			third_party/flac
		")
		$(use !system-fontconfig && echo "
			third_party/fontconfig
		")
		$(use !system-harfbuzz && echo "
			third_party/harfbuzz-ng
		")
		$(use !system-icu && echo "
			third_party/icu
		")
		$(use !system-libaom && echo "
			third_party/libaom
			third_party/libaom/source/libaom/third_party/fastfeat
			third_party/libaom/source/libaom/third_party/SVT-AV1
			third_party/libaom/source/libaom/third_party/vector
			third_party/libaom/source/libaom/third_party/x86inc
		")
		$(use !system-libdrm && echo "
			third_party/libdrm
		")
		$(use !system-libjpeg-turbo && echo "
			third_party/libjpeg_turbo
		")
		$(use !system-libpng && echo "
			third_party/libpng
		")
		$(use !system-libstdcxx && echo "
			third_party/libc++
		")
		$(use !system-libwebp && echo "
			third_party/libwebp
		")
		$(use !system-libxml && echo "
			third_party/libxml
		")
		$(use !system-libxslt && echo "
			third_party/libxslt
		")
		$(use !system-openh264 && echo "
			third_party/openh264
		")
		$(use !system-opus && echo "
			third_party/opus
		")
		$(use !system-re2 && echo "
			third_party/re2
		")
		$(use !system-zlib && echo "
			third_party/zlib
		")
		$(use !system-zlib && echo "
			third_party/zstd
		")
	#
	# Do not remove the third_party/zlib below. \
	#
	# Error:  ninja: error: '../../third_party/zlib/adler32_simd.c', \
	# needed by 'obj/third_party/zlib/zlib_adler32_simd/adler32_simd.o', \
	# missing and no known rule to make it
	#
	# third_party/zlib is already kept but may use system no need split \
	# conditional for CFI or official builds.
	#
		$(use !system-zlib && echo "
			third_party/zlib
		")
	# Arch-specific
		$((use arm64 || use ppc64) && echo "
			third_party/swiftshader/third_party/llvm-10.0
		")
	)
	# We need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64 ; then
		pushd third_party/libvpx > /dev/null || die
			mkdir -p source/config/linux/ppc64 || die
	# The script requires git and clang, bug #832803
			sed -i -e "s|^update_readme||g; s|clang-format|${EPREFIX}/bin/true|g" \
				generate_gni.sh \
				|| die
			./generate_gni.sh || die
		popd > /dev/null || die

		pushd third_party/ffmpeg >/dev/null || die
			cp \
				libavcodec/ppc/h264dsp.c \
				libavcodec/ppc/h264dsp_ppc.c \
				|| die
			cp \
				libavcodec/ppc/h264qpel.c \
				libavcodec/ppc/h264qpel_ppc.c \
				|| die
		popd >/dev/null || die
	fi

	if ! is_generating_credits ; then
einfo
einfo "Unbundling third party internal libraries and packages"
einfo
	# Remove most bundled libraries. Some are still needed.
		build/linux/unbundle/remove_bundled_libraries.py \
			"${keeplibs[@]}" \
			--do-remove \
			|| die
	fi

	if ! is_generating_credits ; then
	# The bundled eu-strip is for amd64 only and we don't want to pre-strip
	# binaries.
		mkdir -p buildtools/third_party/eu-strip/bin || die
		ln -s \
			"${BROOT}/bin/true" \
			"buildtools/third_party/eu-strip/bin/eu-strip" \
			|| die
	fi

	(( ${NABIS} > 1 )) && multilib_copy_sources

	prepare_abi() {
		uopts_src_prepare
	}

	multilib_foreach_abi prepare_abi
}

has_sanitizer_option() {
	local needle="${1}"
	local haystack
	for haystack in $(echo "${CFLAGS}" \
		| grep -E -e "-fsanitize=[a-z,]+( |$)" \
		| sed -e "s|-fsanitize||g" | tr "," "\n") ; do
		[[ "${haystack}" == "${needle}" ]] && return 0
	done
	return 1
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

# Just examples why filter-flags '-fuse-ld=*' should not be removed.
show_mold_adoption_blockers() {
	if is-flagq '-fuse-ld=mold' \
		&& [[ -e "third_party/boringssl/src/include/openssl/opensslv.h" ]] ; then
	# Mold is more compatible with >=dev-libs/openssl-3
	# There is no non-free guarantees on the patent side.  (e.g. Kyber)
	# This one cannot be easily removed.
eerror
eerror "Detected BoringSSL.  Remove the -fuse-ld=mold from LDFLAGS."
eerror
		die
	fi
	if is-flagq '-fuse-ld=mold' && use widevine ; then
eerror
eerror "-fuse-ld=mold cannot be used with the widevine USE flag."
eerror
		die
	fi
	if is-flagq '-fuse-ld=mold' && use proprietary-codecs ; then
eerror
eerror "-fuse-ld=mold cannot be used with the proprietary-codecs USE flag."
eerror
		die
	fi
	local atom=$(best_version "media-video/ffmpeg")
	local repo_root=${EROOT:-"/"}
	local repo=$(portageq metadata "${repo_root}" installed "${atom}" repository)
	if is-flagq '-fuse-ld=mold' \
		&& use system-ffmpeg \
		&& [[ "${repo}" != "oiledmachine-overlay" ]] ; then
	#
	# The distro FFmpeg uses patent-encumbered settings by default and
	# unconditionally.
	#
	# This has been corrected with the oiledmachine-overlay version with the
	# proprietary-codecs-disable* USE flags.
	#
eerror
eerror "-fuse-ld=mold cannot be used with the distro's ffmpeg ebuild."
eerror
		die
	fi
}

show_clang_header_warning() {
	local clang_slot="${1}"
	grep -q -r \
		-e "FORCE_CLANG_STDATOMIC_H" \
		"${ESYSROOT}/usr/lib/clang/${clang_slot}/include/stdatomic.h" \
		&& return
ewarn
ewarn "${ESYSROOT}/usr/lib/clang/${clang_slot}/include/stdatomic.h requires header"
ewarn "modifications.  Solutions..."
ewarn
ewarn "Solution 1 - Manual edit:"
ewarn
ewarn "  See ebuild for details with keyword search atomic_load."
ewarn
ewarn "Solution 2 - Emerge either:"
ewarn
ewarn "  sys-devel/clang:16::oiledmachine-overlay"
ewarn "  sys-devel/clang:17::oiledmachine-overlay"
ewarn
ewarn "Solution 3 - Emerge this package with gcc."
ewarn
#
# The problem:
#
#../../third_party/boringssl/src/crypto/refcount_c11.c:37:23: error: address argument to atomic operation must be a pointer to a trivially-copyable type ('_Atomic(CRYPTO_refcount_t) *' invalid)
#  uint32_t expected = atomic_load(count);
#                      ^~~~~~~~~~~~~~~~~~
#/usr/lib/gcc/xxx-pc-linux-gnu/12/include/stdatomic.h:142:27: note: expanded from macro 'atomic_load'
##define atomic_load(PTR)  atomic_load_explicit (PTR, __ATOMIC_SEQ_CST)
#                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#/usr/lib/gcc/xxx-pc-linux-gnu/12/include/stdatomic.h:138:5: note: expanded from macro 'atomic_load_explicit'
#    __atomic_load (__atomic_load_ptr, &__atomic_load_tmp, (MO));        \
#    ^              ~~~~~~~~~~~~~~~~~
#
# The solution:
#
# Change /usr/lib/clang/17/include/stdatomic.h as follows:
#
##if __STDC_HOSTED__ &&                                                          \
#    __has_include_next(<stdatomic.h>) &&                                        \
#    (!defined(_MSC_VER) || (defined(__cplusplus) && __cplusplus >= 202002L)) && \
#    (!defined(FORCE_CLANG_STDATOMIC_H))
#
# "and emerge with clang:17."
#
}

LLVM_SLOT=""
GCC_SLOT=""
LTO_TYPE=""
_src_configure() {
	local s
	s=$(_get_s)
	cd "${s}" || die

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	local myconf_gn=""

	# Final CC selected
	LLVM_SLOT=""
	if tc-is-clang || is_using_clang ; then
einfo
einfo "Switching to clang."
einfo
	# See build/toolchain/linux/unbundle/BUILD.gn for allowed overridable envvars.
	# See build/toolchain/gcc_toolchain.gni#L657 for consistency.

		local slot
		if use official ; then
			slot="${CR_CLANG_SLOT_OFFICIAL}"
		elif tc-is-clang ; then
			slot="$(clang-major-version)"
		else
			local s
			for s in ${LLVM_SLOTS[@]} ; do
				if has_version "sys-devel/clang:${s}" ; then
					slot="${s}"
					break
				fi
			done
		fi

		LLVM_SLOT="${slot}"
		if [[ -z "${LLVM_SLOT}" ]] ; then
			request_clang_switch_message
			die
		fi

		if tc-is-cross-compiler ; then
			export CC="${CBUILD}-clang-${LLVM_SLOT} -target ${CHOST} --sysroot ${ESYSROOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CBUILD}-clang++-${LLVM_SLOT} -target ${CHOST} --sysroot ${ESYSROOT} $(get_abi_CFLAGS ${ABI})"
			export BUILD_CC="${CBUILD}-clang-${LLVM_SLOT}"
			export BUILD_CXX="${CBUILD}-clang++-${LLVM_SLOT}"
		else
			export CC="${CHOST}-clang-${LLVM_SLOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CHOST}-clang++-${LLVM_SLOT} $(get_abi_CFLAGS ${ABI})"
		fi

		export AR="llvm-ar" # Required for LTO
		export NM="llvm-nm"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
		if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
			die "llvm-ar is unreachable"
		fi
		local pv=$(best_version "sys-devel/llvm:${LLVM_SLOT}" \
			| sed -e "s|sys-devel/llvm-||g")
		if [[ "${pv}" =~ 9999 || "${pv}" =~ pre ]] ; then
			local ts=$(date -d "@${CR_CLANG_USED_UNIX_TIMESTAMP}")
ewarn
ewarn "Only the commit below or newer for the latest live ebuilds having the"
ewarn "same slot are supported for Clang."
ewarn
ewarn "LLVM slot:         ${CR_CLANG_SLOT_OFFICIAL}"
ewarn "Commit:            ${CR_CLANG_USED}"
ewarn "Commit timestamp:  >= ${ts}"
ewarn
		fi

		# Get the stdatomic.h from clang not from gcc.
		append-cflags -stdlib=libc++
		append-ldflags -stdlib=libc++
		if ver_test ${LLVM_SLOT} -ge 16 ; then
			append-cppflags "-isystem/usr/lib/clang/${LLVM_SLOT}/include"
			show_clang_header_warning "${LLVM_SLOT}"
		else
			local clang_pv=$(best_version "sys-devel/clang:${LLVM_SLOT}" \
				| sed -e "s|sys-devel/clang-||")
			clang_pv=$(ver_cut 1-3 "${clang_pv}")
			append-cppflags "-isystem/usr/lib/clang/${clang_pv}/include"
			show_clang_header_warning "${clang_pv}"
		fi
		append-cppflags -DFORCE_CLANG_STDATOMIC_H
	else
einfo
einfo "Switching to GCC"
einfo
		unset GCC_SLOT
		local s
		for s in ${GCC_SLOTS[@]} ; do
			if has_version "sys-devel/gcc:${s}" ; then
				GCC_SLOT="${s}"
				break
			fi
		done

		if tc-is-cross-compiler ; then
			export CC="${CBUILD}-gcc-${GCC_SLOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CBUILD}-g++-${GCC_SLOT} $(get_abi_CFLAGS ${ABI})"
			export BUILD_CC="${CBUILD}-gcc-${GCC_SLOT}"
			export BUILD_CXX="${CBUILD}-g++-${GCC_SLOT}"
		else
			export CC="${CHOST}-gcc-${GCC_SLOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CHOST}-g++-${GCC_SLOT} $(get_abi_CFLAGS ${ABI})"
		fi
		export AR="ar"
		export NM="nm"
		export READELF="readelf"
		export STRIP="strip"
		export LD="ld.bfd"

		if ! use system-libstdcxx ; then
eerror
eerror "The system-libstdcxx USE flag must be enabled for GCC builds."
eerror
			die
		fi
	fi
	${CC} --version || die
	_compiler_version_checks

	if ( tc-is-clang && is-flagq '-flto*' ) \
		|| use official \
		|| use cfi ; then
	# sys-devel/lld-13 was ~20 mins for v8_context_snapshot_generator
	# sys-devel/lld-12 was ~4 hrs for v8_context_snapshot_generator
ewarn
ewarn "Linking times may take longer than usual.  Maybe 1-12+ hour(s)."
ewarn
	fi

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM READELF STRIP

	strip-unsupported-flags

	# Handled by the build scripts
	filter-flags \
		'-f*sanitize*' \
		'-f*visibility*'

	if tc-is-clang ; then
		myconf_gn+=" is_clang=true"
		myconf_gn+=" clang_use_chrome_plugins=false"
	else
		myconf_gn+=" is_clang=false"
	fi

	# Examples of why the filter-flags '-fuse-ld=*' should not be removed.
	show_mold_adoption_blockers

	# Handled by build scripts
	filter-flags '-fuse-ld=*'

	if ! tc-is-clang && use thinlto-opt ; then
eerror
eerror "The thinlto-opt USE flag needs CC=${CHOST}-clang CXX=${CHOST}-clang++."
eerror
		die
	fi

	# See also bug 641556
	if tc-is-clang ; then
		myconf_gn+=" use_lld=true"
	else
		myconf_gn+=" use_lld=false"
	fi

	# Strip incompatable linker flags
	strip-unsupported-flags

	if is-flagq '-flto' || tc-is-clang ; then
		AR=llvm-ar
		NM=llvm-nm
		if tc-is-cross-compiler; then
			BUILD_AR=llvm-ar
			BUILD_NM=llvm-nm
		fi
	fi

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-clang ; then
		myconf_gn+=" clang_base_path=\"${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}\""
	fi

	if tc-is-cross-compiler ; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" pkg_config=\"$(tc-getPKG_CONFIG)\""
		myconf_gn+=" host_pkg_config=\"$(tc-getBUILD_PKG_CONFIG)\""

	# Setup cups-config, build system only uses --libs option
		if use cups; then
			mkdir "${T}/cups-config" || die
			cp \
				"${ESYSROOT}/usr/bin/${CHOST}-cups-config" \
				"${T}/cups-config/cups-config" \
				|| die
			export PATH="${PATH}:${T}/cups-config"
		fi

	# Don't inherit PKG_CONFIG_PATH from environment
		local -x PKG_CONFIG_PATH=
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

	# Disable rust for now; it's only used for testing and we don't need the additional bdep
	#myconf_gn+=" enable_rust=false" # TODO: retest uncommented.  It works as default.

	# Silence
	# The expected Rust version is [...] but the actual version is None
	myconf_gn+=" use_chromium_rust_toolchain=false"

	# Debug symbols level 2 is still on when official is on even though
	# is_debug=false.
	#
	# See https://github.com/chromium/chromium/blob/118.0.5993.117/build/config/compiler/compiler.gni#L276
	#
	# GN needs explicit config for Debug/Release as opposed to inferring it
	# from the build directory.
	myconf_gn+=" is_debug=false"

	# Enable DCHECK with USE=debug only, increases chrome binary size by 30%, bug #811138.
	# DCHECK is fatal by default, make it configurable at runtime, #bug 807881.
	myconf_gn+=" dcheck_always_on=$(usex debug true false)"
	myconf_gn+=" dcheck_is_configurable=$(usex debug true false)"

	# Component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
	myconf_gn+=" is_component_build=false"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	# Use system-provided libraries.
	# TODO: freetype -- remove sources
	# (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	# [B] all of gn_system_libraries set
	# List obtained from /var/tmp/portage/www-client/chromium-118.0.5993.117/work/chromium-118.0.5993.117/build/linux/unbundle/
	local gn_system_libraries=(
		$(use system-dav1d && echo "
			dav1d
		")
		$(use system-ffmpeg && echo "
			ffmpeg
		")
		$(use system-flac && echo "
			flac
		")
		$(use system-freetype && echo "
			freetype
		")
		$(use system-fontconfig && echo "
			fontconfig
		")
	# harfbuzz_from_pkgconfig target is needed.
		$(use system-harfbuzz && echo "
			harfbuzz-ng
		")
		$(use system-icu && echo "
			icu
		")
		$(use system-libaom && echo "
			libaom
		")
		$(use system-libdrm && echo "
			libdrm
		")
		$(use system-libjpeg-turbo && echo "
			libjpeg
		")
		$(use system-libpng && echo "
			libpng
		")
		$(use system-libwebp && echo "
			libwebp
		")
		$(use system-libxml && echo "
			libxml
		")
		$(use system-libxslt && echo "
			libxslt
		")
		$(use system-openh264 && echo "
			openh264
		")
		$(use system-opus && echo "
			opus
		")
		$(use system-re2 && echo "
			re2
		")

	#
	# ld.lld: error: undefined symbol: Cr_z_adler32
	#
		$(use system-zlib && echo "
			zlib
		")

		$(use system-zstd && echo "
			zstd
		")

	)
	# [C]
	if use bundled-libcxx \
		|| use cfi \
		|| use official ; then
	# Unbundling breaks cfi-icall and cfi-cast.
	# Unbundling weakens the security because it removes noexecstack,
	# full RELRO, SSP.
einfo
einfo "Forcing use of internal libs to maintain upstream security expectations"
einfo "and requirements."
einfo
	else
		if ! is_generating_credits ; then
ewarn
ewarn "Unbundling libs and disabling hardening (CFI, SSP, noexecstack,"
ewarn "Full RELRO)."
ewarn
			build/linux/unbundle/replace_gn_files.py \
				--system-libraries \
				"${gn_system_libraries[@]}" \
				|| die
		fi
	fi

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=$(usex system-harfbuzz true false)"

	# Optional dependencies.
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" enable_widevine=$(usex widevine true false)"

	if use headless ; then
		myconf_gn+=" use_cups=false"
		myconf_gn+=" use_kerberos=false"
		myconf_gn+=" use_pulseaudio=false"
		myconf_gn+=" use_vaapi=false"
		myconf_gn+=" rtc_use_pipewire=false"
	else
		myconf_gn+=" use_cups=$(usex cups true false)"
		myconf_gn+=" use_kerberos=$(usex kerberos true false)"
		myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"
		myconf_gn+=" use_vaapi=$(usex vaapi true false)"
		myconf_gn+=" rtc_use_pipewire=$(usex screencast true false)"
		myconf_gn+=" gtk_version=$(usex gtk4 4 3)"
	fi

	# TODO: link_pulseaudio=true for GN.

	myconf_gn+=" disable_fieldtrial_testing_config=true"

	# Never use bundled gold binary. Disable gold linker flags for now.
	# Do not use bundled clang.
	# Trying to use gold results in linker crash.
	myconf_gn+=" use_gold=false"
	myconf_gn+=" use_sysroot=false"
	if use official && use cfi || use bundled-libcxx ; then
		# If you didn't do systemwide CFI Cross-DSO, it must be static.
		myconf_gn+=" use_custom_libcxx=true"
	else
		myconf_gn+=" use_custom_libcxx=false"
	fi

	# Disable pseudolocales, only used for testing
	myconf_gn+=" enable_pseudolocales=false"

	# Disable code formating of generated files
	myconf_gn+=" blink_enable_generated_code_formatting=false"

	# See https://github.com/chromium/chromium/blob/118.0.5993.117/media/media_options.gni#L19
	local ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
	myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
	myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""
	myconf_gn+=" enable_av1_decoder=$(usex dav1d true false)"
	myconf_gn+=" enable_dav1d_decoder=$(usex dav1d true false)"
	myconf_gn+=" enable_hevc_parser_and_hw_decoder=$(usex proprietary-codecs $(usex vaapi-hevc true false) false)"
	myconf_gn+=" enable_libaom=$(usex libaom $(usex encode true false) false)"
	myconf_gn+=" enable_platform_hevc=$(usex proprietary-codecs $(usex vaapi-hevc true false) false)"
	myconf_gn+=" media_use_libvpx=$(usex vpx true false)"
	myconf_gn+=" media_use_openh264=$(usex proprietary-codecs $(usex openh264 true false) false)"
	myconf_gn+=" rtc_include_opus=$(usex opus true false)"
	myconf_gn+=" rtc_use_h264=$(usex proprietary-codecs true false)"
	if ! use system-ffmpeg ; then
	# The internal/vendored ffmpeg enables non-free codecs.
		local _media_use_ffmpeg="true"
		if \
			   use proprietary-codecs-disable-nc-developer \
			|| use proprietary-codecs-disable ; then
			_media_use_ffmpeg="false"
		fi
		myconf_gn+=" media_use_ffmpeg=${_media_use_ffmpeg}"
	fi

	#
	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info. The OAuth2 credentials, however, have been left out.
	# Those OAuth2 credentials have been broken for quite some time anyway.
	# Instead we apply a patch to use the --oauth2-client-id= and
	# --oauth2-client-secret= switches for setting GOOGLE_DEFAULT_CLIENT_ID and
	# GOOGLE_DEFAULT_CLIENT_SECRET at runtime. This allows signing into
	# Chromium without baked-in values.
	#
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	local myarch="$(tc-arch)"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags ; then
		strip-flags

	# Debug info section overflows without component build
	# Prevent linker from running out of address space, bug #471810.
		filter-flags '-g*'

	# Prevent libvpx/xnnpack build failures. Bug 530248, 544702,
	# 546984, 853646.
		if [[ "${myarch}" == "amd64" || "${myarch}" == "x86" ]] ; then
			filter-flags \
				'-mno-avx*' \
				'-mno-fma*' \
				'-mno-mmx*' \
				'-mno-sse*' \
				'-mno-ssse*' \
				'-mno-xop'
		fi
	fi

	if tc-is-gcc ; then
		# https://bugs.gentoo.org/904455
		append-cxxflags "$(test-flags-CXX -fno-tree-vectorize)"
		# https://bugs.gentoo.org/912381
		filter-lto
	fi

	# Boost Oflags for internal dav1d to avoid blurry images or < 25 FPS.
	replace-flags "-Os" "-O2"
	replace-flags "-O1" "-O2"
	replace-flags "-Og" "-O2" # Fork ebuild if you want -Og ; Similar to -O1
	replace-flags "-O0" "-O2"

	# Prevent crash for now
	# TODO:  fix crashes for -Ofast
	replace-flags "-Ofast" "-O3"
	filter-flags "-ffast-math"

	if is-flagq "-Ofast" ; then
	# Precaution
		append_all $(test-flags -fno-allow-store-data-races)
	fi

	local ffmpeg_target_arch
	local target_cpu
	if [[ "${myarch}" == "amd64" ]] ; then
		target_cpu="x64"
		ffmpeg_target_arch="x64"
	elif [[ "${myarch}" == "x86" ]] ; then
		target_cpu="x86"
		ffmpeg_target_arch="ia32"
	# This is normally defined by compiler_cpu_abi in
	# build/config/compiler/BUILD.gn, but we patch that part out.
		append-flags -msse2 -mfpmath=sse -mmmx
	elif [[ "${myarch}" == "arm64" ]] ; then
		target_cpu="arm64"
		ffmpeg_target_arch="arm64"
	elif [[ "${myarch}" == "arm" ]] ; then
		target_cpu="arm"
		ffmpeg_target_arch=$(usex cpu_flags_arm_neon arm-neon arm)
	elif [[ "${myarch}" == "ppc64" ]] ; then
		target_cpu="ppc64"
		ffmpeg_target_arch="ppc64"
	else
		die "Failed to determine target arch, got '${myarch}'."
	fi

	myconf_gn+=" current_cpu=\"${target_cpu}\""
	myconf_gn+=" host_cpu=\"${target_cpu}\""
	myconf_gn+=" target_cpu=\"${target_cpu}\""
	myconf_gn+=" v8_current_cpu=\"${target_cpu}\""

	if ! use cpu_flags_x86_sse2 ; then
		myconf_gn+=" use_sse2=false"
	fi

	if ! use cpu_flags_x86_sse4_2 ; then
		myconf_gn+=" use_sse4_2=false"
	fi

	if ! use cpu_flags_x86_ssse3 ; then
		myconf_gn+=" use_ssse3=false"
	fi

	if use cpu_flags_x86_avx2 ; then
		myconf_gn+=" rtc_enable_avx2=true"
	else
		myconf_gn+=" rtc_enable_avx2=false"
	fi

	# Make sure that -Werror doesn't get added to CFLAGS by the build
	# system.  Depending on GCC version the warnings are different and we
	# don't want the build to fail because of that.
	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Disable external code space for V8 for ppc64. It is disabled for ppc64
	# by default, but cross-compiling on amd64 enables it again.
	if tc-is-cross-compiler ; then
		if ! use amd64 && ! use arm64; then
			myconf_gn+=" v8_enable_external_code_space=false"
		fi
	fi

	# Only enabled for clang, but gcc has endian macros too
	myconf_gn+=" v8_use_libm_trig_functions=true"

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	if use system-ffmpeg ; then
		local build_ffmpeg_args=""
		if use pic && [[ "${ffmpeg_target_arch}" == "ia32" ]] ; then
			build_ffmpeg_args+=" --disable-asm"
		fi

	# Re-configure bundled ffmpeg. See bug #491378 for example reasons.
einfo
einfo "Configuring bundled ffmpeg..."
einfo
		pushd third_party/ffmpeg > /dev/null || die
			chromium/scripts/build_ffmpeg.py \
				linux ${ffmpeg_target_arch} \
				--branding ${ffmpeg_branding} \
				-- \
				${build_ffmpeg_args} \
				|| die
			chromium/scripts/copy_config.sh || die
			chromium/scripts/generate_gn.py || die
		popd > /dev/null || die
	fi

	# Disable unknown warning message from clang.
	if tc-is-clang; then
		append-flags -Wno-unknown-warning-option
		if tc-is-cross-compiler; then
			export BUILD_CXXFLAGS+=" -Wno-unknown-warning-option"
			export BUILD_CFLAGS+=" -Wno-unknown-warning-option"
		fi
	fi

	# Explicitly disable ICU data file support for system-icu/headless builds.
	if use system-icu || use headless; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	# Enable ozone wayland and/or headless support
	myconf_gn+=" use_ozone=true"
	myconf_gn+=" ozone_auto_platforms=false"
	myconf_gn+=" ozone_platform_headless=true"
	if use headless ; then
		myconf_gn+=" ozone_platform=\"headless\""
		myconf_gn+=" use_xkbcommon=false"
		myconf_gn+=" use_gtk=false"
		myconf_gn+=" use_qt5=false"
		myconf_gn+=" use_qt6=false"
		myconf_gn+=" use_glib=false"
		myconf_gn+=" use_gio=false"
		myconf_gn+=" use_pangocairo=false"
		myconf_gn+=" use_alsa=false"
		myconf_gn+=" use_libpci=false"
		myconf_gn+=" use_udev=false"
		myconf_gn+=" enable_print_preview=false"
		myconf_gn+=" enable_remoting=false"
	else
		myconf_gn+=" use_system_libdrm=true"
		myconf_gn+=" use_system_minigbm=true"
		myconf_gn+=" use_xkbcommon=true"
		if use qt5 || use qt6 ; then
			local cbuild_libdir=$(get_libdir)
			if tc-is-cross-compiler; then
	# Hack to workaround get_libdir not being able to handle CBUILD, bug
	# #794181
				local cbuild_libdir=$($(tc-getBUILD_PKG_CONFIG) \
					--keep-system-libs \
					--libs-only-L \
					libxslt)
				cbuild_libdir=${cbuild_libdir/% }
			fi
			if use qt6 ; then
				myconf_gn+=" moc_qt6_path=\"${EPREFIX}/usr/${cbuild_libdir}/qt6/libexec\""
			elif use qt5 ; then
				if tc-is-cross-compiler; then
					myconf_gn+=" moc_qt5_path=\"${EPREFIX}/${cbuild_libdir}/qt5/bin\""
				else
					myconf_gn+=" moc_qt5_path=\"$(qt5_get_bindir)\""
				fi
			fi
		fi
		myconf_gn+=" use_qt5=$(usex qt5 true false)"
		myconf_gn+=" use_qt6=$(usex qt6 true false)"
		myconf_gn+=" ozone_platform_x11=$(usex X true false)"
		myconf_gn+=" ozone_platform_wayland=$(usex wayland true false)"
		myconf_gn+=" ozone_platform=$(usex wayland \"wayland\" \"x11\")"
		use wayland && myconf_gn+=" use_system_libffi=true"
	fi

	#
	#
	#
	#

	myconf_gn+=" is_official_build=$(usex official true false)"
	if [[ -z "${LTO_TYPE}" ]] ; then
		LTO_TYPE=$(check-linker_get_lto_type)
	fi
	if ( tc-is-clang && [[ "${LTO_TYPE}" == "thinlto" ]] ) \
		|| use cfi \
		|| ( use official && [[ "${PGO_PHASE}" != "PGI" ]] ) ; then
ewarn
ewarn "Using ThinLTO"
ewarn
		myconf_gn+=" use_thin_lto=true "
		filter-flags '-flto*'
		filter-flags '-fuse-ld=*'
		filter-flags '-Wl,--lto-O*'
		use thinlto-opt && myconf_gn+=" thin_lto_enable_optimizations=true"
	else
	# gcc doesn't like -fsplit-lto-unit and -fwhole-program-vtables
		myconf_gn+=" use_thin_lto=false "
	fi
	if use official ; then
	# Allow building against system libraries in official builds
		sed -i \
			's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py \
			|| die
	fi

	# CXXFLAGS might overwrite -march=armv8-a+crc+crypto, bug #851639
	if use arm64 && tc-is-gcc; then
		sed -i \
			'/^#if HAVE_ARM64_CRC32C/a #pragma GCC target ("+crc+crypto")' \
			third_party/crc32c/src/src/crc32c_arm64.cc \
			|| die
	fi

	# Skipping typecheck is only supported on amd64, bug #876157
	if ! use amd64; then
		myconf_gn+=" devtools_skip_typecheck=false"
	fi

	# See https://github.com/chromium/chromium/blob/118.0.5993.117/build/config/sanitizers/BUILD.gn#L196
	# See https://github.com/chromium/chromium/blob/118.0.5993.117/tools/mb/mb_config.pyl#L2950
	local is_cfi_custom=0
	if use official ; then
	# Forced because it is the final official settings.
		if [[ "${ABI}" == "amd64" ]] ; then
			myconf_gn+=" is_cfi=true"
			myconf_gn+=" use_cfi_icall=true"
			myconf_gn+=" use_cfi_cast=false"
		else
			myconf_gn+=" is_cfi=false"
			myconf_gn+=" use_cfi_cast=false"
			myconf_gn+=" use_cfi_icall=false"
		fi
	elif use cfi ; then
		local f
		local F=(
			"cfi"
			"cfi-derived-cast"
			"cfi-icall"
			"cfi-underived-cast"
			"cfi-vcall"
		)
		for f in ${F[@]} ; do
			if has_sanitizer_option "${f}" ; then
				is_cfi_custom=1
			fi
		done

		if (( ${is_cfi_custom} == 1 )) ; then
	# Change by CFLAGS
			if has_sanitizer_option "cfi-vcall" ; then
				myconf_gn+=" is_cfi=true"
			fi

			if has_sanitizer_option "cfi-derived-cast" \
				|| has_sanitizer_option "cfi-unrelated-cast" ; then
				myconf_gn+=" use_cfi_cast=true"
			else
				myconf_gn+=" use_cfi_cast=false"
			fi

			if has_sanitizer_option "cfi-icall" ; then
				myconf_gn+=" use_cfi_icall=true"
			else
				myconf_gn+=" use_cfi_icall=false"
			fi
		else
	# Fallback to autoset in non-official
			myconf_gn+=" is_cfi=true"

			local cfi_cast_default="false"
			local cfi_icall_default="false"

			if [[ "${ABI}" == "amd64" ]] ; then
				cfi_icall_default="true"
			fi

	# Allow change by environment variables
			if [[ "${USE_CFI_CAST:-${cfi_cast_default}}" == "1" ]] ; then
				myconf_gn+=" use_cfi_cast=true"
			else
				myconf_gn+=" use_cfi_cast=false"
			fi

			if [[ "${USE_CFI_ICALL:-${cfi_icall_default}}" == "1" ]] ; then
				myconf_gn+=" use_cfi_icall=true"
			else
				myconf_gn+=" use_cfi_icall=false"
			fi
		fi
	else
		myconf_gn+=" is_cfi=false"
		myconf_gn+=" use_cfi_cast=false"
		myconf_gn+=" use_cfi_icall=false"
	fi

	# Dedupe flags
	strip-flag-value "cfi-vcall"
	strip-flag-value "cfi-icall"
	strip-flag-value "cfi-derived-cast"
	strip-flag-value "cfi-unrelated-cast"

	local expected_lto_type="thinlto"
	if [[ "${myconf_gn}" =~ "is_cfi=true" ]] \
		|| has_sanitizer_option "cfi" \
		|| (( ${is_cfi_custom} == 1 )) ; then
		if ! [[ "${LTO_TYPE}" =~ ("${expected_lto_type}") ]] ; then
		# Build scripts can only use ThinLTO for CFI.
eerror
eerror "CFI requires ThinLTO."
eerror
eerror "Contents of ${ESYSROOT}/etc/portage/env/thinlto.conf:"
eerror
eerror "CFLAGS=\"\${CFLAGS} -flto=thin\""
eerror "CXXFLAGS=\"\${CXXFLAGS} -flto=thin\""
eerror "LDFLAGS=\"\${LDFLAGS} -fuse-ld=lld\""
eerror
eerror
eerror "You must apply one of the above linkers to the following file:"
eerror
eerror "Contents of ${ESYSROOT}/etc/portage/package.env"
eerror "www-client/chromium thinlto.conf"
eerror
eerror "Expected LTO type:  ${expected_lto_type}"
eerror "Actual LTO type:    ${LTO_TYPE}"
eerror
			die
		fi
	fi

	if use arm64 ; then
		if use official ; then
			myconf_gn+=" arm_control_flow_integrity=standard"
		else
			if is-flagq "-mbranch-protection=standard" ; then
				myconf_gn+=" arm_control_flow_integrity=standard"
			elif is-flagq "-mbranch-protection=pac-ret" ; then
				myconf_gn+=" arm_control_flow_integrity=pac"
			elif is-flagq "-mbranch-protection=*" ; then
				# Allow for a different option
				:;
			elif use branch-protection ; then
				myconf_gn+=" arm_control_flow_integrity=standard"
			else
				myconf_gn+=" arm_control_flow_integrity=none"
			fi
		fi
	# Dedupe flags
		filter-flags '-mbranch-protection=*'
		if use branch-protection || use official ; then
			filter-flags '-Wl,-z,force-bti'
		fi
	fi

	if use arm64 \
		&& has_sanitizer_option "shadow-call-stack" ; then
		myconf_gn+=" use_shadow_call_stack=true"
		strip-flag-value "shadow-call-stack" # Dedupe flag
	fi

	if [[ "${CHROMIUM_EBUILD_MAINTAINER}" == "1" ]] ; then # Disable annoying check
		:;
	elif use pgo ; then

		if ! tc-is-clang ; then
			request_clang_switch_message
			die
		fi

		local profdata_index_version=$(get_llvm_profdata_version_info)
		CURRENT_PROFDATA_VERSION=$(echo "${profdata_index_version}" \
			| cut -f 1 -d ":")
		CURRENT_PROFDATA_LLVM_VERSION=$(echo "${profdata_index_version}" \
			| cut -f 2 -d ":")
		if ! is_profdata_compatible ; then
eerror
eerror "Profdata compatibility:"
eerror
eerror "The PGO profile is not compatible with this version of LLVM."
eerror
eerror "Expected:\t$(get_pregenerated_profdata_index_version)"
eerror "Found:\t${CURRENT_PROFDATA_VERSION} for ~sys-devel/llvm-${CURRENT_PROFDATA_LLVM_VERSION}"
eerror
eerror "The solution is to rebuild using a newer/older commit or tag."
eerror
eerror "The mapping between INSTR_PROF_INDEX_VERSION and the commit or tag can be"
eerror "found in InstrProfData.inc in the LLVM repo."
eerror
			die
		else
einfo
einfo "Profdata compatibility:"
einfo
einfo "Expected:\t$(get_pregenerated_profdata_index_version)"
einfo "Found:\t${CURRENT_PROFDATA_VERSION} for ~sys-devel/llvm-${CURRENT_PROFDATA_LLVM_VERSION}"
einfo
		fi
	fi

	# See also build/config/compiler/pgo/BUILD.gn#L71 for PGO flags.
	# See also https://github.com/chromium/chromium/blob/118.0.5993.117/docs/pgo.md
	# profile-instr-use is clang which that file assumes but gcc doesn't have.
	# chrome_pgo_phase:  0=NOP, 1=PGI, 2=PGO
	if tc-is-cross-compiler || use epgo ; then
	# Disallow build files choices because they only do Clang PGO.
		myconf_gn+=" chrome_pgo_phase=0"
	elif use pgo && tc-is-clang && ver_test $(clang-major-version) -ge ${PREGENERATED_PGO_PROFILE_MIN_LLVM_SLOT} ; then
	# The profile data is already shipped so use it.
	# PGO profile location: chrome/build/pgo_profiles/chrome-linux-*.profdata
		myconf_gn+=" chrome_pgo_phase=2"
	else
	# The pregenerated profiles are not GCC compatible.
		myconf_gn+=" chrome_pgo_phase=0"
	# Kept symbols in build for debug reports for official
		# myconf_gn+=" symbol_level=0"
	fi

	if ! use epgo || tc-is-cross-compiler ; then
		:;
	else
		[[ "${PGO_PHASE}" == "PGI" ]] && myconf_gn+=" gcc_pgi=true"
	fi

	myconf_gn+=" llvm_libdir=\"$(get_libdir)\""

	if tc-is-clang ; then
		if ver_test $(clang-major-version) -ge 16 ; then
			myconf_gn+=" clang_version=$(clang-major-version)"
		else
			myconf_gn+=" clang_version=$(clang-fullversion)"
		fi
	fi

	uopts_src_configure

einfo
einfo "Configuring Chromium..."
einfo
	set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
	echo "$@"
	"$@" || die
}

_eninja() {
	local ninja_into="${1}"
	local target_id="${2}"
	local pax_path="${3}"
	local file_name=$(basename "${2}")

einfo
einfo "Building ${file_name}"
einfo
	eninja -C "${ninja_into}" "${target_id}"

	if [[ -n "${pax_path}" ]] ; then
		pax-mark m "${pax_path}"
	fi
}

_update_licenses() {
	# Upstream doesn't package PATENTS files
	if [[ -n "${CHROMIUM_EBUILD_MAINTAINER}" \
		&& -n "${GEN_ABOUT_CREDITS}" \
		&& "${GEN_ABOUT_CREDITS}" == "1" ]] ; then
einfo
einfo "Generating license and copyright notice file"
einfo
		eninja -C out/Release about_credits
		# It should be updated when the major.minor.build.x changes
		# because of new features.
		local license_file_name="${PN}-"$(ver_cut 1-3 ${PV})".x"
		local fp=$(sha512sum \
"${s}/out/Release/gen/components/resources/about_credits.html" \
			| cut -f 1 -d " ")
einfo
einfo "Update the license file with"
einfo
einfo "  \`cp -a ${s}/out/Release/gen/components/resources/about_credits.html \
${MY_OVERLAY_DIR}/licenses/${license_file_name}\`"
einfo
einfo "Update ebuild with"
einfo
einfo "  LICENSE_FINGERPRINT=\"${fp}\""
einfo
einfo "and with LICENSE variable updates.  When you are done updating, comment"
einfo "out GEN_ABOUT_CREDITS."
einfo
		die
	fi
}

__clean_build() {
	if [[ -f out/Release/chromedriver ]] ; then
		rm -f out/Release/chromedriver || die
	fi
	if [[ -f out/Release/chromedriver.unstripped ]] ; then
		rm -f out/Release/chromedriver.unstripped || die
	fi
	if [[ -f out/Release/build.ninja ]] ; then
		pushd out/Release > /dev/null || die
einfo
einfo "Cleaning out build"
einfo
			eninja -t clean
		popd > /dev/null || die
	fi
}

_get_s() {
	if (( ${NABIS} == 1 )) ; then
		echo "${S}"
	else
		echo "${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	fi
}

_src_compile() {
	export s=$(_get_s)
	cd "${s}" || die

	# Final link uses lots of file descriptors.
	ulimit -n 2048

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Don't inherit PYTHONPATH from environment, bug #789021, #812689
	local -x PYTHONPATH=

	#"${EPYTHON}" tools/clang/scripts/update.py \
	#	--force-local-build \
	#	--gcc-toolchain /usr \
	#	--skip-checkout \
	#	--use-system-cmake \
	#	--without-android || die

	_update_licenses
	__clean_build

	# Build mksnapshot and pax-mark it.
	local x
	for x in mksnapshot v8_context_snapshot_generator; do
		if tc-is-cross-compiler ; then
			_eninja \
				"out/Release" \
				"host/${x}" \
				"out/Release/host/${x}"
		else
			_eninja \
				"out/Release" \
				"${x}" \
				"out/Release/${x}"
		fi
	done

	# Even though ninja autodetects number of CPUs, we respect user's
	# options, for debugging with -j 1 or any other reason.
	_eninja "out/Release" "chrome" "out/Release/chrome"
	_eninja "out/Release" "chromedriver" ""
	_eninja "out/Release" "chrome_sandbox" ""

	mv out/Release/chromedriver{.unstripped,} || die

	rm -f out/Release/locales/*.pak.info || die

	# Build manpage; bug #684550
	sed -e  '
		s|@@PACKAGE@@|chromium-browser|g;
		s|@@MENUNAME@@|Chromium|g;
		' \
		chrome/app/resources/manpage.1.in \
		> out/Release/chromium-browser.1 \
		|| die

	# Build desktop file; bug #706786
	local suffix
	(( ${NABIS} > 1 )) && suffix=" (${ABI})"
	sed -e  "
		s|@@MENUNAME@@|Chromium${suffix}|g;
		s|@@USR_BIN_SYMLINK_NAME@@|chromium-browser-${ABI}|g;
		"'
		s|@@PACKAGE@@|chromium-browser|g;
		s|\(^Exec=\)/usr/bin/|\1|g;
		' \
		chrome/installer/linux/common/desktop.template \
		> out/Release/chromium-browser-chromium.desktop \
		|| die

	# Build vk_swiftshader_icd.json; bug #827861
	sed -e 's|${ICD_LIBRARY_PATH}|./libvk_swiftshader.so|g' \
		third_party/swiftshader/src/Vulkan/vk_swiftshader_icd.json.tmpl \
		> out/Release/vk_swiftshader_icd.json \
		|| die
}

_src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome

	newexe out/Release/chrome_sandbox chrome-sandbox
	fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"

	newexe out/Release/chromedriver chromedriver-${ABI}
	doexe out/Release/chrome_crashpad_handler

	ozone_auto_session=$(\
		 ! use headless \
		&& use wayland \
		&& use X \
		&& echo "true" \
		|| echo "false")
	sed -e  "
		s:/usr/lib/:/usr/$(get_libdir)/:g;
		s:chromium-browser-chromium.desktop:chromium-browser-chromium-${ABI}.desktop:g;
		s:@@OZONE_AUTO_SESSION@@:${ozone_auto_session}:g;
		" \
		"${FILESDIR}/chromium-launcher-r7.sh" \
		> chromium-launcher.sh \
		|| die
	newexe chromium-launcher.sh chromium-launcher-${ABI}.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		/usr/bin/chromium-browser-${ABI}
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		/usr/bin/chromium-browser
	# Keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		/usr/bin/chromium-${ABI}
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		/usr/bin/chromium

	dosym "${CHROMIUM_HOME}/chromedriver-${ABI}" \
		/usr/bin/chromedriver-${ABI}
	dosym "${CHROMIUM_HOME}/chromedriver-${ABI}" \
		/usr/bin/chromedriver

	# Allow users to override command-line options, bug #357629.
	insinto /etc/chromium
	newins "${FILESDIR}/chromium.default" "default"

	pushd out/Release/locales > /dev/null || die
		chromium_remove_language_paks
	popd > /dev/null || die

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin
	doins out/Release/*.pak
	(
		shopt -s nullglob
		local files=(
			out/Release/*.so
			out/Release/*.so.[0-9]
		)
		[[ ${#files[@]} -gt 0 ]] && doins "${files[@]}"
	)

	# Install bundled xdg-utils, avoids installing X11 libraries with
	# USE="-X wayland"
	doins out/Release/xdg-{settings,mime}

	if ! use system-icu && ! use headless; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/MEIPreload

	# Install vk_swiftshader_icd.json; bug #827861
	doins out/Release/vk_swiftshader_icd.json

	if [[ -d out/Release/swiftshader ]] ; then
		insinto "${CHROMIUM_HOME}/swiftshader"
		doins out/Release/swiftshader/*.so
	fi

	# Install icons
	local branding size
	for size in 16 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
			*)     branding="chrome/app/theme/chromium" ;;
		esac
		newicon \
			-s ${size} \
			"${branding}/product_logo_${size}.png" \
			chromium-browser.png
	done

	# Install desktop entry
	newmenu out/Release/chromium-browser-chromium.desktop \
		chromium-browser-chromium-${ABI}.desktop

	# Install GNOME default application entry (bug #303100).
	insinto /usr/share/gnome-control-center/default-apps
	newins "${FILESDIR}"/chromium-browser.xml chromium-browser.xml

	# Install manpage; bug #684550
	doman out/Release/chromium-browser.1
	dosym chromium-browser.1 /usr/share/man/man1/chromium.1

	readme.gentoo_create_doc

	# This next pass will copy PATENTS, *ThirdParty*, NOTICE files;
	# and npm micropackages copyright notices and licenses which may not
	# have been present in the listed the the .html (about:credits) file.
	lcnr_install_files

	uopts_src_install
}

src_compile() {
	compile_abi() {
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		cd $(_get_s) || die
		_src_install
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	uopts_pkg_postinst
	if ! use headless; then
		if use vaapi ; then
	# It says 3 args:
	# https://github.com/chromium/chromium/blob/118.0.5993.117/docs/gpu/vaapi.md#vaapi-on-linux
einfo
einfo "VA-API is disabled by default at runtime.  You have to enable it by"
einfo "adding --enable-features=VaapiVideoDecoder --ignore-gpu-blocklist with"
einfo "either --use-gl=desktop or --use-gl=egl to the CHROMIUM_FLAGS in"
einfo "/etc/chromium/default."
einfo
		fi
		if use screencast ; then
einfo
einfo "Screencast is disabled by default at runtime. Either enable it by"
einfo "navigating to chrome://flags/#enable-webrtc-pipewire-capturer inside"
einfo "Chromium or add --enable-features=WebRTCPipeWireCapturer to"
einfo "CHROMIUM_FLAGS in /etc/chromium/default."
einfo
		fi
		if use gtk4; then
einfo
einfo "Chromium prefers GTK3 over GTK4 at runtime. To override this behavior"
einfo "you need to pass --gtk-version=4, e.g. by adding it to CHROMIUM_FLAGS in"
einfo "/etc/chromium/default."
einfo
		fi
		if use qt5 || use qt6 ; then
einfo
einfo "Chromium automatically selects Qt5 or Qt6 based on your desktop"
einfo "environment. To override you need to pass --qt-version=5 or"
einfo "--qt-version=6, e.g. by adding it to CHROMIUM_FLAGS in"
einfo "/etc/chromium/default."
einfo
		fi
	fi

einfo
einfo "By default, the /usr/bin/chromium and /usr/bin/chromedriver symlinks are"
einfo "set to the last ABI installed.  You must change it manually if you want"
einfo "to run on a different default ABI."
einfo
einfo "Examples:"
einfo
einfo "  ln -sf /usr/lib64/chromium-browser/chromium-launcher-${ABI}.sh /usr/bin/chromium"
einfo "  ln -sf /usr/lib/chromium-browser/chromium-launcher-${ABI}.sh /usr/bin/chromium"
einfo "  ln -sf /usr/lib32/chromium-browser/chromium-launcher-${ABI}.sh /usr/bin/chromium"
einfo "  ln -sf /usr/lib32/chromium-browser/chromedriver-${ABI} /usr/bin/chromedriver"
einfo

einfo
einfo "See metadata.xml or \`epkginfo -x =${CATEGORY}/${P}::oiledmachine-overlay\`"
einfo "for proper building with PGO+BOLT"
einfo
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, build-32-bit-on-64-bit, license-completeness, license-transparency, prebuilt-pgo-access, shadowcallstack-option-access, disable-simd-on-old-microarches-with-zlib, allow-cfi-with-official-build-settings, branch-protection-access
# OILEDMACHINE-OVERLAY-META-WIP: event-based-full-pgo

#
# = Ebuild fork maintainer checklist =
#
# Update to latest stable every week
# Sync update patch section
#   Check for patch failure
#   Fix patches
# Sync update depends section
# Update license files
#   Set GEN_ABOUT_CREDITS=1
#   Copy license to license folder
# Update the llvm commit details
#  Update CR_CLANG_USED
#  Update CR_CLANG_USED_UNIX_TIMESTAMP
#  Update LLVM_MAX_SLOT, LLVM_MIN_SLOT, LLVM_SLOTS
# Sync update keeplibs, gn_system_libraries
# Sync update CHROMIUM_LANGS in every major version
# Bump chromium-launcher-rX.sh if changed
#
# *Sync update means to keep it updated with the distro ebuild.
#

# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  YES
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 114.0.5735.90 (20230601)
# Tests performed (on wayland):
#   video on demand - pass
#     opus - pass
#     av1 - pass
#     vpx - pass
#     h264 - pass
#   audio streaming - pass
#     US radio website(s) - pass
#     MX radio website(s) - pass
#     UK websites - pass
#     aac streams (shoutcast v1 / HTTP 0.9) - expected fail, some links will work with v2
#     mp3 streams (shoutcast v1 / HTTP 0.9) - expected fail, some links will work with v2
#   audio on demand - pass
#     aac - pass
#     mp3 - pass
#     vorbis - pass
#     wav - pass
#   browsing - pass
#   WebGL Aquarium - pass, ~60 fps with default settings
#   CanvasMark 2013 (html5 canvas tests) - pass
#   GPU Shader Experiments (https://www.kevs3d.co.uk/dev/shaders/) - pass, randomly selected
# Test comments:  Built with clang 17.0.0, Python 3.11.  64-bit ABI only
# USE="X bundled-libcxx cfi custom-cflags dav1d openh264 opus pgo (pic)
# CFLAGS:  -O2 -pipe (after conversion)
# TODO:  Retest -Ofast in 115
# proprietary-codecs pulseaudio vpx wayland -bluetooth -branch-protection
# (-component-build) -cups (-debug) -ebolt -encode -epgo -gtk4 -hangouts
# (-headless) -js-type-check -kerberos -libaom -official -pax-kernel
# -pre-check-vaapi -proprietary-codecs-disable
# -proprietary-codecs-disable-nc-developer -proprietary-codecs-disable-nc-user
# -qt5 (-qt6) -r1 -screencast (-selinux) (-suid) -system-dav1d -system-ffmpeg
# -system-flac -system-fontconfig -system-freetype -system-harfbuzz -system-icu
# -system-libaom -system-libdrm -system-libjpeg-turbo -system-libpng
# -system-libstdcxx -system-libwebp -system-libxml -system-libxslt
# -system-openh264 -system-opus -system-re2 -system-zlib -thinlto-opt -vaapi
# -vaapi-hevc -vorbis -widevine"

# OILEDMACHINE-OVERLAY-TEST:  FAILED (interactive) 115.0.5790.40 (20230601)
# C{,XX}FLAGS:  -Ofast -pipe ; TODO:  Fix -Ofast crashes
# LDFLAGS:  -fuse-ld=thin
# gl-aquarium test - stuck non-moving fishes
# tab crash when watching music videos
