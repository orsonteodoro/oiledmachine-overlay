# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2009-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Monitor
#   https://chromereleases.googleblog.com/search/label/Dev%20updates
# for security updates.  They are announced faster than NVD.
# See https://omahaproxy.appspot.com/ for the latest linux version

EAPI=7
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml"

CHROMIUM_LANGS="
af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he hi hr hu id
it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv sw ta te th tr
uk ur vi zh-CN zh-TW
"

EPGO_PV=$(ver_cut 1-3 ${PV})
LLVM_MAX_SLOT=15
LLVM_MIN_SLOT=15 # The pregenerated PGO profile needs profdata version 8
CR_CLANG_SLOT_OFFICIAL=15
LLVM_SLOTS=(${LLVM_MAX_SLOT}) # [inclusive, inclusive] high to low
inherit check-reqs chromium-2 desktop flag-o-matic ninja-utils pax-utils \
python-any-r1 readme.gentoo-r1 toolchain-funcs xdg-utils
inherit epgo llvm multilib multilib-minimal # Added by the oiledmachine-overlay

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="https://chromium.org/"
PATCHSET="2"
PATCHSET_NAME="chromium-$(ver_cut 1)-patchset-${PATCHSET}"
MTD_V="${PV}"
CTDM_V="${PV}"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.xz
	https://github.com/stha09/chromium-patches/releases/download/${PATCHSET_NAME}/${PATCHSET_NAME}.tar.xz
"
#
# Some assets encoded by proprietary-codecs (mp3, aac, h264) are found in both
#   ${PN}-${CTDM_V}-chrome-test-data-media.tar.gz
#   ${PN}-${MTD_V}-media-test-data.tar.gz
# but shouldn't be necessary to use the USE flag.
#
RESTRICT="mirror"

#
# emerge does not understand ^^ in the LICENSE variable and have been replaced
# with ||.  You should choose at most one at some instances.
# GEN_ABOUT_CREDITS=1 # Uncomment to generate about_credits.html including bundled.
#
# SHA512 about_credits.html fingerprint:
#
LICENSE_FINGERPRINT="\
ce498e4da2de345614b7bd0da67bc6bed709e37617de0b48bac53f911a0f5595\
af40e0eab8a2ed0152472726f00b2942d8aaf1a9a222d4d9177d87bc3757f3d4"
LICENSE="
	BSD
	chromium-$(ver_cut 1-3 ${PV}).x
	APSL-2
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	( all-rights-reserved MIT )
	BSD-2
	BSD-4
	base64
	CC0-1.0
	CC-BY-3.0
	CC-BY-4.0
	CC-BY-ND-2.5
	FTL
	fft2d
	GPL-2+
	g711
	g722
	IJG
	ILA-OpenCV
	ISC
	( ISC CC-BY-SA-4.0 )
	Khronos-CLHPP
	LGPL-2
	LGPL-2+
	LGPL-2.1+
	libpng2
	libwebrtc-PATENTS
	MIT
	( MIT CC0-1.0 )
	MPL-1.1
	MPL-2.0
	neon_2_sse
	OFL-1.1
	ooura
	openssl
	PSF-2
	QU-fft
	Unlicense
	UoI-NCSA
	unRAR
	unicode
	SGI-B-2.0
	sigslot
	SunPro
	svgo
	WTFPL-2
	x11proto
	ZLIB
	widevine? ( widevine )
"
#
# Benchmark website licenses:
# See the webkit-gtk ebuild
#
# BSD-2 BSD LGPL-2.1 - Kraken benchmark
#   ( ( all-rights-reserved || ( MIT AFL-2.1 ) ) (MIT GPL) BSD MIT )
#   ( all-rights-reserved ^^ ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
#   ( all-rights-reserved GPL-3+ ) tests/kraken-1.0/audio-beat-detection-data.js
#   || ( BSD GPL-2 ) ; for SJCL
#   MPL-1.1 tests/kraken-1.0/imaging-desaturate.js
#   public-domain hosted/json2.js

# Third Party Licenses:
#
# TODO:  The rows marked custom need to have or be placed a license file or
#        reevaluated.
# TODO:  scan all font files for embedded licenses
#
# ^^ ( FTL GPL-2 ) ZLIB public-domain - third_party/freetype/src/LICENSE.TXT
# ^^ ( GPL-2+ LGPL-2.1+ MPL-1.1 ) - chrome/utility/importer/nss_decryptor.cc
# ^^ ( GPL-2+ LGPL-2.1+ MPL-1.1 ) BSD BSD-2 - third_party/libgifcodec/LICENSE.md
# || ( WTFPL-2 Apache-2.0 ) - \
#   third_party/catapult/third_party/polymer2/bower_components/sinon-chai/LICENSE.txt ; \
#   the WTFPL is the better choice because Apache-2.0 has more restrictions
# || ( MIT GPL-3 ) third_party/catapult/tracing/third_party/jszip/LICENSE.markdown ; \
#   upstream has more MIT than GPL3 copyright notices, so MIT is assumed
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
# BSD ^^ ( MPL-1.1 GPL-2+ LGPL-2+ ) - \
#   third_party/openscreen/src/third_party/mozilla/LICENSE.txt
# BSD CC-BY-3.0 CC-BY-4.0 MIT public-domain - third_party/snappy/src/COPYING
# BSD ISC MIT openssl - third_party/boringssl/src/LICENSE
# BSD MPL-1.1 - url/third_party/mozilla/LICENSE.txt
# BSD-2 - third_party/node/node_modules/eslint-scope/LICENSE
# BSD-2 IJG MIT - third_party/libavif/src/LICENSE
# base64 - third_party/webrtc/rtc_base/third_party/base64/LICENSE
# custom - third_party/llvm/clang-tools-extra/clang-tidy/cert/LICENSE.TXT
# custom - third_party/llvm/clang-tools-extra/clang-tidy/hicpp/LICENSE.TXT
# custom ^^ ( BSD-2 BSD ) - third_party/blink/LICENSE_FOR_ABOUT_CREDITS
# custom Apache-2.0-with-LLVM-exceptions UoI-NCSA third_party/llvm/openmp/LICENSE.TXT
# custom CC-BY-ND-2.5 LGPL-2.1+ GPL-2+ public-domain - \
#   third_party/blink/perf_tests/svg/resources/LICENSES
# custom BSD APSL-2 MIT BSD-4 - third_party/breakpad/breakpad/LICENSE
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
# ILA-OpenCV (BSD with additional clauses) - third_party/opencv/src/LICENSE
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
# LGPL-2.1+ - third_party/ffmpeg/libavcodec/x86/xvididct.asm
# libpng2 - third_party/pdfium/third_party/libpng16/LICENSE
# MIT CC0-1.0 - third_party/node/node_modules/eslint/node_modules/lodash/LICENSE
# MIT SGI-B-2.0 - third_party/khronos/LICENSE
# MIT unicode - third_party/node/node_modules/typescript/ThirdPartyNoticeText.txt
# MPL-2.0 - third_party/node/node_modules/mdn-data/LICENSE
# neon_2_sse - third_party/neon_2_sse/LICENSE
# OFL-1.1 - third_party/freetype-testing/src/fuzzing/corpora/cff-render-ftengine/bungeman/HangingS.otf
# ooura - third_party/webrtc/common_audio/third_party/ooura/LICENSE
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
# UoI-NCSA - third_party/swiftshader/third_party/llvm-subzero/LICENSE.TXT
# unRAR - third_party/unrar/LICENSE
# widevine - third_party/widevine/LICENSE
# WTFPL BSD-2 - third_party/catapult/third_party/polymer2/bower_components/sinon-chai/LICENSE.txt
# x11proto - third_party/x11proto/LICENSE
# * The public-domain entry was not added to the LICENSE ebuild variable to not
#   give the wrong impression that the entire software was released in public
#   domain.
#
SLOT="0/stable"
KEYWORDS="amd64 arm64 ~x86" # Waiting for server to upload tarball
#
# vaapi is enabled by default upstream for some arches \
# See https://github.com/chromium/chromium/blob/104.0.5112.79/media/gpu/args.gni#L24
#
# Using the system-ffmpeg or system-icu breaks cfi-icall or cfi-cast which is
#   incompatible as a shared lib.
#
# The suid is built by default upstream but not necessarily used:  \
#   https://github.com/chromium/chromium/blob/104.0.5112.79/sandbox/linux/BUILD.gn
#
CPU_FLAGS_ARM=( neon )
CPU_FLAGS_X86=( sse2 ssse3 sse4_2 )
# CFI Basic (.a) mode requires all third party modules built as static.
IUSE="${CPU_FLAGS_ARM[@]/#/cpu_flags_arm_} ${CPU_FLAGS_X86[@]/#/cpu_flags_x86_}
+X component-build cups -debug gtk4 +hangouts headless +js-type-check kerberos
+official pic +proprietary-codecs pulseaudio screencast selinux +suid
-system-ffmpeg -system-icu -system-harfbuzz -system-png +vaapi wayland widevine"
IUSE+=" weston r0"
# What is considered a proprietary codec can be found at:
#   https://github.com/chromium/chromium/blob/104.0.5112.79/media/filters/BUILD.gn#L160
#   https://github.com/chromium/chromium/blob/104.0.5112.79/media/media_options.gni#L38
#   https://github.com/chromium/chromium/blob/104.0.5112.79/media/base/supported_types.cc#L203
#     Upstream doesn't consider MP3 proprietary, but this ebuild does.
#   https://github.com/chromium/chromium/blob/104.0.5112.79/media/base/supported_types.cc#L284
# Codec upstream default: https://github.com/chromium/chromium/blob/104.0.5112.79/tools/mb/mb_config_expectations/chromium.linux.json#L89
IUSE+=" video_cards_amdgpu video_cards_intel video_cards_iris
video_cards_i965 video_cards_nouveau video_cards_nvidia
video_cards_r600 video_cards_radeonsi" # For VA-API
IUSE+=" +partitionalloc libcmalloc"
#
# For cfi-vcall, cfi-icall defaults status, see \
#   https://github.com/chromium/chromium/blob/104.0.5112.79/build/config/sanitizers/sanitizers.gni
# For cfi-cast default status, see \
#   https://github.com/chromium/chromium/blob/104.0.5112.79/build/config/sanitizers/sanitizers.gni#L123
# For pgo default status, see \
#   https://github.com/chromium/chromium/blob/104.0.5112.79/build/config/compiler/pgo/pgo.gni#L15
# For libcxx default, see \
#   https://github.com/chromium/chromium/blob/104.0.5112.79/build/config/c++/c++.gni#L14
# For cdm availability see third_party/widevine/cdm/widevine.gni#L28
#
IUSE_LIBCXX=( bundled-libcxx system-libstdcxx )
IUSE+=" ${IUSE_LIBCXX[@]} +bundled-libcxx branch-protection-standard +cfi-vcall
cfi-cast +cfi-icall +clang +pre-check-llvm +pre-check-vaapi lto-opt +pgo
shadowcallstack"
# perf-opt
_ABIS=(
	abi_x86_32
	abi_x86_64
	abi_x86_x32
	abi_mips_n32
	abi_mips_n64
	abi_mips_o32
	abi_ppc_32
	abi_ppc_64
	abi_s390_32
	abi_s390_64
)
IUSE+=" ${_ABIS[@]}"

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
REQUIRED_USE+="
	^^ (
		${IUSE_LIBCXX[@]}
	)
	^^ (
		partitionalloc
		libcmalloc
	)
	!clang? (
		!cfi-cast
		!cfi-icall
		!cfi-vcall
		!shadowcallstack
	)
	!headless (
		|| (
			X
			wayland
		)
	)
	!proprietary-codecs? (
		!system-ffmpeg
		!vaapi
	)
	amd64? (
		!shadowcallstack
	)
	bundled-libcxx? (
		clang
	)
	branch-protection-standard? (
		arm64
	)
	cfi-cast? (
		!system-ffmpeg
		!system-harfbuzz
		!system-icu
		!system-libstdcxx
		cfi-vcall
	)
	cfi-icall? (
		!system-ffmpeg
		!system-harfbuzz
		!system-icu
		!system-libstdcxx
		cfi-vcall
	)
	cfi-vcall? (
		!system-ffmpeg
		!system-harfbuzz
		!system-icu
		!system-libstdcxx
		clang
	)
	component-build? (
		!bundled-libcxx
		!suid
	)
	lto-opt? (
		clang
	)
	official? (
		pgo
		!epgo
		!debug
		!system-ffmpeg
		!system-harfbuzz
		!system-icu
		!system-libstdcxx
		bundled-libcxx
		partitionalloc
		amd64? (
			cfi-icall
			cfi-vcall
		)
	)
	partitionalloc? (
		!component-build
	)
	pgo? (
		clang
		!epgo
	)
	epgo? (
		!pgo
	)
	ppc64? (
		!shadowcallstack
	)
	pre-check-llvm? (
		clang
	)
	pre-check-vaapi? (
		vaapi
	)
	screencast? (
		wayland
	)
	shadowcallstack? (
		clang
	)
	system-libstdcxx? (
		!cfi-cast
	)
	system-libstdcxx? (
		!cfi-icall
	)
	system-libstdcxx? (
		!cfi-vcall
	)
	vaapi? ( proprietary-codecs )
	video_cards_amdgpu? (
		!video_cards_r600
		!video_cards_radeonsi
	)
	video_cards_r600? (
		!video_cards_amdgpu
		!video_cards_radeonsi
	)
	video_cards_radeonsi? (
		!video_cards_amdgpu
		!video_cards_r600
	)
	widevine? (
		!arm64
		!ppc64
	)
	x86? (
		!shadowcallstack
	)
