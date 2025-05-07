# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 134.0.6998.88 -> 135.0.7049.84
# 135.0.7049.84 -> 135.0.7049.114
# 135.0.7049.114 -> 136.0.7103.59
# 136.0.7103.59 -> 136.0.7103.92

MY_PV="chromium-${PV}"

TARBALL_FLAVOR="lite" # full or lite

# For lite versus full tarball see:
# https://github.com/OSSystems/meta-browser/issues/763
# https://groups.google.com/a/chromium.org/g/chromium-packagers/c/oE60kVFFMyQ/m/T26AJMc7AgAJ
# Added dirs:   https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipes/publish_tarball.py;l=291
# Pruned dirs:  https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipe_modules/chromium/resources/export_tarball.py;l=28
# Pruned list:  https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipes/publish_tarball.expected/basic.json

# The lite prunes the following:
# .git folders
# Build tools and source code (closure-compiler, llvm, node, rust)
# Debian sysroots
# Debug libraries
# NaCl
# Proprietary platform support
# Testing support (apache-linux, blink web tests, test samples, fuzzing data)

inherit dhms

KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}"
# https://gsdview.appspot.com/chromium-browser-official/?marker=chromium-136.0.7103.0.tar.x%40
# https://commondatastorage.googleapis.com/chromium-browser-official/chromium-136.0.7103.264.tar.xz
if [[ "${TARBALL_FLAVOR}" == "lite" ]] ; then
	SRC_URI="
https://gsdview.appspot.com/chromium-browser-official/chromium-${PV}-lite.tar.xz
	"
else
	SRC_URI="
https://gsdview.appspot.com/chromium-browser-official/chromium-${PV}.tar.xz
	"
fi

DESCRIPTION="Chromium sources"
HOMEPAGE="https://www.chromium.org/"
# emerge does not understand ^^ in the LICENSE variable and have been replaced
# with ||.  You should choose at most one at some instances.
LICENSE="
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
	Alliance-for-Open-Media-Patent-License-1.0
	APSL-2
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	base64
	Boost-1.0
	BSD
	BSD-2
	BSD-4
	CC-BY-3.0
	CC-BY-4.0
	CC-BY-ND-2.5
	CC0-1.0
	chromium-$(ver_cut 1-3 ${PV}).x.html
	custom
	fft2d
	FLEX
	FTL
	g711
	g722
	GPL-2+
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
	libvpx-PATENTS
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
	unicode
	Unicode-DFS-2016
	unRAR
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
	widevine
	|| (
		GPL-2
		LGPL-2.1
		MPL-1.1
	)
	|| (
		(
			GPL-2+
			MPL-2.0
		)
		(
			LGPL-2.1+
			MPL-2.0
		)
		GPL-2.0+
		MPL-2.0
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
# Alliance-for-Open-Media-Patent-License-1.0 third_party/libaom/source/libaom/PATENTS
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
# custom - out/Release/gen/components/resources/about_credits.html [Same as chromium-121.0.6167.x.html license file]
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
# libvpx-PATENTS - third_party/libvpx/source/libvpx/PATENTS
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
RESTRICT="binchecks mirror strip test"
SLOT="0/${PV}"
IUSE+=" ebuild_revision_4"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

pkg_setup() {
	dhms_start
}

src_unpack() {
	unpack ${A}
}

# _method0() {
# Completion time:  0 days, 6 hrs, 46 mins, 52 secs
# Reasons for slowdown:
# 1. Output in console
# 2. cp -aT
# 3. scanelf
# 4. write to /var/db/pkg/.../CONTENTS
# 5. md5sum for each file for CONTENTS
# }

_method1() {
	rm -rf "/usr/share/chromium/sources"
	mkdir -p "/usr/share/chromium/sources"
	# Bypass scanelf and writing to /var/pkg/db
	# Use filesystem tricks (pointer change) to speed up merge time.
	mv "${WORKDIR}/chromium-${PV}/"* "/usr/share/chromium/sources" || die
	mv $(find "${WORKDIR}/chromium-${PV}/" -maxdepth 1 -name ".*" -type f) "/usr/share/chromium/sources" || die
# Completion time:  0 days, 0 hrs, 26 mins, 22 secs
}

src_install() {
	keepdir "/usr/share/chromium/sources"
	addwrite "/usr/share/chromium/sources"
	_method1
}

pkg_postinst() {
	dhms_end
ewarn "When emerge runs after the speedup changes it will wipe some files.  Please re-emerge again."
	local count=$(find "/usr/share/chromium/sources/" -type f | wc -l)
einfo "QA:  Update chromium ebuild with sources_count_expected=${count}"
	echo "${count}" > "/usr/share/chromium/sources/file-count"
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/usr/share/chromium/sources"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
