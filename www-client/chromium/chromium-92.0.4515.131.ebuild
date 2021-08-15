# Copyright 2009-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Monitor
#   https://chromereleases.googleblog.com/search/label/Beta%20updates
#   https://chromereleases.googleblog.com/search/label/Stable%20updates
# for security updates.  They are announced faster than NVD.
# See https://omahaproxy.appspot.com/ for the latest linux version

EAPI=7
PYTHON_COMPAT=( python3_8 )
PYTHON_REQ_USE="xml"

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

LLVM_MAX_SLOT=13
inherit check-reqs chromium-2 desktop flag-o-matic llvm multilib ninja-utils pax-utils portability python-any-r1 readme.gentoo-r1 toolchain-funcs xdg-utils
inherit multilib-minimal

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="https://chromium.org/"
PATCHSET="7"
PATCHSET_NAME="chromium-$(ver_cut 1)-patchset-${PATCHSET}"
PPC64LE_PATCHSET="92-ppc64le-1"
HIGHWAY_V="0.12.1"
SETUPTOOLS_V="44.1.0"
GLIBC_PATCH_V="92-glibc-2.33"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.xz
	https://files.pythonhosted.org/packages/ed/7b/bbf89ca71e722b7f9464ebffe4b5ee20a9e5c9a555a56e2d3914bb9119a6/setuptools-${SETUPTOOLS_V}.zip
	https://github.com/stha09/chromium-patches/releases/download/${PATCHSET_NAME}/${PATCHSET_NAME}.tar.xz
	https://dev.gentoo.org/~sultan/distfiles/www-client/${PN}/${PN}-${GLIBC_PATCH_V}-patch.tar.xz
	arm64? ( https://github.com/google/highway/archive/refs/tags/${HIGHWAY_V}.tar.gz -> highway-${HIGHWAY_V}.tar.gz )
	ppc64? ( https://dev.gentoo.org/~gyakovlev/distfiles/${PN}-${PPC64LE_PATCHSET}.tar.xz )
"
# Missing py files in typ in ${P}.tar.xz so download catapult snapshot.
RESTRICT="mirror"

# all-rights-reserved is for unfree websites or content from them.
LICENSE_BENCHMARK_WEBSITES="
	cr_pgo_trainer_desktop_ui? (
		all-rights-reserved
	)
	cr_pgo_trainer_tab_switching_typical_25? (
		all-rights-reserved
	)
	cr_pgo_trainer_rasterize_and_record_micro_top_25? (
		all-rights-reserved
	)
	cr_pgo_trainer_rendering_mobile? (
		all-rights-reserved
	)
	cr_pgo_trainer_unscheduled_v8_loading_desktop? (
		all-rights-reserved
	)
	cr_pgo_trainer_v8_runtime_stats_top_25? (
		all-rights-reserved
	)
	cr_pgo_trainer_dromaeo? (
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
	cr_pgo_trainer_jetstream? (
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
	cr_pgo_trainer_jetstream2? (
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
	cr_pgo_trainer_kraken? (
		( ( all-rights-reserved || ( MIT AFL-2.1 ) ) (MIT GPL) BSD MIT )
		( all-rights-reserved || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) )
		( all-rights-reserved GPL-3+ )
		|| ( BSD GPL-2 )
		BSD
		BSD-2
		LGPL-2.1
		MPL-1.1
	)
	cr_pgo_trainer_octane? (
		BSD
	)
	cr_pgo_trainer_speedometer2? (
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
# with ||.  You should choose at most one.
LICENSE="BSD
	 libcxx? ( chromium-92.0.4515.x-libcxx )
	!libcxx? ( chromium-92.0.4515.x-libstdcxx )
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
LICENSE_FINGERPRINT_LIBSTDCXX="\
65346078d0f6bc0b3659b2774d7943803742f0c0a2152ecf4a4f4babd03bb00f\
e84cbb0696d3ddb4d70c167866943c959823fb1a5eab8194ea558e16ce3f1e34" # SHA512
LICENSE_FINGERPRINT_LIBCXX="\
be21e8628daa9fc06823a99fb9e88ac8d2d1137312986aa38ad2ad4864a4ca7d\
0e922fdd8f465b844bd29df2df246b6c282f1aab762d84226ac726bae274bc73" # SHA512
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
# Apache 2.0 - third_party/node/node_modules/typescript/LICENSE.txt
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
KEYWORDS="amd64 arm64 ~ppc64 ~x86"
IUSE="component-build cups cpu_flags_arm_neon +hangouts headless +js-type-check kerberos +official pic +proprietary-codecs pulseaudio screencast selinux +suid +system-ffmpeg +system-icu vaapi wayland widevine"
IUSE+=" +partitionalloc tcmalloc libcmalloc"
# For cfi, cfi-icall defaults status, see \
#   https://github.com/chromium/chromium/blob/92.0.4515.131/build/config/sanitizers/sanitizers.gni
# For cfi-full default status, see \
#   https://github.com/chromium/chromium/blob/92.0.4515.131/build/config/sanitizers/sanitizers.gni#L123
# For pgo default status, see \
#   https://github.com/chromium/chromium/blob/92.0.4515.131/build/config/compiler/pgo/pgo.gni#L15
# For libcxx default, see \
#   https://github.com/chromium/chromium/blob/92.0.4515.131/build/config/c++/c++.gni#L14
# For cdm availability see third_party/widevine/cdm/widevine.gni#L28
IUSE+=" +cfi cfi-full +cfi-icall +clang libcxx lto-opt +pgo -pgo-full
shadowcallstack"
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
BENCHMARKS_ALL=(
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
	speedometer2
	speedometer2-future
	speedometer2-pcscan
	speedometer-future
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
gen_pgo_profile_use() {
	for x in ${BENCHMARKS_ALL[@]} ; do
		t="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		echo " cr_pgo_trainer_${t}"
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
				cr_pgo_trainer_${a}? ( pgo-full !cr_pgo_trainer_${b} )
				cr_pgo_trainer_${b}? ( pgo-full !cr_pgo_trainer_${a} )
			"
		done
	done
}
IUSE+=" "$(gen_pgo_profile_use)
REQUIRED_USE+=" $(gen_pgo_profile_required_use)"
REQUIRED_USE+=" pgo-full? ( || ( $(gen_pgo_profile_use) ) )"
REQUIRED_USE+="
	^^ ( partitionalloc tcmalloc libcmalloc )
	amd64? ( !shadowcallstack )
	!clang? ( !cfi )
	cfi? ( clang )
	cfi-full? ( cfi )
	cfi-icall? ( cfi )
	component-build? ( !suid )
	libcxx? ( clang )
	lto-opt? ( clang )
	official? ( amd64? ( cfi cfi-icall ) partitionalloc ^^ ( pgo pgo-full ) )
	partitionalloc? ( !component-build )
	pgo? ( clang !pgo-full )
	pgo-full? ( clang !pgo )
	ppc64? ( !shadowcallstack )
	screencast? ( wayland )
	shadowcallstack? ( clang )
	widevine? ( !arm64 !ppc64 )
	x86? ( !shadowcallstack )
"

COMMON_X_DEPEND="
	media-libs/mesa:=[gbm,${MULTILIB_USEDEP}]
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
	vaapi? ( >=x11-libs/libva-2.7:=[X,drm,${MULTILIB_USEDEP}] )
"

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
	media-libs/freetype:=[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.4.0:0=[icu(-),${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	pulseaudio? ( media-sound/pulseaudio:=[${MULTILIB_USEDEP}] )
	system-ffmpeg? (
		>=media-video/ffmpeg-4.3:=[${MULTILIB_USEDEP}]
		|| (
			media-video/ffmpeg[-samba,${MULTILIB_USEDEP}]
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
"
DEPEND="${COMMON_DEPEND}
"
# dev-vcs/git - https://bugs.gentoo.org/593476
BDEPEND="
	${PYTHON_DEPS}
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	>=app-arch/gzip-1.7
	app-arch/unzip
	dev-lang/perl
	dev-lang/python:2.7[xml]
	>=dev-util/gn-0.1807
	dev-vcs/git
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	>=net-libs/nodejs-7.6.0[inspector]
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex[${MULTILIB_USEDEP}]
	clang? (
		|| (
			(
				sys-devel/clang:13[${MULTILIB_USEDEP}]
				sys-devel/llvm:13[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP},compiler-rt,sanitize]
				>=sys-devel/lld-13
				=sys-libs/compiler-rt-13*
				=sys-libs/compiler-rt-sanitizers-13*[cfi?,shadowcallstack?]
			)
		)
		official? (
			sys-devel/clang:13[${MULTILIB_USEDEP}]
			sys-devel/llvm:13[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-13
			=sys-libs/compiler-rt-13*
			=sys-libs/compiler-rt-sanitizers-13*[cfi?,shadowcallstack?]
		)
	)
	js-type-check? ( virtual/jre )
	pgo-full? (
		$(python_gen_any_dep 'dev-python/future[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/psutil[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/pypng[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/pyfakefs[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/requests[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/six[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/websocket-client[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'net-misc/gsutil[${PYTHON_USEDEP}]')
		sys-apps/dbus:=[${MULTILIB_USEDEP}]
		!headless? (
			!wayland? (
				x11-base/xorg-server[xvfb]
				x11-misc/xcompmgr
				x11-wm/openbox
			)
			wayland? ( dev-libs/weston )
		)
	)
"
#	For inherits in tools/perf:
#		perf-opt? (
#			dev-lang/python[sqlite3,xml]
#			$(python_gen_any_dep 'dev-python/httplib2[${PYTHON_USEDEP}]')
#			$(python_gen_any_dep 'dev-python/mock[${PYTHON_USEDEP}]')
#			$(python_gen_any_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
#			$(python_gen_any_dep 'dev-python/pandas[${PYTHON_USEDEP}]')
#		)

# pgo related:  dev-python/requests is python3 but testing/scripts/run_performance_tests.py is python2

# Upstream uses llvm:13
# For the current llvm for this project, see
#   https://github.com/chromium/chromium/blob/92.0.4515.131/tools/clang/scripts/update.py#L42
# Use the same clang for official USE flag because of older llvm bugs which
#   could result in security weaknesses (explained in the llvm:12 note below).
# Used llvm >= 12 for arm64 for the same reason in the Linux kernel CFI comment.
#   Links below from https://github.com/torvalds/linux/commit/cf68fffb66d60d96209446bfc4a15291dc5a5d41
#     https://bugs.llvm.org/show_bug.cgi?id=46258
#     https://bugs.llvm.org/show_bug.cgi?id=47479
# To confirm the hash version match for the reported by CR_CLANG_REVISION, see
#   https://github.com/llvm/llvm-project/blob/d3676d4b/llvm/CMakeLists.txt
RDEPEND+="
	libcxx? (
		>=sys-libs/libcxx-13[${MULTILIB_USEDEP}]
		official? ( >=sys-libs/libcxx-13[${MULTILIB_USEDEP}] )
	)"
DEPEND+="
	libcxx? (
		>=sys-libs/libcxx-13[${MULTILIB_USEDEP}]
		official? ( >=sys-libs/libcxx-13[${MULTILIB_USEDEP}] )
	)"
COMMON_DEPEND="
	!libcxx? (
		app-arch/snappy:=[${MULTILIB_USEDEP}]
		dev-libs/libxslt:=[${MULTILIB_USEDEP}]
		>=dev-libs/re2-0.2019.08.01:=[${MULTILIB_USEDEP}]
		>=media-libs/openh264-1.6.0:=[${MULTILIB_USEDEP}]
		system-icu? ( >=dev-libs/icu-69.1:=[${MULTILIB_USEDEP}] )
	)
"

RDEPEND+="${COMMON_DEPEND}"
DEPEND+="${COMMON_DEPEND}"

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
	check-reqs_pkg_setup
}

pkg_pretend() {
	pre_build_checks
}

CR_CLANG_USED="d3676d4b666ead794fc58bbc7e07aa406dcf487a" # Obtained from \
# https://github.com/chromium/chromium/blob/92.0.4515.131/tools/clang/scripts/update.py#L42
CR_CLANG_USED_UNIX_TIMESTAMP="1621237229" # Cached.  Use below to obtain this. \
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
	# For sys-devel/llvm:x.y.z slot style
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

_get_release_timestamp() {
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

_get_live_llvm_timestamp() {
	if [[ -z "${emerged_llvm_commit}" ]] ; then
		# Should check against the llvm milestone if not live
		v=$(ver_cut 1-3 "${pv}")
		local suffix=""
		if [[ "${pv}" =~ "_rc" ]] ; then
			suffix=$(echo "${pv}" | grep -E -o -e "_rc[0-9]+")
			suffix=${suffix//_/-}
		fi
		v="${v}${suffix}"
		emerged_llvm_timestamp=$(_get_release_timestamp ${v})
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

_check_live_llvm_updated() {
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
		live_packages_status[${p_}]="1" # needs emerge
	else
		live_packages_status[${p_}]="0" # package is okay
	fi
}

_check_live_llvm_updated_triple() {
	[[ -z "${emerged_llvm_timestamp}" ]] && die
	[[ -z "${LLVM_TIMESTAMP}" ]] && die

	if (( ${emerged_llvm_timestamp} < ${LLVM_TIMESTAMP} )) ; then
		needs_emerge=1
		live_packages_status[${p_}]="1" # needs emerge
		old_triple_slot_packages+=( "${category}/${pn}:"$(cat "${mp}/SLOT") )
	else
		live_packages_status[${p_}]="0" # package is okay
	fi
}

print_old_live_llvm_multislot_pkgs() {
	local arg="${1}"
	for x in ${old_triple_slot_packages[@]} ; do
		local slot=${x/:*}
		if [[ "${arg}" == "${slot}" ]] ; then
			eerror "emerge -1v ${x}"
		fi
	done
}

verify_llvm_report_card() {
	if (( ${needs_emerge} == 1 )) ; then
eerror
eerror "Detected a old clang/llvm version.  Please re-emerge the clang/LLVM"
eerror "toolchain by doing the following:"
eerror
		for p in ${live_pkgs[@]} ; do
			if [[ "${p}" == "sys-libs/libcxx" ]] && ! use libcxx ; then
				continue
			fi
			if [[ "${p}" == "sys-libs/libcxxabi" ]] && ! use libcxx ; then
				continue
			fi
			if [[ "${p}" == "sys-libs/libcxxabi" ]] && use libcxx \
				&& ! has_version "sys-libs/libcxxabi" ; then
				continue
			fi
			local p_=${p//-/_}
			p_=${p_//\//_}
			if (( ${live_packages_status[${p_}]} == 1 )) ; then
				if contains_slotted_major_version "${p}" ; then
					eerror "emerge -1v ${p}:${CR_CLANG_SLOT}"
				elif contains_slotted_triple_version "${p}" ; then
					print_old_live_llvm_multislot_pkgs "${p}"
				elif contains_slotted_zero "${p}" ; then
					eerror "emerge -1v ${p}:0"
				fi
			fi
		done
		die
	else
einfo "The live LLVM ${CR_CLANG_SLOT} toolchain is up-to-date."
	fi
}

LLVM_TIMESTAMP=
verify_llvm_toolchain() {
	[[ "${CLANG_SLOT}" != "${CR_CLANG_SLOT}" ]] && return

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

	unset live_packages_status
	declare -A live_packages_status

	unset cached_release_hashes
	declare -A cached_release_hashes

	local old_triple_slot_packages=()

	local needs_emerge=0
	# The llvm library or llvm-ar doesn't embed the hash info, so scan the /var/db/pkg.
	if has_version "sys-devel/llvm:${CR_CLANG_SLOT}" ; then
		for p in ${live_pkgs[@]} ; do
			if [[ "${p}" == "sys-libs/libcxx" ]] && ! use libcxx ; then
				continue
			fi
			if [[ "${p}" == "sys-libs/libcxxabi" ]] && ! use libcxx ; then
				continue
			fi
			if [[ "${p}" == "sys-libs/libcxxabi" ]] && use libcxx \
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
				einfo "Checking ${p}:${CR_CLANG_SLOT}"
				emerged_llvm_commit=$(bzless \
					"${ESYSROOT}/var/db/pkg/${p}-${CR_CLANG_SLOT}"*"/environment.bz2" \
					| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
				pv=$(cat "${ESYSROOT}/var/db/pkg/${p}-${CR_CLANG_SLOT}"*"/PF" | sed "s|${p}-||")
				_get_live_llvm_timestamp
				[[ "${p}" == "sys-devel/llvm" ]] \
					&& LLVM_TIMESTAMP=${emerged_llvm_timestamp}
				_check_live_llvm_updated
			elif contains_slotted_zero "${p}" ; then
				einfo
				einfo "Checking ${p}:0"
				emerged_llvm_commit=$(bzless \
					"${ESYSROOT}/var/db/pkg/${p}"*"/environment.bz2" \
					| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
				pv=$(cat "${ESYSROOT}/var/db/pkg/${p}"*"/PF" | sed "s|${p}-||")
				_get_live_llvm_timestamp
				_check_live_llvm_updated
			else
				local category=${p/\/*}
				local pn=${p/*\/}
				# Handle multiple slots
				# We shouldn't have to deal with multislot patch versions, but
				# we have to.
				for mp in $(find "${ESYSROOT}/var/db/pkg/${category}" \
					-maxdepth 1 \
					-type d \
					-regextype "posix-extended" \
					-regex ".*${pn}-${CR_CLANG_SLOT}.[0-9.]+") ; do
					einfo
					einfo "Checking ="$(basename ${mp})
					emerged_llvm_commit=$(bzless \
						"${mp}/environment.bz2" \
						| grep -F -e "EGIT_VERSION" \
						| head -n 1 \
						| cut -f 2 -d '"')
					pv=$(cat "${mp}/PF" | sed "s|${p}-||")
					_get_live_llvm_timestamp
					_check_live_llvm_updated_triple
				done
			fi
		done
		verify_llvm_report_card
	else
die "${PN} requires llvm:${CR_CLANG_SLOT}"
	fi
}

NABIS=0
pkg_setup() {
	einfo "The $(ver_cut 1 ${PV}) series is the Stable channel."
	pre_build_checks

	chromium_suid_sandbox_check_kernel_config

	# nvidia-drivers does not work correctly with Wayland due to unsupported EGLStreams
	if use wayland && ! use headless && has_version "x11-drivers/nvidia-drivers" ; then
		ewarn "Proprietary nVidia driver does not work with Wayland. You can disable"
		ewarn "Wayland by setting DISABLE_OZONE_PLATFORM=true in /etc/chromium/default."
	fi

	if ! use amd64 && [[ "${IUSE}" =~ cfi ]] ; then
ewarn
ewarn "All variations of the cfi USE flags are not defaults for this platform."
ewarn "Disable them if problematic."
ewarn
	fi

	if use pgo-full ; then
ewarn
ewarn "The pgo-full USE flag is a Work In Progress (WIP) and not production ready."
ewarn
		if has network-sandbox $FEATURES ; then
eerror "FEATURES=\"-network-sandbox\" must be added as a per-package env to"
eerror "be able to use PGO trainers with external benchmarking websites."
			die
		fi
		# TODO: check if all relevant USE flags added:
		local remote_access_use=(
			cr_pgo_trainer_desktop_ui
			cr_pgo_trainer_tab_switching_typical_25
			cr_pgo_trainer_rasterize_and_record_micro_top_25
			cr_pgo_trainer_rendering_mobile
			cr_pgo_trainer_unscheduled_v8_loading_desktop
			cr_pgo_trainer_v8_runtime_stats_top_25
		)
		# Backtrack tools/perf/benchmark.csv to find the USE flag
		local warned=0
		for u in ${remote_access_use[@]} ; do
			if use "${u}" ; then
ewarn
ewarn "The ${u} USE flag may access external sites with user contributed data"
ewarn "when using PGO profile generation and may need site terms of use to be"
ewarn "reviewed for acceptable use.  They also may access news, governmental,"
ewarn "political, or corporate sites.  They may access or reference unfree"
ewarn "trademarks and content."
ewarn
ewarn "You have 120 seconds to remove this USE flag if you disagree with such"
ewarn "access."
ewarn
				warned=1
			fi
		done
		(( ${warned} == 1 )) && sleep 120
	fi

	if use official || ( use clang && use cfi && use pgo ) ; then
		# sys-devel/lld-13 was ~20 mins for v8_context_snapshot_generator
		# sys-devel/lld-12 was ~4 hrs for v8_context_snapshot_generator
ewarn
ewarn "Linking times may take longer than usual.  Maybe 1-4+ hour(s)."
ewarn
	fi

	# These checks are a maybe required.
	if use clang ; then
		llvm_pkg_setup
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		local MESA_LLVM_MAX_SLOT=$(bzless \
			"${ESYSROOT}/var/db/pkg/media-libs/mesa"*"/environment.bz2" \
			| grep -F -e "LLVM_MAX_SLOT" \
			| head -n 1 \
			| cut -f 2 -d '"')
		local CLANG_SLOT=$(clang-major-version)
		einfo "CLANG_SLOT: ${CLANG_SLOT}"
		einfo "MESA_LLVM_MAX_SLOT: ${MESA_LLVM_MAX_SLOT}"
		verify_llvm_toolchain
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

	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done
}

USED_EAPPLY=0
ceapply() {
	USED_EAPPLY=1
	eapply "${@}"
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	local PATCHES=()
	if ( ! use clang ) || ( ! use libcxx ) || use arm64 ; then
		# TODO: split GCC only and libstdc++ only.
		# The patches purpose are not documented well.
		einfo "Applying gcc & libstdc++ compatibility patches"
		PATCHES+=( "${WORKDIR}/patches" )
	fi

	PATCHES+=(
		"${WORKDIR}/sandbox-patches/chromium-syscall_broker.patch"
		"${WORKDIR}/sandbox-patches/chromium-fstatat-crash.patch"
		"${FILESDIR}/chromium-92-EnumTable-crash.patch"
		"${FILESDIR}/chromium-92-crashpad-consent.patch"
		"${FILESDIR}/chromium-freetype-2.11.patch"
		"${FILESDIR}/chromium-shim_headers.patch"
	)

	if ! use arm64 ; then
		einfo "Removing aarch64 only patches"
		rm "${WORKDIR}/patches/chromium-91-libyuv-aarch64.patch" || die
		rm "${WORKDIR}/patches/chromium-92-v8-constexpr.patch" || die
	fi

	if use ppc64 ; then
		ceapply "${WORKDIR}/${PN}-ppc64le/xxx-ppc64le-libvpx.patch"
		ceapply "${WORKDIR}/${PN}-ppc64le/xxx-ppc64le-support.patch"
		ceapply "${WORKDIR}/${PN}-ppc64le/xxx-ppc64le-swiftshader.patch"
	fi

	if use clang ; then
		ceapply "${FILESDIR}/${PN}-92-clang-toolchain-1.patch"
		ceapply "${FILESDIR}/${PN}-92-clang-toolchain-2.patch"
	fi

	if use arm64 && use shadowcallstack ; then
		ceapply "${FILESDIR}/chromium-93-arm64-shadow-call-stack.patch"
	fi

	if use pgo-full ; then
		ceapply "${FILESDIR}/chromium-92-use-system-gsutil.patch"
	fi

	default

	# this patch needs to be applied after gentoo sandbox patchset
	use ppc64 && ceapply "${WORKDIR}/${PN}-ppc64le/xxx-ppc64le-sandbox_kernel_stat.patch"

	if use cr_pgo_trainer_custom && [[ ! -f "${T}/epatch_user.log" ]] ; then
eerror
eerror "You must supply a per-package patch to use the cr_pgo_trainer_custom"
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

	# adjust python interpreter versions
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die
	sed -i -e "s|python2|python2\.7|g" buildtools/linux64/clang-format || die

	# bundled highway library does not support arm64 with GCC
	if use arm64 ; then
		rm -r third_party/highway/src || die
		ln -s "${WORKDIR}/highway-0.12.1" third_party/highway/src || die
	fi

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
		third_party/angle/src/third_party/compiler
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
		third_party/catapult/third_party/beautifulsoup4
		third_party/catapult/third_party/html5lib-python
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
		third_party/harfbuzz-ng/utils
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
		tools/grit/third_party/six
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
	if use pgo-full ; then
		keeplibs+=(
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
	if use wayland && ! use headless ; then
		keeplibs+=( third_party/wayland )
	fi
	if use libcxx ; then
		keeplibs+=( third_party/libxml )
		keeplibs+=( third_party/libxslt )
		keeplibs+=( third_party/openh264 )
		keeplibs+=( third_party/re2 )
		keeplibs+=( third_party/snappy )
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

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die

	if use js-type-check ; then
		ln -s "${EPREFIX}"/usr/bin/java third_party/jdk/current/bin/java || die
	fi

	# bundled eu-strip is for amd64 only and we don't want to pre-stripped binaries
	mkdir -p buildtools/third_party/eu-strip/bin || die
	ln -s "${EPREFIX}"/bin/true buildtools/third_party/eu-strip/bin/eu-strip || die

	# Trys to do the minimal edits in order to run the benchmarks without resorting
	# to pulling possibly EOL versions.
	if use pgo-full ; then
		sed -i -e "s|/usr/bin/env vpython|/usr/bin/env ${EPYTHON}|" \
			-e "s|/usr/bin/env {vpython}|/usr/bin/env ${EPYTHON}|" \
			"build/util/generate_wrapper.py" || die

		local futurize_lst=(
			# Put the entire import tree
			tools/perf/benchmarks
			tools/perf/core
			tools/perf/page_sets
			tools/perf/run_benchmark
			testing/scripts/common.py
			testing/scripts/run_performance_tests.py
			testing/test_env.py
			testing/xvfb.py
		)

		# Skip use of vpython because of download times for cipd and found no way to cache downloads.
		for f in $(grep -l -G -e "/usr/bin/env vpython3$" $(find ${futurize_lst[@]} -name "*.py")) ; do
			einfo "Converting shebang:  vpython3 -> ${EPYTHON} for ${f}"
			sed -i -e "s|/usr/bin/env vpython3$|/usr/bin/env ${EPYTHON}|" \
				"${f}" || die
		done
		for f in $(grep -l -G -e "/usr/bin/env vpython$" $(find ${futurize_lst[@]} -name "*.py")) ; do
			einfo "Converting shebang:  vpython -> ${EPYTHON} for ${f}"
			sed -i -e "s|/usr/bin/env vpython$|/usr/bin/env ${EPYTHON}|" \
				"${f}" || die
		done
		for f in $(find ${futurize_lst[@]} -name "*.py") ; do
			local result=$(futurize -0 "${f}" 2>&1)
			if [[ "${result}" =~ "RefactoringTool: No changes to" \
				|| "${result}" =~ "RefactoringTool: No files need to be modified." ]] ; then
				einfo "Skipping py2 -> py3 futurization of ${f}"
			else
				einfo "Applied py2 -> py3 futurization of ${f}"
				futurize -n -w -0 "${f}" || die
			fi
		done
		einfo "EPYTHON=${EPYTHON}"
		sed -i -e "s|'python'|'${EPYTHON}'|" \
			testing/test_env.py || die
		sed -i -e "s|reader.read()|reader.read().decode()|g" \
			testing/test_env.py || die
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

	if use clang ; then
		# See build/toolchain/linux/unbundle/BUILD.gn for allowed overridable envvars.
		# See build/toolchain/gcc_toolchain.gni#L657 for consistency.
		CC=${chost}-clang
		CXX=${chost}-clang++
		AR=llvm-ar # required for LTO
		NM=llvm-nm
		READELF=llvm-readelf
		STRIP=llvm-strip
		strip-unsupported-flags
		if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
			die "llvm-ar is unreachable"
		fi
	fi

	if ! use clang && tc-is-clang ; then
		if [[ ! ( "${AR}" =~ "llvm-ar" ) ]] ; then
			einfo "Forcing llvm-ar for LTO"
			AR=llvm-ar # required for LTO
			NM=llvm-nm
			READELF=llvm-readelf
			STRIP=llvm-strip
			if ! which llvm-ar 2>/dev/null 1>/dev/null ; then
				die "llvm-ar is unreachable"
			fi
		fi
	fi

	if tc-is-clang ; then
		myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	else
		if use libcxx ; then
			die "Compiling with sys-libs/libcxx requires clang."
		fi
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
# See https://github.com/chromium/chromium/blob/92.0.4515.131/build/config/compiler/compiler.gni#L276
	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

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
	if ! use libcxx ; then
		# unbundle only without libc++, because libc++ is not fully ABI compatible with libstdc++
		gn_system_libraries+=( libxml )
		gn_system_libraries+=( libxslt )
		gn_system_libraries+=( openh264 )
		gn_system_libraries+=( re2 )
		gn_system_libraries+=( snappy )
	fi
	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" || die

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=true"

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

	myconf_gn+=" fieldtrial_testing_like_official_build=true"

	# Never use bundled gold binary. Disable gold linker flags for now.
	# Do not use bundled clang.
	# Trying to use gold results in linker crash.
	myconf_gn+=" use_gold=false use_sysroot=false use_custom_libcxx=false"

	if use clang || tc-is-clang ; then
		filter-flags -fuse-ld=*
		myconf_gn+=" use_lld=true"
	else
		myconf_gn+=" use_lld=false"
	fi

	# Disable pseudolocales, only used for testing
	myconf_gn+=" enable_pseudolocales=false"

	ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
	myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
	myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info.
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	local google_default_client_id="329227923882.apps.googleusercontent.com"
	local google_default_client_secret="vgKG0NNv7GoDpbtoFNLxCUXu"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	myconf_gn+=" google_default_client_id=\"${google_default_client_id}\""
	myconf_gn+=" google_default_client_secret=\"${google_default_client_secret}\""
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

	if use libcxx ; then
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

	# highway/libjxl relies on this with arm64
	if use arm64 && tc-is-gcc ; then
		append-cxxflags -flax-vector-conversions
	fi

	# highway/libjxl fail on ppc64 without extra patches, disable for now.
	use ppc64 && myconf_gn+=" enable_jxl_decoder=false"

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

# See https://github.com/chromium/chromium/blob/92.0.4515.131/build/config/sanitizers/BUILD.gn#L196
	if use cfi ; then
		myconf_gn+=" is_cfi=true"
	else
		myconf_gn+=" is_cfi=false"
	fi

# See https://github.com/chromium/chromium/blob/92.0.4515.131/tools/mb/mb_config.pyl#L2950
	if use cfi-full ; then
		myconf_gn+=" use_cfi_cast=true"
	else
		myconf_gn+=" use_cfi_cast=false"
	fi

	if use cfi-icall ; then
		myconf_gn+=" use_cfi_icall=true"
	else
		myconf_gn+=" use_cfi_icall=false"
	fi

	if use arm64 && use shadowcallstack ; then
		myconf_gn+=" use_shadow_call_stack=true"
	fi

# See also build/config/compiler/pgo/BUILD.gn#L71 for PGO flags.
# See also https://github.com/chromium/chromium/blob/92.0.4515.131/docs/pgo.md
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
		einfo "Building ${x}"
		if tc-is-cross-compiler ; then
			eninja -C out/Release "host/${x}"
			pax-mark m "out/Release/host/${x}"
		else
			eninja -C out/Release "${x}"
			pax-mark m "out/Release/${x}"
		fi
	done

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	einfo "Building chrome"
	eninja -C out/Release chrome
	einfo "Building chromedriver"
	eninja -C out/Release chromedriver
	if use suid ; then
		einfo "Building chrome_sandbox"
		eninja -C out/Release chrome_sandbox
	fi

	pax-mark m out/Release/chrome

	mv out/Release/chromedriver{.unstripped,} || die
}

_run_training_suite() {
# See also https://github.com/chromium/chromium/blob/92.0.4515.131/docs/pgo.md
# https://github.com/chromium/chromium/blob/92.0.4515.131/testing/buildbot/generate_buildbot_json.py
# https://github.com/chromium/chromium/commit/8acfdce99c84fbc35ad259692ac083a9ea18392c
# tools/perf/contrib/vr_benchmarks
	local pp=(
		"${BUILD_DIR}/third_party/catapult/common/py_utils"
		"${BUILD_DIR}/third_party/catapult/telemetry/telemetry"
		"${BUILD_DIR}/third_party/catapult/third_party/typ"
		"${BUILD_DIR}/third_party/catapult/tracing"
		"${BUILD_DIR}/tools/perf"
	)
	local benchmarks_allowed=()
	for x in ${BENCHMARKS_ALL[@]} ; do
		t="${x}"
		t="${t//-/_}"
		t="${t//./_}"
		t="${t,,}"
		if use "cr_pgo_trainer_${t}" ; then
			if [[ -d "${T}/${x}" ]] ; then
				# Clear for different ABI builds
				rm -vrf "${T}/${x}" || die
			fi
			benchmarks_allowed+=( ${x} )
		fi
	done
	export PYTHONPATH=$(echo "${pp}" | tr " " ":")
	einfo "PYTHONPATH=${PYTHONPATH}"
	local benchmarks=$(echo "${benchmarks_allowed[@]}" | tr " " ",")
	eninja -C out/Release bin/run_performance_test_suite
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
	local cmd=(${EPYTHON} bin/run_performance_test_suite
		--benchmarks=${benchmarks}
		--isolated-script-test-output="${T}/pgo-test-output.json"
		${display_args[@]}
		${run_benchmark_args[@]})
	pushd out/Release || die
		einfo "${cmd[@]}"
		"${cmd[@]}" || die
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
	if [[ -n "${CHROMIUM_EBUILD_MAINTAINER}" ]] ; then
		einfo "Generating license and copyright notice file"
		eninja -C out/Release about_credits
		# It should be updated when the major.minor.build.x changes
		# because of new features.
		local license_file_name=$(echo "${PN}-${PV}" \
			| sed -r -e "s|(${PN}-[0-9]+\.[0-9]+\.[0-9]+\.)[0-9]+|\1x|g")
		local x_license_fingerprint=$(sha512sum \
			"${BUILD_DIR}/out/Release/gen/components/resources/about_credits.html" \
                                        | cut -f 1 -d " ")
		# Check the license fingerprint between point releases.
		local fp
		local suffix
		if use libcxx ; then
			fp="${LICENSE_FINGERPRINT_LIBCXX}"
			license_file_name+="-libcxx"
			suffix="LIBCXX"
		else
			fp="${LICENSE_FINGERPRINT_LIBSTDCXX}"
			license_file_name+="-libstdcxx"
			suffix="LIBSTDCXX"
		fi
		if [[ ! ( "${LICENSE}" =~ "${license_file_name}" ) \
			|| ! -f "${MY_OVERLAY_DIR}/licenses/${license_file_name}" \
			|| "${x_license_fingerprint}" != "${fp}" \
		]] ; then
einfo
einfo "Please update the LICENSE variable and add the license file to the"
einfo "licenses folder.  Copy license file as follows:"
einfo
einfo "  \`cp -a ${BUILD_DIR}/out/Release/gen/components/resources/about_credits.html \
${MY_OVERLAY_DIR}/licenses/${license_file_name}\`"
einfo
einfo "Update the LICENSE_FINGERPRINT_${suffix} to ${x_license_fingerprint}"
einfo
			die
		fi
	else
		einfo "Generating license and copyright notice file"
		eninja -C out/Release about_credits
		# It should be updated when the major.minor.build.x changes
		# because of new features.
		local x_license_fingerprint=$(sha512sum \
			"${BUILD_DIR}/out/Release/gen/components/resources/about_credits.html" \
			| cut -f 1 -d " ")
		# Check the license fingerprint between point releases.
		# The 93 fingerprints differ from the 92
		einfo "Verifying about:credits fingerprints"
		local fp
		if use libcxx ; then
			fp="${LICENSE_FINGERPRINT_LIBCXX}"
		else
			fp="${LICENSE_FINGERPRINT_LIBSTDCXX}"
		fi
		if [[ "${x_license_fingerprint}" != "${fp}" ]] ; then
einfo
einfo "The about:credits fingerprints do not match and may dynamically be"
einfo "generated based on features or dependencies used.  Send an issue report"
einfo "to the ebuild maintainer.  Report back the USE flags used and the arch."
einfo
			die
		fi
	fi
}

_clean_profraw() {
	if [[ -d "${BUILD_DIR}/out/Release" ]] ; then
		find "${BUILD_DIR}/out/Release" -name "*.profraw" -delete || die
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

	# https://bugs.gentoo.org/717456
	# don't inherit PYTHONPATH from environment, bug #789021
	local -x PYTHONPATH="${WORKDIR}/setuptools-44.1.0"

	#"${EPYTHON}" tools/clang/scripts/update.py --force-local-build --gcc-toolchain /usr --skip-checkout --use-system-cmake --without-android || die

	if use pgo-full ; then
		_clean_profraw
		PGO_PHASE=1
		_configure_pgx # pgi
		_update_licenses
		_build_pgx
		_start_pgo_training
		export PYTHONPATH="${WORKDIR}/setuptools-44.1.0"
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
	sed -i -e "s|@@MENUNAME@@|Chromium (${ABI})|g" \
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
		elog "VA-API is disabled by default at runtime. You have to enable it"
		elog "by adding --enable-features=VaapiVideoDecoder to CHROMIUM_FLAGS"
		elog "in /etc/chromium/default."
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