"

LIBVA_V="2.7"
FFMPEG_V="4.3"

LIBVA_DEPEND="
	vaapi? (
		|| (
			video_cards_amdgpu? (
				media-libs/mesa:=[gallium,vaapi,video_cards_radeonsi,${MULTILIB_USEDEP}]
			)
			video_cards_i965? (
				|| (
					x11-libs/libva-intel-media-driver
					x11-libs/libva-intel-driver[${MULTILIB_USEDEP}]
				)
			)
			video_cards_intel? (
				|| (
					x11-libs/libva-intel-media-driver
					x11-libs/libva-intel-driver[${MULTILIB_USEDEP}]
				)
			)
			video_cards_iris? (
				x11-libs/libva-intel-media-driver
			)
			video_cards_nouveau? (
				media-libs/mesa:=[gallium,video_cards_nouveau,${MULTILIB_USEDEP}]
				|| (
					media-libs/mesa:=[gallium,vaapi,video_cards_nouveau,${MULTILIB_USEDEP}]
					>=x11-libs/libva-vdpau-driver-0.7.4-r3[${MULTILIB_USEDEP}]
				)
			)
			video_cards_nvidia? (
				>=x11-libs/libva-vdpau-driver-0.7.4-r1[${MULTILIB_USEDEP}]
				x11-drivers/nvidia-drivers
			)
			video_cards_r600? (
				media-libs/mesa:=[gallium,vaapi,video_cards_r600,${MULTILIB_USEDEP}]
			)
			video_cards_radeonsi? (
				media-libs/mesa:=[gallium,vaapi,video_cards_radeonsi,${MULTILIB_USEDEP}]
			)
		)
		>=x11-libs/libva-${LIBVA_V}:=[${MULTILIB_USEDEP}]
		system-ffmpeg? (
			>=media-video/ffmpeg-${FFMPEG_V}[vaapi,${MULTILIB_USEDEP}]
		)
	)
"

gen_bdepend_llvm() {
	local o_all=""
	local t=""
	local o_official=""
	for s in ${LLVM_SLOTS[@]} ; do
		t="
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${s}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${s}
			=sys-libs/compiler-rt-${s}*
			=sys-libs/compiler-rt-sanitizers-${s}*:=[shadowcallstack?]
			cfi-cast? (
				=sys-libs/compiler-rt-sanitizers-${s}*:=[cfi]
			)
			cfi-icall? (
				=sys-libs/compiler-rt-sanitizers-${s}*:=[cfi]
			)
			cfi-vcall? (
				=sys-libs/compiler-rt-sanitizers-${s}*:=[cfi]
			)
		"
		o_all+=" ( ${t} ) "
		(( ${s} == ${CR_CLANG_SLOT_OFFICIAL} )) && o_official=" ${t} "
	done
	echo -e "
		|| ( ${o_all} )
		official? ( ${o_official} )
	"
}

