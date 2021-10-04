# Copyright 2009-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Monitor
#   https://chromereleases.googleblog.com/search/label/Dev%20updates
# for security updates.  They are announced faster than NVD.
# See https://omahaproxy.appspot.com/ for the latest linux version

EAPI=7
PYTHON_COMPAT=( python3_{8,9} )
PYTHON_REQ_USE="xml"

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

LLVM_MAX_SLOT=14
LLVM_SLOTS=(13 14)
inherit check-reqs chromium-2 desktop flag-o-matic llvm multilib ninja-utils pax-utils portability python-any-r1 readme.gentoo-r1 toolchain-funcs xdg-utils
inherit multilib-minimal

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="https://chromium.org/"
PATCHSET="3"
PATCHSET_NAME="chromium-$(ver_cut 1)-patchset-${PATCHSET}"
CIPD_V="9464003f070813371070f9b8f7c350d87619d145" # in \
# third_party/depot_tools/cipd_client_version
MTD_V="${PV}"
CTDM_V="${PV}"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.xz
	https://github.com/stha09/chromium-patches/releases/download/${PATCHSET_NAME}/${PATCHSET_NAME}.tar.xz
	pgo-full? (
		amd64? ( https://chrome-infra-packages.appspot.com/client?platform=linux-amd64&version=git_revision:${CIPD_V} -> .cipd_client-amd64-${CIPD_V} )
		arm64? ( https://chrome-infra-packages.appspot.com/client?platform=linux-arm64&version=git_revision:${CIPD_V} -> .cipd_client-arm64-${CIPD_V} )
		ppc64? ( https://chrome-infra-packages.appspot.com/client?platform=linux-ppc64&version=git_revision:${CIPD_V} -> .cipd_client-ppc64-${CIPD_V} )
		x86? ( https://chrome-infra-packages.appspot.com/client?platform=linux-386&version=git_revision:${CIPD_V} -> .cipd_client-x86-${CIPD_V} )
		cr_pgo_trainers_memory_desktop? (
			https://chromium.googlesource.com/chromium/src.git/+archive/refs/tags/${CTDM_V}/chrome/test/data/media.tar.gz -> ${PN}-${CTDM_V}-chrome-test-data-media.tar.gz
			https://chromium.googlesource.com/chromium/src.git/+archive/refs/tags/${MTD_V}/media/test/data.tar.gz -> ${PN}-${MTD_V}-media-test-data.tar.gz
		)
		cr_pgo_trainers_media_desktop? (
			https://chromium.googlesource.com/chromium/src.git/+archive/refs/tags/${CTDM_V}/chrome/test/data/media.tar.gz -> ${PN}-${CTDM_V}-chrome-test-data-media.tar.gz
			https://chromium.googlesource.com/chromium/src.git/+archive/refs/tags/${MTD_V}/media/test/data.tar.gz -> ${PN}-${MTD_V}-media-test-data.tar.gz
		)
		cr_pgo_trainers_media_mobile? (
			https://chromium.googlesource.com/chromium/src.git/+archive/refs/tags/${CTDM_V}/chrome/test/data/media.tar.gz -> ${PN}-${CTDM_V}-chrome-test-data-media.tar.gz
			https://chromium.googlesource.com/chromium/src.git/+archive/refs/tags/${MTD_V}/media/test/data.tar.gz -> ${PN}-${MTD_V}-media-test-data.tar.gz
		)
	)
"

# Some assets encoded by proprietary-codecs (mp3, aac, h264) are found in both
#   ${PN}-${CTDM_V}-chrome-test-data-media.tar.gz
#   ${PN}-${MTD_V}-media-test-data.tar.gz
# but shouldn't be necessary to use the USE flag.

RESTRICT="mirror"
#PROPERTIES="interactive" # For interactive login in social networks for PGO profile generation. \
# See _init_cr_pgo_trainers_rasterize_and_record_micro_top_25() function below. \
# Disabled until the inner workings is understood.

# all-rights-reserved is for unfree websites or content from them.
LICENSE_BENCHMARK_WEBSITES="
	cr_pgo_trainers_desktop_ui? (
		all-rights-reserved
	)
	cr_pgo_trainers_loading_desktop? (
		all-rights-reserved
	)
	cr_pgo_trainers_loading_mobile? (
		all-rights-reserved
	)
	cr_pgo_trainers_power_mobile? (
		all-rights-reserved
	)
	cr_pgo_trainers_rasterize_and_record_micro_top_25? (
		all-rights-reserved
	)
	cr_pgo_trainers_rendering_desktop? (
		all-rights-reserved
	)
	cr_pgo_trainers_rendering_mobile? (
		all-rights-reserved
	)
	cr_pgo_trainers_tab_switching_typical_25? (
		all-rights-reserved
	)
	cr_pgo_trainers_unscheduled_loading_mbi? (
		all-rights-reserved
	)
	cr_pgo_trainers_unscheduled_v8_loading_desktop? (
		all-rights-reserved
	)
	cr_pgo_trainers_v8_runtime_stats_top_25? (
		all-rights-reserved
	)
	cr_pgo_trainers_dromaeo? (
		( all-rights-reserved || ( MPL-1.1 GPL-2.0+ LGPL-2.1+ ) )
		( all-rights-reserved MIT )
		( ( all-rights-reserved || ( MIT AFL-2.1 ) ) ( MIT GPL-2 ) || ( AFL-2.1 BSD ) MIT )
		( all-rights-reserved GPL-2+ )
		( MIT GPL-2 )
		( MIT BSD GPL )
		BSD
		BSD-2
		LGPL-2.1
	)
	cr_pgo_trainers_jetstream? (
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
	cr_pgo_trainers_jetstream2? (
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
	cr_pgo_trainers_kraken? (
		( ( all-rights-reserved || ( MIT AFL-2.1 ) ) (MIT GPL) BSD MIT )
		( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
		( all-rights-reserved GPL-3+ )
		|| ( BSD GPL-2 )
		BSD
		BSD-2
		LGPL-2.1
		MPL-1.1
	)
	cr_pgo_trainers_media_desktop? (
		CC-BY-3.0
		CC-BY-4.0
	)
	cr_pgo_trainers_media_mobile? (
		CC-BY-3.0
		CC-BY-4.0
	)
	cr_pgo_trainers_memory_desktop? (
		CC-BY-3.0
	)
	cr_pgo_trainers_octane? (
		BSD
	)
	cr_pgo_trainers_speedometer2? (
		|| ( MIT BSD )
		( all-rights-reserved GPL-2 )
		( all-rights-reserved MIT )
		( MIT CC0-1.0 )
		Apache-2.0
		BSD
		CC-BY-4.0
		MIT
	)
" # emerge does not understand ^^ in the LICENSE variable and have been replaced
# with ||.  You should choose at most one at some instances.
# GEN_ABOUT_CREDITS=1 # Uncomment to generate about_credits.html including bundled.
# SHA512 about_credits.html fingerprint:
LICENSE_FINGERPRINT="\
021a432e2cdbdb8965d0567fe0e580652e0e1f5bc9bbbd2509d7cef82462cdb0\
33ee401ffbe7f123226990ca2bd12fb5d7c0c98efadc0ee4b8f3f33f1b679954"
LICENSE="BSD
	chromium-94.0.4606.x
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
	${LICENSE_BENCHMARK_WEBSITES}"
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
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
# vaapi is enabled by default upstream for some arches \
# See https://github.com/chromium/chromium/blob/94.0.4606.71/media/gpu/args.gni#L24
# Using the system-ffmpeg or system-icu breaks cfi-icall or cfi-cast which is
#   incompatible as a shared lib.
IUSE="component-build cups cpu_flags_arm_neon -debug +hangouts headless +js-type-check kerberos +official pic +proprietary-codecs pulseaudio screencast selinux +suid system-ffmpeg system-icu system-harfbuzz +vaapi wayland widevine"
IUSE+=" weston"
# What is considered a proprietary codec can be found at:
#   https://github.com/chromium/chromium/blob/94.0.4606.71/media/filters/BUILD.gn#L160
#   https://github.com/chromium/chromium/blob/94.0.4606.71/media/media_options.gni#L38
#   https://github.com/chromium/chromium/blob/94.0.4606.71/media/base/supported_types.cc#L203
#     Upstream doesn't consider MP3 proprietary, but this ebuild does.
#   https://github.com/chromium/chromium/blob/94.0.4606.71/media/base/supported_types.cc#L284
# Codec upstream default: https://github.com/chromium/chromium/blob/94.0.4606.71/tools/mb/mb_config_expectations/chromium.linux.json#L89
IUSE+=" video_cards_amdgpu video_cards_amdgpu-pro video_cards_amdgpu-pro-lts
video_cards_intel video_cards_iris video_cards_i965 video_cards_nouveau
video_cards_nvidia video_cards_r600 video_cards_radeonsi" # For VA-API
IUSE+=" +partitionalloc tcmalloc libcmalloc"
# For cfi-vcall, cfi-icall defaults status, see \
#   https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/sanitizers/sanitizers.gni
# For cfi-cast default status, see \
#   https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/sanitizers/sanitizers.gni#L123
# For pgo default status, see \
#   https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/compiler/pgo/pgo.gni#L15
# For libcxx default, see \
#   https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/c++/c++.gni#L14
# For cdm availability see third_party/widevine/cdm/widevine.gni#L28
IUSE_LIBCXX=( bundled-libcxx system-libcxx system-libstdcxx )
IUSE+=" ${IUSE_LIBCXX[@]} +bundled-libcxx branch-protection-standard +cfi-vcall
cfi-cast +cfi-icall +clang lto-opt +pgo -pgo-full shadowcallstack"
# perf-opt
_ABIS=( abi_x86_32
	abi_x86_64
	abi_x86_x32
	abi_mips_n32
	abi_mips_n64
	abi_mips_o32
	abi_ppc_32
	abi_ppc_64
	abi_s390_32
	abi_s390_64 )
IUSE+=" ${_ABIS[@]}"
BENCHMARKS_DESKTOP=(
	desktop_ui
	loading.desktop
	media.desktop
	memory.desktop
	power.desktop
	rendering.desktop
	system_health.common_desktop
	system_health.memory_desktop
	UNSCHEDULED_v8.loading_desktop
	v8.browsing_desktop
	v8.browsing_desktop-future
)
BENCHMARKS_MOBILE=(
	loading.mobile
	media.mobile
	power.mobile
	rendering.mobile
	startup.mobile
	system_health.common_mobile
	system_health.memory_mobile
	UNSCHEDULED_v8.loading_mobile
	v8.browsing_mobile
	v8.browsing_mobile-future
)

# Official except for UNSCHEDULED_*
OFFICIAL_BENCHMARKS=(
	blink_perf.accessibility
	blink_perf.bindings
	blink_perf.css
	blink_perf.display_locking
	blink_perf.dom
	blink_perf.events
	blink_perf.image_decoder
	blink_perf.layout
	blink_perf.owp_storage
	blink_perf.paint
	blink_perf.parser
	blink_perf.sanitizer-api
	blink_perf.shadow_dom
	blink_perf.svg
	blink_perf.webaudio
	blink_perf.webgl
	blink_perf.webgl_fast_call
	blink_perf.webgpu
	blink_perf.webgpu_fast_call
	custom
	desktop_ui
	dromaeo
	dummy_benchmark.noisy_benchmark_1
	dummy_benchmark.stable_benchmark_1
	jetstream
	jetstream2
	kraken
	loading.desktop
	loading.mobile
	media.desktop
	media.mobile
	memory.desktop
	octane
	power.desktop
	power.mobile
	rasterize_and_record_micro
	rasterize_and_record_micro.top_25
	rendering.desktop
	rendering.mobile
	speedometer
	speedometer-future
	speedometer2
	speedometer2-future
	speedometer2-pcscan
	startup.mobile
	system_health.common_desktop
	system_health.common_mobile
	system_health.memory_desktop
	system_health.memory_mobile
	system_health.pcscan
	system_health.weblayer_startup
	system_health.webview_startup
	tab_switching.typical_25
	tracing.tracing_with_background_memory_infra
	UNSCHEDULED_blink_perf.performance_apis
	UNSCHEDULED_blink_perf.service_worker
	UNSCHEDULED_loading.mbi
	UNSCHEDULED_v8.loading_desktop
	UNSCHEDULED_v8.loading_mobile
	v8.browsing_desktop
	v8.browsing_desktop-future
	v8.browsing_mobile
	v8.browsing_mobile-future
	v8.runtime_stats.top_25
	wasmpspdfkit
	webrtc
)

CONTRIB_BENCHMARKS_DISABLED=(
	ad_tagging.cluster_telemetry
	blink_perf
	blink_perf.layout_ng
	blink_perf.paint_layout_ng
	blink_perf.parser_layout_ng
	blink_perf.privacy_budget
	download.mobile
	generic_trace_ct
	generic_trace.top25
	layout_shift.cluster_telemetry
	leak_detection.cluster_telemetry
	loading.cluster_telemetry
	loading.desktop_layout_ng
	loading.mobile_layout_ng
	media_router.cpu_memory
	media_router.cpu_memory.no_media_router
	memory.cluster_telemetry
	memory.leak_detection
	memory.long_running_desktop_sites
	multipage_skpicture_printer
	multipage_skpicture_printer_ct
	orderfile_generation.debugging
	orderfile_generation.testing
	orderfile_generation.training
	orderfile_generation.variation.testing0
	orderfile_generation.variation.testing1
	orderfile_generation.variation.testing2
	orderfile_generation.variation.training
	orderfile.memory_mobile
	rasterize_and_record_micro_ct
	rendering.cluster_telemetry
	repaint_ct
	screenshot_ct
	skpicture_printer
	skpicture_printer_ct
	system_health.scroll_jank_mobile
	tracing.tracing_with_debug_overhead
	v8.loading.cluster_telemetry
	v8.loading_runtime_stats.cluster_telemetry
)

CONTRIB_BENCHMARKS=(
	xr.webxr.static
)

gen_pgo_profile_use() {
	for x in ${OFFICIAL_BENCHMARKS[@]} ${CONTRIB_BENCHMARKS[@]} ; do
		t="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		echo " cr_pgo_trainers_${t}"
	done
}
gen_pgo_profile_required_use() {
	for d in ${BENCHMARK_DESKTOP[@]} ; do
		a="${d}"
		a="${a//-/_}"
		a="${a//./_}"
		a="${a,,}"
		for m in ${BENCHMARK_MOBILE[@]} ; do
			b="${m}"
			b="${b//-/_}"
			b="${b//./_}"
			b="${b,,}"
			echo "
				cr_pgo_trainers_${a}? ( pgo-full !cr_pgo_trainers_${b} )
				cr_pgo_trainers_${b}? ( pgo-full !cr_pgo_trainers_${a} )
			"
		done
	done
	for x in ${OFFICIAL_BENCHMARKS[@]} ${CONTRIB_BENCHMARKS[@]} ; do
		t="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		echo " cr_pgo_trainers_${t}? ( pgo-full )"
	done
}

# There is 2 official (perflab) platforms for linux:  linux and linux_rel.
# ~50 benchmarks used.
gen_required_use_pgo_profile_linux() { # For CI
	# See
# https://github.com/chromium/chromium/blob/94.0.4606.71/tools/perf/core/bot_platforms.py#L311
# https://github.com/chromium/chromium/blob/94.0.4606.71/tools/perf/core/bot_platforms.py#L226
# https://github.com/chromium/chromium/blob/94.0.4606.71/tools/perf/core/shard_maps/linux-perf_map.json
	local exclude=(
		blink_perf.display_locking
		power.mobile
		v8.runtime_stats.top_25
	)
	for x in ${OFFICIAL_BENCHMARKS[@]} ; do
		t="${x}"
		t_raw="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		local excluded=0
		for ex in ${exclude[@]} ; do
			if [[ "${t_raw}" == "${ex}" ]] ; then
				excluded=1
			fi
		done
		if [[ "${t_raw}" =~ ^"UNSCHEDULED" \
			|| "${t_raw}" == "custom" \
			|| "${t_raw}" == ".mobile"$ \
			]] ; then
			excluded=1
		fi
		if (( excluded == 1 )) ; then
			echo " !cr_pgo_trainers_${t}"
		else
			echo " cr_pgo_trainers_${t}"
		fi
	done
	for x in ${CONTRIB_BENCHMARKS[@]} ; do
		t="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		echo " !cr_pgo_trainers_${t}"
	done
}

# Only 1 benchmark used.
gen_required_use_pgo_profile_linux_rel() { # For CI release
	# See
# https://github.com/chromium/chromium/blob/94.0.4606.71/tools/perf/core/bot_platforms.py#L307
# https://github.com/chromium/chromium/blob/94.0.4606.71/tools/perf/core/shard_maps/linux-perf-rel_map.json
	local whitelist=(
		system_health.common_desktop
	)
	for x in ${OFFICIAL_BENCHMARKS[@]} ; do
		t="${x}"
		t_raw="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		local included=0
		for wl in ${whitelist[@]} ; do
			if [[ "${t_raw}" == "${wl}" ]] ; then
				included=1
			fi
		done
		if (( included == 1 )) ; then
			echo " cr_pgo_trainers_${t}"
		else
			echo " !cr_pgo_trainers_${t}"
		fi
	done
	for x in ${CONTRIB_BENCHMARKS[@]} ; do
		t="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		echo " !cr_pgo_trainers_${t}"
	done
}

PGO_PROFILE_LINUX_SET=$(gen_required_use_pgo_profile_linux)
PGO_PROFILE_LINUX_SET_REL=$(gen_required_use_pgo_profile_linux_rel)
IUSE+=" "$(gen_pgo_profile_use)
REQUIRED_USE+=" $(gen_pgo_profile_required_use)"
REQUIRED_USE+=" pgo-full? ( || ( $(gen_pgo_profile_use) ) )"
# TODO:  Update pgo-full with complete (or near complete) PGO set
# when official USE selected.
# The cr_pgo_trainers_custom is disallowed for security reasons
# when the official USE is set.
# vaapi is not conditioned on proprietary-codecs upstream, but should
# be or by case-by-case (i.e. h264_vaapi, vp9_vaapi, av1_vaapi)
# with additional USE flags.
# The system-ffmpeg comes with aac which is unavoidable.  This is why
# there is a block with !proprietary-codecs.
# cfi-icall, cfi-cast requires static linking.  See
#   https://clang.llvm.org/docs/ControlFlowIntegrity.html#indirect-function-call-checking
#   https://clang.llvm.org/docs/ControlFlowIntegrity.html#bad-cast-checking
REQUIRED_USE+="
	^^ ( ${IUSE_LIBCXX[@]} )
	^^ ( partitionalloc tcmalloc libcmalloc )
	!clang? ( !cfi-vcall )
	!proprietary-codecs? ( !system-ffmpeg !vaapi )
	amd64? ( !shadowcallstack )
	bundled-libcxx? ( clang )
	branch-protection-standard? ( arm64 )
	cfi-cast? ( cfi-vcall !system-ffmpeg !system-harfbuzz !system-icu !system-libcxx !system-libstdcxx )
	cfi-icall? ( cfi-vcall !system-ffmpeg !system-harfbuzz !system-icu !system-libcxx !system-libstdcxx )
	cfi-vcall? ( clang !system-ffmpeg !system-harfbuzz !system-icu !system-libcxx !system-libstdcxx )
	component-build? ( !suid )
	lto-opt? ( clang )
	official? (
		^^ ( pgo pgo-full )
		!system-ffmpeg
		!system-harfbuzz
		!system-icu
		!system-libcxx
		!system-libstdcxx
		bundled-libcxx
		partitionalloc
		amd64? ( cfi-icall cfi-vcall )
		pgo-full? ( ${PGO_PROFILE_LINUX_SET_REL} )
	)
	partitionalloc? ( !component-build )
	pgo? ( clang !pgo-full )
	pgo-full? ( clang !pgo )
	ppc64? ( !shadowcallstack )
	screencast? ( wayland )
	shadowcallstack? ( clang )
	system-libcxx? ( clang )
	system-libstdcxx? ( !cfi-cast )
	system-libstdcxx? ( !cfi-icall )
	system-libstdcxx? ( !cfi-vcall )
	vaapi? ( proprietary-codecs )
	video_cards_amdgpu? (
		!video_cards_amdgpu-pro
		!video_cards_amdgpu-pro-lts
		!video_cards_r600
		!video_cards_radeonsi
	)
	video_cards_amdgpu-pro? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro-lts
		!video_cards_r600
		!video_cards_radeonsi
	)
	video_cards_amdgpu-pro-lts? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro
		!video_cards_r600
		!video_cards_radeonsi
	)
	video_cards_r600? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro
		!video_cards_amdgpu-pro-lts
		!video_cards_radeonsi
	)
	video_cards_radeonsi? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro
		!video_cards_amdgpu-pro-lts
		!video_cards_r600
	)
	widevine? ( !arm64 !ppc64 )
	x86? ( !shadowcallstack )
"

LIBVA_V="2.7"
COMMON_X_DEPEND="
	media-libs/mesa:=[gbm(+),${MULTILIB_USEDEP}]
	x11-libs/libX11:=[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:=[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:=[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:=[${MULTILIB_USEDEP}]
	x11-libs/libXext:=[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXi-1.6.0:=[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	x11-libs/libXrender:=[${MULTILIB_USEDEP}]
	x11-libs/libXtst:=[${MULTILIB_USEDEP}]
	x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence:=[${MULTILIB_USEDEP}]
	vaapi? ( >=x11-libs/libva-${LIBVA_V}:=[X,drm,${MULTILIB_USEDEP}] )
"

FFMPEG_V="4.3"
COMMON_DEPEND="
	app-arch/bzip2:=[${MULTILIB_USEDEP}]
	cups? ( >=net-print/cups-1.3.11:=[${MULTILIB_USEDEP}] )
	dev-libs/expat:=[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.4-r3:=[icu,${MULTILIB_USEDEP}]
	dev-libs/nspr:=[${MULTILIB_USEDEP}]
	>=dev-libs/nss-3.26:=[${MULTILIB_USEDEP}]
	>=media-libs/alsa-lib-1.0.19:=[${MULTILIB_USEDEP}]
	media-libs/fontconfig:=[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.11.0-r1:=[${MULTILIB_USEDEP}]
	system-harfbuzz? ( >=media-libs/harfbuzz-2.9.0:0=[icu(-),${MULTILIB_USEDEP}] )
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	pulseaudio? ( media-sound/pulseaudio:=[${MULTILIB_USEDEP}] )
	system-ffmpeg? (
		>=media-video/ffmpeg-${FFMPEG_V}:=[${MULTILIB_USEDEP}]
		|| (
			>=media-video/ffmpeg-${FFMPEG_V}:=[-samba,${MULTILIB_USEDEP}]
			>=net-fs/samba-4.5.10-r1[-debug(-),${MULTILIB_USEDEP}]
		)
		>=media-libs/opus-1.3.1:=[${MULTILIB_USEDEP}]
	)
	net-misc/curl[ssl]
	sys-apps/dbus:=[${MULTILIB_USEDEP}]
	sys-apps/pciutils:=[${MULTILIB_USEDEP}]
	virtual/udev
	x11-libs/cairo:=[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/libxkbcommon:=[${MULTILIB_USEDEP}]
	x11-libs/pango:=[${MULTILIB_USEDEP}]
	media-libs/flac:=[${MULTILIB_USEDEP}]
	>=media-libs/libwebp-0.4.0:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[minizip,${MULTILIB_USEDEP}]
	kerberos? ( virtual/krb5[${MULTILIB_USEDEP}] )
	!headless? (
		${COMMON_X_DEPEND}
		>=app-accessibility/at-spi2-atk-2.26:2[${MULTILIB_USEDEP}]
		>=app-accessibility/at-spi2-core-2.26:2[${MULTILIB_USEDEP}]
		>=dev-libs/atk-2.26[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[X,${MULTILIB_USEDEP}]
		wayland? (
			dev-libs/wayland:=[${MULTILIB_USEDEP}]
			screencast? ( media-video/pipewire:0/0.3 )
			x11-libs/gtk+:3[wayland,X,${MULTILIB_USEDEP}]
			x11-libs/libdrm:=[${MULTILIB_USEDEP}]
		)
	)
"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xdg-utils
	virtual/opengl[${MULTILIB_USEDEP}]
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	vaapi? (
		|| (
			video_cards_amdgpu? (
				media-libs/mesa:=[gallium,vaapi,video_cards_radeonsi,${MULTILIB_USEDEP}]
			)
			video_cards_amdgpu-pro? (
				x11-drivers/amdgpu-pro[open-stack,vaapi]
			)
			video_cards_amdgpu-pro-lts? (
				x11-drivers/amdgpu-pro-lts[open-stack,vaapi]
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
		system-ffmpeg? ( >=media-video/ffmpeg-${FFMPEG_V}[vaapi,${MULTILIB_USEDEP}] )
	)
"
DEPEND="${COMMON_DEPEND}"
# dev-vcs/git - https://bugs.gentoo.org/593476
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	>=app-arch/gzip-1.7
	dev-lang/perl
	>=dev-util/gn-0.1807
	dev-vcs/git
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	>=net-libs/nodejs-7.6.0[inspector]
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex[${MULTILIB_USEDEP}]
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	clang? (
		|| (
			(
				sys-devel/clang:13[${MULTILIB_USEDEP}]
				sys-devel/llvm:13[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP},compiler-rt,sanitize]
				>=sys-devel/lld-13
				=sys-libs/compiler-rt-13*
				=sys-libs/compiler-rt-sanitizers-13*[shadowcallstack?]
				cfi-cast? ( =sys-libs/compiler-rt-sanitizers-13*[cfi] )
				cfi-icall? ( =sys-libs/compiler-rt-sanitizers-13*[cfi] )
				cfi-vcall? ( =sys-libs/compiler-rt-sanitizers-13*[cfi] )
			)
			(
				sys-devel/clang:14[${MULTILIB_USEDEP}]
				sys-devel/llvm:14[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-14*[${MULTILIB_USEDEP},compiler-rt,sanitize]
				>=sys-devel/lld-14
				=sys-libs/compiler-rt-14*
				=sys-libs/compiler-rt-sanitizers-14*[shadowcallstack?]
				cfi-cast? ( =sys-libs/compiler-rt-sanitizers-14*[cfi] )
				cfi-icall? ( =sys-libs/compiler-rt-sanitizers-14*[cfi] )
				cfi-vcall? ( =sys-libs/compiler-rt-sanitizers-14*[cfi] )
			)
		)
		official? (
			sys-devel/clang:13[${MULTILIB_USEDEP}]
			sys-devel/llvm:13[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-13
			=sys-libs/compiler-rt-13*
			=sys-libs/compiler-rt-sanitizers-13*[shadowcallstack?]
			cfi-cast? ( =sys-libs/compiler-rt-sanitizers-13*[cfi] )
			cfi-icall? ( =sys-libs/compiler-rt-sanitizers-13*[cfi] )
			cfi-vcall? ( =sys-libs/compiler-rt-sanitizers-13*[cfi] )
		)
	)
	js-type-check? ( virtual/jre )
	pgo-full? (
		sys-apps/dbus:=[${MULTILIB_USEDEP}]
		sys-apps/grep[pcre]
		!headless? (
			!weston? (
				x11-base/xorg-server[xvfb]
				x11-misc/xcompmgr
				x11-wm/openbox
			)
			weston? ( dev-libs/weston )
		)
		cr_pgo_trainers_memory_desktop? (
			media-video/ffmpeg[encode]
		)
		cr_pgo_trainers_media_desktop? (
			proprietary-codecs? (
				media-video/ffmpeg[encode,openh264]
				media-video/ffmpeg[encode,mp3]
			)
			media-video/ffmpeg[encode,libaom]
			media-video/ffmpeg[opus,vorbis,vpx]
		)
		cr_pgo_trainers_media_mobile? (
			proprietary-codecs? (
				media-video/ffmpeg[encode,openh264]
				media-video/ffmpeg[encode,mp3]
			)
			media-video/ffmpeg[opus,vorbis,vpx]
		)
	)
	vaapi? ( media-video/libva-utils )
"
# pgo related:  dev-python/requests is python3 but testing/scripts/run_performance_tests.py is python2

# Upstream uses llvm:13
# When CFI + PGO + official was tested, it didn't work well with LLVM12.  Error noted in
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/f0c13049dc89f068370511b4664f7fb111df2d3a/www-client/chromium/bug_notes
# This is why LLVM13 was set as the minimum and did fix the problem.

# For the current llvm for this project, see
#   https://github.com/chromium/chromium/blob/94.0.4606.71/tools/clang/scripts/update.py#L42
# Use the same clang for official USE flag because of older llvm bugs which
#   could result in security weaknesses (explained in the llvm:12 note below).
# Used llvm >= 12 for arm64 for the same reason in the Linux kernel CFI comment.
#   Links below from https://github.com/torvalds/linux/commit/cf68fffb66d60d96209446bfc4a15291dc5a5d41
#     https://bugs.llvm.org/show_bug.cgi?id=46258
#     https://bugs.llvm.org/show_bug.cgi?id=47479
# To confirm the hash version match for the reported by CR_CLANG_REVISION, see
#   https://github.com/llvm/llvm-project/blob/98033fdc/llvm/CMakeLists.txt
RDEPEND+="
	system-libcxx? (
		>=sys-libs/libcxx-13[${MULTILIB_USEDEP}]
		official? ( >=sys-libs/libcxx-13[${MULTILIB_USEDEP}] )
	)"
DEPEND+="
	system-libcxx? (
		>=sys-libs/libcxx-13[${MULTILIB_USEDEP}]
		official? ( >=sys-libs/libcxx-13[${MULTILIB_USEDEP}] )
	)"
# [A]
COMMON_DEPEND="
	system-libstdcxx? (
		app-arch/snappy:=[${MULTILIB_USEDEP}]
		dev-libs/libxslt:=[${MULTILIB_USEDEP}]
		>=dev-libs/re2-0.2019.08.01:=[${MULTILIB_USEDEP}]
		proprietary-codecs? ( >=media-libs/openh264-1.6.0:=[${MULTILIB_USEDEP}] )
		system-icu? ( >=dev-libs/icu-69.1:=[${MULTILIB_USEDEP}] )
	)
"

RDEPEND+="${COMMON_DEPEND}"
DEPEND+="${COMMON_DEPEND}"

# This section in the context of SECURITY_DEPENDS is rough draft or in
# development and may change.  The RDEPEND sections below ensure the
# transferrance of security policy or security expectations to ebuild-packages
# down the package hierarchy.

# These additional security flags exist to prevent vanilla ebuilds without these
# changes from weakening the security and indicate that they exist.

# Some concerns about about externalizing below:
# The first problem with unbundling is the CFI bypass problem.
# The second problem with unbundling is the lack of PGO support in
# the ebuilds themselves, causing unmatched performance.

# Over time, the security USE flags have been simplied to hardened, cfi-*,
# libcxx.  The hardened profiles will keep the hardened default ONs and
# add noexecstack.  The non-hardened profiles will keep the suggestions
# by this package or may choose to use the same distro settings by the
# hardened profile.

# For recommended CFI flags, see
# https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/sanitizers/BUILD.gn#L196
# https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/sanitizers/BUILD.gn#L313
#   full cfi which includes cfi-icall, cfi-cast, cfi-mfcall must be statically linked
#   for cfi to be effective.  See https://clang.llvm.org/docs/ControlFlowIntegrity.html
#   with "statically linked" search for details.  Static linking is obviously a licensing problem.

# For fstack-protector SSP details, see
# See https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/compiler/BUILD.gn#L335
# https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/compiler/BUILD.gn#L1677

# For noexecstack details, see
# See https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/compiler/BUILD.gn#L434

# For Full RELRO details, see
# See https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/compiler/BUILD.gn#L436

# Check supported FFmpeg decoders, encoders, containers in the ebuild-dependency for proper security.
# Video decoders listed https://github.com/chromium/chromium/blob/94.0.4606.71/media/ffmpeg/ffmpeg_common.cc#L213
#   https://github.com/chromium/chromium/blob/94.0.4606.71/media/ffmpeg/ffmpeg_common.cc#L189
# Audio decoders listed https://github.com/chromium/chromium/blob/94.0.4606.71/media/ffmpeg/ffmpeg_common.cc#L133
#   https://github.com/chromium/chromium/blob/94.0.4606.71/media/ffmpeg/ffmpeg_common.cc#L83
# Containers https://github.com/chromium/chromium/blob/94.0.4606.71/media/filters/ffmpeg_glue.cc#L137
# Continers-to-codec support https://github.com/chromium/chromium/blob/94.0.4606.71/media/base/mime_util_internal.cc#L289
# These are cross referenced with https://github.com/FFmpeg/FFmpeg/blob/master/configure
#   to find other 2+ deep dependency tree.
# FFmpeg will autoselect the algorithm with an ambiguious codec ID
# This means all relevant codecs for that codec ID should be scanned.

# The already has lists:
# FORTIFY_SOURCE:  libxml2
# SSP:  openh264, opus
# Full RELRO:  ffmpeg
# noexecstack:  ffmpeg
# Cannot use libcxx:  zlib

# [D]
BZIP2_DEPENDS=" app-arch/bzip2[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]"
OPUS_DEPENDS=" media-libs/opus[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}] "
ZLIB_DEPENDS=" sys-libs/zlib[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,${MULTILIB_USEDEP}]"
FFMPEG_DEPENDS="
	system-ffmpeg? (
		${BZIP2_DEPENDS}
		${OPUS_DEPENDS}
		${ZLIB_DEPENDS}
		media-video/ffmpeg[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		media-libs/dav1d[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		media-libs/flac[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		media-libs/libaom[cfi,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		media-libs/libogg[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		media-libs/libtheora[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		media-libs/libvorbis[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		media-libs/libvpx[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		media-sound/gsm[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		x11-libs/libva[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		x11-libs/libvdpau[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	)
"

LIBWEBP_DEPENDS="
	media-libs/giflib[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	media-libs/tiff[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	media-libs/libpng[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	virtual/jpeg[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
"

# check brotli?
FREETYPE_DEPENDS="
	${BZIP2_DEPENDS}
	${ZLIB_DEPENDS}
	media-libs/harfbuzz[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	media-libs/libpng[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
"

FONTCONFIG_DEPENDS="
	${FREETYPE_DEPENDS}
	dev-libs/expat[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	media-libs/fontconfig[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	official? (
		media-libs/freetype[cfi-cast?,cfi-icall?,cfi-vcall?,cfi-icall-generalize-pointers,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	)
	!official? (
		media-libs/freetype[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	)
"

# flac is required for speech support.
# These are related to https://github.com/chromium/chromium/tree/94.0.4606.71/build/linux/unbundle
# and initial attempts by the original ebuild developers.
# TODO: regroup this list by primary dependencies.
# Corresponds to [B] in this ebuild.
UNBUNDLE_DEPENDS="
	${FFMPEG_DEPENDS}
	${FONTCONFIG_DEPENDS}
	${OPUS_DEPENDS}
	dev-libs/libxml2[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	media-libs/flac[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	media-libs/libwebp[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	libcxx? ( sys-libs/libcxx[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}] )
"

# dev-libs/weston may need it but only used in build time
WAYLAND_DEPENDS="
	wayland? (
		dev-libs/wayland[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
		weston? ( dev-libs/weston[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}] )
	)
"

# dev-libs/icu Requires -fsanitize-blacklist=${S}/cfi-exceptions.txt
# TODO: Add in forked package:
#
# cfi-exceptions.txt:
# # Required by chromium
# [cfi-icall]
# src:*/common/*
#
# In common COMMON_DEPENDS, search for [A] in ebuild
# The lack of hardending for openh264 is due to royalty issues (see Wikipedia),
# we assume only the binary only version.
SYSTEM_LIBXCXX_DEPENDS="
	dev-libs/libxslt[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	dev-libs/re2[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	app-arch/snappy[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}]
	proprietary-codecs? ( media-libs/openh264[${MULTILIB_USEDEP}] )
	system-icu? ( dev-libs/icu[cfi-cast?,cfi-icall?,cfi-vcall?,clang,hardened,libcxx,${MULTILIB_USEDEP}] )
"

SECURITY_DEPENDS_COMMON="
	system-libcxx? (
		${LIBWEBP_DEPENDS}
		${SYSTEM_LIBXCXX_DEPENDS}
		${UNBUNDLE_DEPENDS}
		${WAYLAND_DEPENDS}
	)
"

SECURITY_DEPENDS+="
	official? ( ${SECURITY_DEPENDS_COMMON} )
	cfi-cast? ( ${SECURITY_DEPENDS_COMMON} )
	cfi-icall? ( ${SECURITY_DEPENDS_COMMON} )
	cfi-vcall? ( ${SECURITY_DEPENDS_COMMON} )
"

# Disabled until forked ebuild progress completes
#RDEPEND+=" ${SECURITY_DEPENDS}"

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS} ; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/noto
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

To fix broken icons on the Downloads page, you should install an icon
theme that covers the appropriate MIME types, and configure this as your
GTK+ icon theme.

For native file dialogs in KDE, install kde-apps/kdialog.

To make password storage work with your desktop environment you may
have install one of the supported credentials management applications:
- app-crypt/libsecret (GNOME)
- kde-frameworks/kwallet (KDE)
If you have one of above packages installed, but don't want to use
them in Chromium, then add --password-store=basic to CHROMIUM_FLAGS
in /etc/chromium/default.
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
			CPP="${CHOST}-clang++ -E"
			if ! ver_test "$(clang-major-version)" -ge 13 ; then
				die "At least clang 13 is required"
			fi
		fi
	fi

	# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="3G"
	CHECKREQS_DISK_BUILD="8G"
	if ( shopt -s extglob; is-flagq '-g?(gdb)?([1-9])' ) ; then
		if use custom-cflags || use component-build ; then
			CHECKREQS_DISK_BUILD="25G"
		fi
		if ! use component-build ; then
			CHECKREQS_MEMORY="16G"
		fi
	fi

	local virt_mem_sources=$(free --giga | tail -n +2 \
		| sed -r -e "s|[ ]+| |g" | cut -f 2 -d " ")
	local total_virtual_mem=0
	for virt_mem_source in ${virt_mem_sources[@]} ; do
		total_virtual_mem=$((${total_virtual_mem} + ${virt_mem_source}))
	done
	if (( ${total_virtual_mem} < 12 )) ; then
# It randomly fails and a success observed with 8 GiB of total memory
# (ram + swap) when multitasking.  It works with 16 GiB of total memory when
# multitasking, but peak virtual memory (used + reserved) is ~10.2 GiB for
# ld.lld.
# [43742.787803] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/,task=ld.lld,pid=27154,uid=250
# [43742.787817] Out of memory: Killed process 27154 (ld.lld) total-vm:10471016kB, anon-rss:2440396kB, file-rss:3180kB, shmem-rss:0kB, UID:250 pgtables:20168kB oom_score_adj:0
# [43744.101600] oom_reaper: reaped process 27154 (ld.lld), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
ewarn
ewarn "You may need >= 12 GiB of total memory to link ${PN}.  Please add more"
ewarn "swap space.  You currently have ${total_virtual_mem} GiB of total"
ewarn "memory."
ewarn
	else
einfo "Total memory (RAM + swap) is sufficient (>= 12 GiB)."
	fi

	if use lto-opt && (( ${total_virtual_mem} <= 8 )) ; then
		die "Add more swap space."
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
}

# The answer to the profdata compatibility is answered in
# https://clang.llvm.org/docs/SourceBasedCodeCoverage.html#format-compatibility-guarantees

# The profdata (aka indexed profile) version is 7 corresponding to >= llvm 12
# to main branch (llvm 14) and is after the magic (lprofi - i for index) in the
# profdata file located in chrome/build/pgo_profiles/*.profdata.

# PGO version compatibility

# Profdata versioning:
# https://github.com/llvm/llvm-project/blob/98033fdc50e61273b1d5c77ba5f0f75afe3965c1/llvm/include/llvm/ProfileData/InstrProf.h#L991
# LLVM version:
# https://github.com/llvm/llvm-project/blob/98033fdc50e61273b1d5c77ba5f0f75afe3965c1/llvm/CMakeLists.txt
# The 98033fd is from the CR_CLANG_USED below.

CR_CLANG_USED="98033fdc50e61273b1d5c77ba5f0f75afe3965c1" # Obtained from \
# https://github.com/chromium/chromium/blob/94.0.4606.71/tools/clang/scripts/update.py#L42
CR_CLANG_USED_UNIX_TIMESTAMP="1626129557" # Cached.  Use below to obtain this. \
# TIMESTAMP=$(wget -q -O - https://github.com/llvm/llvm-project/commit/${CR_CLANG_USED}.patch \
#	| grep -F -e "Date:" | sed -e "s|Date: ||") ; date -u -d "${TIMESTAMP}" +%s
CR_CLANG_SLOT="13"

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
		sys-libs/libcxx
		sys-libs/libcxxabi
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
	if [[ -n "${emerged_llvm_timestamp}" ]] ; then
		einfo "System's ${p} timestamp:  "$(date -d "@${emerged_llvm_timestamp}")
		if [[ "${p}" == "sys-devel/llvm" ]] ; then
			einfo "${PN^}'s LLVM timestamp:  "$(date -d "@${CR_CLANG_USED_UNIX_TIMESTAMP}")
		else
			einfo "System's sys-devel/llvm timestamp:  "$(date -d "@${LLVM_TIMESTAMP}")
		fi
	fi
}

_get_release_hash() {
	local v="${1}"
	if [[ -z "${cached_release_hashes[${v}]}" ]] ; then
		local hash=$(git --no-pager ls-remote \
			https://github.com/llvm/llvm-project.git \
			llvmorg-${v} \
			| cut -f 1 -d $'\t')
		cached_release_hashes[${v}]="${hash}"
	fi
	echo "${cached_release_hashes[${v}]}"
}

_get_llvm_timestamp() {
	if [[ -z "${emerged_llvm_commit}" ]] ; then
		# Should check against the llvm milestone if not live
		v=$(ver_cut 1-3 "${pv}")
		local suffix=""
		if [[ "${pv}" =~ "_rc" ]] ; then
			suffix=$(echo "${pv}" | grep -E -o -e "_rc[0-9]+")
			suffix=${suffix//_/-}
		fi
		v="${v}${suffix}"
		emerged_llvm_commit=$(_get_release_hash ${v})
	fi
	if [[ -z "${emerged_llvm_timestamps[${emerged_llvm_commit}]}" ]] ; then
		einfo "Fetching timestamp for ${emerged_llvm_commit}"
		# Uncached
		local emerged_llvm_time_desc=$(wget -q -O - \
			https://github.com/llvm/llvm-project/commit/${emerged_llvm_commit}.patch \
			| grep -F -e "Date:" | sed -e "s|Date: ||")
		emerged_llvm_timestamp=$(date -u -d "${emerged_llvm_time_desc}" +%s)
		emerged_llvm_timestamps[${emerged_llvm_commit}]=${emerged_llvm_timestamp}
		einfo "Timestamp comparison for ${p}"
		_print_timestamps
	else
		einfo "Using cached timestamp for ${emerged_llvm_commit}"
		# Cached
		emerged_llvm_timestamp=${emerged_llvm_timestamps[${emerged_llvm_commit}]}
		einfo "Timestamp comparison for ${p}"
		_print_timestamps
	fi
}

_check_llvm_updated() {
	local root_pkg_timestamp=""

	if [[ "${p}" == "sys-devel/llvm" ]] ; then
		root_pkg_timestamp="${CR_CLANG_USED_UNIX_TIMESTAMP}"
	else
		root_pkg_timestamp="${LLVM_TIMESTAMP}"
	fi

	[[ -z "${emerged_llvm_timestamp}" ]] && die
	[[ -z "${root_pkg_timestamp}" ]] && die

	if (( ${emerged_llvm_timestamp} < ${root_pkg_timestamp} )) ; then
		needs_emerge=1
		llvm_packages_status[${p_}]="1" # needs emerge
	else
		llvm_packages_status[${p_}]="0" # package is okay
	fi
}

# For multiple sys-libs/compiler-rt-sanitizers:x.y.z
_check_llvm_updated_triple() {
	[[ -z "${emerged_llvm_timestamp}" ]] && die
	[[ -z "${LLVM_TIMESTAMP}" ]] && die

	if (( ${emerged_llvm_timestamp} < ${LLVM_TIMESTAMP} )) ; then
		needs_emerge=1
		llvm_packages_status[${p_}]="1" # needs emerge
		old_triple_slot_packages+=( "${category}/${pn}:"$(cat "${mp}/SLOT") )
	else
		llvm_packages_status[${p_}]="0" # package is okay
	fi
}

print_old_live_llvm_multislot_pkgs() {
	local arg="${1}"
	local llvm_slot="${2}"
	for x in ${old_triple_slot_packages[@]} ; do
		local slot=${x/:*}
		if [[ "${arg}" == "${slot}" ]] ; then
			LLVM_REPORT_CARDS[${llvm_slot}]+="emerge -1v ${x}\n"
		fi
	done
}

verify_llvm_report_card() {
	local llvm_slot=${1}
	if (( ${needs_emerge} == 1 )) ; then
		for p in ${live_pkgs[@]} ; do
			if [[ "${p}" == "sys-libs/libcxx" ]] && ! use system-libcxx ; then
				continue
			fi
			if [[ "${p}" == "sys-libs/libcxxabi" ]] && ! use system-libcxx ; then
				continue
			fi
			if [[ "${p}" == "sys-libs/libcxxabi" ]] && use system-libcxx \
				&& ! has_version "sys-libs/libcxxabi" ; then
				continue
			fi
			local p_=${p//-/_}
			p_=${p_//\//_}
			if (( ${llvm_packages_status[${p_}]} == 1 )) ; then
				if contains_slotted_major_version "${p}" ; then
					LLVM_REPORT_CARDS[${llvm_slot}]+="emerge -1v ${p}:${llvm_slot}\n"
				elif contains_slotted_triple_version "${p}" ; then
					print_old_live_llvm_multislot_pkgs "${p}" ${llvm_slot}
				elif contains_slotted_zero "${p}" ; then
					LLVM_REPORT_CARDS[${llvm_slot}]+="emerge -1v ${p}:0\n"
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
	einfo "Inspecting for llvm:${llvm_slot}"

	# Everything that inherits the llvm.org must be checked.
	# sys-devel/clang-runtime doesn't need check
	# 3 slot types
	# sys-devel/llvm:x
	# sys-devel/clang:x
	# sys-libs/compiler-rt:x.y.z
	# sys-libs/compiler-rt-sanitizers:x.y.z
	# sys-libs/libomp:0
	# sys-devel/lld:0
	# sys-libs/libcxx:0
	# sys-libs/libcxxabi:0
	local live_pkgs=(
		# Do not change the order!
		sys-devel/llvm
		sys-libs/libomp
		sys-libs/libcxxabi
		sys-libs/libcxx
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

	local pass=0
	local needs_emerge=0
	# The llvm library or llvm-ar doesn't embed the hash info, so scan the /var/db/pkg.
	if has_version "sys-devel/llvm:${llvm_slot}" ; then
		for p in ${live_pkgs[@]} ; do
			if [[ "${p}" == "sys-libs/libcxx" ]] && ! use system-libcxx ; then
				continue
			fi
			if [[ "${p}" == "sys-libs/libcxxabi" ]] && ! use system-libcxx ; then
				continue
			fi
			if [[ "${p}" == "sys-libs/libcxxabi" ]] && use system-libcxx \
				&& ! has_version "sys-libs/libcxxabi" ; then
				continue
			fi

			# Check each of the live packages that use llvm.org
			# eclass.  Especially for forgetful types.

			local emerged_llvm_commit

			local p_=${p//-/_}
			p_=${p_//\//_}
			if contains_slotted_major_version "${p}" ; then
				einfo
				einfo "Checking ${p}:${llvm_slot}"
				emerged_llvm_commit=$(bzcat \
					"${ESYSROOT}/var/db/pkg/${p}-${llvm_slot}"*"/environment.bz2" \
					| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
				pv=$(cat "${ESYSROOT}/var/db/pkg/${p}-${llvm_slot}"*"/PF" | sed "s|${p}-||")
				_get_llvm_timestamp
				[[ "${p}" == "sys-devel/llvm" ]] \
					&& LLVM_TIMESTAMP=${emerged_llvm_timestamp}
				_check_llvm_updated
			elif contains_slotted_zero "${p}" ; then
				einfo
				einfo "Checking ${p}:0"
				emerged_llvm_commit=$(bzcat \
					"${ESYSROOT}/var/db/pkg/${p}"*"/environment.bz2" \
					| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
				pv=$(cat "${ESYSROOT}/var/db/pkg/${p}"*"/PF" | sed "s|${p}-||")
				_get_llvm_timestamp
				_check_llvm_updated
			else
				local category=${p/\/*}
				local pn=${p/*\/}
				# Handle multiple slots (i.e multiple sys-libs/compiler-rt-sanitizers:x.y.z)
				# We shouldn't have to deal with multiple sys-libs/compiler-rt-sanitizers
				# 13.0.0.9999 13.0.0_rc3 13.0.0_rc2 versions installed at the same time
				# for just 1 sys-libs/llvm but we have to.
				for mp in $(find "${ESYSROOT}/var/db/pkg/${category}" \
					-maxdepth 1 \
					-type d \
					-regextype "posix-extended" \
					-regex ".*${pn}-${llvm_slot}.[0-9.]+") ; do
					einfo
					einfo "Checking ="$(basename ${mp})
					emerged_llvm_commit=$(bzcat \
						"${mp}/environment.bz2" \
						| grep -F -e "EGIT_VERSION" \
						| head -n 1 \
						| cut -f 2 -d '"')
					pv=$(cat "${mp}/PF" | sed "s|${p}-||")
					_get_llvm_timestamp
					_check_llvm_updated_triple
				done
			fi
		done
		verify_llvm_report_card ${llvm_slot}
	else
		LLVM_REPORT_CARDS[${llvm_slot}]="not installed"
	fi
}

find_video0() {
	if [[ -z "${CR_PGO_VIDEO0}" ]] ; then
eerror
eerror "CR_PGO_VIDEO0 is missing the abspath to your vp8/vp9 video as a"
eerror "per-package envvar.  The video must be 3840x2160 resolution,"
eerror "60fps, >= 2 minutes."
eerror
		die
	fi
	if ffprobe "${CR_PGO_VIDEO0}" 2>/dev/null 1>/dev/null ; then
		einfo "Verifying asset requirements"
		if ! ( ffprobe "${CR_PGO_VIDEO0}" 2>&1 \
			| grep -q -e "3840x2160" ) ; then
eerror
eerror "The PGO video sample must be 3840x2160."
eerror
			die
		fi
		if ! ( ffprobe "${CR_PGO_VIDEO0}" 2>&1 \
			| grep -q -E -e ", (59|60)[.0-9]* fps" ) ; then
eerror
eerror "The PGO video sample must be >=59 fps."
eerror
			die
		fi

		local d=$(ffprobe "${CR_PGO_VIDEO0}" 2>&1 \
			| grep -E -e "Duration" \
			| cut -f 4 -d " " \
			| sed -e "s|,||g" \
			| cut -f 1 -d ".")
		local h=$(($(echo "${d}" \
			| cut -f 1 -d ":") * 60 * 60))
		local m=$(($(echo "${d}" \
			| cut -f 2 -d ":") * 60))
		local s=$(($(echo "${d}" \
			| cut -f 3 -d ":") * 1))
		local t=$((${h} + ${m} + ${s}))
		if (( ${t} < 120 )) ; then
eerror
eerror "The PGO video sample must be >= 2 minutes."
eerror
			die
		fi
	else
eerror
eerror "${CR_PGO_VIDEO0} is possibly not a valid video file.  Ensure that"
eerror "the proper codec is supported for that file"
eerror
		die
	fi
}

NABIS=0
pkg_setup() {
	einfo "The $(ver_cut 1 ${PV}) series is the stable channel."
	pre_build_checks

	chromium_suid_sandbox_check_kernel_config

	# nvidia-drivers does not work correctly with Wayland due to unsupported EGLStreams
	if use wayland && ! use headless && has_version "x11-drivers/nvidia-drivers" ; then
		ewarn "Proprietary nVidia driver does not work with Wayland. You can disable"
		ewarn "Wayland by setting DISABLE_OZONE_PLATFORM=true in /etc/chromium/default."
	fi

	if ! use amd64 && [[ "${USE}" =~ cfi ]] ; then
ewarn
ewarn "All variations of the cfi USE flags are not defaults for this platform."
ewarn "Disable them if problematic."
ewarn
	fi

	if use pgo-full ; then
ewarn
ewarn "The pgo-full USE flag is a Work In Progress (WIP) and not production ready."
ewarn "Please only use the pgo USE flag instead.  This notice will be removed when"
ewarn "it is ready."
ewarn
		if has network-sandbox $FEATURES ; then
eerror
eerror "The pgo-full USE flag requires FEATURES=\"-network-sandbox\" to be able to"
eerror "use vpython and other dependencies in order to generate PGO profiles."
eerror
			die
		fi
		if use wayland && ! use weston ; then
ewarn
ewarn "Weston is required for PGO profile generation but mutually exclusive to"
ewarn "X windowing system PGO profile generation."
ewarn
		fi
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
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		local MESA_LLVM_MAX_SLOT=$(bzcat \
			"${ESYSROOT}/var/db/pkg/media-libs/mesa"*"/environment.bz2" \
			| grep -F -e "LLVM_MAX_SLOT" \
			| head -n 1 \
			| cut -f 2 -d '"')
		einfo "MESA_LLVM_MAX_SLOT: ${MESA_LLVM_MAX_SLOT}"
		unset LLVM_REPORT_CARDS
		for s in ${LLVM_SLOTS[@]} ; do
			verify_llvm_toolchain ${s}
		done
		LLVM_SLOT=
		local slots
		if use official ; then
			slots=${CR_CLANG_SLOT}
		else
			slots=$(echo "${LLVM_SLOTS[@]}" | tr " " "\n" | tac | tr "\n" " ")
		fi
		for s in ${slots} ; do
			if [[ ${LLVM_REPORT_CARDS[${s}]} == "pass" ]] ; then
				LLVM_SLOT=${s}
				break
			fi
		done
		if [[ -z "${LLVM_SLOT}" ]] ; then
eerror
eerror "You must choose a LLVM slot to update properly:"
eerror
			for s in $(echo "${LLVM_SLOTS[@]}" | tr " " "\n" | tac) ; do
				[[ ${LLVM_REPORT_CARDS[${s}]} == "not installed" ]] \
					&& continue
eerror
eerror "The LLVM ${s} toolchain needs the following update:"
echo -e "${LLVM_REPORT_CARDS[${s}]}"
			done
			die
		else
			export PATH=$(echo "${PATH}" | tr ":" "\n" | sed -e "s|.*llvm/.*||" | uniq \
				| sed -e "/^$/d" | tr "\n" ":" | sed -e "s|:$||")
			export PATH+=":/usr/lib/llvm/${LLVM_SLOT}/bin"
			einfo "Using llvm:${LLVM_SLOT}"
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

	if use vaapi ; then
		find_vaapi
	fi

	if use cr_pgo_trainers_media_desktop \
		|| use cr_pgo_trainers_media_mobile ; then
		find_video0
	fi

	if use system-libcxx || use system-libstdcxx ; then
ewarn
ewarn "The system's libcxx or libstdcxx may weaken the security.  Consider"
ewarn "using only the bundled-libcxx instead."
ewarn
	fi

	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done
}

USED_EAPPLY=0
ceapply() {
	USED_EAPPLY=1
	eapply "${@}"
}

CIPD_CACHE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/${PN}/cipd-cache"
init_vpython() {
	export CIPD_CACHE_DIR
	export PATH="${S}/third_party/depot_tools:${PATH}"
	# See https://github.com/chromium/chromium/blob/92.0.4577.42/DEPS#L4489
	addwrite "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	mkdir -p "${CIPD_CACHE_DIR}" || die
	addwrite "${CIPD_CACHE_DIR}"
	einfo "Downloading VirtualEnvs ( ~287 MiB, ~1 hr wait )"
	einfo "If build problems, remove the ${CIPD_CACHE_DIR} folder and try again."
#		tools/perf/fetch_benchmark_deps.py
	local scripts_to_run=(
		out/Release/bin/run_performance_test_suite
	)
	cd "${S}" || die
	for s in ${scripts_to_run[@]} ; do
		einfo "Downloading a VirtualEnv for $(basename ${s})"
		"${s}" -cache-dir "${CIPD_CACHE_DIR}" --help || die
	done
}

fetching_pgo_deps() {
	einfo "Downloading all benchmark deps used by PGO trainers"
	cd "${S}" || die
	vpython -cache-dir "${CIPD_CACHE_DIR}" tools/perf/fetch_benchmark_deps.py || die
}

src_unpack() {
	for a in ${A} ; do
		[[ "${a}" == "${PN}-${MTD_V}-media-test-data.tar.gz" ]] && continue
		[[ "${a}" == "${PN}-${CTDM_V}-chrome-test-data-media.tar.gz" ]] && continue
		unpack ${a}
	done
	if use pgo-full ; then
		cp -a $(realpath "${DISTDIR}/.cipd_client-${ABI}-${CIPD_V}") \
			"${S}/third_party/depot_tools/.cipd_client" || die
		chmod +x "${S}/third_party/depot_tools/.cipd_client" || die
		pushd "${S}/media/test/data" || die
			unpack ${PN}-${MTD_V}-media-test-data.tar.gz
		popd
		pushd "${S}/chrome/test/data/media" || die
			unpack ${PN}-${CTDM_V}-chrome-test-data-media.tar.gz
		popd
	fi
}

# Full list of hw accelerated image processing
# ffmpeg -filters | grep vaapi
_is_hw_scaling_supported() {
	local encoding_format="${1}"
	if use vaapi && ffmpeg -filters 2>/dev/null \
		| grep -q -F -e "scale_vaapi" \
		&& vainfo 2>/dev/null \
		| grep -q -F -e "VAEntrypointVideoProc" \
		&& vainfo 2>/dev/null \
                | grep -q -G -e "${encoding_format}.*VAEntrypointEncSlice" \
                && ffmpeg -hide_banner -encoders 2>/dev/null \
                        | grep -q -F -e "${encoding_format,,}_vaapi" ; then
		return 0
	else
		return 1
	fi
}

_gen_vaapi_filter() {
	local encoding_format="${1}"
	if use vaapi \
		&& vainfo 2>/dev/null \
		| grep -q -G -e "${encoding_format}.*VAEntrypointEncSlice" \
		&& ffmpeg -hide_banner -encoders 2>/dev/null \
			| grep -q -F -e "${encoding_format,,}_vaapi" ; then
		echo "format=nv12,hwupload"
	else
		echo ""
	fi
}

_is_vaapi_allowed() {
	local encoding_format="${1}"
	if use vaapi && vainfo 2>/dev/null \
		| grep -q -G -e "${encoding_format}.*VAEntrypointEncSlice" \
		&& ffmpeg -hide_banner -encoders 2>/dev/null \
			| grep -q -F -e "${encoding_format,,}_vaapi" ; then
		return 0
	fi
	return 1
}

DRM_RENDER_NODE=
find_vaapi() {
	if use vaapi && [[ -n "${CR_DRM_RENDER_NODE}" ]] ; then
		einfo "User VA-API override"
		# Per-package envvar overridable
		DRM_RENDER_NODE=${CR_DRM_RENDER_NODE}
	elif use vaapi ; then
		einfo "Autodetecting VA-API device"
		unset LIBVA_DRIVERS_PATH
		unset LIBVA_DRIVER_NAME
		unset DRM_RENDER_NODE
		for d in $(find /dev/dri -name "render*") ; do
			# Permute
			for v in $(seq 0 2) ; do # 2 GPU and 1 APU scenario
				export DRI_PRIME=${v} # \
				# See xrandr --listproviders for mapping, could be 1=dGPU, 0=APU/IGP
				if vainfo 2>/dev/null 1>/dev/null ; then
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib/dri" \
					LIBVA_DRIVER_NAME="iHD" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib/dri"
					export LIBVA_DRIVER_NAME="iHD"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib/dri" \
					LIBVA_DRIVER_NAME="i965" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib/dri"
					export LIBVA_DRIVER_NAME="i965"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib/dri" \
					LIBVA_DRIVER_NAME="radeonsi" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib/dri"
					export LIBVA_DRIVER_NAME="radeonsi"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib/dri" \
					LIBVA_DRIVER_NAME="r600" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib/dri"
					export LIBVA_DRIVER_NAME="r600"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib/dri" \
					LIBVA_DRIVER_NAME="r300" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib/dri"
					export LIBVA_DRIVER_NAME="r300"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/opt/amdgpu/lib64/dri" \
					LIBVA_DRIVER_NAME="radeonsi" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/opt/amdgpu/lib64/dri"
					export LIBVA_DRIVER_NAME="radeonsi"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/opt/amdgpu/lib64/dri" \
					LIBVA_DRIVER_NAME="r600" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/opt/amdgpu/lib64/dri"
					export LIBVA_DRIVER_NAME="r600"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/opt/amdgpu/lib64/dri" \
					LIBVA_DRIVER_NAME="r300" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/opt/amdgpu/lib64/dri"
					export LIBVA_DRIVER_NAME="r300"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/opt/amdgpu/lib/x86_64-linux-gnu/dri" \
					LIBVA_DRIVER_NAME="radeonsi" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/opt/amdgpu/lib/x86_64-linux-gnu/dri"
					export LIBVA_DRIVER_NAME="radeonsi"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/opt/amdgpu/lib/x86_64-linux-gnu/dri" \
					LIBVA_DRIVER_NAME="r600" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/opt/amdgpu/lib/x86_64-linux-gnu/dri"
					export LIBVA_DRIVER_NAME="r600"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/opt/amdgpu/lib/x86_64-linux-gnu/dri" \
					LIBVA_DRIVER_NAME="r300" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/opt/amdgpu/lib/x86_64-linux-gnu/dri"
					export LIBVA_DRIVER_NAME="r300"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib64/dri/" \
					LIBVA_DRIVER_NAME="nvidia" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib64/dri/"
					export LIBVA_DRIVER_NAME="nvidia"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib/dri" \
					LIBVA_DRIVER_NAME="nvidia" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib/dri"
					export LIBVA_DRIVER_NAME="nvidia"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib/dri" \
					LIBVA_DRIVER_NAME="vdpau" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib/dri"
					export LIBVA_DRIVER_NAME="vdpau"
					export DRM_RENDER_NODE="${d}"
				elif LIBVA_DRIVERS_PATH="/usr/lib/dri" \
					LIBVA_DRIVER_NAME="nouveau" \
					vainfo 2>/dev/null 1>/dev/null ; then
					export LIBVA_DRIVERS_PATH="/usr/lib/dri"
					export LIBVA_DRIVER_NAME="nouveau"
					export DRM_RENDER_NODE="${d}"
				fi
			done
		done
	fi
	vaapi_autodetect_failed_msg() {
eerror
eerror "VA-API autodetect failed.  Manual setup required."
eerror
eerror "Set the CR_DRM_RENDER_NODE per-package envvar to the abspath DRM render"
eerror "node.  See \`ls /dev/dri\` for a list of possibilities."
eerror "LIBVA_DRIVERS_PATH, LIBVA_DRIVER_NAME, DRI_PRIME may also need to be"
eerror "set."
eerror
eerror "You may also disable the vaapi USE flag if there is difficulty"
eerror "installing or configuring the driver."
eerror
	}
	if use vaapi && [[ -n "${CR_DRM_RENDER_NODE}" ]] \
		&& ! vainfo --display drm --device "${DRM_RENDER_NODE}" ; then
		eerror "VA-API test failure"
		vaapi_autodetect_failed_msg
		die
	elif use vaapi && [[ -z "${DRM_RENDER_NODE}" ]] ; then
		vaapi_autodetect_failed_msg
		die
	elif use vaapi ; then
		einfo "Using VA-API device with DRM render node ${DRM_RENDER_NODE}"
		[[ -n "${LIBVA_DRIVER_NAME}" ]] \
			&& einfo " LIBVA_DRIVER_NAME=${LIBVA_DRIVER_NAME}"
		[[ -n "${LIBVA_DRIVERS_PATH}" ]] \
			&& einfo " LIBVA_DRIVERS_PATH=${LIBVA_DRIVERS_PATH}"
	fi
}

is_generating_credits() {
	if [[ -n "${GEN_ABOUT_CREDITS}" && "${GEN_ABOUT_CREDITS}" == "1" ]] ; then
		return 0
	else
		return 1
	fi
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

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

	# It's already applied upstream.
	rm -rf "${WORKDIR}/patches/chromium-93-dawn-raw-string-literal.patch" || die
	rm -rf "${WORKDIR}/patches/chromium-swiftshader-export.patch" || die

	PATCHES+=(
		"${FILESDIR}/chromium-93-EnumTable-crash.patch"
		"${FILESDIR}/chromium-93-InkDropHost-crash.patch"
		"${FILESDIR}/chromium-use-oauth2-client-switches-as-default.patch"
		"${FILESDIR}/chromium-shim_headers.patch"
	)

	if ! use arm64 ; then
		einfo "Removing aarch64 only patches"
		rm "${WORKDIR}/patches/chromium-91-libyuv-aarch64.patch" || die
	fi

	if use clang ; then
		ceapply "${FILESDIR}/${PN}-92-clang-toolchain-1.patch"
		ceapply "${FILESDIR}/${PN}-92-clang-toolchain-2.patch"
	fi

	if use arm64 && use shadowcallstack ; then
		ceapply "${FILESDIR}/chromium-94-arm64-shadow-call-stack.patch"
	fi

	default

	if use cr_pgo_trainers_custom && [[ ! -f "${T}/epatch_user.log" ]] ; then
eerror
eerror "You must supply a per-package patch to use the cr_pgo_trainers_custom"
eerror "USE flag."
eerror
		die
	fi

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
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/dav1d
		third_party/dawn
		third_party/dawn/third_party/khronos
		third_party/dawn/third_party/tint
		third_party/depot_tools
		third_party/devscripts
		third_party/devtools-frontend
		third_party/devtools-frontend/src/front_end/third_party/acorn
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
		third_party/dom_distiller_js
		third_party/eigen3
		third_party/emoji-segmenter
		third_party/farmhash
		third_party/fdlibm
		third_party/fft2d
		third_party/flatbuffers
		third_party/freetype
		third_party/fusejs
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
		third_party/libXNVCtrl
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
		third_party/opencv
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
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/astc-encoder
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/marl
		third_party/swiftshader/third_party/subzero
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv/unified1
		third_party/tcmalloc
		third_party/tensorflow-text
		third_party/tflite
		third_party/tflite/src/third_party/eigen3
		third_party/tflite/src/third_party/fft2d
		third_party/tflite-support
		third_party/ruy
		third_party/six
		third_party/ukey2
		third_party/unrar
		third_party/usrsctp
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
	if use cfi-cast || use cfi-icall || use cfi-vcall || use official ; then
		keeplibs+=(
			third_party/zlib
		)
	fi
	if use pgo-full ; then
		keeplibs+=(
			third_party/catapult/third_party/gsutil
			third_party/catapult/third_party/tsproxy
			third_party/catapult/third_party/typ
		)
	fi
	if ! use system-ffmpeg ; then
		keeplibs+=( third_party/ffmpeg third_party/opus )
	fi
	if ! use system-icu ; then
		keeplibs+=( third_party/icu )
	fi
	if use system-harfbuzz; then
		keeplibs+=( third_party/harfbuzz-ng/utils )
	else
		keeplibs+=( third_party/harfbuzz-ng )
	fi
	if use wayland && ! use headless ; then
		keeplibs+=( third_party/wayland )
	fi
	if ! use system-libstdcxx \
		|| use cfi-cast \
		|| use cfi-icall \
		|| use cfi-vcall \
		|| use official ; then
		keeplibs+=( third_party/libxml )
		keeplibs+=( third_party/libxslt )
		keeplibs+=( third_party/re2 )
		keeplibs+=( third_party/snappy )
		if use proprietary-codecs ; then
			keeplibs+=( third_party/openh264 )
		fi
		if use system-icu ; then
			keeplibs+=( third_party/icu )
		fi
	fi
	if use arm64 || use ppc64 ; then
		keeplibs+=( third_party/swiftshader/third_party/llvm-10.0 )
	fi
	# we need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64 ; then
		pushd third_party/libvpx >/dev/null || die
		mkdir -p source/config/linux/ppc64 || die
		./generate_gni.sh || die
		popd >/dev/null || die
	fi

	if ! is_generating_credits ; then
		einfo "Unbundling third party internal libraries and packages"
		# Remove most bundled libraries. Some are still needed.
		build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die
	fi

	if use js-type-check ; then
		ln -s "${EPREFIX}"/usr/bin/java third_party/jdk/current/bin/java || die
	fi

	if ! is_generating_credits ; then
		# bundled eu-strip is for amd64 only and we don't want to pre-stripped binaries
		mkdir -p buildtools/third_party/eu-strip/bin || die
		ln -s "${EPREFIX}"/bin/true buildtools/third_party/eu-strip/bin/eu-strip || die
	fi

	if use pgo-full ; then
		export ASSET_CACHE_REVISION=6 # Bump on every change of output.
		ASSET_CACHE="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/${PN}/asset-cache"
		addwrite "${ASSET_CACHE}"

		restart_asset_cache() {
			einfo "Restarting the asset cache"
			rm -rf "${ASSET_CACHE}"
			mkdir -p "${ASSET_CACHE}" || die
			echo "REVISION=${ASSET_CACHE_REVISION}" \
				> "${ASSET_CACHE}/.cache-control" || die
		}
		if [[ ! -f "${ASSET_CACHE}/.cache-control" ]] ; then
			restart_asset_cache
		else
			local x_asset_cache_revision=$(grep -r \
				-e "REVISION=" "${ASSET_CACHE}/.cache-control" \
				| cut -f 2 -d "=")
			einfo "x_asset_cache_revision=${x_asset_cache_revision}"
			einfo "ASSET_CACHE_REVISION=${ASSET_CACHE_REVISION}"
			if (( ${x_asset_cache_revision} < ${ASSET_CACHE_REVISION} )) ; then
				restart_asset_cache
			else
				einfo "Reusing the asset-cache"
			fi
		fi

		mkdir -p "${ASSET_CACHE}" || die
		local drm_render_node=()
		local init_ffmpeg_filter=()
		if use vaapi ; then
			if [[ -e ${DRM_RENDER_NODE} ]] ; then
				export MESA_GLSL_CACHE_DIR="${HOME}/mesa_shader_cache" # \
				  # Prevent a sandbox violation and isolate between parallel running emerges.
				drm_render_node=( -init_hw_device vaapi=drm_render_node:${DRM_RENDER_NODE} )
			else
				die "Missing VA-API device"
			fi
			if use vaapi && ffmpeg -filters 2>/dev/null \
				| grep -q -F -e "scale_vaapi" ; then
				init_ffmpeg_filter=( -filter_hw_device drm_render_node )
			fi
		fi
		if use cr_pgo_trainers_memory_desktop ; then
			einfo "Generating missing assets for the memory.desktop"

			local vp8_decoding=()

			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP8.*VAEntrypointVLD" \
				&& [[ -e /dev/dri/renderD128 ]] ; then
				vp8_decoding=( -hwaccel vaapi
					-hwaccel_output_format vaapi
					-hwaccel_device drm_render_node
					-filter_hw_device drm_render_node )
			fi

			if use proprietary-codecs ; then
				local aac_encoding=( -codec:a aac )
				local h264_encoding=()

				h264_baseline_profile=()
				if use vaapi && vainfo 2>/dev/null \
					| grep -q -G -e "H264.*VAEntrypointEncSlice" \
					&& ffmpeg -hide_banner -encoders 2>/dev/null \
						| grep -q -F -e "h264_vaapi" ; then
					h264_encoding=( -c:v h264_vaapi )
					h264_baseline_profile=( -profile:v 578 )
					# For quality see, ffmpeg -h full
				elif has_version "media-video/ffmpeg[openh264]" ;then
					h264_encoding=( -c:v libopenh264 )
					h264_baseline_profile=( -profile:v 578 )
				fi

				# bigbuck.webm -> buck-480p.mp4
				einfo "Generating buck-480p.mp4 for the memory.desktop benchmark"
				# The bunny.gif doesn't actually exist on the website but is converted from the
				# movie explained in https://codereview.chromium.org/2243403006
				filter_sw=()
				filter_hw+=( $(_gen_vaapi_filter "H264") )
				if _is_hw_scaling_supported "H264" ; then
					filter_hw+=( "scale_vaapi=w=852:h=-1" )
				else
					filter_sw+=( "scale=w=852:h=-1" )
					filter_sw+=( "crop=852:480:0:0" )
				fi
				cmd=( ffmpeg \
					${drm_render_node[@]} \
					${vp8_decoding[@]} \
					-i "${S}/chrome/test/data/media/bigbuck.webm" \
					${h264_encoding[@]} \
					$(_is_vaapi_allowed "H264" && echo "${init_ffmpeg_filter[@]}") \
					-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
						&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
						&& echo " ${filter_hw[@]}") | tr " " ",") \
					${aac_encoding[@]} \
					"${S}/tools/perf/page_sets/trivial_sites/buck-480p.mp4" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"
				sed -i -e "s|road_trip_640_480.mp4|buck-480p.mp4|g" \
					"${S}/tools/perf/page_sets/trivial_sites/trivial_fullscreen_video.html" \
					|| die
			fi

			# bigbuck.webm -> bunny.gif
			einfo "Generating bunny.gif (animated gif) for the memory.desktop benchmark"
			# The bunny.gif doesn't actually exist on the website but is converted from the
			# movie explained in https://codereview.chromium.org/2243403006
			filter_sw=( "scale=w=852:h=-1" )
			filter_sw+=( "crop=852:480:0:0" )
			cmd=( ffmpeg \
				${drm_render_node[@]} \
				${vp8_decoding[@]} \
				-i "${S}/chrome/test/data/media/bigbuck.webm" \
				$(_is_vaapi_allowed "GIF" && echo "${init_ffmpeg_filter[@]}") \
				-vf $(echo "${filter_sw[@]}" | tr " " ",") \
				-t 60.0 \
				-f gif \
				"${S}/tools/perf/page_sets/trivial_sites/bunny.gif" )
			einfo "${cmd[@]}"
			"${cmd[@]}" || die "${cmd[@]}"
			# For animated gif alternatives:
			#sed -i -e "s|bunny.gif|bunny.gif|g" \
			#	"${S}/tools/perf/page_sets/trivial_sites/trivial_gif.html"
		fi

		# See also https://chromium.googlesource.com/chromium/src.git/+/refs/tags/94.0.4606.71/media/test/data/#media-test-data
		# https://chromium.googlesource.com/chromium/src.git/+/refs/tags/94.0.4606.71/tools/perf/page_sets/media_cases.py
		if use cr_pgo_trainers_media_desktop \
			|| use cr_pgo_trainers_media_mobile ; then
			einfo "Generating missing assets for the media.desktop or media.mobile benchmarks"
			local opus_encoding=( -c:a libopus )
			local vorbis_encoding=( -c:a libvorbis )
			local vp8_decoding=()
			local vp8_encoding=()
			local vp9_decoding=()
			local vp9_encoding=()

			# vp8, vorbis : bigbuck.webm, tulip2.webm
			# vp9, opus : ${CR_PGO_VIDEO0}

			# tulip2.webm is 1280x720 res, 2104 kb/s bitrate, 29.97 fps.  Audio bitrate is unknown.
			# ${CR_PGO_VIDEO0} is 3840x2160 res, 24124k bitrate, 59.94 fps.  Audio bitrate is unknown.

			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP8.*VAEntrypointVLD" \
				&& [[ -e /dev/dri/renderD128 ]] ; then
				vp8_decoding=( -hwaccel vaapi
					-hwaccel_output_format vaapi
					-hwaccel_device drm_render_node
					-filter_hw_device drm_render_node )
			fi
			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP9.*VAEntrypointVLD" \
				&& [[ -e /dev/dri/renderD128 ]] ; then
				vp9_decoding=( -hwaccel vaapi
					-hwaccel_output_format vaapi
					-hwaccel_device drm_render_node
					-filter_hw_device drm_render_node )
			fi

			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP8.*VAEntrypointEncSlice" \
				&& ffmpeg -hide_banner -encoders 2>/dev/null \
					| grep -q -F -e "vp8_vaapi" ; then
				vp8_encoding=( -c:v vp8_vaapi )
			else
				vp8_encoding=( -c:v libvpx )
			fi

			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP9.*VAEntrypointEncSlice" \
				&& ffmpeg -hide_banner -encoders 2>/dev/null \
					| grep -q -F -e "vp9_vaapi" ; then
				vp9_encoding=( -c:v vp9_vaapi )
			else
				vp9_encoding=( -c:v libvpx-vp9 )
			fi

			if use proprietary-codecs ; then
				local aac_encoding=( -codec:a aac )
				local h264_encoding=()
				local mp3_encoding=( -c:a libmp3lame )

				h264_baseline_profile=()
				h264_high_profile_4_0=()
				if use vaapi && vainfo 2>/dev/null \
					| grep -q -G -e "H264.*VAEntrypointEncSlice" \
					&& ffmpeg -hide_banner -encoders 2>/dev/null \
						| grep -q -F -e "h264_vaapi" ; then
					h264_encoding=( -c:v h264_vaapi )
					h264_baseline_profile=( -profile:v 578 )
					h264_high_profile_4_0=( -profile:v 100 -level:v 40 )
				elif has_version "media-video/ffmpeg[openh264]" ;then
					h264_encoding=( -c:v libopenh264 )
					h264_baseline_profile=( -profile:v 578 )
					h264_high_profile_4_0=( -profile:v 100 ) # no level
				fi

				# tulip2.webm -> tulip2.m4a
				cmd=( ffmpeg -i "${S}/media/test/data/tulip2.webm" \
					-vn \
					${aac_encoding[@]} \
					"${S}/tools/perf/page_sets/media_cases/tulip2.m4a" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"

				# tulip2.webm -> tulip2.mp3
				cmd=( ffmpeg -i "${S}/media/test/data/tulip2.webm" \
					-vn \
					${mp3_encoding[@]} \
					"${S}/tools/perf/page_sets/media_cases/tulip2.mp3" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"

				# tulip2.webm -> tulip2.mp4
				h264_filter_args=( -vf "format=nv12,hwupload" )
				cmd=( ffmpeg \
					${drm_render_node[@]} \
					${vp8_decoding[@]} \
					-i "${S}/media/test/data/tulip2.webm" \
					${h264_encoding[@]} \
					$(_is_vaapi_allowed "H264" && echo "${init_ffmpeg_filter[@]}") \
					$(_is_vaapi_allowed "H264" && echo "${h264_filter_args[@]}") \
					${h264_baseline_profile[@]} \
					${aac_encoding[@]} \
					"${S}/tools/perf/page_sets/media_cases/tulip2.mp4" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"

				# tulip2.webm -> aac_audio.mp4
				# Asset must be AAC-LC.
				aac_lc=( -profile:a aac_low )
				cmd=( ffmpeg -i "${S}/media/test/data/tulip2.webm" \
					-vn \
					${aac_encoding[@]} \
					${aac_lc[@]} \
					"${S}/tools/perf/page_sets/media_cases/aac_audio.mp4" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"

				# tulip2.webm -> h264_video.mp4
				# Asset must be h264, level 4, high profile
				# See tools/perf/page_sets/media_cases/mse.js
				h264_filter_args=( -vf "format=nv12,hwupload" )
				cmd=( ffmpeg \
					${drm_render_node[@]} \
					-i "${S}/media/test/data/tulip2.webm" \
					${h264_encoding[@]} \
					${h264_high_profile_4_0[@]} \
					$(_is_vaapi_allowed "H264" && echo "${init_ffmpeg_filter[@]}") \
					$(_is_vaapi_allowed "H264" && echo "${h264_filter_args[@]}") \
					-an \
					"${S}/tools/perf/page_sets/media_cases/h264_video.mp4" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"

				# ${CR_PGO_VIDEO0} -> video0_720p30fps.mp4
				# 1280 x 720 res ; must be 2 min
				if [[ -f "${ASSET_CACHE}/video0_720p30fps.mp4" \
					&& -f "${ASSET_CACHE}/video0_720p30fps.mp4.sha512" \
					&& $(cat "${ASSET_CACHE}/video0_720p30fps.mp4.sha512") \
						== $(sha512sum "${ASSET_CACHE}/video0_720p30fps.mp4" \
							| cut -f 1 -d " ") ]] ; then
					einfo "Using pregenerated and cached video0_720p30fps.mp4"
					cp -a "${ASSET_CACHE}/video0_720p30fps.mp4" \
						"${S}/tools/perf/page_sets/media_cases/video0_720p30fps.mp4" \
						|| die
				else
					filter_sw=()
					filter_hw=( $(_gen_vaapi_filter "H264") )
					if _is_hw_scaling_supported "H264" ; then
						filter_hw+=( "scale_vaapi=w=-1:h=720" )
					else
						filter_sw+=( "scale=w=-1:h=720" )
					fi
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp9_decoding[@]} \
						-i $(realpath "${CR_PGO_VIDEO0}") \
						${h264_encoding[@]} \
						$(_is_vaapi_allowed "H264" && echo "${init_ffmpeg_filter[@]}") \
						-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
							&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
							&& echo " ${filter_hw[@]}") | tr " " ",") \
						-maxrate 1485k -minrate 512k -b:v 1024k \
						-r 30 \
						${aac_encoding[@]} \
						-t 120.0 \
						"${S}/tools/perf/page_sets/media_cases/video0_720p30fps.mp4" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
					einfo "Saving work to ${ASSET_CACHE}/video0_720p30fps.mp4 for faster rebuilds."
					cp -a "${S}/tools/perf/page_sets/media_cases/video0_720p30fps.mp4" \
						"${ASSET_CACHE}/video0_720p30fps.mp4" || die
					sha512sum "${ASSET_CACHE}/video0_720p30fps.mp4" \
						| cut -f 1 -d " " > "${ASSET_CACHE}/video0_720p30fps.mp4.sha512" || die
				fi
				sed -i -e "s|foodmarket_720p30fps.mp4|video0_720p30fps.mp4|g" \
					"${S}/tools/perf/page_sets/media_cases.py" || die
			fi

			# tulip2.webm -> tulip2.ogg
			cmd=( ffmpeg -i "${S}/media/test/data/tulip2.webm" \
				-vn \
				${vorbis_encoding[@]} \
				"${S}/tools/perf/page_sets/media_cases/tulip2.ogg" )
			einfo "${cmd[@]}"
			"${cmd[@]}" || die "${cmd[@]}"

			# tulip2.webm -> tulip2.vp9.webm
			# Must be <= wifi bitrate.  U = 2.8Mbps upload, so A kbps for audio and V = ( U - A ) video max.
			# For no audio, then V = U for max bitrate.
			if [[ -f "${ASSET_CACHE}/tulip2.vp9.webm" \
				&& -f "${ASSET_CACHE}/tulip2.vp9.webm.sha512" \
				&& $(cat "${ASSET_CACHE}/tulip2.vp9.webm.sha512") \
					== $(sha512sum "${ASSET_CACHE}/tulip2.vp9.webm" \
						| cut -f 1 -d " ") ]] ; then
				einfo "Using pregenerated and cached tulip2.vp9.webm"
				cp -a "${ASSET_CACHE}/tulip2.vp9.webm" \
					"${S}/tools/perf/page_sets/media_cases/tulip2.vp9.webm" \
					|| die
			else
				if _is_vaapi_allowed "VP9" ; then
					# Likely only single pass supported
					# Quality is auto but based on other args.
					# https://trac.ffmpeg.org/wiki/Hardware/VAAPI mentions how vp9 quality is handled indirectly.
					vp9_filter_args=( -vf "format=nv12,hwupload" )
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp8_decoding[@]} \
						-i "${S}/media/test/data/tulip2.webm" \
						${vp9_encoding[@]} \
						$(_is_vaapi_allowed "VP9" && echo "${init_ffmpeg_filter[@]}") \
						$(_is_vaapi_allowed "VP9" && echo "${vp9_filter_args[@]}") \
						-maxrate 1485k -minrate 512k -b:v 1024k \
						${opus_encoding[@]} \
						"${S}/tools/perf/page_sets/media_cases/tulip2.vp9.webm" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
				else
					# See https://developers.google.com/media/vp9/settings/vod
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp8_decoding[@]} \
						-i "${S}/media/test/data/tulip2.webm" \
						${vp9_encoding[@]} \
						-maxrate 1485k -minrate 512k -b:v 1024k -crf 31 \
						${opus_encoding[@]} \
						"${S}/tools/perf/page_sets/media_cases/tulip2.vp9.webm" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
				fi
				einfo "Saving work to ${ASSET_CACHE}/tulip2.vp9.webm for faster rebuilds."
				cp -a "${S}/tools/perf/page_sets/media_cases/tulip2.vp9.webm" \
					"${ASSET_CACHE}/tulip2.vp9.webm" || die
				sha512sum "${ASSET_CACHE}/tulip2.vp9.webm" \
					| cut -f 1 -d " " > "${ASSET_CACHE}/tulip2.vp9.webm.sha512" || die
			fi

			# ${CR_PGO_VIDEO0} -> video0_1080p60fps_vp9.webm
			# 1920 x 1080 res ; must be 2 min
			if [[ -f "${ASSET_CACHE}/video0_1080p60fps_vp9.webm" \
				&& -f "${ASSET_CACHE}/video0_1080p60fps_vp9.webm.sha512" \
				&& $(cat "${ASSET_CACHE}/video0_1080p60fps_vp9.webm.sha512") \
					== $(sha512sum "${ASSET_CACHE}/video0_1080p60fps_vp9.webm" \
						| cut -f 1 -d " ") ]] ; then
				einfo "Using pregenerated and cached video0_1080p60fps_vp9.webm"
				cp -a "${ASSET_CACHE}/video0_1080p60fps_vp9.webm" \
					"${S}/tools/perf/page_sets/media_cases/video0_1080p60fps_vp9.webm" \
					|| die
			else
				if _is_vaapi_allowed "VP9" ; then
					# Likely only single pass supported
					filter_sw=()
					filter_hw=( $(_gen_vaapi_filter "VP9") )
					if _is_hw_scaling_supported "VP9" ; then
						filter_hw+=( "scale_vaapi=w=-1:h=1080" )
					else
						filter_sw+=( "scale=w=-1:h=1080" )
					fi
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp9_decoding[@]} \
						-i $(realpath "${CR_PGO_VIDEO0}") \
						${vp9_encoding[@]} \
						$(_is_vaapi_allowed "VP9" && echo "${init_ffmpeg_filter[@]}") \
						-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
							&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
							&& echo " ${filter_hw[@]}") | tr " " ",") \
						-maxrate 4350k -minrate 1500k -b:v 3000k \
						-r 60 \
						-t 120.0 \
						${opus_encoding[@]} \
						"${S}/tools/perf/page_sets/media_cases/video0_1080p60fps_vp9.webm" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
				else
					# See https://developers.google.com/media/vp9/settings/vod
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp9_decoding[@]} \
						-i $(realpath "${CR_PGO_VIDEO0}") \
						${vp9_encoding[@]} \
						-vf scale=w=-1:h=1080 \
						-maxrate 4350k -minrate 1500k -b:v 3000k -crf 31 \
						-r 60 \
						-t 120.0 \
						${opus_encoding[@]} \
						"${S}/tools/perf/page_sets/media_cases/video0_1080p60fps_vp9.webm" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
				fi
				einfo "Saving work to ${ASSET_CACHE}/video0_1080p60fps_vp9.webm for faster rebuilds."
				cp -a "${S}/tools/perf/page_sets/media_cases/video0_1080p60fps_vp9.webm" \
					"${ASSET_CACHE}/video0_1080p60fps_vp9.webm" || die
				sha512sum "${ASSET_CACHE}/video0_1080p60fps_vp9.webm" \
					| cut -f 1 -d " " > "${ASSET_CACHE}/video0_1080p60fps_vp9.webm.sha512" || die
			fi
			sed -i -e "s|boat_1080p60fps_vp9.webm|animal_1080p60fps_vp9.webm|g" \
				"${S}/tools/perf/page_sets/media_cases.py" || die
		fi

		if use cr_pgo_trainers_media_desktop ; then
			einfo "Generating missing assets for the media.desktop benchmark"
			local av1_encoding=()
			local vp8_decoding=()
			local vp8_encoding=()
			local vp9_decoding=()
			local vp9_encoding=()
			local vorbis_encoding=( -c:a libvorbis )

			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP8.*VAEntrypointVLD" \
				&& [[ -e /dev/dri/renderD128 ]] ; then
				vp8_decoding=( -hwaccel vaapi
					-hwaccel_output_format vaapi
					-hwaccel_device drm_render_node
					-filter_hw_device drm_render_node )
			fi
			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP9.*VAEntrypointVLD" \
				&& [[ -e /dev/dri/renderD128 ]] ; then
				vp9_decoding=( -hwaccel vaapi
					-hwaccel_output_format vaapi
					-hwaccel_device drm_render_node
					-filter_hw_device drm_render_node )
			fi

			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "AV1.*VAEntrypointEncSlice" \
				&& ffmpeg -hide_banner -encoders 2>/dev/null \
					| grep -q -F -e "av1_vaapi" ; then
				av1_encoding=( -c:v av1_vaapi )
			elif has_version "media-video/ffmpeg[libaom]" ; then
				ncpus=$(lscpu \
					| grep -E -e "^CPU\(s\):.*" \
					| grep -E -o -e "[0-9]+")
				nthreads_per_core=$(lscpu \
					| grep -E -e "^Thread\(s\) per core:.*" \
					| grep -E -o -e "[0-9]+")
				# The defaults are slow.  Test?
				local tot_tpc=$(( ${ncpus} * ${nthreads_per_core} ))
				if (( ${ncpus} == 1 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 0
						-tile-rows 0 -threads 1 )
				elif (( ${ncpus} == 2 && ${nthreads_per_core} > 1 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 0
						-tile-rows 1 -threads ${tpc}
						-row-mt 1 )
				elif (( ${ncpus} == 2 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 0
						-tile-rows 1 -threads ${ncpus} )
				elif (( ${ncpus} == 3 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 0
						-tile-rows 1 -threads ${ncpus}
						-row-mt 1 )
				elif (( ${ncpus} == 4 && ${nthreads_per_core} > 1 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 1
						-tile-rows 1 -threads ${tot_tpc}
						-row-mt 1 )
				elif (( ${ncpus} == 4 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 1
						-tile-rows 1 -threads ${ncpus} )
				elif (( ${ncpus} == 6 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 1
						-tile-rows 1 -threads ${ncpus}
						-row-mt 1 )
				elif (( ${ncpus} == 8 && ${nthreads_per_core} > 1 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 1
						-tile-rows 2 -threads ${tot_tpc}
						-row-mt 1 )
				elif (( ${ncpus} == 8 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 1
						-tile-rows 2 -threads ${ncpus} )
				elif (( ${ncpus} == 16 && ${nthreads_per_core} > 1 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 2
						-tile-rows 2 -threads ${tot_tpc}
						-row-mt 1 )
				elif (( ${ncpus} == 16 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 2
						-tile-rows 2 -threads ${ncpus} )
				elif (( ${nthreads_per_core} > 1 )) ; then
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 2
						-tile-rows 2 -threads ${tot_tpc}
						-row-mt 1 )
				else
					av1_encoding=( -c:v libaom-av1
						-cpu-used 8 -tile-columns 2
						-tile-rows 2 -threads ${ncpus}
						-row-mt 1 )
				fi
			fi

			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP8.*VAEntrypointEncSlice" \
				&& ffmpeg -hide_banner -encoders 2>/dev/null \
					| grep -q -F -e "vp8_vaapi" ; then
				vp8_encoding=( -c:v vp8_vaapi )
			else
				vp8_encoding=( -c:v libvpx )
			fi

			if use vaapi && vainfo 2>/dev/null \
				| grep -q -G -e "VP9.*VAEntrypointEncSlice" \
				&& ffmpeg -hide_banner -encoders 2>/dev/null \
					| grep -q -F -e "vp9_vaapi" ; then
				vp9_encoding=( -c:v vp9_vaapi )
			else
				vp9_encoding=( -c:v libvpx-vp9 )
			fi

			if use proprietary-codecs ; then
				local aac_encoding=( -codec:a aac )
				local h264_encoding=()

				h264_baseline_profile=()
				if use vaapi && vainfo 2>/dev/null \
					| grep -q -G -e "H264.*VAEntrypointEncSlice" \
					&& ffmpeg -hide_banner -encoders 2>/dev/null \
						| grep -q -F -e "h264_vaapi" ; then
					h264_encoding=( -c:v h264_vaapi )
					h264_baseline_profile=( -profile:v 578 )
				elif has_version "media-video/ffmpeg[openh264]" ;then
					h264_encoding=( -c:v libopenh264 )
					h264_baseline_profile=( -profile:v 578 )
				fi

				# tulip2.webm -> crowd1080.mp4
				if [[ -f "${ASSET_CACHE}/crowd1080.mp4" \
					&& -f "${ASSET_CACHE}/crowd1080.mp4.sha512" \
					&& $(cat "${ASSET_CACHE}/crowd1080.mp4.sha512") \
						== $(sha512sum "${ASSET_CACHE}/crowd1080.mp4" \
							| cut -f 1 -d " ") ]] ; then
					einfo "Using pregenerated and cached crowd1080.mp4"
					cp -a "${ASSET_CACHE}/crowd1080.mp4" \
						"${S}/tools/perf/page_sets/media_cases/crowd1080.mp4" \
						|| die
				else
					filter_sw=( "minterpolate=vsbmc=1" )
					filter_hw=( $(_gen_vaapi_filter "H264") )
					if _is_hw_scaling_supported "H264" ; then
						filter_hw+=( "scale_vaapi=w=-1:h=1080" )
					else
						filter_sw+=( "scale=w=-1:h=1080" )
					fi
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp8_decoding[@]} \
						-i "${S}/media/test/data/tulip2.webm" \
						${h264_encoding[@]} \
						$(_is_vaapi_allowed "H264" && echo "${init_ffmpeg_filter[@]}") \
						-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
							&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
							&& echo " ${filter_hw[@]}") | tr " " ",") \
						-maxrate 4350k -minrate 1500k -b:v 3000k \
						${aac_encoding[@]} \
						-r 50 \
						"${S}/tools/perf/page_sets/media_cases/crowd1080.mp4" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
					einfo "Saving work to ${ASSET_CACHE}/crowd1080.mp4 for faster rebuilds."
					cp -a "${S}/tools/perf/page_sets/media_cases/crowd1080.mp4" \
						"${ASSET_CACHE}/crowd1080.mp4" || die
					sha512sum "${ASSET_CACHE}/crowd1080.mp4" \
						| cut -f 1 -d " " > "${ASSET_CACHE}/crowd1080.mp4.sha512" || die
				fi

				# ${CR_PGO_VIDEO0} -> garden2_10s.mp4
				# 3840 x 2160 resolution
				if [[ -f "${ASSET_CACHE}/video0_10s.mp4" \
					&& -f "${ASSET_CACHE}/video0_10s.mp4.sha512" \
					&& $(cat "${ASSET_CACHE}/video0_10s.mp4.sha512") \
						== $(sha512sum "${ASSET_CACHE}/video0_10s.mp4" \
							| cut -f 1 -d " ") ]] ; then
					einfo "Using pregenerated and cached video0_10s.mp4"
					cp -a "${ASSET_CACHE}/video0_10s.mp4" \
						"${S}/tools/perf/page_sets/media_cases/video0_10s.mp4" \
						|| die
				else
					filter_sw=()
					filter_hw=( $(_gen_vaapi_filter "H264") )
					if _is_hw_scaling_supported "H264" ; then
						filter_hw+=( "scale_vaapi=w=-1:h=2160" )
					else
						filter_sw+=( "scale=w=-1:h=2160" )
					fi
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp9_decoding[@]} \
						-i $(realpath "${CR_PGO_VIDEO0}") \
						${h264_encoding[@]} \
						$(_is_vaapi_allowed "H264" && echo "${init_ffmpeg_filter[@]}") \
						-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
							&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
							&& echo " ${filter_hw[@]}") | tr " " ",") \
						${aac_encoding[@]} \
						-t 10 \
						"${S}/tools/perf/page_sets/media_cases/video0_10s.mp4" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
					einfo "Saving work to ${ASSET_CACHE}/video0_10s.mp4 for faster rebuilds."
					cp -a "${S}/tools/perf/page_sets/media_cases/video0_10s.mp4" \
						"${ASSET_CACHE}/video0_10s.mp4" || die
					sha512sum "${ASSET_CACHE}/video0_10s.mp4" \
						| cut -f 1 -d " " > "${ASSET_CACHE}/video0_10s.mp4.sha512" || die
				fi
				sed -i -e "s|garden2_10s.mp4|video0_10s.mp4|g" \
					"${S}/tools/perf/page_sets/media_cases.py" || die
			fi

			# tulip2.webm -> crowd1080.webm
			if [[ -f "${ASSET_CACHE}/crowd1080.webm" \
				&& -f "${ASSET_CACHE}/crowd1080.webm.sha512" \
				&& $(cat "${ASSET_CACHE}/crowd1080.webm.sha512") \
					== $(sha512sum "${ASSET_CACHE}/crowd1080.webm" \
						| cut -f 1 -d " ") ]] ; then
				einfo "Using pregenerated and cached crowd1080.webm"
				cp -a "${ASSET_CACHE}/crowd1080.webm" \
					"${S}/tools/perf/page_sets/media_cases/crowd1080.webm" \
					|| die
			else
				filter_sw=( "minterpolate=vsbmc=1" )
				filter_hw=( $(_gen_vaapi_filter "VP8") )
				if _is_hw_scaling_supported "VP8" ; then
					filter_hw+=( "scale_vaapi=w=-1:h=1080" )
				else
					filter_sw+=( "scale=w=-1:h=1080" )
				fi
				cmd=( ffmpeg \
					${drm_render_node[@]} \
					${vp8_decoding[@]} \
					-i "${S}/media/test/data/tulip2.webm" \
					${vp8_encoding[@]} \
					$(_is_vaapi_allowed "VP8" && echo "${init_ffmpeg_filter[@]}") \
					-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
						&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
						&& echo " ${filter_hw[@]}") | tr " " ",") \
					-maxrate 4350k -minrate 1500k -b:v 3000k -crf 31 \
					${vorbis_encoding[@]} \
					-r 50 \
					"${S}/tools/perf/page_sets/media_cases/crowd1080.webm" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"
				einfo "Saving work to ${ASSET_CACHE}/crowd1080.webm for faster rebuilds."
				cp -a "${S}/tools/perf/page_sets/media_cases/crowd1080.webm" \
					"${ASSET_CACHE}/crowd1080.webm" || die
				sha512sum "${ASSET_CACHE}/crowd1080.webm" \
					| cut -f 1 -d " " > "${ASSET_CACHE}/crowd1080.webm.sha512" || die
			fi

			# tulip2.webm -> crowd1080_vp9.webm
			if [[ -f "${ASSET_CACHE}/crowd1080_vp9.webm" \
				&& -f "${ASSET_CACHE}/crowd1080_vp9.webm.sha512" \
				&& $(cat "${ASSET_CACHE}/crowd1080_vp9.webm.sha512") \
					== $(sha512sum "${ASSET_CACHE}/crowd1080_vp9.webm" \
						| cut -f 1 -d " ") ]] ; then
				einfo "Using pregenerated and cached crowd1080_vp9.webm"
				cp -a "${ASSET_CACHE}/crowd1080_vp9.webm" \
					"${S}/tools/perf/page_sets/media_cases/crowd1080_vp9.webm" \
					|| die
			else
				if _is_vaapi_allowed "VP9" ; then
					filter_sw=( "minterpolate=vsbmc=1" )
					filter_hw=( $(_gen_vaapi_filter "VP9") )
					if _is_hw_scaling_supported "VP9" ; then
						filter_hw+=( "scale_vaapi=w=-1:h=1080" )
					else
						filter_sw+=( "scale=w=-1:h=1080" )
					fi
					# Likely only single pass supported
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp8_decoding[@]} \
						-i "${S}/media/test/data/tulip2.webm" \
						${vp9_encoding[@]} \
						$(_is_vaapi_allowed "VP9" && echo "${init_ffmpeg_filter[@]}") \
						-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
							&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
							&& echo " ${filter_hw[@]}") | tr " " ",") \
						-maxrate 4350k -minrate 1500k -b:v 3000k \
						-r 50 \
						"${S}/tools/perf/page_sets/media_cases/crowd1080_vp9.webm" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
				else
					# See https://developers.google.com/media/vp9/settings/vod
					cmd=( ffmpeg \
						${drm_render_node[@]} \
						${vp8_decoding[@]} \
						-i "${S}/media/test/data/tulip2.webm" \
						${vp9_encoding[@]} \
						-vf "minterpolate=vsbmc=1" \
						-maxrate 4350k -minrate 1500k -b:v 3000k -crf 31 \
						-r 50 \
						"${S}/tools/perf/page_sets/media_cases/crowd1080_vp9.webm" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
				fi
				einfo "Saving work to ${ASSET_CACHE}/crowd1080_vp9.webm for faster rebuilds."
				cp -a "${S}/tools/perf/page_sets/media_cases/crowd1080_vp9.webm" \
					"${ASSET_CACHE}/crowd1080_vp9.webm" || die
				sha512sum "${ASSET_CACHE}/crowd1080_vp9.webm" \
					| cut -f 1 -d " " > "${ASSET_CACHE}/crowd1080_vp9.webm.sha512" || die
			fi

			# ${CR_PGO_VIDEO0} -> garden2_10s.webm
			# 3840 x 2160 resolution
			if [[ -f "${ASSET_CACHE}/video0_10s.webm" \
				&& -f "${ASSET_CACHE}/video0_10s.webm.sha512" \
				&& $(cat "${ASSET_CACHE}/video0_10s.webm.sha512") \
					== $(sha512sum "${ASSET_CACHE}/video0_10s.webm" \
						| cut -f 1 -d " ") ]] ; then
				einfo "Using pregenerated and cached video0_10s.webm"
				cp -a "${ASSET_CACHE}/video0_10s.webm" \
					"${S}/tools/perf/page_sets/media_cases/video0_10s.webm" \
					|| die
			else
				filter_sw=()
				filter_hw=( $(_gen_vaapi_filter "VP8") )
				if _is_hw_scaling_supported "VP8" ; then
					filter_hw+=( "scale_vaapi=w=-1:h=2160" )
				else
					filter_sw+=( "scale=w=-1:h=2160" )
				fi
				cmd=( ffmpeg \
					${drm_render_node[@]} \
					${vp9_decoding[@]} \
					-i $(realpath "${CR_PGO_VIDEO0}") \
					${vp8_encoding[@]} \
					$(_is_vaapi_allowed "VP8" && echo "${init_ffmpeg_filter[@]}") \
					-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
						&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
						&& echo " ${filter_hw[@]}") | tr " " ",") \
					${vorbis_encoding[@]} \
					-t 10 \
					"${S}/tools/perf/page_sets/media_cases/video0_10s.webm" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"
				einfo "Saving work to ${ASSET_CACHE}/video0_10s.webm for faster rebuilds."
				cp -a "${S}/tools/perf/page_sets/media_cases/video0_10s.webm" \
					"${ASSET_CACHE}/video0_10s.webm" || die
				sha512sum "${ASSET_CACHE}/video0_10s.webm" \
					| cut -f 1 -d " " > "${ASSET_CACHE}/video0_10s.webm.sha512" || die
			fi
			sed -i -e "s|garden2_10s.webm|video0_10s.webm|g" \
				"${S}/tools/perf/page_sets/media_cases.py" || die

			# ffmpeg -> smpte_3840x2160_60fps_vp9.webm
			# 3840 x 2160 resolution ; 120s required
			if [[ -f "${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm" \
				&& -f "${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm.sha512" \
				&& $(cat "${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm.sha512") \
					== $(sha512sum "${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm" \
						| cut -f 1 -d " ") ]] ; then
				einfo "Using pregenerated and cached smpte_3840x2160_60fps_vp9.webm"
				cp -a "${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm" \
					"${S}/tools/perf/page_sets/media_cases/smpte_3840x2160_60fps_vp9.webm" \
					|| die
			else
				einfo "Generating test video.  Estimated completion time: several min to hour(s)."
				vp9_filter_args=( -vf "format=nv12,hwupload" )
				libvpx_vp9_args=( -crf 31 )
				cmd=( ffmpeg \
					${drm_render_node[@]} \
					-f lavfi -i testsrc=duration=120:size=3840x2160:rate=60 \
					${vp9_encoding[@]} \
					$(_is_vaapi_allowed "VP9" && echo "${init_ffmpeg_filter[@]}") \
					$(_is_vaapi_allowed "VP9" && echo "${vp9_filter_args[@]}") \
					-maxrate 26100k -minrate 9000k -b:v 18000k \
					$(_is_vaapi_allowed "VP9" || echo "${libvpx_vp9_args[@]}") \
					-an \
					"${S}/tools/perf/page_sets/media_cases/smpte_3840x2160_60fps_vp9.webm" )
				einfo "${cmd[@]}"
				"${cmd[@]}" || die "${cmd[@]}"
				einfo "Saving work to ${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm for faster rebuilds."
				cp -a "${S}/tools/perf/page_sets/media_cases/smpte_3840x2160_60fps_vp9.webm" \
					"${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm" || die
				sha512sum "${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm" \
					| cut -f 1 -d " " > "${ASSET_CACHE}/smpte_3840x2160_60fps_vp9.webm.sha512" || die
			fi

			# tulip2.webm -> tulip0.av1.mp4
			# Must be 8 bit AV1
			# An alternative exist (bear in the media/test/data) folder,
			# but it was decided to stick to the tulip to match upstream testing.
			if [[ -f "${ASSET_CACHE}/tulip0.av1.mp4" \
				&& -f "${ASSET_CACHE}/tulip0.av1.mp4.sha512" \
				&& $(cat "${ASSET_CACHE}/tulip0.av1.mp4.sha512") \
					== $(sha512sum "${ASSET_CACHE}/tulip0.av1.mp4" \
						| cut -f 1 -d " ") ]] ; then
				einfo "Using pregenerated and cached tulip0.av1.mp4"
				cp -a "${ASSET_CACHE}/tulip0.av1.mp4" \
					"${S}/tools/perf/page_sets/media_cases/tulip0.av1.mp4" \
					|| die
			else
				filter_sw=( format=yuv420p )
				filter_hw=( $(_gen_vaapi_filter "AV1") )
				cmd=( ffmpeg \
					${drm_render_node[@]} \
					${vp8_decoding[@]} \
					-i "${S}/media/test/data/tulip2.webm" \
					${av1_encoding[@]} \
					$(_is_vaapi_allowed "AV1" && echo "${init_ffmpeg_filter[@]}") \
					-vf $(echo $((( ${#filter_sw[@]} > 0 )) \
						&& echo " ${filter_sw[@]}")$((( ${#filter_hw[@]} > 0 )) \
						&& echo " ${filter_hw[@]}") | tr " " ",") \
					-an \
					"${S}/tools/perf/page_sets/media_cases/tulip0.av1.mp4" )
					einfo "${cmd[@]}"
					"${cmd[@]}" || die "${cmd[@]}"
				einfo "Saving work to ${ASSET_CACHE}/tulip0.av1.mp4 for faster rebuilds."
				cp -a "${S}/tools/perf/page_sets/media_cases/tulip0.av1.mp4" \
					"${ASSET_CACHE}/tulip0.av1.mp4" || die
				sha512sum "${ASSET_CACHE}/tulip0.av1.mp4" \
					| cut -f 1 -d " " > "${ASSET_CACHE}/tulip0.av1.mp4.sha512" || die
			fi
		fi

		for u in ${remote_access_use[@]} ; do
			# This section is still unfinished
			# TODO: Still categorizing benchmarks if local copy
			# or network access access is required
			if [[ "${u}" =~ "blink_perf" \
				|| "${u}" =~ "dummy_benchmark" \
				|| "${u}" =~ "memory_desktop" \
				|| "${u}" =~ "speedometer2" \
				|| "${u}" =~ "webrtc" \
				]] ; then
				:; # Skip if local copy
			elif has network-sandbox $FEATURES ; then
				# -network-sandbox requirement applies to:
				# dromaeo
				# jetstream
				# jetstream2
				# kraken
				# octane
				# power.mobile
				# speedometer
				# speedometer-future
				# system_health_pcscan
				# tab_switching_typical_25
				# wasmpspdfkit
eerror
eerror "The ${u} USE flag requires FEATURES=\"-network-sandbox\" to be added as"
eerror "a per-package envvar to allowed Internet access to a website in order to"
eerror "perform benchmarks in the src_compile() phase."
eerror
				die
			fi
		done
		# Backtrack tools/perf/benchmark.csv to find the USE flag
		# All sites in remote_access_use assume real time retrieval.
		# TODO: check if all relevant USE flags added:
		local remote_access_use=(
			cr_pgo_trainers_desktop_ui
			cr_pgo_trainers_loading_desktop
			cr_pgo_trainers_loading_mobile
			cr_pgo_trainers_power_mobile
			cr_pgo_trainers_rasterize_and_record_micro_top_25
			cr_pgo_trainers_rendering_mobile
			cr_pgo_trainers_system_health_common_desktop
			cr_pgo_trainers_system_health_common_mobile
			cr_pgo_trainers_system_health_memory_desktop
			cr_pgo_trainers_system_health_memory_mobile
			cr_pgo_trainers_system_health_pcscan
			cr_pgo_trainers_tab_switching_typical_25
			cr_pgo_trainers_unscheduled_loading_mbi
			cr_pgo_trainers_unscheduled_v8_loading_desktop
			cr_pgo_trainers_v8_runtime_stats_top_25
		)
		local warned=0
ewarn
ewarn "Discovered URIs for external access for PGO trainers:"
ewarn
		echo "http://dromaeo.com?"{'dom-attr','dom-modify','dom-query','dom-traverse'} \
			> "${T}/found_uris" || die
		( grep -Pzo -r -e "URL_LIST = \[[^\]]+\]" \
			"${S}/tools/perf/page_sets" || die ) \
			| tr "\0" "\n" \
			| sed -e "s|.*URL_LIST =|URL_LIST =|g" \
				-e "\|URL_LIST = \[DOWNLOAD_URL\]|d" \
			>> "${T}/found_uris" || die
		( grep  -Pzo -r -e "(urls_list|ads_urls_list) = \[\n([^\]]*\n)+" \
			"${S}/tools/perf" || die ) \
			| sed -e "s|/.*.py:||g" \
			>> "${T}/found_uris" || die
		( grep -Pzo -r -e "URL = ([(][^)]+|'[^']+)" \
			"${S}/tools/perf/page_sets" || die ) \
			| tr "\0" "\n" \
			| sed -e "s|.*URL =|URL =|g" \
			>> "${T}/found_uris" || die
		( grep -Pzo -r -e "AddStor(ies|y)\((((.*)(\[|,)\n(.*#.*\n)*)+|(.*#.*\n)|([^']*\n.*http.*\n)|(.*http.*)) " \
			"${S}/tools/perf/" || die ) \
			| tr "\0" "\n" \
			| sed -e "s|.*AddStories||g" \
			| sed -e "s|.*.py:AddStory||"
			>> "${T}/found_uris" || die
		cat "${T}/found_uris" || die
ewarn
ewarn "A more comprehensive list of external URIs to be accessed that are"
ewarn "possibly used by some PGO trainers can be read.  You can be read this"
ewarn "info by scrolling up with ctrl + page up or by doing the following in"
ewarn "another terminal:"
ewarn
ewarn "  \`cat ${T}/found_uris\`"
ewarn
ewarn "Some may or may not be relevant depending on the USE flags used."
ewarn
		local accepted_use_list=()
		for u in ${remote_access_use[@]} ; do
			if use "${u}" ; then
				accepted_use_list+=( ${u} )
				warned=1
			fi
		done
		if (( ${warned} == 1 )) ; then
ewarn
ewarn "The following affected USE flags were consented for access and use of"
ewarn "the web for PGO trainers:"
ewarn
for u in ${accepted_use_list[@]} ; do
ewarn "  ${u}"
done
ewarn
ewarn "The affected USE flag(s) may access external sites with possibly"
ewarn "untrusted user contributed data when using PGO profile generation and"
ewarn "may need site terms of use to be reviewed for acceptable use.  They also"
ewarn "may access news, governmental, political, or corporate sites.  They may"
ewarn "access or reference unfree trademarks and content."
ewarn
ewarn "You have 180 seconds to remove this USE flag if you disagree with such"
ewarn "access.  You may cancel and make changes by pressing ctrl + c."
ewarn
			sleep 180
		fi
	fi

	(( ${NABIS} > 1 )) \
		&& multilib_copy_sources
}

_configure_pgx() {
	local chost=$(get_abi_CHOST ${ABI})
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	if use pgo-full ; then
		for f in $(grep -l -F -r -e "/opt/chromium/chrome_sandbox" testing) ; do
			einfo "Changing hardcoded /opt/chromium/chrome_sandbox -> ${BUILD_DIR}/out/Release/chrome_sandbox for ${f}"
			sed -i -e "s|/opt/chromium/chrome_sandbox|${BUILD_DIR}/out/Release/chrome_sandbox|" \
				"${f}" || die
		done
	fi

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

	if use clang ; then
		# See build/toolchain/linux/unbundle/BUILD.gn for allowed overridable envvars.
		# See build/toolchain/gcc_toolchain.gni#L657 for consistency.
		export CC="clang $(get_abi_CFLAGS ${ABI})"
		export CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		export AR=llvm-ar # required for LTO
		export NM=llvm-nm
		export READELF=llvm-readelf
		export STRIP=llvm-strip
		strip-unsupported-flags
		if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
			die "llvm-ar is unreachable"
		fi
	else
		einfo "Forcing GCC"
		export CC="gcc $(get_abi_CFLAGS ${ABI})"
		export CXX="g++ $(get_abi_CFLAGS ${ABI})"
		export AR=ar
		export NM=nm
		export READELF=readelf
		export STRIP=strip
		export LD=ld.bfd
	fi

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
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

# Debug symbols level 2 is still on when official is on even though is_debug=false:
# See https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/compiler/compiler.gni#L276
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
	elif use tcmalloc ; then
		myconf_gn+=" use_allocator=\"tcmalloc\""
	else
		myconf_gn+=" use_allocator=\"none\""
	fi

	# Use system-provided libraries.
	# TODO: freetype -- remove sources (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_libsrtp (bug #459932).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_ssl (http://crbug.com/58087).
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
		libpng
		libwebp
		zlib
	)
	if use system-ffmpeg ; then
		gn_system_libraries+=( ffmpeg opus )
	fi
	if use system-icu ; then
		gn_system_libraries+=( icu )
	fi
	if use system-libstdcxx ; then
		# unbundle only without libc++, because libc++ is not fully ABI compatible with libstdc++
		gn_system_libraries+=( libxml )
		gn_system_libraries+=( libxslt )
		gn_system_libraries+=( re2 )
		gn_system_libraries+=( snappy )
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
ewarn "Unbundling libs and disabling hardening (CFI, SSP, noexecstack, Full RELRO)."
ewarn
			build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" || die
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
	myconf_gn+=" use_cups=$(usex cups true false)"
	myconf_gn+=" use_kerberos=$(usex kerberos true false)"
	myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"
	myconf_gn+=" use_vaapi=$(usex vaapi true false)"
	myconf_gn+=" rtc_use_pipewire=$(usex screencast true false) rtc_pipewire_version=\"0.3\""

	# TODO: link_pulseaudio=true for GN.

	# Never use bundled gold binary. Disable gold linker flags for now.
	myconf_gn+=" use_gold=false use_sysroot=false"
	# Do not use bundled clang.
	# Trying to use gold results in linker crash.
	if use official && ( use cfi-cast || use cfi-icall || use cfi-vcall ) || use bundled-libcxx ; then
		# Must be built as static for cfi* to work properly.
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

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info. The OAuth2 credentials, however, have been left out.
	# Those OAuth2 credentials have been broken for quite some time anyway.
	# Instead we apply a patch to use the --oauth2-client-id= and
	# --oauth2-client-secret= switches for setting GOOGLE_DEFAULT_CLIENT_ID and
	# GOOGLE_DEFAULT_CLIENT_SECRET at runtime. This allows signing into
	# Chromium without baked-in values.
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	local myarch="$(tc-arch)"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags ; then
		replace-flags "-Os" "-O2"
		strip-flags

		# Debug info section overflows without component build
		# Prevent linker from running out of address space, bug #471810 .
		if ! use component-build || use x86 ; then
			filter-flags "-g*"
		fi

		# Prevent libvpx build failures. Bug 530248, 544702, 546984.
		if [[ ${myarch} == amd64 || ${myarch} == x86 ]] ; then
			filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 -mno-avx -mno-avx2 -mno-fma -mno-fma4
		fi
	fi

	if use system-libcxx ; then
		append-flags -stdlib=libc++
		append-ldflags -stdlib=libc++
	fi

	if [[ $myarch = amd64 ]] ; then
		myconf_gn+=" target_cpu=\"x64\""
		ffmpeg_target_arch=x64
	elif [[ $myarch = x86 ]] ; then
		myconf_gn+=" target_cpu=\"x86\""
		ffmpeg_target_arch=ia32

		# This is normally defined by compiler_cpu_abi in
		# build/config/compiler/BUILD.gn, but we patch that part out.
		append-flags -msse2 -mfpmath=sse -mmmx
	elif [[ $myarch = arm64 ]] ; then
		myconf_gn+=" target_cpu=\"arm64\""
		ffmpeg_target_arch=arm64
	elif [[ $myarch = arm ]] ; then
		myconf_gn+=" target_cpu=\"arm\""
		ffmpeg_target_arch=$(usex cpu_flags_arm_neon arm-neon arm)
	elif [[ $myarch = ppc64 ]] ; then
		myconf_gn+=" target_cpu=\"ppc64\""
		ffmpeg_target_arch=ppc64
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	local target_cpu=""
	case "${ABI}" in
		amd64*|x64*)
			target_cpu="x64"
			;;
		arm|n32|n64|o32)
			target_cpu="${chost%%-*}"
			;;
		arm64|ppc|ppc64|s390*)
			target_cpu="${ABI}"
			;;
		ppc_aix,ppc_macos)
			target_cpu="ppc"
			;;
		x86*)
			target_cpu="x86"
			;;
		*)
			einfo "${ABI} is not supported"
			;;
	esac

	myconf_gn+=" target_cpu=\"${target_cpu}\""
	myconf_gn+=" v8_current_cpu=\"${target_cpu}\""
	myconf_gn+=" current_cpu=\"${target_cpu}\""
	myconf_gn+=" host_cpu=\"${target_cpu}\""
	myconf_gyp+=" -Dtarget_arch=${target_arch}"

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

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
		einfo "Configuring bundled ffmpeg..."
		pushd third_party/ffmpeg > /dev/null || die
		chromium/scripts/build_ffmpeg.py linux ${ffmpeg_target_arch} \
			--branding ${ffmpeg_branding} -- ${build_ffmpeg_args} || die
		chromium/scripts/copy_config.sh || die
		chromium/scripts/generate_gn.py || die
		popd > /dev/null || die
	fi

	# Chromium relies on this, but was disabled in >=clang-10, crbug.com/1042470
	append-cxxflags $(test-flags-CXX -flax-vector-conversions=all)

	# Disable unknown warning message from clang.
	tc-is-clang && append-flags -Wno-unknown-warning-option

	# Explicitly disable ICU data file support for system-icu builds.
	if use system-icu ; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	# Enable ozone wayland and/or headless support
	myconf_gn+=" use_ozone=true ozone_auto_platforms=false"
	myconf_gn+=" ozone_platform_headless=true"
	if use wayland || use headless ; then
		if use headless ; then
			myconf_gn+=" ozone_platform=\"headless\""
			myconf_gn+=" use_x11=false"
		else
			myconf_gn+=" ozone_platform_wayland=true"
			myconf_gn+=" use_system_libdrm=true"
			myconf_gn+=" use_system_minigbm=true"
			myconf_gn+=" use_xkbcommon=true"
			myconf_gn+=" ozone_platform=\"wayland\""
		fi
	fi

	# Enable official builds
	myconf_gn+=" is_official_build=$(usex official true false)"
	if use clang || tc-is-clang ; then
		ewarn "Using ThinLTO"
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

# See https://github.com/chromium/chromium/blob/94.0.4606.71/build/config/sanitizers/BUILD.gn#L196
	if use cfi-vcall ; then
		myconf_gn+=" is_cfi=true"
	else
		myconf_gn+=" is_cfi=false"
	fi

# See https://github.com/chromium/chromium/blob/94.0.4606.71/tools/mb/mb_config.pyl#L2950
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

# See also build/config/compiler/pgo/BUILD.gn#L71 for PGO flags.
# See also https://github.com/chromium/chromium/blob/94.0.4606.71/docs/pgo.md
# profile-instr-use is clang which that file assumes but gcc doesn't have.
	if use pgo-full ; then
		myconf_gn+=" chrome_pgo_phase=${PGO_PHASE}"
		mkdir -p "${BUILD_DIR}/chrome/build/pgo_profiles" || die
		[[ "${PGO_PHASE}" == "2" ]] && \
		myconf_gn+=" pgo_data_path=\"${BUILD_DIR}/chrome/build/pgo_profiles/custom.profdata\""
	elif use pgo && tc-is-clang && ver_test $(clang-version) -ge 11 ; then
		# The profile data is already shipped so use it.
		# PGO profile location: chrome/build/pgo_profiles/chrome-linux-*.profdata
		myconf_gn+=" chrome_pgo_phase=2"
	else
		# The pregenerated profiles are not GCC compatible.
		myconf_gn+=" chrome_pgo_phase=0"
	fi

	einfo "Configuring Chromium..."
	set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
	echo "$@"
	"$@" || die
}

_build() {
	local ninja_into="${1}"
	local target_id="${2}"
	local pax_path="${3}"
	local file_name=$(basename "${2}")

	einfo "Building ${file_name}"
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
			einfo "Cleaning out build"
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

_run_training_suite() {
# See also https://github.com/chromium/chromium/blob/94.0.4606.71/docs/pgo.md
# https://github.com/chromium/chromium/blob/94.0.4606.71/testing/buildbot/generate_buildbot_json.py
# https://github.com/chromium/chromium/commit/8acfdce99c84fbc35ad259692ac083a9ea18392c
# tools/perf/contrib/vr_benchmarks
	export PYTHONPATH=$(_get_pythonpath)
	einfo "PYTHONPATH=${PYTHONPATH}"
	local benchmarks_allowed=()
	# TODO add CONTRIB_BENCHMARKS
	for x in ${OFFICIAL_BENCHMARKS[@]} ; do
		t="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		if use "cr_pgo_trainers_${t}" ; then
			if [[ -d "${T}/${x}" ]] ; then
				# Clear for different ABI builds
				rm -vrf "${T}/${x}" || die
			fi
			benchmarks_allowed+=( ${x} )
		fi
	done
	local benchmarks=$(echo "${benchmarks_allowed[@]}" | tr " " ",")
	export CHROME_SANDBOX_ENV="${BUILD_DIR}/out/Release/chrome_sandbox" # For testing/test_env.py
	export MESA_GLSL_CACHE_DIR="${HOME}/mesa_shader_cache" # \
	  # Prevent a sandbox violation and isolate between parallel running emerges.
	local display_args
	if use headless ; then
		display_args=()
	elif use wayland ; then
		display_args=(--xvfb --no-xvfb --use-weston)
	else
		display_args=(--xvfb)
	fi
	local run_benchmark_args=(
		--assert-gpu-compositing
		--browser=exact
		--browser-executable="${BUILD_DIR}/out/Release/chrome")
	local cmd=(vpython -cache-dir "${CIPD_CACHE_DIR}" bin/run_performance_test_suite
		--benchmarks=${benchmarks}
		--isolated-script-test-output="${T}/pgo-test-output.json"
		${display_args[@]}
		${run_benchmark_args[@]})
	pushd out/Release || die
		einfo "${cmd[@]}"
		"${cmd[@]}" || die "${cmd[@]}"
	popd
}

_gen_pgo_profile() {
	pushd "${BUILD_DIR}/out/Release" || die
		if ! ls *.profraw 2>/dev/null 1>/dev/null ; then
			die "Missing *.profraw files"
		fi
		einfo "Merging PGO profile data to build PGO profile"
		llvm-profdata merge *.profraw \
			-o "${BUILD_DIR}/chrome/build/pgo_profiles/custom.profdata" \
			|| die
	popd
}

_start_pgo_training() {
	_run_training_suite
	_gen_pgo_profile
}

_update_licenses() {
	# Upstream doesn't package PATENTS files
	if [[ -n "${CHROMIUM_EBUILD_MAINTAINER}" \
		&& -n "${GEN_ABOUT_CREDITS}" \
		&& "${GEN_ABOUT_CREDITS}" == "1" ]] ; then
		einfo "Generating license and copyright notice file"
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
		die
	fi
}

_clean_profraw() {
	if [[ -d "${BUILD_DIR}/out/Release" ]] ; then
		find "${BUILD_DIR}/out/Release" -name "*.profraw" -delete || die
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

_init_cr_pgo_trainers_rasterize_and_record_micro_top_25() {
	# No automated script for this found.
	# It's better to snapshot free websites instead of personal data or nonfree ones.
	local static_pages_interactive=(
		"https://mail.google.com/mail/ gmail.html"
		"https://www.google.com/calendar/ googlecalendar.html"
		"https://www.google.com/search?q=cats&tbm=isch googleimagesearch.html"
		"https://docs.google.com/document/d/1X-IKNjtEnx-WW5JIKRLsyhz5sbsat3mfTpAPUSX3_s4/view googledocs.html"
		"https://plus.google.com/110031535020051778989/posts googleplus.html"
		"http://www.youtube.com youtube.html"
	)
	local static_pages_non_interactive=(
		"http://www.amazon.com amazon.html"
		"http://googlewebmastercentral.blogspot.com/ blogger.html"
		"http://booking.com booking.html"
		"http://www.cnn.com cnn.html"
		"http://www.ebay.com ebay.html"
		"http://espn.go.com espn.html"
		"https://www.facebook.com/barackobama facebook.html"
		"https://www.google.com/search?q=barack+obama google.html"
		"http://www.linkedin.com/in/linustorvalds linkedin.html"
		"http://pinterest.com pinterest.html"
		"http://techcrunch.com techcrunch.html"
		"https://twitter.com/katyperry twitter.html"
		"http://www.weather.com/weather/right-now/Mountain+View+CA+94043 weather.html"
		"http://en.wikipedia.org/wiki/Wikipedia wikipedia.html"
		"http://en.blog.wordpress.com/2012/09/04/freshly-pressed-editors-picks-for-august-2012/ wordpress.html"
		"http://answers.yahoo.com yahooanswers.html"
		"http://games.yahoo.com yahoogames.html"
		"http://news.yahoo.com yahoonews.html"
		"http://sports.yahoo.com/ yahoosports.html"
	)
	# Update sync both columns from
	#   tools/perf/page_sets/static_top_25/README.md
	#   tools/perf/page_sets/static_top_25_pages.py
#	for entry in ${static_pages_interactive[@]} ; do
		# Temporary disabled
#		local url=$(cut -f 1 -d " ")
#		local file=$(cut -f 2 -d " ")
#		einfo "Fetching interactive static page for ${url}"
#		${EPYTHON} "${BUILD_DIR}/third_party/catapult/telemetry/bin/snap_page" \
#			--browser=system \
#			--url="${url}" \
#			--snapshot-path=${file} \
#			--interactive || die
#	done
	for entry in ${static_pages_non_interactive[@]} ; do
		local url=$(cut -f 1 -d " ")
		local file=$(cut -f 2 -d " ")
		einfo "Fetching static page for ${url}"
		${EPYTHON} "${BUILD_DIR}/third_party/catapult/telemetry/bin/snap_page" \
			--browser=system \
			--url="${url}" \
			--snapshot-path=${file} || die
	done
}

_init_pgo_training() {
	if use pgo-full ; then
		export PYTHONPATH=$(_get_pythonpath)
		einfo "PYTHONPATH=${PYTHONPATH}"
		eninja -C out/Release bin/run_performance_test_suite
		init_vpython
		fetching_pgo_deps
		if use cr_pgo_trainers_rasterize_and_record_micro_top_25 ; then
			# This also applies to generic_trace.top25
			_init_cr_pgo_trainers_rasterize_and_record_micro_top_25
		fi
	fi
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

	#"${EPYTHON}" tools/clang/scripts/update.py --force-local-build --gcc-toolchain /usr --skip-checkout --use-system-cmake --without-android || die

	if use pgo-full ; then
		_clean_profraw
		PGO_PHASE=1
		_configure_pgx # pgi
		_update_licenses
		_init_pgo_training
		_build_pgx
		_start_pgo_training
		PGO_PHASE=2
		_configure_pgx # pgo
		_build_pgx
	else
		_configure_pgx # pgo / no-pgo
		_update_licenses
		_build_pgx
	fi

	# Build manpage; bug #684550
	sed -e 's|@@PACKAGE@@|chromium-browser|g;
		s|@@MENUNAME@@|Chromium|g;' \
		chrome/app/resources/manpage.1.in > \
		out/Release/chromium-browser.1 || die

	# Build desktop file; bug #706786
	sed -e 's|@@PACKAGE@@|chromium-browser|g;
		s|\(^Exec=\)/usr/bin/|\1|g;' \
		chrome/installer/linux/common/desktop.template > \
		out/Release/chromium-browser-chromium.desktop || die
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
	doexe out/Release/crashpad_handler

	local sedargs=( -e
			"s:/usr/lib/:/usr/$(get_libdir)/:g;
			s:chromium-browser-chromium.desktop:chromium-browser-chromium-${ABI}.desktop:g;
			s:@@OZONE_AUTO_SESSION@@:$(usex wayland true false):g;
			s:@@FORCE_OZONE_PLATFORM@@:$(usex headless true false):g"
	)
	sed "${sedargs[@]}" "${FILESDIR}/chromium-launcher-r6.sh" > chromium-launcher.sh || die
	newexe chromium-launcher.sh chromium-launcher-${ABI}.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" /usr/bin/chromium-browser-${ABI}
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" /usr/bin/chromium-browser
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" /usr/bin/chromium-${ABI}
	dosym "${CHROMIUM_HOME}/chromium-launcher-${ABI}.sh" /usr/bin/chromium

	dosym "${CHROMIUM_HOME}/chromedriver-${ABI}" /usr/bin/chromedriver-${ABI}
	dosym "${CHROMIUM_HOME}/chromedriver-${ABI}" /usr/bin/chromedriver

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

	if ! use system-icu ; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/resources

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
	newmenu out/Release/chromium-browser-chromium.desktop chromium-browser-chromium-${ABI}.desktop

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
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	if use vaapi ; then
		# It says 3 args:  https://github.com/chromium/chromium/blob/94.0.4606.71/docs/gpu/vaapi.md#vaapi-on-linux
		elog "VA-API is disabled by default at runtime.  You have to enable it"
		elog "by adding --enable-features=VaapiVideoDecoder --ignore-gpu-blocklist"
		elog "--use-gl=desktop or --use-gl=egl to the CHROMIUM_FLAGS in"
		elog "/etc/chromium/default."

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
		if use video_cards_amdgpu || use video_cards_amdgpu-pro \
			|| use video_cards_amdgpu-pro-lts || use video_cards_r600 \
			|| use video_cards_radeonsi  ; then
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
		has_version "x11-libs/libva-intel-driver" \
			&& einfo "  LIBVA_DRIVER_NAME=\"i965\""
		has_version "x11-libs/libva-intel-media-driver" \
			&& einfo "  LIBVA_DRIVER_NAME=\"iHD\""
		use video_cards_r600 \
			&& einfo "  LIBVA_DRIVER_NAME=\"r600\""
		( use video_cards_radeonsi || use video_cards_amdgpu ) \
			&& einfo "  LIBVA_DRIVER_NAME=\"radeonsi\""
		use video_cards_amdgpu-pro \
			&& einfo "  LIBVA_DRIVERS_PATH=\"/opt/amdgpu/$(get_libdir)/dri\" LIBVA_DRIVER_NAME=\"r600\"      # for Northern Islands" \
			&& einfo "  LIBVA_DRIVERS_PATH=\"/opt/amdgpu/$(get_libdir)/dri\" LIBVA_DRIVER_NAME=\"radeonsi\"  # for Southern Islands or newer"
		use video_cards_amdgpu-pro-lts \
			&& einfo "  LIBVA_DRIVERS_PATH=\"/opt/amdgpu/lib/x86_64-linux-gnu/dri\" LIBVA_DRIVER_NAME=\"r600\"      # for Northern Islands" \
			&& einfo "  LIBVA_DRIVERS_PATH=\"/opt/amdgpu/lib/x86_64-linux-gnu/dri\" LIBVA_DRIVER_NAME=\"radeonsi\"  # for Southern Islands or newer"
		einfo
		einfo "to your ~/.bashrc or ~/.xinitrc and relogging."
		einfo
	fi
	if use screencast ; then
		elog "Screencast is disabled by default at runtime. Either enable it"
		elog "by navigating to chrome://flags/#enable-webrtc-pipewire-capturer"
		elog "inside Chromium or add --enable-webrtc-pipewire-capturer"
		elog "to CHROMIUM_FLAGS in /etc/chromium/default."
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