COMMON_X_DEPEND="
	x11-libs/libXcomposite:=[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:=[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:=[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXi-1.6.0:=[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	x11-libs/libXrender:=[${MULTILIB_USEDEP}]
	x11-libs/libXtst:=[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence:=[${MULTILIB_USEDEP}]
"

COMMON_SNAPSHOT_DEPEND="
	system-icu? ( >=dev-libs/icu-71.1:=[${MULTILIB_USEDEP}] )
	>=dev-libs/libxml2-2.9.4-r3:=[icu,${MULTILIB_USEDEP}]
	dev-libs/nspr:=[${MULTILIB_USEDEP}]
	>=dev-libs/nss-3.26:=[${MULTILIB_USEDEP}]
	system-libstdcxx? ( >=dev-libs/re2-0.2019.08.01:=[${MULTILIB_USEDEP}] )
	dev-libs/libxslt:=[${MULTILIB_USEDEP}]
	media-libs/fontconfig:=[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.11.0-r1:=[${MULTILIB_USEDEP}]
	system-harfbuzz? ( >=media-libs/harfbuzz-3:0=[icu(-),${MULTILIB_USEDEP}] )
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	system-png? ( media-libs/libpng:=[-apng,${MULTILIB_USEDEP}] )
	>=media-libs/libwebp-0.4.0:=[${MULTILIB_USEDEP}]
	media-libs/mesa:=[gbm(+),${MULTILIB_USEDEP}]
	proprietary-codecs? ( >=media-libs/openh264-1.6.0:=[${MULTILIB_USEDEP}] )
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	x11-libs/libdrm:=[${MULTILIB_USEDEP}]
	!headless? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		>=media-libs/alsa-lib-1.0.19:=[${MULTILIB_USEDEP}]
		pulseaudio? ( media-sound/pulseaudio:=[${MULTILIB_USEDEP}] )
		sys-apps/pciutils:=[${MULTILIB_USEDEP}]
		kerberos? ( virtual/krb5[${MULTILIB_USEDEP}] )
		vaapi? ( >=x11-libs/libva-${LIBVA_V}:=[X,drm,${MULTILIB_USEDEP}] )
		X? (
			x11-libs/libX11:=[${MULTILIB_USEDEP}]
			x11-libs/libXext:=[${MULTILIB_USEDEP}]
			x11-libs/libxcb:=[${MULTILIB_USEDEP}]
		)
		x11-libs/libxkbcommon:=[${MULTILIB_USEDEP}]
		wayland? (
			dev-libs/wayland:=[${MULTILIB_USEDEP}]
			screencast? ( media-video/pipewire:=[${MULTILIB_USEDEP}] )
		)
	)
"

# No multilib for this virtual/udev when it should be.
VIRTUAL_UDEV="
	|| (
		>=sys-fs/udev-217[${MULTILIB_USEDEP}]
		>=sys-fs/eudev-2.1.1[${MULTILIB_USEDEP}]
		>=sys-apps/systemd-217[${MULTILIB_USEDEP}]
	)
"

COMMON_DEPEND="
	${COMMON_SNAPSHOT_DEPEND}
	${LIBVA_DEPEND}
	app-arch/bzip2:=[${MULTILIB_USEDEP}]
	dev-libs/expat:=[${MULTILIB_USEDEP}]
	system-ffmpeg? (
		>=media-video/ffmpeg-${FFMPEG_V}:=[${MULTILIB_USEDEP}]
		|| (
			>=media-video/ffmpeg-${FFMPEG_V}[-samba,${MULTILIB_USEDEP}]
			>=net-fs/samba-4.5.10-r1[-debug(-),${MULTILIB_USEDEP}]
		)
		>=media-libs/opus-1.3.1:=[${MULTILIB_USEDEP}]
	)
	net-misc/curl[ssl,${MULTILIB_USEDEP}]
	sys-apps/dbus:=[${MULTILIB_USEDEP}]
	media-libs/flac:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[minizip,${MULTILIB_USEDEP}]
	!headless? (
		X? ( ${COMMON_X_DEPEND} )
		>=app-accessibility/at-spi2-atk-2.26:2[${MULTILIB_USEDEP}]
		>=app-accessibility/at-spi2-core-2.26:2[${MULTILIB_USEDEP}]
		>=dev-libs/atk-2.26[${MULTILIB_USEDEP}]
		media-libs/mesa:=[X?,wayland?,${MULTILIB_USEDEP}]
		cups? ( >=net-print/cups-1.3.11:=[${MULTILIB_USEDEP}] )
		${VIRTUAL_UDEV}
		x11-libs/cairo:=[${MULTILIB_USEDEP}]
		x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
		x11-libs/pango:=[${MULTILIB_USEDEP}]
	)
"
RDEPEND="${COMMON_DEPEND}
	!headless? (
		|| (
			x11-libs/gtk+:3[X?,wayland?,${MULTILIB_USEDEP}]
			gui-libs/gtk:4[X?,wayland?]
		)
		x11-misc/xdg-utils
	)
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
"
DEPEND="${COMMON_DEPEND}
	!headless? (
		gtk4? ( gui-libs/gtk:4[X?,wayland?] )
		!gtk4? ( x11-libs/gtk+:3[X?,wayland?,${MULTILIB_USEDEP}] )
	)
"
BDEPEND="
	${COMMON_SNAPSHOT_DEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	>=app-arch/gzip-1.7
	dev-lang/perl
	>=dev-util/gn-0.1807
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	dev-vcs/git
	>=net-libs/nodejs-7.6.0[inspector]
	>=sys-devel/bison-2.4.3
	sys-devel/flex[${MULTILIB_USEDEP}]
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	clang? ( $(gen_bdepend_llvm) )
	js-type-check? ( virtual/jre )
	vaapi? ( media-video/libva-utils )
"

# Upstream uses llvm:13
# When CFI + PGO + official was tested, it didn't work well with LLVM12.  Error noted in
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/f0c13049dc89f068370511b4664f7fb111df2d3a/www-client/chromium/bug_notes
# This is why LLVM13 was set as the minimum and did fix the problem.

# For the current llvm for this project, see
#   https://github.com/chromium/chromium/blob/104.0.5112.79/tools/clang/scripts/update.py#L42
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
	has_version -b "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pre_build_checks() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		local -x CPP="$(tc-getCXX) -E"
		if tc-is-gcc && ! ver_test "$(gcc-version)" -ge 9.2 ; then
			die "At least gcc 9.2 is required"
		fi
		if use clang || tc-is-clang ; then
			tc-is-cross-compiler && CPP=${CBUILD}-clang++ || CPP=${CHOST}-clang++
			CPP+=" -E"
			local clang_min
			if use official ; then
				clang_min=${CR_CLANG_SLOT_OFFICIAL}
			else
				clang_min=${LLVM_MIN_SLOT}
			fi
			if ! ver_test "$(clang-major-version)" -ge ${clang_min} ; then
				die "At least clang ${clang_min} is required"
			fi
		fi
	fi

# https://github.com/chromium/chromium/blob/104.0.5112.79/docs/linux/build_instructions.md#system-requirements
# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="4G"
	CHECKREQS_DISK_BUILD="10G"
	tc-is-cross-compiler && CHECKREQS_DISK_BUILD="13G"
	if use clang ; then
		CHECKREQS_MEMORY="9G"
		CHECKREQS_DISK_BUILD="12G"
		tc-is-cross-compiler && CHECKREQS_DISK_BUILD="15G"
	fi
	if ( shopt -s extglob; is-flagq '-g?(gdb)?([1-9])' ) ; then
		if use custom-cflags || use component-build ; then
			CHECKREQS_DISK_BUILD="25G"
		fi
		if ! use component-build ; then
			CHECKREQS_MEMORY="16G"
		fi
	fi

	# Assumes 2.1875 ratio (as the uncompressed:compressed ratio)
	local has_compressed_memory=0
	local required_total_memory=27
	local required_total_memory_lto=16
	if grep -q -e "Y" "/sys/module/zswap/parameters/enabled" ; then
		has_compressed_memory=1
		required_total_memory=12 # Done with zswap
		required_total_memory_lto=8
	fi

	local total_memory_sources=$(free --giga | tail -n +2 \
		| sed -r -e "s|[ ]+| |g" | cut -f 2 -d " ")
	local total_memory=0
	for total_memory_source in ${total_memory_sources[@]} ; do
		total_memory=$((${total_memory} + ${total_memory_source}))
	done
	if (( ${total_memory} < ${required_total_memory} )) ; then
#
# It randomly fails and a success observed with 8 GiB of total memory
# (ram + swap) when multitasking.  It works with 16 GiB of total memory when
# multitasking, but peak virtual memory (used + reserved) is ~10.2 GiB for
# ld.lld.
#
# [43742.787803] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/,task=ld.lld,pid=27154,uid=250
# [43742.787817] Out of memory: Killed process 27154 (ld.lld) total-vm:10471016kB, anon-rss:2440396kB, file-rss:3180kB, shmem-rss:0kB, UID:250 pgtables:20168kB oom_score_adj:0
# [43744.101600] oom_reaper: reaped process 27154 (ld.lld), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
#
ewarn
ewarn "You may need >= ${required_total_memory} GiB of total memory to link"
ewarn "${PN}.  Please add more swap space or enable swap compression.  You"
ewarn "currently have ${total_memory} GiB of total memory."
ewarn
	else
einfo
einfo "Total memory is sufficient (>= ${required_total_memory} GiB met)."
einfo
	fi

	if use lto-opt && (( ${total_memory} <= ${required_total_memory_lto} )) ; then
eerror
eerror "lto-opt requires >= ${required_total_memory_lto} of total memory.  Add"
eerror "more swap space or enable swap compression."
eerror
		die
	fi

	if has_version "x11-libs/libva-intel-driver" ; then
ewarn
ewarn "x11-libs/libva-intel-driver is the older vaapi driver but intended for"
ewarn "select hardware.  See also x11-libs/libva-intel-media-driver package"
ewarn "to access more vaapi accelerated encoders if driver support overlaps."
ewarn
	fi

	check-reqs_pkg_setup
}

pkg_pretend() {
	pre_build_checks

	if use headless; then
		local headless_unused_flags=("cups" "kerberos" "pulseaudio"
			"vaapi" "wayland")
		for myiuse in ${headless_unused_flags[@]}; do
			if use ${myiuse} ; then
ewarn
ewarn "Ignoring USE=${myiuse} since USE=headless is set."
ewarn
			fi
		done
	fi
}

# The answer to the profdata compatibility is answered in
# https://clang.llvm.org/docs/SourceBasedCodeCoverage.html#format-compatibility-guarantees

# The profdata (aka indexed profile) version is 8 corresponding from >= llvm 15
# up to main branch (llvm 15) and is after the magic (lprofi - i for index) in the
# profdata file located in chrome/build/pgo_profiles/*.profdata.

# PGO version compatibility

# Profdata versioning:
# https://github.com/llvm/llvm-project/blob/ba4537b2/llvm/include/llvm/ProfileData/InstrProf.h#L991
# LLVM version:
# https://github.com/llvm/llvm-project/blob/ba4537b2/llvm/CMakeLists.txt#L14

# LLVM 15
CR_CLANG_USED="c2a7904a" # Obtained from \
# https://github.com/chromium/chromium/blob/104.0.5112.79/tools/clang/scripts/update.py#L42 \
# https://github.com/llvm/llvm-project/commit/c2a7904a
CR_CLANG_USED_UNIX_TIMESTAMP="1652308059" # Cached.  Use below to obtain this. \
# TIMESTAMP=$(wget -q -O - https://github.com/llvm/llvm-project/commit/${CR_CLANG_USED}.patch \
#	| grep -F -e "Date:" | sed -e "s|Date: ||") ; date -u -d "${TIMESTAMP}" +%s
# Change also CR_CLANG_SLOT_OFFICIAL

contains_slotted_major_version() {
	# For sys-devel/llvm:x slot style
	local live_pkgs_=(
		sys-devel/llvm
		sys-devel/clang
	)
	local x="${1}"
	local p
	for p in ${live_pkgs_[@]} ; do
		[[ "${x}" == "${p}" ]] && return 0
	done
	return 1
}

contains_slotted_triple_version() {
	# For sys-libs/compiler-rt-sanitizers:x.y.z slot style
	local live_pkgs_=(
		sys-libs/compiler-rt
		sys-libs/compiler-rt-sanitizers
	)
	local x="${1}"
	local p
	for p in ${live_pkgs_[@]} ; do
		[[ "${x}" == "${p}" ]] && return 0
	done
	return 1
}

contains_slotted_zero() {
	# For sys-devel/llvm:0 slot style
	local live_pkgs_=(
		sys-libs/libomp
		sys-devel/lld
	)
	local x="${1}"
	local p
	for p in ${live_pkgs_[@]} ; do
		[[ "${x}" == "${p}" ]] && return 0
	done
	return 1
}

_print_timestamps() {
	local timestamp
	if [[ -n "${emerged_llvm_timestamp}" ]] ; then
		timestamp=$(date -d "@${emerged_llvm_timestamp}")
einfo
einfo "System's ${p} timestamp:  ${timestamp}"
einfo
		if [[ "${p}" == "sys-devel/llvm" ]] ; then
			timestamp=$(date -d "@${cr_clang_used_unix_timestamp}")
einfo
einfo "${PN^}'s LLVM timestamp:  ${timestamp}"
einfo
		else
			timestamp=$(date -d "@${LLVM_TIMESTAMP}")
einfo
einfo "System's sys-devel/llvm timestamp:  ${timestamp}"
einfo
		fi
	fi
}

_get_release_hash() {
	local v="${1}"
	if [[ -z "${cached_release_hashes[${v}]}" ]] ; then

		# This doesn't redirect to the tip
		#local hash=$(git --no-pager ls-remote \
		#	https://github.com/llvm/llvm-project.git \
		#	llvmorg-${v} \
		#	| cut -f 1 -d $'\t')

		# Get the tip
		local hash=$(
			wget -q -O - \
		https://github.com/llvm/llvm-project/commits/llvmorg-${v} \
				| grep "/commit/" \
				| head -n 1 \
				| cut -f 2 -d "\"" \
				| cut -f 5 -d "/"
		)
		cached_release_hashes[${v}]="${hash}"
	fi
	echo "${cached_release_hashes[${v}]}"
}

_get_llvm_timestamp() {
	local emerged_llvm_commit
	if [[ -z "${emerged_llvm_commit}" ]] ; then
		# Should check against the llvm milestone if not live
		while [[ "${pv:0:1}" =~ [A-Za-z] ]] ; do
			pv="${pv#*-}"
		done
		local v=$(ver_cut 1-3 "${pv}")
		local suffix=""
		if [[ "${pv}" =~ "_rc" ]] ; then
			suffix=$(echo "${pv}" | grep -E -o -e "_rc[0-9]+")
			suffix=${suffix//_/-}
		fi
		v="${v}${suffix}"
		emerged_llvm_commit=$(_get_release_hash ${v})
	fi
	if [[ -z "${emerged_llvm_timestamps[${emerged_llvm_commit}]}" ]] ; then
einfo
einfo "Fetching timestamp for ${emerged_llvm_commit}"
einfo
		# Uncached
		# Fetched uncached because of potential partial download problems.
		local emerged_llvm_time_desc=$(wget -q -O - \
	https://github.com/llvm/llvm-project/commit/${emerged_llvm_commit}.patch)
		if [[ -z "${emerged_llvm_time_desc}" ]] ; then
eerror
eerror "${emerged_llvm_commit} didn't download anything."
eerror
			die
		fi
		if echo "${emerged_llvm_time_desc}" | grep "Not Found" ; then
eerror
eerror "The commit ${emerged_llvm_commit} doesn't exist."
eerror
			die
		fi
		emerged_llvm_time_desc=$(echo -e "${emerged_llvm_time_desc}" \
			| grep -F -e "Date:" \
			| sed -e "s|Date: ||")
		emerged_llvm_timestamp=$(date -u -d "${emerged_llvm_time_desc}" +%s)
		emerged_llvm_timestamps[${emerged_llvm_commit}]=${emerged_llvm_timestamp}
einfo
einfo "Timestamp comparison for ${p}"
einfo
		_print_timestamps
	else
einfo
einfo "Using cached timestamp for ${emerged_llvm_commit}"
einfo
		# Cached
		emerged_llvm_timestamp=${emerged_llvm_timestamps[${emerged_llvm_commit}]}
einfo
einfo "Timestamp comparison for ${p}"
einfo
		_print_timestamps
	fi
}

_check_llvm_updated() {
	local root_pkg_timestamp=""

	local timestamp_type=-1
	if [[ "${p}" == "sys-devel/llvm" ]] ; then
		if use official ; then
			root_pkg_timestamp="${cr_clang_used_unix_timestamp}"
		else
			root_pkg_timestamp="${LLVM_TIMESTAMP}"
		fi
		timestamp_type=0
	else
		root_pkg_timestamp="${LLVM_TIMESTAMP}"
		timestamp_type=1
	fi

	[[ -z "${emerged_llvm_timestamp}" ]] && die
	[[ -z "${root_pkg_timestamp}" ]] && die

	if (( ${timestamp_type} == 0 )) ; then
		if (( ${emerged_llvm_timestamp} < ${root_pkg_timestamp} )) ; then
			needs_emerge=1
			llvm_packages_status[${p_}]="1" # needs emerge
		else
			llvm_packages_status[${p_}]="0" # package is okay
		fi
	else
		if (( ${emerged_llvm_timestamp} < ${root_pkg_timestamp} )) ; then
			needs_emerge=1
			llvm_packages_status[${p_}]="1" # needs emerge
		else
			llvm_packages_status[${p_}]="0" # package is okay
		fi
	fi
}

# For multiple sys-libs/compiler-rt-sanitizers:x.y.z
_check_llvm_updated_triple() {
	[[ -z "${emerged_llvm_timestamp}" ]] && die
	[[ -z "${LLVM_TIMESTAMP}" ]] && die

	#einfo "Using LLVM_TIMESTAMP"
	#einfo "${emerged_llvm_timestamp} < ${LLVM_TIMESTAMP} ? ${p} (2)"
	if (( ${emerged_llvm_timestamp} < ${LLVM_TIMESTAMP} )) ; then
		#einfo "needs merge"
		needs_emerge=1
		llvm_packages_status[${p_}]="1" # needs emerge
		old_triple_slot_packages+=( "${category}/${pn}:"$(cat "${mp}/SLOT") )
	else
		#einfo "no merge needed"
		llvm_packages_status[${p_}]="0" # package is okay
	fi
}

print_old_live_llvm_multislot_pkgs() {
	local arg="${1}"
	local llvm_slot="${2}"
	for x in ${old_triple_slot_packages[@]} ; do
		local slot=${x/:*}
		if [[ "${arg}" == "${slot}" ]] ; then
			LLVM_REPORT_CARDS[${llvm_slot}]+="emerge -1vuDN ${x}\n"
		fi
	done
}

verify_llvm_report_card() {
	local llvm_slot=${1}
	if (( ${needs_emerge} == 1 )) ; then
		for p in ${live_pkgs[@]} ; do
			local p_=${p//-/_}
			p_=${p_//\//_}
			if [[ -z "${llvm_packages_status[${p_}]}" ]] || (( ${llvm_packages_status[${p_}]} == 1 )) ; then
				if contains_slotted_major_version "${p}" ; then
					LLVM_REPORT_CARDS[${llvm_slot}]+="emerge -1vuDN ${p}:${llvm_slot}\n"
				elif contains_slotted_triple_version "${p}" ; then
					print_old_live_llvm_multislot_pkgs "${p}" ${llvm_slot}
				elif contains_slotted_zero "${p}" ; then
					LLVM_REPORT_CARDS[${llvm_slot}]+="emerge -1vuDN ${p}:0\n"
				fi
			fi
		done
	else
		LLVM_REPORT_CARDS[${llvm_slot}]="pass"
	fi
}

LLVM_TIMESTAMP=
verify_llvm_toolchain() {
	local llvm_slot=${1}
einfo
einfo "Inspecting for llvm:${llvm_slot}"
einfo

	if use official ; then
		cr_clang_used_unix_timestamp=${CR_CLANG_USED_UNIX_TIMESTAMP}
	else
		cr_clang_used_unix_timestamp=${CR_CLANG_USED_UNIX_TIMESTAMP}
	fi

	# Everything that inherits the llvm.org must be checked.
	# sys-devel/clang-runtime doesn't need check
	# 3 slot types
	# sys-devel/llvm:x
	# sys-devel/clang:x
	# sys-libs/compiler-rt:x.y.z
	# sys-libs/compiler-rt-sanitizers:x.y.z
	# sys-libs/libomp:0
	# sys-devel/lld:0
	local live_pkgs=(
		# Do not change the order!
		sys-devel/llvm
		sys-libs/libomp
		sys-devel/lld
		sys-devel/clang
		sys-libs/compiler-rt
		sys-libs/compiler-rt-sanitizers
	)

	unset emerged_llvm_timestamps
	declare -A emerged_llvm_timestamps

	unset llvm_packages_status
	declare -A llvm_packages_status

	unset cached_release_hashes
	declare -A cached_release_hashes

	local old_triple_slot_packages=()

	[[ -z "${llvm_slot}" ]] && die "llvm_slot is empty"

	local pass=0
	local needs_emerge=0
	# The llvm library or llvm-ar doesn't embed the hash info, so scan the /var/db/pkg.
	if has_version "sys-devel/llvm:${llvm_slot}" ; then
		for p in ${live_pkgs[@]} ; do
			# Check each of the live packages that use llvm.org
			# eclass.  Especially for forgetful types.

			local emerged_llvm_commit

			local p_=${p//-/_}
			p_=${p_//\//_}
			if contains_slotted_major_version "${p}" ; then
einfo
einfo "Checking ${p}:${llvm_slot}"
einfo
				local path=$(realpath "${EROOT}/var/db/pkg/${p}-${llvm_slot}"*"/environment.bz2")
				if [[ -e "${path}" ]] ; then
					emerged_llvm_commit=$(bzcat \
						"${path}" \
						| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
					pv=$(cat "${EROOT}/var/db/pkg/${p}-${llvm_slot}"*"/PF" | sed "s|${p}-||")
					_get_llvm_timestamp
					[[ "${p}" == "sys-devel/llvm" ]] \
						&& LLVM_TIMESTAMP=${emerged_llvm_timestamp}
				else
ewarn
ewarn "Missing ${p}:${llvm_slot}"
ewarn
					p="sys-devel/llvm"
					emerged_llvm_timestamp=$(( ${cr_clang_used_unix_timestamp} -1 ))
				fi
				_check_llvm_updated
			elif contains_slotted_zero "${p}" ; then
einfo
einfo "Checking ${p}:0"
einfo
				local path=$(realpath "${EROOT}/var/db/pkg/${p}"*"/environment.bz2")
				if [[ -e "${path}" ]] ; then
					emerged_llvm_commit=$(bzcat \
						"${path}" \
						| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
					pv=$(cat "${EROOT}/var/db/pkg/${p}"*"/PF" | sed "s|${p}-||")
					_get_llvm_timestamp
				else
ewarn
ewarn "Missing ${p}:${llvm_slot}"
ewarn
					p="sys-devel/llvm"
					emerged_llvm_timestamp=$(( ${cr_clang_used_unix_timestamp} -1 ))
				fi
				_check_llvm_updated
			else
				local category=${p/\/*}
				local pn=${p/*\/}
				# Handle multiple slots (i.e multiple sys-libs/compiler-rt-sanitizers:x.y.z)
				# We shouldn't have to deal with multiple sys-libs/compiler-rt-sanitizers
				# 13.0.0.9999 13.0.0_rc3 13.0.0_rc2 versions installed at the same time
				# for just 1 sys-libs/llvm but we have to.
				for mp in $(find "${EROOT}/var/db/pkg/${category}" \
					-maxdepth 1 \
					-type d \
					-regextype "posix-extended" \
					-regex ".*${pn}-${llvm_slot}.[0-9.]+") ; do
					local path=$(realpath "${mp}/environment.bz2")
					if [[ -e "${path}" ]] ; then
						emerged_llvm_commit=$(bzcat \
							"${path}" \
							| grep -F -e "EGIT_VERSION" \
							| head -n 1 \
							| cut -f 2 -d '"')
						pv=$(cat "${mp}/PF" | sed "s|${p}-||")
						_get_llvm_timestamp
					else
ewarn
ewarn "Missing ${p}:${llvm_slot}"
ewarn
						emerged_llvm_timestamp=$(( ${cr_clang_used_unix_timestamp} -1 ))
					fi
					_check_llvm_updated_triple
				done
			fi
		done
		verify_llvm_report_card ${llvm_slot}
	else
		# For not installed
		local compiler_rt_sanitizers_args=()
		[[ "${USE}" =~ "cfi" ]] && compiler_rt_sanitizers_args+=( cfi ubsan )
		use shadowcallstack && compiler_rt_sanitizers_args+=( shadowcallstack )
		if (( ${#compiler_rt_sanitizers_args[@]} > 0 )) ; then
			local args=$(echo "${compiler_rt_sanitizers_args[@]}" \
				| tr " " ",")
			LLVM_REPORT_CARDS[${llvm_slot}]=\
"emerge -1vuDN clang:${llvm_slot} llvm:${llvm_slot} "\
"=clang-runtime-${llvm_slot}*[compiler-rt,sanitize] "\
"=sys-libs/compiler-rt-sanitizers-${llvm_slot}*[${args}]\n"
		else
			LLVM_REPORT_CARDS[${llvm_slot}]=\
"emerge -1vuDN clang:${llvm_slot} llvm:${llvm_slot}\n"
		fi
	fi
}

get_pregenerated_profdata_version()
{
	test -e "${S}/chrome/build/pgo_profiles/chrome-linux-"*".profdata" || die
	echo $(od -An -j 8 -N 1 -t d1 \
		"${S}/chrome/build/pgo_profiles/chrome-linux-"*".profdata" \
		| grep -E -o -e "[0-9]+")
}

get_llvm_profdata_version_info()
{
	local profdata_v=0
	local v
	local ver
	# The live versions can have different profdata versions over time.
	for v in \
		"15.0.0.9999" \
	; do
		(( $(ver_cut 1 "${v}") != ${LLVM_SLOT} )) && continue
		(! has_version "~sys-devel/llvm-${v}" ) && continue
		local llvm_version
		if [[ "${v}" =~ "9999" ]] ; then
			local llvm_version=$(bzless \
				"${EROOT}/var/db/pkg/sys-devel/llvm-${v}"*"/environment.bz2" \
				| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
		else
			llvm_version="llvmorg-${v/_/-}"
		fi
		ver=${v}
		profdata_v=$(wget -q -O - \
https://raw.githubusercontent.com/llvm/llvm-project/${llvm_version}/llvm/include/llvm/ProfileData/InstrProfData.inc \
			| grep "INSTR_PROF_INDEX_VERSION" \
			| head -n 1 \
			| grep -E -o -e "[0-9]+")
	done
	echo "${profdata_v}:${ver}"
}

is_profdata_compatible() {
	local a=$(get_pregenerated_profdata_version)
	local b=${CURRENT_PROFDATA_VERSION}
	if (( ${a} == ${b} )) ; then
		return 0
	else
		return 1
	fi
}

# Check the system for security weaknesses.
check_deps_cfi_cross_dso() {
	if ! use cfi-vcall ; then
einfo
einfo "Skipping CFI Cross-DSO checks"
einfo
		return
	fi
	# These are libs required by the prebuilt bin version.
	# This list was generated from the _maintainer_notes/get_package_libs script.
	# TODO:  Update list for source build.
	local pkg_libs=(
libX11.so.6
libXau.so.6
libXcomposite.so.1
libXdamage.so.1
libXdmcp.so.6
libXext.so.6
libXfixes.so.3
libXrandr.so.2
libXrender.so.1
libasound.so.2
libatk-1.0.so.0
libatk-bridge-2.0.so.0
libatspi.so.0
libblkid.so.1
libbsd.so.0
libc.so.6
libcairo.so.2
libcups.so.2
libdbus-1.so.3
libdl.so.2
libdrm.so.2
libexpat.so.1
libffi.so.8
libfontconfig.so.1
libfreetype.so.6
libfribidi.so.0
libgbm.so.1
libgcc_s.so.1
libgio-2.0.so.0
libglib-2.0.so.0
libgmodule-2.0.so.0
libgmp.so.10
libgnutls.so.30
libgobject-2.0.so.0
libharfbuzz.so.0
libhogweed.so.6
libm.so.6
libmd.so.0
libmount.so.1
libnettle.so.8
libnspr4.so
libnss3.so
libnssutil3.so
libpango-1.0.so.0
libpcre.so.1
libpixman-1.so.0
libplc4.so
libplds4.so
libpng16.so.16
libpthread.so.0
librt.so.1
libsmime3.so
libstdc++.so.6
libtasn1.so.6
libunistring.so.2
libuuid.so.1
libxcb-render.so.0
libxcb-shm.so.0
libxcb.so.1
libxkbcommon.so.0
libz.so.1
	)

	# TODO: check dependency n levels deep.
	# We assume CFI Cross-DSO.
einfo
einfo "Evaluating system for possible weaknesses."
einfo "Assuming systemwide CFI Cross-DSO."
einfo
	for f in ${pkg_libs[@]} ; do
		local paths=(
$(realpath {"${EPREFIX}"/usr/lib/gcc/*/{,32/},/lib,/usr/lib}*"/${f}" 2>/dev/null)
		)
		if (( "${#paths[@]}" == 0 )) ; then
ewarn "${f} does not exist."
			continue
		fi
		local path
		path=$(echo "${paths[@]}" | tr " " "\n" | tail -n 1)
		local real_path=$(realpath "${path}")
		if "${BROOT}/usr/bin/readelf" -Ws "${real_path}" 2>/dev/null \
			| grep -E -q -e "(cfi_bad_type|cfi_check_fail|__cfi_init)" ; then
einfo "${f} is CFI protected."
		else
ewarn "${f} is NOT CFI protected."
		fi
	done
einfo
einfo "The information presented is a draft report that may not"
einfo "represent your configuration.  Some libraries listed"
einfo "may not be be able to be CFI Cross-DSOed."
einfo
einfo "An estimated >= 37.7% (26/69) of the libraries listed should be"
einfo "marked CFI protected."
einfo
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

	# nvidia-drivers does not work correctly with Wayland due to unsupported
	# EGLStreams
	if use wayland \
		&& ! use headless \
		&& has_version "x11-drivers/nvidia-drivers" ; then
ewarn
ewarn "Proprietary nVidia driver does not work with Wayland. You can disable"
ewarn "Wayland by setting DISABLE_OZONE_PLATFORM=true in /etc/chromium/default."
ewarn
	fi

	if ! use amd64 && [[ "${USE}" =~ cfi ]] ; then
ewarn
ewarn "All variations of the cfi USE flags are not defaults for this platform."
ewarn "Disable them if problematic."
ewarn
	fi

	if use official && tc-is-cross-compiler ; then
eerror
eerror "Do not use USE=official with cross-compiling"
eerror
		die
	fi

	if ( \
		use cfi-cast \
		|| use cfi-vcall \
		|| use cfi-icall \
	) \
		&& tc-is-cross-compiler ; then
eerror
eerror "Do not use USE=cfi-cast, USE=cfi-vcall, USE=cfi-icall with"
eerror "cross-compiling."
eerror
		die
	fi

	if use official || ( use clang && use cfi-vcall && use pgo ) ; then
		# sys-devel/lld-13 was ~20 mins for v8_context_snapshot_generator
		# sys-devel/lld-12 was ~4 hrs for v8_context_snapshot_generator
ewarn
ewarn "Linking times may take longer than usual.  Maybe 1-12+ hour(s)."
ewarn
	fi

	# These checks are a maybe required.
	if use clang ; then
		# No LLVM multi version bug here.
		# Cr will still work if Mesa slot is lower and Cr is built with
		# a higher version.
		local s
		if use pre-check-llvm ; then
			unset LLVM_REPORT_CARDS
			for s in ${LLVM_SLOTS[@]} ; do
				verify_llvm_toolchain ${s}
			done
			LLVM_SLOT=
			local slots
			if use official ; then
				slots=${CR_CLANG_SLOT_OFFICIAL}
			else
				slots=$(echo "${LLVM_SLOTS[@]}" \
					| tr " " "\n" \
					| tac \
					| tr "\n" " ")
			fi
			for s in ${slots} ; do
				if [[ ${LLVM_REPORT_CARDS[${s}]} == "pass" ]] ; then
					export LLVM_SLOT=${s}
					break
				fi
			done
		else
			if use official ; then
				LLVM_SLOT=${CR_CLANG_SLOT_OFFICIAL}
			else
				LLVM_SLOT=$(ver_cut 1 $(best_version "sys-devel/clang" \
					| sed -e "s|sys-devel/clang-||g"))
			fi
		fi
		if [[ -z "${LLVM_SLOT}" ]] ; then
eerror
eerror "You must choose a LLVM slot to update properly:"
eerror
			for s in ${slots} ; do
eerror
eerror "The LLVM ${s} toolchain needs the following update(s):"
echo -e "${LLVM_REPORT_CARDS[${s}]}"
			done
eerror
eerror "OR"
eerror
eerror "You can remove the official USE flag.  The official USE flag strictly"
eerror "requires LLVM ${CR_CLANG_SLOT_OFFICIAL} and for related packages.  To"
eerror "use a different slotted LLVM, disable the official USE flag."
eerror
eerror "You must ensure that the timestamps of the installed packages are the"
eerror "same or newer than the installed LLVM for that slot for missing symbols"
eerror "avoidance AND the timestamp or commit is the same or newer than the"
eerror "timestamp of the one used to build the official build if using the"
eerror "official USE flag.  Some of these issue may be avoided if the official"
eerror "USE flag is disabled for more relaxed requirement constraints which"
eerror "requires the commits/version be the same or newer as the LLVM lib"
eerror "for missing symbols reasons."
eerror
eerror "For live ebuilds (*.9999) you might have to replace -1vuDN with -1vO to"
eerror "force a rebuild if the following message is encountered:"
eerror
eerror "  Nothing to merge; quitting."
eerror
# One reason is possibly for crash reporting.
			die
		else
			export PATH=$(echo "${PATH}" \
				| tr ":" "\n" \
				| sed -e "s|.*llvm/.*||" \
				| uniq \
				| sed -e "/^$/d" \
				| tr "\n" ":" \
				| sed -e "s|:$||")
# If building without ccache, include in the search path:
# 1.  Path to clang/clang++ (/usr/lib/llvm/${LLVM_SLOT}/bin)
# 2.  Path to highest LLD (/usr/lib/llvm/${v_major_lld}/bin)
# If ccache is installed, this really does nothing because
# /usr/lib/ccache/bin has a higher precedence.
			export PATH+=":${EPREFIX}/usr/lib/llvm/${LLVM_SLOT}/bin"
einfo
einfo "Using sys-devel/llvm:${LLVM_SLOT}"
einfo
			local lld_v_maj=$(ver_cut 1 \
				$(best_version "sys-devel/lld" \
					| sed -e "s|sys-devel/lld-||"))
			v_major_lld=$(ver_cut 1 "${v_major_lld}")
			export PATH+=":${EPREFIX}/usr/lib/llvm/${v_major_lld}/bin"
		fi
		if use pgo ; then
			local vi=$(get_llvm_profdata_version_info)
			CURRENT_PROFDATA_VERSION=$(echo "${vi}" \
				| cut -f 1 -d ":")
			CURRENT_PROFDATA_LLVM_VERSION=$(echo "${vi}" \
				| cut -f 2 -d ":")
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
ewarn "The system's libstdcxx may weaken the security.  Consider"
ewarn "using only the bundled-libcxx instead."
ewarn
	fi

	epgo_setup

	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done
}

USED_EAPPLY=0
ceapply() {
	USED_EAPPLY=1
	eapply "${@}"
}

src_unpack() {
	for a in ${A} ; do
		[[ "${a}" == "${PN}-${MTD_V}-media-test-data.tar.gz" ]] \
			&& continue
		[[ "${a}" == "${PN}-${CTDM_V}-chrome-test-data-media.tar.gz" ]] \
			&& continue
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

verify_clang_commit() {
	use pre-check-llvm || return
	local commit_id=$(grep -r -e "CLANG_REVISION" \
		"${S}/tools/clang/scripts/update.py" \
		| head -n 1 \
		| grep -E -o -e "-g[a-f0-9]+" \
		| sed -e "s|-g||g")
	if [[ "${CR_CLANG_USED}" =~ ^"${commit_id}" ]] ; then
		:;
	else
		# Update on every major version of this package.
eerror
eerror "The LLVM commit is out of date.  Update CR_CLANG_*,"
eerror "LLVM_SLOTS, CR_CLANG_SLOT_OFFICIAL variables."
eerror
		die
	fi
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	check_deps_cfi_cross_dso

	local PATCHES=()
	if ( ! use clang ) || use system-libstdcxx ; then
		# Contains arm64 patches for unknown purpose.
		# TODO: split GCC only and libstdc++ only.
		# The patches purpose are not documented well.
ewarn
ewarn "Applying GCC & libstdc++ compatibility patches."
ewarn
		PATCHES+=( "${WORKDIR}/patches" )
	fi

	PATCHES+=(
		"${FILESDIR}/chromium-93-InkDropHost-crash.patch"
		"${FILESDIR}/chromium-98-EnumTable-crash.patch"
		"${FILESDIR}/chromium-98-gtk4-build.patch"
		"${FILESDIR}/chromium-104-tflite-system-zlib.patch"
		"${FILESDIR}/chromium-104-swiftshader-no-wayland.patch"
		"${FILESDIR}/chromium-use-oauth2-client-switches-as-default.patch"
		"${FILESDIR}/chromium-shim_headers.patch"
		"${FILESDIR}/chromium-cross-compile.patch"
	)

	if use clang ; then
		if tc-is-clang ; then # Duplicate conditional is for testing reasons
			# Using gcc with these patches results in this error:
			# Two or more targets generate the same output:
			#   lib.unstripped/libEGL.so
			ceapply "${FILESDIR}/extra-patches/${PN}-92-clang-toolchain-1.patch"
			ceapply "${FILESDIR}/extra-patches/${PN}-92-clang-toolchain-2.patch"
		fi
	fi

	if use arm64 && use shadowcallstack ; then
		ceapply "${FILESDIR}/extra-patches/chromium-94-arm64-shadow-call-stack.patch"
	fi

	ceapply "${FILESDIR}/extra-patches/chromium-103.0.5060.53-zlib-selective-simd.patch"

	default

	if ( (( ${#PATCHES[@]} > 0 || ${USED_EAPPLY} == 1 )) || [[ -f "${T}/epatch_user.log" ]] ) ; then
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
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die

	# adjust python interpreter version
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die

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
		third_party/angle/src/common/third_party/base
		third_party/angle/src/common/third_party/smhasher
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/trace_event
		third_party/angle/src/third_party/volk
		third_party/apple_apsl
		third_party/axe-core
		third_party/blink
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
		third_party/cpuinfo
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/dav1d
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
		third_party/devtools-frontend/src/front_end/third_party/lit-html
		third_party/devtools-frontend/src/front_end/third_party/lodash-isequal
		third_party/devtools-frontend/src/front_end/third_party/marked
		third_party/devtools-frontend/src/front_end/third_party/puppeteer
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
		third_party/libgifcodec
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
		third_party/jinja2
		third_party/jsoncpp
		third_party/jstemplate
		third_party/khronos
		third_party/leveldatabase
		third_party/libaddressinput
		third_party/libaom
		third_party/libaom/source/libaom/third_party/fastfeat
		third_party/libaom/source/libaom/third_party/vector
		third_party/libaom/source/libaom/third_party/x86inc
		third_party/libavif
		third_party/libgav1
		third_party/libjingle
		third_party/libjxl
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
		third_party/mesa
		third_party/metrics_proto
		third_party/minigbm
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
		third_party/node/node_modules/polymer-bundler/lib/third_party/UglifyJS2
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
		third_party/pdfium/third_party/libopenjpeg20
		third_party/pdfium/third_party/libpng16
		third_party/pdfium/third_party/libtiff
		third_party/pdfium/third_party/skia_shared
		third_party/perfetto
		third_party/perfetto/protos/third_party/chromium
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private-join-and-compute
		third_party/private_membership
		third_party/protobuf
		third_party/protobuf/third_party/six
		third_party/pthreadpool
		third_party/pyjson5
		third_party/qcms
		third_party/rnnoise
		third_party/s2cellid
		third_party/securemessage
		third_party/shell-encryption
		third_party/simplejson
		third_party/skia
		third_party/skia/include/third_party/skcms
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/skcms
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
		third_party/web-animations-js
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
		v8/third_party/inspector_protocol
		v8/third_party/v8

		# gyp -> gn leftovers
		base/third_party/libevent
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils
	)
	keeplibs+=( third_party/zlib )
	#
	# Do not remove the third_party/zlib above. \
	#
	# Error:  ninja: error: '../../third_party/zlib/adler32_simd.c', \
	# needed by 'obj/third_party/zlib/zlib_adler32_simd/adler32_simd.o', \
	# missing and no known rule to make it
	#
	# third_party/zlib is already kept but may use system no need split \
	# conditional for CFI or official builds.
	#
	if ! use system-ffmpeg ; then
		keeplibs+=( third_party/ffmpeg third_party/opus )
	fi
	if ! use system-icu ; then
		keeplibs+=( third_party/icu )
	fi
	if ! use system-png; then
		keeplibs+=( third_party/libpng )
	fi
	#
	# For re2 see ! use system-libstdcxx conditional below
	#
	if use system-harfbuzz; then
		keeplibs+=( third_party/harfbuzz-ng/utils )
	else
		keeplibs+=( third_party/harfbuzz-ng )
	fi
	if use wayland && ! use headless ; then
		keeplibs+=( third_party/wayland )
	fi
	if use arm64 || use ppc64 ; then
		keeplibs+=( third_party/swiftshader/third_party/llvm-10.0 )
	fi
	if ! use system-libstdcxx \
		|| use cfi-cast \
		|| use cfi-icall \
		|| use cfi-vcall \
		|| use official ; then
		keeplibs+=( third_party/libxml )
		keeplibs+=( third_party/libxslt )
		keeplibs+=( third_party/re2 )
		#keeplibs+=( third_party/snappy )
		if use proprietary-codecs ; then
			keeplibs+=( third_party/openh264 )
		fi
		if use system-icu ; then
			keeplibs+=( third_party/icu )
		fi
	fi
	# we need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64 ; then
		pushd third_party/libvpx >/dev/null || die
		mkdir -p source/config/linux/ppc64 || die
		# requires git and clang, bug #832803
		sed -i -e "s|^update_readme||g; s|clang-format|${EPREFIX}/bin/true|g" \
			generate_gni.sh || die
		./generate_gni.sh || die
		popd >/dev/null || die

		pushd third_party/ffmpeg >/dev/null || die
		cp libavcodec/ppc/h264dsp.c libavcodec/ppc/h264dsp_ppc.c || die
		cp libavcodec/ppc/h264qpel.c libavcodec/ppc/h264qpel_ppc.c || die
		popd >/dev/null || die
	fi

	if ! is_generating_credits ; then
einfo
einfo "Unbundling third party internal libraries and packages"
einfo
		# Remove most bundled libraries. Some are still needed.
		build/linux/unbundle/remove_bundled_libraries.py \
			"${keeplibs[@]}" \
			--do-remove || die
	fi

	if use js-type-check ; then
		ln -s "${EPREFIX}"/usr/bin/java third_party/jdk/current/bin/java || die
	fi

	if ! is_generating_credits ; then
		#
		# bundled eu-strip is for amd64 only and we don't want to
		# pre-strip binaries.
		#
		mkdir -p buildtools/third_party/eu-strip/bin || die
		ln -s "${BROOT}"/bin/true \
			buildtools/third_party/eu-strip/bin/eu-strip || die
	fi

	verify_clang_commit

	(( ${NABIS} > 1 )) \
		&& multilib_copy_sources
}

meets_pgo_requirements() {
	if use pgo ; then
		local pgo_data_dir="${EPREFIX}/var/lib/pgo-profiles/${CATEGORY}/${PN}/$(ver_cut 1-2 ${pv})/${MULTILIB_ABI_FLAG}.${ABI}"
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
			return 2
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
	meets_pgo_requirements
	local ret=$?
	if ! use pgo ; then
		result="NO_PGO"
	elif use pgo && (( ${ret} == 0 )) ; then
		result="PGO"
	elif use pgo && (( ${ret} == 1 )) ; then
		result="PGI"
	elif use pgo && (( ${ret} == 2 )) ; then
		result="NO_PGO"
	fi
	echo "${result}"
}

_configure_pgx() {
	local chost=$(get_abi_CHOST ${ABI})

	EPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}"
	epgo_src_prepare

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	local myconf_gn=""

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM READELF STRIP

	if tc-is-clang && ! use clang ; then
ewarn
ewarn "Clang detected but clang USE flag was disabled."
ewarn
ewarn "Enable the clang USE flag for clang otherwise disable the clang USE"
ewarn "flag for gcc."
ewarn
		die
	fi

	# Final CC selected
	if use clang ; then
		# See build/toolchain/linux/unbundle/BUILD.gn for allowed overridable envvars.
		# See build/toolchain/gcc_toolchain.gni#L657 for consistency.
		if tc-is-cross-compiler; then
			export CC="${CBUILD}-clang -target ${CHOST} --sysroot ${ESYSROOT}"
			export CXX="${CBUILD}-clang++ -target ${CHOST} --sysroot ${ESYSROOT}"
			export BUILD_CC=${CBUILD}-clang
			export BUILD_CXX=${CBUILD}-clang++
		elif tc-is-cross-compiler && [[ -n ${FORCE_LLVM_SLOT} ]] ; then
			export CC="${CBUILD}-clang-${FORCE_LLVM_SLOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="${CBUILD}-clang++-${FORCE_LLVM_SLOT} $(get_abi_CFLAGS ${ABI})"
			export BUILD_CC=${CBUILD}-clang-${FORCE_LLVM_SLOT}
			export BUILD_CXX=${CBUILD}-clang++${FORCE_LLVM_SLOT}
		else
			export CC="clang-${LLVM_SLOT} $(get_abi_CFLAGS ${ABI})"
			export CXX="clang++-${LLVM_SLOT} $(get_abi_CFLAGS ${ABI})"
		fi
		export AR=llvm-ar # Required for LTO
		export NM=llvm-nm
		export READELF=llvm-readelf
		export STRIP=llvm-strip
		if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
			die "llvm-ar is unreachable"
		fi
	else
einfo
einfo "Forcing GCC"
einfo
		export CC="gcc $(get_abi_CFLAGS ${ABI})"
		export CXX="g++ $(get_abi_CFLAGS ${ABI})"
		export AR=ar
		export NM=nm
		export READELF=readelf
		export STRIP=strip
		export LD=ld.bfd
	fi
	strip-unsupported-flags

	# Handled by the build scripts
	filter-flags \
		'-f*sanitize*' \
		'-f*visibility*'

	if use clang ; then
		myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	else
		myconf_gn+=" is_clang=false"
	fi

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-cross-compiler ; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" pkg_config=\"$(tc-getPKG_CONFIG)\""
		myconf_gn+=" host_pkg_config=\"$(tc-getBUILD_PKG_CONFIG)\""

		# setup cups-config, build system only uses --libs option
		if use cups; then
			mkdir "${T}/cups-config" || die
			cp "${ESYSROOT}/usr/bin/${CHOST}-cups-config" \
				"${T}/cups-config/cups-config" || die
			export PATH="${PATH}:${T}/cups-config"
		fi

		# Don't inherit PKG_CONFIG_PATH from environment
		local -x PKG_CONFIG_PATH=
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

# Debug symbols level 2 is still on when official is on even though is_debug=false:
# See https://github.com/chromium/chromium/blob/104.0.5112.79/build/config/compiler/compiler.gni#L276
	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	# enable DCHECK with USE=debug only, increases chrome binary size by 30%, bug #811138.
	# DCHECK is fatal by default, make it configurable at runtime, #bug 807881.
	myconf_gn+=" dcheck_always_on=$(usex debug true false)"
	myconf_gn+=" dcheck_is_configurable=$(usex debug true false)"

	# Component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
	myconf_gn+=" is_component_build=$(usex component-build true false)"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	if use partitionalloc ; then
		myconf_gn+=" use_allocator=\"partition\""
	else
		myconf_gn+=" use_allocator=\"none\""
	fi

	# Use system-provided libraries.
	# TODO: freetype -- remove sources (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	# [B] all of gn_system_libraries set
	local gn_system_libraries=(
		flac
		fontconfig
		freetype
		# Need harfbuzz_from_pkgconfig target
		#harfbuzz-ng
		libdrm
		libjpeg
		libwebp
		# moved in use system-libstdcxx cond
		# moved in use system-libstdcxx cond
		# moved in use system-libstdcxx cond
		zlib
	)
	if use system-ffmpeg ; then
		gn_system_libraries+=( ffmpeg opus )
	fi
	if use system-icu ; then
		gn_system_libraries+=( icu )
	fi
	if use system-png ; then
		gn_system_libraries+=( libpng )
	fi
	if use system-libstdcxx ; then
		# Unbundle only without libc++, because libc++ is not fully ABI
		# compatible with libstdc++
		gn_system_libraries+=( libxml )
		gn_system_libraries+=( libxslt )
		# re2 library interface relies on std::string and std::vector
		gn_system_libraries+=( re2 )
		if use proprietary-codecs ; then
			gn_system_libraries+=( openh264 )
		fi
	fi
	# [C]
	if ! use system-libstdcxx \
		|| use cfi-cast \
		|| use cfi-icall \
		|| use cfi-vcall \
		|| use official ; then
		# Unbundling breaks cfi-icall and cfi-cast.
		# Unbundling weakens the security because it removes
		# noexecstack, full RELRO, SSP.
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
				"${gn_system_libraries[@]}" || die
		fi
	fi

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=$(usex system-harfbuzz true false)"

	# Disable deprecated libgnome-keyring dependency, bug #713012
	myconf_gn+=" use_gnome_keyring=false"

	# Optional dependencies.
	myconf_gn+=" enable_js_type_check=$(usex js-type-check true false)"
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" enable_widevine=$(usex widevine true false)"

	if use headless; then
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
	myconf_gn+=" use_gold=false use_sysroot=false"
	if use official \
		&& ( \
			use cfi-cast \
			|| use cfi-icall \
			|| use cfi-vcall \
		) \
		|| use bundled-libcxx ; then
		# If you didn't do systemwide CFI Cross-DSO, it must be static.
		myconf_gn+=" use_custom_libcxx=true"
	else
		myconf_gn+=" use_custom_libcxx=false"
	fi

	if use clang || tc-is-clang ; then
		filter-flags -fuse-ld=*
		myconf_gn+=" use_lld=true"
	else
		myconf_gn+=" use_lld=false"
	fi

	# Disable pseudolocales, only used for testing
	myconf_gn+=" enable_pseudolocales=false"

	# Disable code formating of generated files
	myconf_gn+=" blink_enable_generated_code_formatting=false"

	ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
	myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
	myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""

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
		replace-flags "-Os" "-O2"
		strip-flags

		# Debug info section overflows without component build
		# Prevent linker from running out of address space, bug #471810.
		if ! use component-build || use x86 ; then
			filter-flags "-g*"
		fi

		# Prevent libvpx/xnnpack build failures. Bug 530248, 544702,
		# 546984, 853646.
		if [[ ${myarch} == amd64 || ${myarch} == x86 ]] ; then
			filter-flags \
				-mno-avx \
				-mno-avx2 \
				-mno-fma \
				-mno-fma4 \
				-mno-mmx \
				-mno-sse2 \
				-mno-sse4.1 \
				-mno-ssse3 \
				-mno-xop
		fi
	fi

	if [[ ${myarch} = amd64 ]] ; then
		target_cpu="x64"
		ffmpeg_target_arch=x64
	elif [[ ${myarch} = x86 ]] ; then
		target_cpu="x86"
		ffmpeg_target_arch=ia32

		# This is normally defined by compiler_cpu_abi in
		# build/config/compiler/BUILD.gn, but we patch that part out.
		append-flags -msse2 -mfpmath=sse -mmmx
	elif [[ ${myarch} = arm64 ]] ; then
		target_cpu="arm64"
		ffmpeg_target_arch=arm64
	elif [[ ${myarch} = arm ]] ; then
		target_cpu="arm"
		ffmpeg_target_arch=$(usex cpu_flags_arm_neon arm-neon arm)
	elif [[ ${myarch} = ppc64 ]] ; then
		target_cpu="ppc64"
		ffmpeg_target_arch=ppc64
	else
		die "Failed to determine target arch, got '${myarch}'."
	fi

	myconf_gn+=" target_cpu=\"${target_cpu}\""
	myconf_gn+=" v8_current_cpu=\"${target_cpu}\""
	myconf_gn+=" current_cpu=\"${target_cpu}\""
	myconf_gn+=" host_cpu=\"${target_cpu}\""
	myconf_gyp+=" -Dtarget_arch=${target_arch}"

	if ! use cpu_flags_x86_sse2 ; then
		myconf_gn+=" use_sse2=false"
	fi

	if ! use cpu_flags_x86_sse4_2 ; then
		myconf_gn+=" use_sse4_2=false"
	fi

	if ! use cpu_flags_x86_ssse3 ; then
		myconf_gn+=" use_ssse3=false"
	fi

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Disable external code space for V8 for ppc64. It is disabled for ppc64
	# by default, but cross-compiling on amd64 enables it again.
	if tc-is-cross-compiler; then
		if ! use amd64 && ! use arm64; then
			myconf_gn+=" v8_enable_external_code_space=false"
		fi
	fi

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	#if ! use system-ffmpeg ; then
	if false ; then
		local build_ffmpeg_args=""
		if use pic && [[ "${ffmpeg_target_arch}" == "ia32" ]] ; then
			build_ffmpeg_args+=" --disable-asm"
		fi

		# Re-configure bundled ffmpeg. See bug #491378 for example reasons.
einfo
einfo "Configuring bundled ffmpeg..."
einfo
		pushd third_party/ffmpeg > /dev/null || die
		chromium/scripts/build_ffmpeg.py linux ${ffmpeg_target_arch} \
			--branding ${ffmpeg_branding} -- ${build_ffmpeg_args} || die
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

	# Disable opaque pointers, https://crbug.com/1316298
	if tc-is-clang; then
		if test-flag-CXX -Xclang -no-opaque-pointers; then
			append-flags -Xclang -no-opaque-pointers
			if tc-is-cross-compiler; then
				export BUILD_CXXFLAGS+=" -Xclang -no-opaque-pointers"
				export BUILD_CFLAGS+=" -Xclang -no-opaque-pointers"
			fi
		fi
	fi

	if ! use pgo-full || tc-is-cross-compiler ; then
		:;
	else
		EPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}"
		epgo_src_configure
	fi

	# Explicitly disable ICU data file support for system-icu/headless builds.
	if use system-icu || use headless; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	# Enable ozone wayland and/or headless support
	myconf_gn+=" use_ozone=true ozone_auto_platforms=false"
	myconf_gn+=" ozone_platform_headless=true"
	if use headless ; then
		myconf_gn+=" ozone_platform=\"headless\""
		myconf_gn+=" use_xkbcommon=false use_gtk=false"
		myconf_gn+=" use_glib=false use_gio=false"
		myconf_gn+=" use_pangocairo=false use_alsa=false"
		myconf_gn+=" use_libpci=false use_udev=false"
		myconf_gn+=" enable_print_preview=false"
		myconf_gn+=" enable_remoting=false"
	else
		myconf_gn+=" use_system_libdrm=true"
		myconf_gn+=" use_system_minigbm=true"
		myconf_gn+=" use_xkbcommon=true"
		myconf_gn+=" ozone_platform_x11=$(usex X true false)"
		myconf_gn+=" ozone_platform_wayland=$(usex wayland true false)"
		myconf_gn+=" ozone_platform=$(usex wayland \"wayland\" \"x11\")"
	fi

	#
	#
	#
	#

	# Enable official builds
	myconf_gn+=" is_official_build=$(usex official true false)"
	if use clang || tc-is-clang ; then
ewarn
ewarn "Using ThinLTO"
ewarn
		myconf_gn+=" use_thin_lto=true "
		use lto-opt && myconf_gn+=" thin_lto_enable_optimizations=true"
	else
		# gcc doesn't like -fsplit-lto-unit and -fwhole-program-vtables
		myconf_gn+=" use_thin_lto=false "
	fi
	if use official ; then
		# Allow building against system libraries in official builds
		sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py || die
	fi

	# user CXXFLAGS might overwrite -march=armv8-a+crc+crypto, bug #851639
	if use arm64 && tc-is-gcc; then
		sed -i '/^#if HAVE_ARM64_CRC32C/a #pragma GCC target ("+crc+crypto")' \
			third_party/crc32c/src/src/crc32c_arm64.cc || die
	fi


# See https://github.com/chromium/chromium/blob/104.0.5112.79/build/config/sanitizers/BUILD.gn#L196
	if use cfi-vcall ; then
		myconf_gn+=" is_cfi=true"
	else
		myconf_gn+=" is_cfi=false"
	fi

# See https://github.com/chromium/chromium/blob/104.0.5112.79/tools/mb/mb_config.pyl#L2950
	if use cfi-cast ; then
		myconf_gn+=" use_cfi_cast=true"
	else
		myconf_gn+=" use_cfi_cast=false"
	fi

	if use cfi-icall ; then
		myconf_gn+=" use_cfi_icall=true"
	else
		myconf_gn+=" use_cfi_icall=false"
	fi

	if use arm64 && use branch-protection-standard ; then
		myconf_gn+=" arm_control_flow_integrity=standard"
	fi

	if use arm64 && use shadowcallstack ; then
		myconf_gn+=" use_shadow_call_stack=true"
	fi

	if use pgo ; then
		if ! is_profdata_compatible ; then
eerror
eerror "Profdata compatibility:"
eerror
eerror "The PGO profile is not compatible with this version of LLVM."
eerror "Expected:  $(get_pregenerated_profdata_version)"
eerror "Found:  ${CURRENT_PROFDATA_VERSION} for ~sys-devel/llvm-${CURRENT_PROFDATA_LLVM_VERSION}"
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
einfo "Expected:  $(get_pregenerated_profdata_version)"
einfo "Found:  ${CURRENT_PROFDATA_VERSION} for ~sys-devel/llvm-${CURRENT_PROFDATA_LLVM_VERSION}"
einfo
		fi
	fi

# See also build/config/compiler/pgo/BUILD.gn#L71 for PGO flags.
# See also https://github.com/chromium/chromium/blob/104.0.5112.79/docs/pgo.md
# profile-instr-use is clang which that file assumes but gcc doesn't have.
	if tc-is-cross-compiler || use epgo ; then
		myconf_gn+=" chrome_pgo_phase=0"
	elif use pgo && tc-is-clang && ver_test $(clang-version) -ge 11 ; then
		# The profile data is already shipped so use it.
		# PGO profile location: chrome/build/pgo_profiles/chrome-linux-*.profdata
		myconf_gn+=" chrome_pgo_phase=2"
	else
		# The pregenerated profiles are not GCC compatible.
		myconf_gn+=" chrome_pgo_phase=0"
		# Kept symbols in build for debug reports for official
		# myconf_gn+=" symbol_level=0"
	fi

einfo
einfo "Configuring Chromium..."
einfo
	set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
	echo "$@"
	"$@" || die
}

_build() {
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

_build_pgx() {
	if [[ -f out/Release/chromedriver ]] ; then
		rm out/Release/chromedriver || die
	fi
	if [[ -f out/Release/chromedriver.unstripped ]] ; then
		rm out/Release/chromedriver.unstripped || die
	fi
	if [[ -f out/Release/build.ninja ]] ; then
		pushd out/Release || popd
einfo
einfo "Cleaning out build"
einfo
			eninja -t clean
		popd
	fi
	# Build mksnapshot and pax-mark it.
	local x
	for x in mksnapshot v8_context_snapshot_generator; do
		if tc-is-cross-compiler ; then
			_build "out/Release" "host/${x}" "out/Release/host/${x}"
		else
			_build "out/Release" "${x}" "out/Release/${x}"
		fi
	done

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	_build "out/Release" "chrome" "out/Release/chrome"
	_build "out/Release" "chromedriver" ""
	if use suid ; then
		_build "out/Release" "chrome_sandbox" ""
	fi

	mv out/Release/chromedriver{.unstripped,} || die
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
einfo
einfo "Update the license file by doing the following:"
einfo
einfo "  \`cp -a ${BUILD_DIR}/out/Release/gen/components/resources/about_credits.html \
${MY_OVERLAY_DIR}/licenses/${license_file_name}\`"
einfo
einfo "LICENSE_FINGERPRINT (with sha512sum) and LICENSE need to be updated also."
einfo "When you are done updating, comment out GEN_ABOUT_CREDITS."
einfo
		die
	fi
}

_get_pythonpath() {
	local pp=(
		"${BUILD_DIR}/third_party/catapult/common/py_utils"
		"${BUILD_DIR}/third_party/catapult/telemetry/telemetry"
		"${BUILD_DIR}/third_party/catapult/telemetry/third_party/png"
		"${BUILD_DIR}/third_party/catapult/telemetry/third_party/pyfakefs"
		"${BUILD_DIR}/third_party/catapult/third_party/typ"
		"${BUILD_DIR}/third_party/catapult/tracing"
		"${BUILD_DIR}/tools/perf"
	)
	echo $(echo "${pp}" | tr " " ":")
}

multilib_src_compile() {
	if (( ${NABIS} == 1 )) ; then
		export BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
	fi

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

	EPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}"
	export PGO_PHASE=$(epgo_get_phase)
einfo
einfo "PGO_PHASE:  ${PGO_PHASE}"
einfo
	_configure_pgx
	_update_licenses
	_build_pgx

	# Build manpage; bug #684550
	sed -e 's|@@PACKAGE@@|chromium-browser|g;
		s|@@MENUNAME@@|Chromium|g;' \
		chrome/app/resources/manpage.1.in > \
		out/Release/chromium-browser.1 || die

	# Build desktop file; bug #706786
	# Moved down
	# Moved down
	sed -e 's|@@PACKAGE@@|chromium-browser|g;
		s|\(^Exec=\)/usr/bin/|\1|g;' \
		chrome/installer/linux/common/desktop.template > \
		out/Release/chromium-browser-chromium.desktop || die

	# Build vk_swiftshader_icd.json; bug #827861
	sed -e 's|${ICD_LIBRARY_PATH}|./libvk_swiftshader.so|g' \
		third_party/swiftshader/src/Vulkan/vk_swiftshader_icd.json.tmpl \
		> out/Release/vk_swiftshader_icd.json || die

	local suffix
	if (( ${NABIS} > 1 )) ; then
		suffix=" (${ABI})"
	fi
	sed -i -e "s|@@MENUNAME@@|Chromium${suffix}|g" \
		-e "s|@@USR_BIN_SYMLINK_NAME@@|chromium-browser-${ABI}|g" \
		out/Release/chromium-browser-chromium.desktop || die
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
# Installs licenses and copyright notices from packages and other internal
# packages.
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

	# Place _install_header_license or _install_header_license_mid
	# calls here.

	touch "${T}/.copied_licenses"
}

multilib_src_install() {
	if (( ${NABIS} == 1 )) ; then
		export BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
	fi

	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome

	if use suid ; then
		newexe out/Release/chrome_sandbox chrome-sandbox
		fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"
	fi

	newexe out/Release/chromedriver chromedriver-${ABI}
	doexe out/Release/chrome_crashpad_handler

	ozone_auto_session () {
		use X && use wayland && ! use headless && echo true || echo false
	}
	local sedargs=( -e
"s:/usr/lib/:/usr/$(get_libdir)/:g;
s:chromium-browser-chromium.desktop:chromium-browser-chromium-${ABI}.desktop:g;
s:@@OZONE_AUTO_SESSION@@:$(ozone_auto_session):g"
	)
	sed "${sedargs[@]}" "${FILESDIR}/chromium-launcher-r7.sh" \
		> chromium-launcher.sh || die
	newexe chromium-launcher.sh chromium-launcher-${ABI}.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		/usr/bin/chromium-browser-${ABI}
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" \
		/usr/bin/chromium-browser
	# keep the old symlink around for consistency
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
	popd

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin
	doins out/Release/*.pak
	(
		shopt -s nullglob
		local files=(out/Release/*.so out/Release/*.so.[0-9])
		[[ ${#files[@]} -gt 0 ]] && doins "${files[@]}"
	)

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
				*) branding="chrome/app/theme/chromium" ;;
		esac
		newicon -s ${size} "${branding}/product_logo_${size}.png" \
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

	# This next pass will copy PATENTS files, *ThirdParty*, and NOTICE files
	# and npm micropackages copyright notices and licenses which may not
	# have been present in the listed the the .html (about:credits) file
	_install_licenses

	EPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}"
	epgo_src_install
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

print_vaapi_support() {
#
# This information is provided for a better WebRTC experience.
# Instead of using the inferior software codec(s), it suggests better vaapi
# drivers with hardware accelerated encoders.
#
	if has_version "x11-libs/libva-intel-driver" ; then
ewarn
ewarn "x11-libs/libva-intel-driver is the older vaapi driver but intended for"
ewarn "select hardware.  See also x11-libs/libva-intel-media-driver package"
ewarn "to access more VA-API accelerated encoders if driver support overlaps."
ewarn
	fi

	if use video_cards_intel || use video_cards_i965 || use video_cards_iris ; then
einfo
einfo "Intel Quick Sync Video is required for hardware accelerated H.264 VA-API"
einfo "encode."
einfo
einfo "For hardware support, see the AVC row at"
einfo "https://en.wikipedia.org/wiki/Intel_Quick_Sync_Video#Hardware_decoding_and_encoding"
einfo
einfo "Driver ebuild packages for their corresponding hardware can be found at:"
einfo
einfo "x11-libs/libva-intel-driver:"
einfo "https://github.com/intel/intel-vaapi-driver/blob/master/README"
einfo
einfo "x11-libs/libva-intel-media-driver:"
einfo "https://github.com/intel/media-driver#decodingencoding-features"
einfo
	fi
	if use video_cards_amdgpu \
		|| use video_cards_r600 \
		|| use video_cards_radeonsi ; then
einfo
einfo "You need VCE (Video Code Engine) or VCN (Video Core Next) for"
einfo "hardware accelerated H.264 VA-API encode."
einfo
einfo "For details see https://en.wikipedia.org/wiki/Video_Coding_Engine#Feature_overview"
einfo "or https://www.x.org/wiki/RadeonFeature/"
einfo
einfo "The r600 driver only supports ARUBA for VCE encode."
einfo "For newer hardware, try a newer free driver like"
einfo "the radeonsi driver or closed drivers."
einfo
	fi
	if use video_cards_nouveau ; then
einfo
einfo "For details see, https://nouveau.freedesktop.org/VideoAcceleration.html"
einfo "Reconsider using the official driver instead."
einfo
	fi
einfo
einfo "Some drivers may require firmware for proper VA-API support."
einfo
einfo "The user must be part of the video group to use VA-API support."
# Because it touches /dev/dri/renderD128
einfo
einfo "The LIBVA_DRIVER_NAME envvar may need to be changed if both open"
einfo "and closed drivers are installed to one of the following"
einfo
	if has_version "x11-libs/libva-intel-driver" ; then
einfo
einfo "  LIBVA_DRIVER_NAME=\"i965\""
einfo
	fi
	if has_version "x11-libs/libva-intel-media-driver" ; then
einfo
einfo "  LIBVA_DRIVER_NAME=\"iHD\""
einfo
	fi
	if use video_cards_r600 ; then
einfo
einfo "  LIBVA_DRIVER_NAME=\"r600\""
einfo
	fi
	if ( use video_cards_radeonsi || use video_cards_amdgpu ) ; then
einfo
einfo "  LIBVA_DRIVER_NAME=\"radeonsi\""
einfo
	fi
einfo
einfo "to your ~/.bashrc or ~/.xinitrc and relogging."
einfo
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	epgo_pkg_postinst
	if ! use headless; then
		if use vaapi ; then
# It says 3 args:
# https://github.com/chromium/chromium/blob/104.0.5112.79/docs/gpu/vaapi.md#vaapi-on-linux
einfo
einfo "VA-API is disabled by default at runtime.  You have to enable it"
einfo "by adding --enable-features=VaapiVideoDecoder --ignore-gpu-blocklist"
einfo "with either --use-gl=desktop or --use-gl=egl to the CHROMIUM_FLAGS"
einfo "in /etc/chromium/default."
einfo
		fi
		if use screencast ; then
einfo
einfo "Screencast is disabled by default at runtime. Either enable it"
einfo "by navigating to chrome://flags/#enable-webrtc-pipewire-capturer"
einfo "inside Chromium or add --enable-features=WebRTCPipeWireCapturer"
einfo "to CHROMIUM_FLAGS in /etc/chromium/default."
einfo
		fi
		if use gtk4; then
einfo
einfo "Chromium prefers GTK3 over GTK4 at runtime. To override this"
einfo "behavior you need to pass --gtk-version=4, e.g. by adding it"
einfo "to CHROMIUM_FLAGS in /etc/chromium/default."
einfo
		fi
		if use vaapi ; then
			print_vaapi_support
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
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, build-32-bit-on-64-bit, license-completeness, license-transparency, prebuilt-pgo-access, shadowcallstack-option-access, disable-simd-on-old-microarches-with-zlib, allow-cfi-with-official-build-settings, branch-protection-standard-access
# OILEDMACHINE-OVERLAY-META-WIP: event-based-full-pgo
